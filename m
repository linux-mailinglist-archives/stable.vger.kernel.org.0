Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D2B25A1F8
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 01:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIAXjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 19:39:13 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgIAXjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 19:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599003550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iIgftDPZ6SF8umaBejPdd+v6H04Rm7NRcY7/1QkewU=;
        b=Dw1cSb1dqRRnrKmIFlL6DXXKgDT5JbdJQK4/CAhTOqlfz/ZZ+nBMAUNVLYYHpUhEz4xDiW
        pI9Cjpl+nm6tu3JYEqzuWcJiGokrM3WE/bfOnQa+hsbZ4Wysjx1S7IKNJ4xtQ8LQHeDbZ2
        5goCC5ckfsTiqn0j9UUW5RVEppojKz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-p3seJ9kXNYCK5akRClhjmg-1; Tue, 01 Sep 2020 19:39:08 -0400
X-MC-Unique: p3seJ9kXNYCK5akRClhjmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798D910082E8;
        Tue,  1 Sep 2020 23:39:05 +0000 (UTC)
Received: from Whitewolf.redhat.com (ovpn-119-108.rdu2.redhat.com [10.10.119.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B4E96198E;
        Tue,  1 Sep 2020 23:39:00 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        James Jones <jajones@nvidia.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
Date:   Tue,  1 Sep 2020 19:38:27 -0400
Message-Id: <20200901233842.196818-1-lyude@redhat.com>
In-Reply-To: <20200824183253.826343-2-lyude@redhat.com>
References: <20200824183253.826343-2-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not entirely sure why this never came up when I originally tested this
(maybe some BIOSes already have this setup?) but the ->caps_init vfunc
appears to cause the display engine to throw an exception on driver
init, at least on my ThinkPad P72:

nouveau 0000:01:00.0: disp: chid 0 mthd 008c data 00000000 0000508c 0000102b

This is magic nvidia speak for "You need to have the DMA notifier offset
programmed before you can call NV507D_GET_CAPABILITIES." So, let's fix
this by doing that, and also perform an update afterwards to prevent
racing with the GPU when reading capabilities.

v2:
* Don't just program the DMA notifier offset, make sure to actually
  perform an update
v3:
* Don't call UPDATE()
* Actually read the correct notifier fields, as apparently the
  CAPABILITIES_DONE field lives in a different location than the main
  NV_DISP_CORE_NOTIFIER_1 field. As well, 907d+ use a different
  CAPABILITIES_DONE field then pre-907d cards.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support")
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/nouveau/dispnv50/core.h       |  2 ++
 drivers/gpu/drm/nouveau/dispnv50/core507d.c   | 34 +++++++++++++++++--
 drivers/gpu/drm/nouveau/dispnv50/core907d.c   | 33 +++++++++++++++++-
 drivers/gpu/drm/nouveau/dispnv50/core917d.c   |  2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.h       |  2 ++
 .../drm/nouveau/include/nvhw/class/cl507d.h   |  5 ++-
 .../drm/nouveau/include/nvhw/class/cl907d.h   |  4 +++
 7 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/core.h b/drivers/gpu/drm/nouveau/dispnv50/core.h
index 498622c0c670d..b789139e5fff6 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/core.h
@@ -44,6 +44,7 @@ int core507d_new_(const struct nv50_core_func *, struct nouveau_drm *, s32,
 		  struct nv50_core **);
 int core507d_init(struct nv50_core *);
 void core507d_ntfy_init(struct nouveau_bo *, u32);
+int core507d_read_caps(struct nv50_disp *disp, u32 offset);
 int core507d_caps_init(struct nouveau_drm *, struct nv50_disp *);
 int core507d_ntfy_wait_done(struct nouveau_bo *, u32, struct nvif_device *);
 int core507d_update(struct nv50_core *, u32 *, bool);
@@ -55,6 +56,7 @@ extern const struct nv50_outp_func pior507d;
 int core827d_new(struct nouveau_drm *, s32, struct nv50_core **);
 
 int core907d_new(struct nouveau_drm *, s32, struct nv50_core **);
+int core907d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp);
 extern const struct nv50_outp_func dac907d;
 extern const struct nv50_outp_func sor907d;
 
diff --git a/drivers/gpu/drm/nouveau/dispnv50/core507d.c b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
index ad1f09a143aa4..3ec4c3a238c41 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
@@ -75,18 +75,48 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
 }
 
 int
-core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
+core507d_read_caps(struct nv50_disp *disp, u32 offset)
 {
 	struct nvif_push *push = disp->core->chan.push;
 	int ret;
 
-	if ((ret = PUSH_WAIT(push, 2)))
+	ret = PUSH_WAIT(push, 4);
+	if (ret)
 		return ret;
 
+	PUSH_MTHD(push, NV507D, SET_NOTIFIER_CONTROL,
+		  NVDEF(NV507D, SET_NOTIFIER_CONTROL, MODE, WRITE) |
+		  NVVAL(NV507D, SET_NOTIFIER_CONTROL, OFFSET, offset >> 2) |
+		  NVDEF(NV507D, SET_NOTIFIER_CONTROL, NOTIFY, ENABLE));
 	PUSH_MTHD(push, NV507D, GET_CAPABILITIES, 0x00000000);
+
 	return PUSH_KICK(push);
 }
 
