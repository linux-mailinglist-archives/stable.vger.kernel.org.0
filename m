Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7225E2B8
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 22:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIDU2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 16:28:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727923AbgIDU2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 16:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599251308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BZDW8aVcR3JjlZkQLY3DvQBbkVCDbW7ARFJrRWlAmag=;
        b=ZlTkt+sFBs+NKCP0ssK/Sdol9spm5xzCblLmFpyIrcFA3GGlbCDUUV/N4HKG3dcgj/FSs+
        AhYdv2QAI8G1TW7Gy9sS9LMbDqw13mY/3ZxQTdT/iHiHTkoRPhLSfqCI6mw01XyY2bIWTM
        HXz4L9TFHgyXguN8ckO6LWkYmabbCWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-tQhuWdMvPFiR8TFL_751LA-1; Fri, 04 Sep 2020 16:28:25 -0400
X-MC-Unique: tQhuWdMvPFiR8TFL_751LA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E2D8420E9;
        Fri,  4 Sep 2020 20:28:23 +0000 (UTC)
Received: from Whitewolf.redhat.com (ovpn-118-1.rdu2.redhat.com [10.10.118.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B15060C05;
        Fri,  4 Sep 2020 20:28:21 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 1/2] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
Date:   Fri,  4 Sep 2020 16:27:58 -0400
Message-Id: <20200904202813.1260202-1-lyude@redhat.com>
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
v4:
* Don't forget to check the return value of core507d_read_caps()
v5:
* Get rid of NV50_DISP_CAPS_NTFY[14], use NV50_DISP_CORE_NTFY
* Disable notifier after calling GetCapabilities()

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 4a2cb4181b07 ("drm/nouveau/kms/nv50-: Probe SOR and PIOR caps for DP interlacing support")
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/nouveau/dispnv50/core.h       |  2 +
 drivers/gpu/drm/nouveau/dispnv50/core507d.c   | 41 ++++++++++++++++++-
 drivers/gpu/drm/nouveau/dispnv50/core907d.c   | 36 +++++++++++++++-
 drivers/gpu/drm/nouveau/dispnv50/core917d.c   |  2 +-
 .../drm/nouveau/include/nvhw/class/cl507d.h   |  5 ++-
 .../drm/nouveau/include/nvhw/class/cl907d.h   |  4 ++
 6 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/core.h b/drivers/gpu/drm/nouveau/dispnv50/core.h
index 498622c0c670d..f75088186fba3 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/core.h
@@ -44,6 +44,7 @@ int core507d_new_(const struct nv50_core_func *, struct nouveau_drm *, s32,
 		  struct nv50_core **);
 int core507d_init(struct nv50_core *);
 void core507d_ntfy_init(struct nouveau_bo *, u32);
+int core507d_read_caps(struct nv50_disp *disp);
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
index 248edf69e1683..e6f16a7750f07 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
@@ -78,18 +78,55 @@ core507d_ntfy_init(struct nouveau_bo *bo, u32 offset)
 }
 
 int
-core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
+core507d_read_caps(struct nv50_disp *disp)
 {
 	struct nvif_push *push = disp->core->chan.push;
 	int ret;
 
-	if ((ret = PUSH_WAIT(push, 2)))
+	ret = PUSH_WAIT(push, 6);
+	if (ret)
 		return ret;
 
+	PUSH_MTHD(push, NV507D, SET_NOTIFIER_CONTROL,
+		  NVDEF(NV507D, SET_NOTIFIER_CONTROL, MODE, WRITE) |
+		  NVVAL(NV507D, SET_NOTIFIER_CONTROL, OFFSET, NV50_DISP_CORE_NTFY >> 2) |
+		  NVDEF(NV507D, SET_NOTIFIER_CONTROL, NOTIFY, ENABLE));
+
 	PUSH_MTHD(push, NV507D, GET_CAPABILITIES, 0x00000000);
+
+	PUSH_MTHD(push, NV507D, SET_NOTIFIER_CONTROL,
+		  NVDEF(NV507D, SET_NOTIFIER_CONTROL, NOTIFY, DISABLE));
+
 	return PUSH_KICK(push);
 }
 
+int
+core507d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp)
+{
+	struct nv50_core *core = disp->core;
+	struct nouveau_bo *bo = disp->sync;
+	s64 time;
+	int ret;
+
+	NVBO_WR32(bo, NV50_DISP_CORE_NTFY, NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1,
+				     NVDEF(NV_DISP_CORE_NOTIFIER_1, CAPABILITIES_1, DONE, FALSE));
+
+	ret = core507d_read_caps(disp);
+	if (ret < 0)
+		return ret;
+
+	time = nvif_msec(core->chan.base.device, 2000ULL,
+			 if (NVBO_TD32(bo, NV50_DISP_CORE_NTFY,
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
index b17c03529c784..8564d4dffaff0 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/core907d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core907d.c
@@ -22,11 +22,45 @@
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
+	int ret;
+
+	NVBO_WR32(bo, NV50_DISP_CORE_NTFY, NV907D_CORE_NOTIFIER_3, CAPABILITIES_4,
+				     NVDEF(NV907D_CORE_NOTIFIER_3, CAPABILITIES_4, DONE, FALSE));
+
+	ret = core507d_read_caps(disp);
+	if (ret < 0)
+		return ret;
+
+	time = nvif_msec(core->chan.base.device, 2000ULL,
+			 if (NVBO_TD32(bo, NV50_DISP_CORE_NTFY,
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

