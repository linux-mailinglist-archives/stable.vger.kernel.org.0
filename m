Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6552ABA2B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbgKINQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732251AbgKINQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F57206D8;
        Mon,  9 Nov 2020 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927785;
        bh=bHymZLqrSXJSBTuyoy+7+TUo85iP5i7JQlwErl6ORZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pjqv3OylFcVrGQtg0+sExhHfPnhpFKCUkNOFfdm2PwrsdQ7A4+59Tr6mHgmvwDk9f
         N/9lmIxFaZffFbMimPXDCSq4h4C8NT0yqdZKNnnz6pPOZFdYlCecvKwkUKSIh2nvpr
         2LK8gWEqodf6Q0LZwLXa8DfiTdFpIMLijaEbYF9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.9 020/133] drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
Date:   Mon,  9 Nov 2020 13:54:42 +0100
Message-Id: <20201109125031.689636633@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 24d9422e26ea75118acf00172f83417c296f5b5f upstream.

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
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/dispnv50/core.h             |    2 
 drivers/gpu/drm/nouveau/dispnv50/core507d.c         |   41 +++++++++++++++++++-
 drivers/gpu/drm/nouveau/dispnv50/core907d.c         |   36 +++++++++++++++++
 drivers/gpu/drm/nouveau/dispnv50/core917d.c         |    2 
 drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h |    5 +-
 drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h |    4 +
 6 files changed, 85 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/core.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/core.h
@@ -44,6 +44,7 @@ int core507d_new_(const struct nv50_core
 		  struct nv50_core **);
 int core507d_init(struct nv50_core *);
 void core507d_ntfy_init(struct nouveau_bo *, u32);
+int core507d_read_caps(struct nv50_disp *disp);
 int core507d_caps_init(struct nouveau_drm *, struct nv50_disp *);
 int core507d_ntfy_wait_done(struct nouveau_bo *, u32, struct nvif_device *);
 int core507d_update(struct nv50_core *, u32 *, bool);
@@ -55,6 +56,7 @@ extern const struct nv50_outp_func pior5
 int core827d_new(struct nouveau_drm *, s32, struct nv50_core **);
 
 int core907d_new(struct nouveau_drm *, s32, struct nv50_core **);
+int core907d_caps_init(struct nouveau_drm *drm, struct nv50_disp *disp);
 extern const struct nv50_outp_func dac907d;
 extern const struct nv50_outp_func sor907d;
 
--- a/drivers/gpu/drm/nouveau/dispnv50/core507d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/core507d.c
@@ -78,19 +78,56 @@ core507d_ntfy_init(struct nouveau_bo *bo
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
 
 int
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
+int
 core507d_init(struct nv50_core *core)
 {
 	struct nvif_push *push = core->chan.push;
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


