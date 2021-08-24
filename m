Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3373F5497
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhHXAzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233781AbhHXAzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11ED61423;
        Tue, 24 Aug 2021 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766467;
        bh=dc6kas5jlSzoNZX45DZHg4hAZj9suAd7fww8wxE7Xgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaTcss6IJrZ8F8WHqGeXBPuWW2oCQTjVKEmFnrqZNUJylSkbRR1qmXRIqy0ZhMWRf
         32kAh4MMl2cP8/pw5CqRNnWyHEVkIo2qiRFUz9tZI49hiGQidSCjhvVJJY3CI+UcIK
         zgnGfqnFcCN2d6xK93gdd8F5J5WamDi7aB1ATMFaq3kPZnzEi7XJ8Tus2c8xPZJB/f
         lwq0bsaVFlgCFVr6l/N/K/O5AVw8D2aZjagfQj3HSqA02MOb6Z3N82+wpFxWX0JyBb
         5xgYP5QDaTvivUzZycjqqsqehXzJW2vHL+CLpzbpfvYQtZQ6A84EB719Ww0UgOXfWa
         VnyRs62RYs9sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 23/26] drm/nouveau: block a bunch of classes from userspace
Date:   Mon, 23 Aug 2021 20:53:53 -0400
Message-Id: <20210824005356.630888-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit 148a8653789c01f159764ffcc3f370008966b42f ]

Long ago, there had been plans for making use of a bunch of these APIs
from userspace and there's various checks in place to stop misbehaving.

Countless other projects have occurred in the meantime, and the pieces
didn't finish falling into place for that to happen.

They will (hopefully) in the not-too-distant future, but it won't look
quite as insane.  The super checks are causing problems right now, and
are going to be removed.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/include/nvif/cl0080.h |  3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c         |  1 +
 drivers/gpu/drm/nouveau/nouveau_usif.c        | 57 ++++++++++++++-----
 .../gpu/drm/nouveau/nvkm/engine/device/user.c |  2 +-
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvif/cl0080.h b/drivers/gpu/drm/nouveau/include/nvif/cl0080.h
index 0b86c44878e0..59759c4fb62e 100644
--- a/drivers/gpu/drm/nouveau/include/nvif/cl0080.h
+++ b/drivers/gpu/drm/nouveau/include/nvif/cl0080.h
@@ -4,7 +4,8 @@
 
 struct nv_device_v0 {
 	__u8  version;
-	__u8  pad01[7];
+	__u8  priv;
+	__u8  pad02[6];
 	__u64 device;	/* device identifier, ~0 for client default */
 };
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 885815ea917f..5cadd7c5a252 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -242,6 +242,7 @@ nouveau_cli_init(struct nouveau_drm *drm, const char *sname,
 	ret = nvif_device_ctor(&cli->base.object, "drmDevice", 0, NV_DEVICE,
 			       &(struct nv_device_v0) {
 					.device = ~0,
+					.priv = true,
 			       }, sizeof(struct nv_device_v0),
 			       &cli->device);
 	if (ret) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_usif.c b/drivers/gpu/drm/nouveau/nouveau_usif.c
index 9dc10b17ad34..5da1f4d223d7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_usif.c
+++ b/drivers/gpu/drm/nouveau/nouveau_usif.c
@@ -32,6 +32,9 @@
 #include <nvif/event.h>
 #include <nvif/ioctl.h>
 
+#include <nvif/class.h>
+#include <nvif/cl0080.h>
+
 struct usif_notify_p {
 	struct drm_pending_event base;
 	struct {
@@ -261,7 +264,7 @@ usif_object_dtor(struct usif_object *object)
 }
 
 static int
-usif_object_new(struct drm_file *f, void *data, u32 size, void *argv, u32 argc)
+usif_object_new(struct drm_file *f, void *data, u32 size, void *argv, u32 argc, bool parent_abi16)
 {
 	struct nouveau_cli *cli = nouveau_cli(f);
 	struct nvif_client *client = &cli->base;
@@ -271,23 +274,48 @@ usif_object_new(struct drm_file *f, void *data, u32 size, void *argv, u32 argc)
 	struct usif_object *object;
 	int ret = -ENOSYS;
 
+	if ((ret = nvif_unpack(ret, &data, &size, args->v0, 0, 0, true)))
+		return ret;
+
+	switch (args->v0.oclass) {
+	case NV_DMA_FROM_MEMORY:
+	case NV_DMA_TO_MEMORY:
+	case NV_DMA_IN_MEMORY:
+		return -EINVAL;
+	case NV_DEVICE: {
+		union {
+			struct nv_device_v0 v0;
+		} *args = data;
+
+		if ((ret = nvif_unpack(ret, &data, &size, args->v0, 0, 0, false)))
+			return ret;
+
+		args->v0.priv = false;
+		break;
+	}
+	default:
+		if (!parent_abi16)
+			return -EINVAL;
+		break;
+	}
+
 	if (!(object = kmalloc(sizeof(*object), GFP_KERNEL)))
 		return -ENOMEM;
 	list_add(&object->head, &cli->objects);
 
-	if (!(ret = nvif_unpack(ret, &data, &size, args->v0, 0, 0, true))) {
-		object->route = args->v0.route;
-		object->token = args->v0.token;
-		args->v0.route = NVDRM_OBJECT_USIF;
-		args->v0.token = (unsigned long)(void *)object;
-		ret = nvif_client_ioctl(client, argv, argc);
-		args->v0.token = object->token;
-		args->v0.route = object->route;
+	object->route = args->v0.route;
+	object->token = args->v0.token;
+	args->v0.route = NVDRM_OBJECT_USIF;
+	args->v0.token = (unsigned long)(void *)object;
+	ret = nvif_client_ioctl(client, argv, argc);
+	if (ret) {
+		usif_object_dtor(object);
+		return ret;
 	}
 
-	if (ret)
-		usif_object_dtor(object);
-	return ret;
+	args->v0.token = object->token;
+	args->v0.route = object->route;
+	return 0;
 }
 
 int
@@ -301,6 +329,7 @@ usif_ioctl(struct drm_file *filp, void __user *user, u32 argc)
 		struct nvif_ioctl_v0 v0;
 	} *argv = data;
 	struct usif_object *object;
+	bool abi16 = false;
 	u8 owner;
 	int ret;
 
@@ -331,11 +360,13 @@ usif_ioctl(struct drm_file *filp, void __user *user, u32 argc)
 			mutex_unlock(&cli->mutex);
 			goto done;
 		}
+
+		abi16 = true;
 	}
 
 	switch (argv->v0.type) {
 	case NVIF_IOCTL_V0_NEW:
-		ret = usif_object_new(filp, data, size, argv, argc);
+		ret = usif_object_new(filp, data, size, argv, argc, abi16);
 		break;
 	case NVIF_IOCTL_V0_NTFY_NEW:
 		ret = usif_notify_new(filp, data, size, argv, argc);
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c
index fea9d8f2b10c..f28894fdede9 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c
@@ -397,7 +397,7 @@ nvkm_udevice_new(const struct nvkm_oclass *oclass, void *data, u32 size,
 		return ret;
 
 	/* give priviledged clients register access */
-	if (client->super)
+	if (args->v0.priv)
 		func = &nvkm_udevice_super;
 	else
 		func = &nvkm_udevice;
-- 
2.30.2

