Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9994F303346
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbhAZEtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730020AbhAYSqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0663C224BE;
        Mon, 25 Jan 2021 18:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600325;
        bh=RccCsQNVx20yPJGFohhUuMJI9emhkI0B9PKi9OPEaC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmODwJo7c+/gxd/sGIGdBwIkqT9IL8jqun/M7BxPG1y5ZR2sno6u3GVYMIb4aY4yy
         J+P8wd4FUGrrIFjBQEAekHg66YQasrN/mAGInSCKFCir9VNs48PspaAanWp96egFv7
         Bb90JDAa3xX5TwArVLekOTzVRFi0BnTi6AuhqVtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/86] drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0
Date:   Mon, 25 Jan 2021 19:39:23 +0100
Message-Id: <20210125183202.801047339@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit caeb6ab899c3d36a74cda6e299c6e1c9c4e2a22e ]

VRAM offset 0 is a valid address, triggered on GA102.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c     | 4 ++--
 drivers/gpu/drm/nouveau/dispnv50/disp.h     | 2 +-
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index ee2b1e1199e09..daa79d39201f9 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -132,7 +132,7 @@ nv50_dmac_destroy(struct nv50_dmac *dmac)
 
 int
 nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
-		 const s32 *oclass, u8 head, void *data, u32 size, u64 syncbuf,
+		 const s32 *oclass, u8 head, void *data, u32 size, s64 syncbuf,
 		 struct nv50_dmac *dmac)
 {
 	struct nouveau_cli *cli = (void *)device->object.client;
@@ -167,7 +167,7 @@ nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
 	if (ret)
 		return ret;
 
-	if (!syncbuf)
+	if (syncbuf < 0)
 		return 0;
 
 	ret = nvif_object_init(&dmac->base.user, 0xf0000000, NV_DMA_IN_MEMORY,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.h b/drivers/gpu/drm/nouveau/dispnv50/disp.h
index 7c41b0599d1ac..284068fa6d007 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.h
@@ -70,7 +70,7 @@ struct nv50_dmac {
 
 int nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
 		     const s32 *oclass, u8 head, void *data, u32 size,
-		     u64 syncbuf, struct nv50_dmac *dmac);
+		     s64 syncbuf, struct nv50_dmac *dmac);
 void nv50_dmac_destroy(struct nv50_dmac *);
 
 u32 *evo_wait(struct nv50_dmac *, int nr);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
index f7dbd965e4e72..b49a212af4d8d 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
@@ -68,7 +68,7 @@ wimmc37b_init_(const struct nv50_wimm_func *func, struct nouveau_drm *drm,
 	int ret;
 
 	ret = nv50_dmac_create(&drm->client.device, &disp->disp->object,
-			       &oclass, 0, &args, sizeof(args), 0,
+			       &oclass, 0, &args, sizeof(args), -1,
 			       &wndw->wimm);
 	if (ret) {
 		NV_ERROR(drm, "wimm%04x allocation failed: %d\n", oclass, ret);
-- 
2.27.0



