Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65311171DD8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgB0OX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388869AbgB0OOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:14:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DBC20578;
        Thu, 27 Feb 2020 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812877;
        bh=+aqyWWYn7K1Jqt2esBmrsHiElG8yI/T2Tl7qzGvNYJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3uVmKbnDGPvICLaqktHO7lniTgYQuKLJgo8nkARNvMENjyrKnLl8uxVaOESfTPBO
         vlURzYIfoziSlVArMbkwNwxKchNZ2Gj67L9KVWmtAyjqTq3sMA64uScZrXFum7a26u
         T0sj6r9s6rF+39+2X3C3Pl0TO0UT0Yvxf4i0Vt0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.5 050/150] drm/panfrost: perfcnt: Reserve/use the AS attached to the perfcnt MMU context
Date:   Thu, 27 Feb 2020 14:36:27 +0100
Message-Id: <20200227132240.467574688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit dde2bb2da01e96c17f0a44b4a3cf72a30e66e3ef upstream.

We need to use the AS attached to the opened FD when dumping counters.

Reported-by: Antonio Caggiano <antonio.caggiano@collabora.com>
Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Tested-by: Antonio Caggiano <antonio.caggiano@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200206141327.446127-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_mmu.c     |    7 ++++++-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c |   11 ++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -151,7 +151,12 @@ u32 panfrost_mmu_as_get(struct panfrost_
 	as = mmu->as;
 	if (as >= 0) {
 		int en = atomic_inc_return(&mmu->as_count);
-		WARN_ON(en >= NUM_JOB_SLOTS);
+
+		/*
+		 * AS can be retained by active jobs or a perfcnt context,
+		 * hence the '+ 1' here.
+		 */
+		WARN_ON(en >= (NUM_JOB_SLOTS + 1));
 
 		list_move(&mmu->list, &pfdev->as_lru_list);
 		goto out;
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -73,7 +73,7 @@ static int panfrost_perfcnt_enable_locke
 	struct panfrost_file_priv *user = file_priv->driver_priv;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 	struct drm_gem_shmem_object *bo;
-	u32 cfg;
+	u32 cfg, as;
 	int ret;
 
 	if (user == perfcnt->user)
@@ -126,12 +126,8 @@ static int panfrost_perfcnt_enable_locke
 
 	perfcnt->user = user;
 
-	/*
-	 * Always use address space 0 for now.
-	 * FIXME: this needs to be updated when we start using different
-	 * address space.
-	 */
-	cfg = GPU_PERFCNT_CFG_AS(0) |
+	as = panfrost_mmu_as_get(pfdev, perfcnt->mapping->mmu);
+	cfg = GPU_PERFCNT_CFG_AS(as) |
 	      GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_MANUAL);
 
 	/*
@@ -195,6 +191,7 @@ static int panfrost_perfcnt_disable_lock
 	drm_gem_shmem_vunmap(&perfcnt->mapping->obj->base.base, perfcnt->buf);
 	perfcnt->buf = NULL;
 	panfrost_gem_close(&perfcnt->mapping->obj->base.base, file_priv);
+	panfrost_mmu_as_put(pfdev, perfcnt->mapping->mmu);
 	panfrost_gem_mapping_put(perfcnt->mapping);
 	perfcnt->mapping = NULL;
 	pm_runtime_mark_last_busy(pfdev->dev);


