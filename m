Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20245304ABA
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbhAZE6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729342AbhAYSuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0298D224D1;
        Mon, 25 Jan 2021 18:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600576;
        bh=w47xUjtssxFdsLz2ijKucaSRH0GvyKyr248a8MEcdPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wytI0WV5Pt1nEFuv97urECGB1LtMlTZrASB8p7JvJT0vZzvUNDGyZ45Ctvoj+oumH
         8z1ieNBke9WTWN+Y7vsct0OhLeEHLlFhajXmOnRl9MR2J/RGe2aGb7UgGhQvNW2gRL
         afQJXezhO5LvdxQ7+ISyobRLg1rf+FR3kLlYk/18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/199] drm/nouveau/kms/nv50-: fix case where notifier buffer is at offset 0
Date:   Mon, 25 Jan 2021 19:38:11 +0100
Message-Id: <20210125183219.182666861@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
index 36d6b6093d16d..5b8cabb099eb1 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -221,7 +221,7 @@ nv50_dmac_wait(struct nvif_push *push, u32 size)
 
 int
 nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
-		 const s32 *oclass, u8 head, void *data, u32 size, u64 syncbuf,
+		 const s32 *oclass, u8 head, void *data, u32 size, s64 syncbuf,
 		 struct nv50_dmac *dmac)
 {
 	struct nouveau_cli *cli = (void *)device->object.client;
@@ -270,7 +270,7 @@ nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
 	if (ret)
 		return ret;
 
-	if (!syncbuf)
+	if (syncbuf < 0)
 		return 0;
 
 	ret = nvif_object_ctor(&dmac->base.user, "kmsSyncCtxDma", NV50_DISP_HANDLE_SYNCBUF,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.h b/drivers/gpu/drm/nouveau/dispnv50/disp.h
index 92bddc0836171..38dec11e7dda5 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.h
@@ -95,7 +95,7 @@ struct nv50_outp_atom {
 
 int nv50_dmac_create(struct nvif_device *device, struct nvif_object *disp,
 		     const s32 *oclass, u8 head, void *data, u32 size,
-		     u64 syncbuf, struct nv50_dmac *dmac);
+		     s64 syncbuf, struct nv50_dmac *dmac);
 void nv50_dmac_destroy(struct nv50_dmac *);
 
 /*
diff --git a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
index 685b708713242..b390029c69ec1 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c
@@ -76,7 +76,7 @@ wimmc37b_init_(const struct nv50_wimm_func *func, struct nouveau_drm *drm,
 	int ret;
 
 	ret = nv50_dmac_create(&drm->client.device, &disp->disp->object,
-			       &oclass, 0, &args, sizeof(args), 0,
+			       &oclass, 0, &args, sizeof(args), -1,
 			       &wndw->wimm);
 	if (ret) {
 		NV_ERROR(drm, "wimm%04x allocation failed: %d\n", oclass, ret);
-- 
2.27.0



