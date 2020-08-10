Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32D42410DC
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgHJTdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgHJTJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90E252078D;
        Mon, 10 Aug 2020 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086571;
        bh=JqWjv8wRp7OfV56EpWs4WVdnBiJF6+GRBXmrIPRdz20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7QUlIn7/UCho3uZJxCTwXodNhV3VtPpTEwb8R79MwnS+O9IGSDlkYMYntxDZi2Yv
         JlCCYu6BDc/7t/vYPP9fOheEKaJibWRxFub4jluWU/7aeDTxOjbEVVgjgBGTXvuWuq
         KLGk7WckemLk/a5SYYGV9+uSOOphrzdr79T+fu0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 23/64] drm/nouveau: fix multiple instances of reference count leaks
Date:   Mon, 10 Aug 2020 15:08:18 -0400
Message-Id: <20200810190859.3793319-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 659fb5f154c3434c90a34586f3b7aa1c39cf6062 ]

On calling pm_runtime_get_sync() the reference count of the device
is incremented. In case of failure, decrement the
ref count before returning the error.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 8 ++++++--
 drivers/gpu/drm/nouveau/nouveau_gem.c | 4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index ac93d12201dc0..880d962c1b19a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1026,8 +1026,10 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 
 	/* need to bring up power immediately if opening device */
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	get_task_comm(tmpname, current);
 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->pid));
@@ -1109,8 +1111,10 @@ nouveau_drm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	long ret;
 
 	ret = pm_runtime_get_sync(dev->dev);
-	if (ret < 0 && ret != -EACCES)
+	if (ret < 0 && ret != -EACCES) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return ret;
+	}
 
 	switch (_IOC_NR(cmd) - DRM_COMMAND_BASE) {
 	case DRM_NOUVEAU_NVIF:
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 4c3f131ad31da..c5ee5b7364a09 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -45,8 +45,10 @@ nouveau_gem_object_del(struct drm_gem_object *gem)
 	int ret;
 
 	ret = pm_runtime_get_sync(dev);
-	if (WARN_ON(ret < 0 && ret != -EACCES))
+	if (WARN_ON(ret < 0 && ret != -EACCES)) {
+		pm_runtime_put_autosuspend(dev);
 		return;
+	}
 
 	if (gem->import_attach)
 		drm_prime_gem_destroy(gem, nvbo->bo.sg);
-- 
2.25.1

