Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E011FB6D5
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgFPPk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbgFPPk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:40:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F9C721475;
        Tue, 16 Jun 2020 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322055;
        bh=N2fVI1JDeAb55G6+FUaty4ijhd6xjY1FQoh6aCeXreg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rj/5dtpeEu57LOK3K9HMz1li4W+dWFPyOAINhK4GKrtw35EKRIpw+tyMSh0GnulmH
         hsPCmsU8ggpmRa0g9EL2GBTPgvjvrRBDnX5Gi6O0RCyZF8MiA+LJuKeAXd9STl+bX9
         aF/KbTU5S2jT9n+VTCJkydr+KIcMh+mFPWhuxV+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>,
        syzbot+e3372a2afe1e7ef04bc7@syzkaller.appspotmail.com
Subject: [PATCH 5.4 119/134] drm/vkms: Hold gem object while still in-use
Date:   Tue, 16 Jun 2020 17:35:03 +0200
Message-Id: <20200616153106.483679065@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

commit 0ea2ea42b31abc1141f2fd3911f952a97d401fcb upstream.

We need to keep the reference to the drm_gem_object
until the last access by vkms_dumb_create.

Therefore, the put the object after it is used.

This fixes a use-after-free issue reported by syzbot.

While here, change vkms_gem_create() symbol to static.

Reported-and-tested-by: syzbot+e3372a2afe1e7ef04bc7@syzkaller.appspotmail.com
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigosiqueiramelo@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200427214405.13069-1-ezequiel@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vkms/vkms_drv.h |    5 -----
 drivers/gpu/drm/vkms/vkms_gem.c |   11 ++++++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/vkms/vkms_drv.h
+++ b/drivers/gpu/drm/vkms/vkms_drv.h
@@ -121,11 +121,6 @@ struct drm_plane *vkms_plane_init(struct
 				  enum drm_plane_type type, int index);
 
 /* Gem stuff */
-struct drm_gem_object *vkms_gem_create(struct drm_device *dev,
-				       struct drm_file *file,
-				       u32 *handle,
-				       u64 size);
-
 vm_fault_t vkms_gem_fault(struct vm_fault *vmf);
 
 int vkms_dumb_create(struct drm_file *file, struct drm_device *dev,
--- a/drivers/gpu/drm/vkms/vkms_gem.c
+++ b/drivers/gpu/drm/vkms/vkms_gem.c
@@ -95,10 +95,10 @@ vm_fault_t vkms_gem_fault(struct vm_faul
 	return ret;
 }
 
-struct drm_gem_object *vkms_gem_create(struct drm_device *dev,
-				       struct drm_file *file,
-				       u32 *handle,
-				       u64 size)
+static struct drm_gem_object *vkms_gem_create(struct drm_device *dev,
+					      struct drm_file *file,
+					      u32 *handle,
+					      u64 size)
 {
 	struct vkms_gem_object *obj;
 	int ret;
@@ -111,7 +111,6 @@ struct drm_gem_object *vkms_gem_create(s
 		return ERR_CAST(obj);
 
 	ret = drm_gem_handle_create(file, &obj->gem, handle);
-	drm_gem_object_put_unlocked(&obj->gem);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -140,6 +139,8 @@ int vkms_dumb_create(struct drm_file *fi
 	args->size = gem_obj->size;
 	args->pitch = pitch;
 
+	drm_gem_object_put_unlocked(gem_obj);
+
 	DRM_DEBUG_DRIVER("Created object of size %lld\n", size);
 
 	return 0;


