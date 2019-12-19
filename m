Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F46126BA4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730598AbfLSSzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:55:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730596AbfLSSzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CC7206EC;
        Thu, 19 Dec 2019 18:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781699;
        bh=Be1O2j7Z4b1WMstvecL4tEM81NqtYVosdwqztphEMZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVbXIRG8GiS//HAnTBrW5aPAgYCLejA/4kB0AYlDrtiij+zknKS1gA1IbgpW4i3Fc
         fV/YEx9WGsarhX+ays+d6CEQ8+bKFyF1peJ1tm0GJ0rUKH4ljnmJdhmJrbne+YrLMN
         /pmRqUeTfbdCcQVD7DGoNBYSTZsYvnGSoCFqMNx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 45/80] drm/panfrost: Fix a race in panfrost_gem_free_object()
Date:   Thu, 19 Dec 2019 19:34:37 +0100
Message-Id: <20191219183113.201635558@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit aed44cbeae2b7674cd155ba5cc6506aafe46a94e upstream.

panfrost_gem_shrinker_scan() might purge a BO (release the sgt and
kill the GPU mapping) that's being freed by panfrost_gem_free_object()
if we don't remove the BO from the shrinker list at the beginning of
panfrost_gem_free_object().

Fixes: 013b65101315 ("drm/panfrost: Add madvise and shrinker support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191129135908.2439529-5-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/panfrost/panfrost_gem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -19,6 +19,16 @@ static void panfrost_gem_free_object(str
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	struct panfrost_device *pfdev = obj->dev->dev_private;
 
+	/*
+	 * Make sure the BO is no longer inserted in the shrinker list before
+	 * taking care of the destruction itself. If we don't do that we have a
+	 * race condition between this function and what's done in
+	 * panfrost_gem_shrinker_scan().
+	 */
+	mutex_lock(&pfdev->shrinker_lock);
+	list_del_init(&bo->base.madv_list);
+	mutex_unlock(&pfdev->shrinker_lock);
+
 	if (bo->sgts) {
 		int i;
 		int n_sgt = bo->base.base.size / SZ_2M;
@@ -33,11 +43,6 @@ static void panfrost_gem_free_object(str
 		kfree(bo->sgts);
 	}
 
-	mutex_lock(&pfdev->shrinker_lock);
-	if (!list_empty(&bo->base.madv_list))
-		list_del(&bo->base.madv_list);
-	mutex_unlock(&pfdev->shrinker_lock);
-
 	drm_gem_shmem_free_object(obj);
 }
 


