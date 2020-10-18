Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC27291EAA
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgJRTyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbgJRTUX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8743222E9;
        Sun, 18 Oct 2020 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048822;
        bh=qVLQGQ6KsFo9hRXhNqOBETAXWIMU/bRwbo/wKvJagPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOmutrKv0WvAeNWwTt6SR13A/k3PYzpEqjv08Euqek+CkUoIbnGeUdmxIXKRNXxnE
         qeBXSyY8aMfWypTHYlj0M+E6XPlV/HA3xS8HjEdyaptAsI5CC3iUen0bzlOi+V8BSO
         PxPq7FAfyQjJ25yoXKgwOkRFsQWtw0OzgbomSA4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 110/111] drm/panfrost: perfcnt: fix ref count leak in panfrost_perfcnt_enable_locked
Date:   Sun, 18 Oct 2020 15:18:06 -0400
Message-Id: <20201018191807.4052726-110-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

