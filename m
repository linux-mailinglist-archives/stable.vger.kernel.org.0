Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E497330BFE5
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhBBNo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhBBNms (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:42:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9389364F6C;
        Tue,  2 Feb 2021 13:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273214;
        bh=0cc0C+ESJgLTR5Nx83f8VhA64RykTwwolse4CCSrHjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvsxz9B5dR7vBe1cRKjJvQksiXWCNNpN17ea1X0RLGvwHwdPkyltSLIzbitN1NYB6
         +JG0m0iKiaPoQF5kB5wuXAMS+g6lXAZGenMgtjA93nPI7/11bf3Ss+rtgUUw+B5ZVF
         CgMdXeXCl1AyMK4w9Hozcvb8X+sZqlyxacpScS6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Peres <martin.peres@free.fr>,
        Jeremy Cline <jcline@redhat.com>,
        Simon Ser <contact@emersion.fr>, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.10 023/142] drm/nouveau/kms/gk104-gp1xx: Fix > 64x64 cursors
Date:   Tue,  2 Feb 2021 14:36:26 +0100
Message-Id: <20210202132958.670163001@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit ba839b7598440a5d78550a115bac21b08d57cc32 upstream.

While we do handle the additional cursor sizes introduced in NVE4, it looks
like we accidentally broke this when converting over to use Nvidia's
display headers. Since we now use NVVAL in dispnv50/head907d.c in order to
format the value for the cursor layout and NVD9 only had one byte reserved
vs. the 2 bytes reserved in later generations, we end up accidentally
stripping the second bit in the cursor layout format parameter - causing us
to set the wrong cursor size.

This fixes that by adding our own curs_set hook for 917d which uses the
NV917D headers.

Cc: Martin Peres <martin.peres@free.fr>
Cc: Jeremy Cline <jcline@redhat.com>
Cc: Simon Ser <contact@emersion.fr>
Cc: <stable@vger.kernel.org> # v5.9+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ed0b86a90bf9 ("drm/nouveau/kms/nv50-: use NVIDIA's headers for core head_curs_set()")
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/gpu/drm/nouveau/dispnv50/head917d.c b/drivers/gpu/drm/nouveau/dispnv50/head917d.c
index a5d827403660..ea9f8667305e 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head917d.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head917d.c
@@ -22,6 +22,7 @@
 #include "head.h"
 #include "core.h"
 
+#include "nvif/push.h"
 #include <nvif/push507c.h>
 
 #include <nvhw/class/cl917d.h>
@@ -73,6 +74,31 @@ head917d_base(struct nv50_head *head, struct nv50_head_atom *asyh)
 	return 0;
 }
 
+static int
+head917d_curs_set(struct nv50_head *head, struct nv50_head_atom *asyh)
+{
+	struct nvif_push *push = nv50_disp(head->base.base.dev)->core->chan.push;
+	const int i = head->base.index;
+	int ret;
+
+	ret = PUSH_WAIT(push, 5);
+	if (ret)
+		return ret;
+
+	PUSH_MTHD(push, NV917D, HEAD_SET_CONTROL_CURSOR(i),
+		  NVDEF(NV917D, HEAD_SET_CONTROL_CURSOR, ENABLE, ENABLE) |
+		  NVVAL(NV917D, HEAD_SET_CONTROL_CURSOR, FORMAT, asyh->curs.format) |
+		  NVVAL(NV917D, HEAD_SET_CONTROL_CURSOR, SIZE, asyh->curs.layout) |
+		  NVVAL(NV917D, HEAD_SET_CONTROL_CURSOR, HOT_SPOT_X, 0) |
+		  NVVAL(NV917D, HEAD_SET_CONTROL_CURSOR, HOT_SPOT_Y, 0) |
+		  NVDEF(NV917D, HEAD_SET_CONTROL_CURSOR, COMPOSITION, ALPHA_BLEND),
+
+				HEAD_SET_OFFSET_CURSOR(i), asyh->curs.offset >> 8);
+
+	PUSH_MTHD(push, NV917D, HEAD_SET_CONTEXT_DMA_CURSOR(i), asyh->curs.handle);
+	return 0;
+}
+
 int
 head917d_curs_layout(struct nv50_head *head, struct nv50_wndw_atom *asyw,
 		     struct nv50_head_atom *asyh)
@@ -101,7 +127,7 @@ head917d = {
 	.core_clr = head907d_core_clr,
 	.curs_layout = head917d_curs_layout,
 	.curs_format = head507d_curs_format,
-	.curs_set = head907d_curs_set,
+	.curs_set = head917d_curs_set,
 	.curs_clr = head907d_curs_clr,
 	.base = head917d_base,
 	.ovly = head907d_ovly,
diff --git a/drivers/gpu/drm/nouveau/include/nvhw/class/cl917d.h b/drivers/gpu/drm/nouveau/include/nvhw/class/cl917d.h
index 2a2612d6e1e0..fb223723a38a 100644
--- a/drivers/gpu/drm/nouveau/include/nvhw/class/cl917d.h
+++ b/drivers/gpu/drm/nouveau/include/nvhw/class/cl917d.h
@@ -66,6 +66,10 @@
 #define NV917D_HEAD_SET_CONTROL_CURSOR_COMPOSITION_ALPHA_BLEND                  (0x00000000)
 #define NV917D_HEAD_SET_CONTROL_CURSOR_COMPOSITION_PREMULT_ALPHA_BLEND          (0x00000001)
 #define NV917D_HEAD_SET_CONTROL_CURSOR_COMPOSITION_XOR                          (0x00000002)
+#define NV917D_HEAD_SET_OFFSET_CURSOR(a)                                        (0x00000484 + (a)*0x00000300)
+#define NV917D_HEAD_SET_OFFSET_CURSOR_ORIGIN                                    31:0
+#define NV917D_HEAD_SET_CONTEXT_DMA_CURSOR(a)                                   (0x0000048C + (a)*0x00000300)
+#define NV917D_HEAD_SET_CONTEXT_DMA_CURSOR_HANDLE                               31:0
 #define NV917D_HEAD_SET_DITHER_CONTROL(a)                                       (0x000004A0 + (a)*0x00000300)
 #define NV917D_HEAD_SET_DITHER_CONTROL_ENABLE                                   0:0
 #define NV917D_HEAD_SET_DITHER_CONTROL_ENABLE_DISABLE                           (0x00000000)


