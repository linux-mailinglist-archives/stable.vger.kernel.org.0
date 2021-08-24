Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AAD3F54DD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhHXA5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhHXA4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8417615E4;
        Tue, 24 Aug 2021 00:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766510;
        bh=uuII/fHDZKZ37JSjCcIDfBjf4SqtgMmTPhUZMG/lwUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5F6PYQDQP8lwEt8JMr8IlzA2iIjkLM+ZX5xp//1qdmb30Z30Nf8O2YUuwWpv3zS4
         SglUTiSMFxF7QHqBiRyHeTl1cJAlSluN9zV8VLRHcaIWKcvQ28Gfvlwv4EM1Zkj93B
         l1cC+k8zbwUdDH3byTNkImOM1KPuZl7ApFkVpa8vRKQGqmJNj7Lm0d34h46xpeisyt
         s0FaVqqbpmLaI8d71s6/fzxw2Bb1gtoPq90NAGVGg5LoadcEteXycwQw/93Snqz5pZ
         H13J5s27R/VdwdSOiqhGF4fbcsssE6Vrv9BCP74aDcj8t9OZSTPOzeWZ40sTh6BDB1
         A3bAkX/jqtd8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 09/10] drm/nouveau: block a bunch of classes from userspace
Date:   Mon, 23 Aug 2021 20:54:56 -0400
Message-Id: <20210824005458.631377-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005458.631377-1-sashal@kernel.org>
References: <20210824005458.631377-1-sashal@kernel.org>
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
index cd9a2e687bb6..08bda344e32f 100644
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
index 5347e5bdee8c..3e7c55a2302c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -241,6 +241,7 @@ nouveau_cli_init(struct nouveau_drm *drm, const char *sname,
 	ret = nvif_device_init(&cli->base.object, 0, NV_DEVICE,
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
index 03c6d9aef075..69ca7cb2d663 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/user.c
@@ -426,7 +426,7 @@ nvkm_udevice_new(const struct nvkm_oclass *oclass, void *data, u32 size,
 		return ret;
 
 	/* give priviledged clients register access */
-	if (client->super)
+	if (args->v0.priv)
 		func = &nvkm_udevice_super;
 	else
 		func = &nvkm_udevice;
-- 
2.30.2