+int
+core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
+{
+	struct nv50_core *core = disp->core;
+	struct nouveau_bo *bo = disp->sync;
+	s64 time;
+
+	NVBO_WR32(bo, NV50_DISP_CAPS_NTFY1, NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1,
+				      NVDEF(NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1, DONE, FALSE));
+
+	core507d_read_caps(disp, NV50_DISP_CAPS_NTFY1);
+
+	time = nvif_msec(core->chan.base.device, 2000ULL,
+			 if (NVBO_TD32(bo, NV50_DISP_CAPS_NTFY1,
+				       NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1, DONE, ==, TRUE))
+				 break;
+			 usleep_range(1, 2);
+			 );
+	if (time < 0)
+		NV_ERROR(drm, "core caps notifier timeout\n");
+
+	return 0;
+}
+
 int
 core507d_init(struct nv50_core *core)
 {
diff --git a/drivers/gpu/drm/nouveau/dispnv50/core907d.c b/drivers/gpu/drm/nouveau/dispnv50/core907d.c
index b17c03529c784..8a2005adb0e2f 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core907d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core907d.c
@@ -22,11 +22,42 @@
 #include "core.h"
 #include "head.h"
 
+#include <nvif/push507c.h>
+#include <nvif/timer.h>
+
+#include <nvhw/class/cl907d.h>
+
+#include "nouveau_bo.h"
+
+int
+core907d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
+{
+	struct nv50_core *core = disp->core;
+	struct nouveau_bo *bo = disp->sync;
+	s64 time;
+
+	NVBO_WR32(bo, NV50_DISP_CAPS_NTFY4, NV907D_CORE_NOTIFIER_3, CAPABILITIES_4,
+				      NVDEF(NV907D_CORE_NOTIFIER_3, CAPABILITIES_4, DONE, FALSE));
+
+	core507d_read_caps(disp, NV50_DISP_CAPS_NTFY4);
+
+	time = nvif_msec(core->chan.base.device, 2000ULL,
+			 if (NVBO_TD32(bo, NV50_DISP_CAPS_NTFY4,
+				       NV907D_CORE_NOTIFIER_3, CAPABILITIES_4, DONE, ==, TRUE))
+				 break;
+			 usleep_range(1, 2);
+			 );
+	if (time < 0)
+		NV_ERROR(drm, "core caps notifier timeout\n");
+
+	return 0;
+}
+
 static const struct nv50_core_func
 core907d = {
 	.init = core507d_init,
 	.ntfy_init = core507d_ntfy_init,
-	.caps_init = core507d_caps_init,
+	.caps_init = core907d_caps_init,
 	.ntfy_wait_done = core507d_ntfy_wait_done,
 	.update = core507d_update,
 	.head = &head907d,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/core917d.c b/drivers/gpu/drm/nouveau/dispnv50/core917d.c
index 66846f3720805..1cd3a2a35dfb7 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core917d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core917d.c
@@ -26,7 +26,7 @@ static const struct nv50_core_func
 core917d = {
 	.init = core507d_init,
 	.ntfy_init = core507d_ntfy_init,
-	.caps_init = core507d_caps_init,
+	.caps_init = core907d_caps_init,
 	.ntfy_wait_done = core507d_ntfy_wait_done,
 	.update = core507d_update,
 	.head = &head917d,
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.h b/drivers/gpu/drm/nouveau/dispnv50/disp.h
index 92bddc0836171..a59051bd070d7 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.h
@@ -16,6 +16,8 @@ struct nv50_disp {
 
 #define NV50_DISP_SYNC(c, o)                                ((c) * 0x040 + (o))
 #define NV50_DISP_CORE_NTFY                       NV50_DISP_SYNC(0      , 0x00)
+#define NV50_DISP_CAPS_NTFY1                      NV50_DISP_SYNC(0      , 0x01)
+#define NV50_DISP_CAPS_NTFY4                      NV50_DISP_SYNC(0      , 0x04)
 #define NV50_DISP_WNDW_SEM0(c)                    NV50_DISP_SYNC(1 + (c), 0x00)
 #define NV50_DISP_WNDW_SEM1(c)                    NV50_DISP_SYNC(1 + (c), 0x10)
 #define NV50_DISP_WNDW_NTFY(c)                    NV50_DISP_SYNC(1 + (c), 0x20)
diff --git a/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h b/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
index 2e444bac701dd..6a463f308b64f 100644
--- a/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
+++ b/drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h
@@ -32,7 +32,10 @@
 #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_DONE_TRUE                               0x00000001
 #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_R0                                      15:1
 #define NV_DISP_CORE_NOTIFIER_1_COMPLETION_0_TIMESTAMP                               29:16
-
+#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1                                       0x00000001
+#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE                                  0:0
+#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE_FALSE                            0x00000000
+#define NV_DISP_CORE_NOTIFIER_1_CAPABILITIES_1_DONE_TRUE                             0x00000001
 
 // class methods
 #define NV507D_UPDATE                                                           (0x00000080)
diff --git a/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h b/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
index 34bc3eafac7d1..79aff6ff31385 100644
--- a/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
+++ b/drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h
@@ -24,6 +24,10 @@
 #ifndef _cl907d_h_
 #define _cl907d_h_
 
+#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4                                       0x00000004
+#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE                                  0:0
+#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE_FALSE                            0x00000000
+#define NV907D_CORE_NOTIFIER_3_CAPABILITIES_4_DONE_TRUE                             0x00000001
 #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20                             0x00000014
 #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20_SINGLE_LVDS18               0:0
 #define NV907D_CORE_NOTIFIER_3_CAPABILITIES_CAP_SOR0_20_SINGLE_LVDS18_FALSE         0x00000000
-- 
2.26.2

