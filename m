Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6929BA47
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368868AbgJ0P7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804280AbgJ0PyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07502204EF;
        Tue, 27 Oct 2020 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814050;
        bh=qVLQGQ6KsFo9hRXhNqOBETAXWIMU/bRwbo/wKvJagPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk1+CGf1ypiFg9kcD32/W1foOly9tHWzlXKlp/dQayFRai9KEi2iLO9sjkzCCWzDg
         kZtaUNWSrA2CaXqOwaMskow6/kSjeBtKY8ovcA0BM5V0Kws1mg+BsW1P9poB6kld7d
         7ZAcekhD0f41cBIaCdVsCaItxc95tD5CkiBe74hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 746/757] drm/panfrost: perfcnt: fix ref count leak in panfrost_perfcnt_enable_locked
Date:   Tue, 27 Oct 2020 14:56:36 +0100
Message-Id: <20201027135525.497694505@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 9df0e0c1889677175037445d5ad1654d54176369 ]

in panfrost_perfcnt_enable_locked, pm_runtime_get_sync is called which
increments the counter even in case of failure, leading to incorrect
ref count. In case of failure, decrement the ref count before returning.

Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200614063619.44944-1-navid.emamdoost@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index ec4695cf3caf3..fdbc8d9491356 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -83,11 +83,13 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
 
 	ret = pm_runtime_get_sync(pfdev->dev);
 	if (ret < 0)
-		return ret;
+		goto err_put_pm;
 
 	bo = drm_gem_shmem_create(pfdev->ddev, perfcnt->bosize);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
+	if (IS_ERR(bo)) {
+		ret = PTR_ERR(bo);
+		goto err_put_pm;
+	}
 
 	/* Map the perfcnt buf in the address space attached to file_priv. */
 	ret = panfrost_gem_open(&bo->base, file_priv);
@@ -168,6 +170,8 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
 	panfrost_gem_close(&bo->base, file_priv);
 err_put_bo:
 	drm_gem_object_put(&bo->base);
+err_put_pm:
+	pm_runtime_put(pfdev->dev);
 	return ret;
 }
 
-- 
2.25.1



