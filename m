Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E32A440D8
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFMQJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731257AbfFMIoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ADAA2147A;
        Thu, 13 Jun 2019 08:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415452;
        bh=r9PVd2oBi+l5mmfgbA2673gCPPqo7CsSezjV9vr1aHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+T1BDjRxrjulRcaKhwTKtA+IFiPk0DQwYmBEWK2Kgcqjdxs9qbdYMIq/fvCW17nC
         /+8ZweSZko1sxllSVOS0m6RsL5w6EHa+AKG1+k8pMDlauOWUFZhzgpOFO90Y6vGpi+
         G7tpf61UiNT7xJTh7z7CzuGXv8Sm5M1UIBz3M9tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 001/155] Revert "drm: allow render capable master with DRM_AUTH ioctls"
Date:   Thu, 13 Jun 2019 10:31:53 +0200
Message-Id: <20190613075652.777739182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dbb92471674a48892f5e50779425e03388073ab9 ]

This reverts commit 8059add0478e29cb641936011a8fcc9ce9fd80be.

This commit while seemingly a good idea, breaks a radv check,
for a node being master because something succeeds where it failed
before now.

Apply the Linus rule, revert early and try again, we don't break
userspace.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioctl.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 687943df58e1..ab5692104ea0 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -508,13 +508,6 @@ int drm_version(struct drm_device *dev, void *data,
 	return err;
 }
 
-static inline bool
-drm_render_driver_and_ioctl(const struct drm_device *dev, u32 flags)
-{
-	return drm_core_check_feature(dev, DRIVER_RENDER) &&
-		(flags & DRM_RENDER_ALLOW);
-}
-
 /**
  * drm_ioctl_permit - Check ioctl permissions against caller
  *
@@ -529,19 +522,14 @@ drm_render_driver_and_ioctl(const struct drm_device *dev, u32 flags)
  */
 int drm_ioctl_permit(u32 flags, struct drm_file *file_priv)
 {
-	const struct drm_device *dev = file_priv->minor->dev;
-
 	/* ROOT_ONLY is only for CAP_SYS_ADMIN */
 	if (unlikely((flags & DRM_ROOT_ONLY) && !capable(CAP_SYS_ADMIN)))
 		return -EACCES;
 
-	/* AUTH is only for master ... */
-	if (unlikely((flags & DRM_AUTH) && drm_is_primary_client(file_priv))) {
-		/* authenticated ones, or render capable on DRM_RENDER_ALLOW. */
-		if (!file_priv->authenticated &&
-		    !drm_render_driver_and_ioctl(dev, flags))
-			return -EACCES;
-	}
+	/* AUTH is only for authenticated or render client */
+	if (unlikely((flags & DRM_AUTH) && !drm_is_render_client(file_priv) &&
+		     !file_priv->authenticated))
+		return -EACCES;
 
 	/* MASTER is only for master or control clients */
 	if (unlikely((flags & DRM_MASTER) &&
-- 
2.20.1



