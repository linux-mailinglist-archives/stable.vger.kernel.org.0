Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0723F5493
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhHXAzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhHXAzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23186140D;
        Tue, 24 Aug 2021 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766464;
        bh=pdzR9bAcvlOI9LJRvaU3alz4Kke8fRSlkhih6w2qr9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdM1uMGURqH+SEaLTML/gok1LdLLPPFhNThObmf0Jt1YZoEKpbJbO8oynmNtDLhka
         CTkWYrpuxu10Xn+0nbe7eoq++IjJ4sYEHoZZK1qdxCUcHz90C/pB/N+jxRCh/LPIhj
         YIVTtkNRo2R5SnwBjASVdaGkjLcyHsWwXkzk/jLFHYf6JMDsU3RI+/o5xiP2l0eiE8
         OljS5Lii8gZ6w3VY9LRBfIUF5hKi8O+mhtgQozPMAVLStIUmruAv6L8ZCkgToffKtM
         d8v78GQaPTXZWwWjP1r8qSs2LVxJFITfx0kuOIA7ccZC7mcKzsucaTzOJ4QQ1eGhPZ
         dUBBs+p2f/d0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 21/26] drm/nouveau/disp: power down unused DP links during init
Date:   Mon, 23 Aug 2021 20:53:51 -0400
Message-Id: <20210824005356.630888-21-sashal@kernel.org>
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

[ Upstream commit 6eaa1f3c59a707332e921e32782ffcad49915c5e ]

When booted with multiple displays attached, the EFI GOP driver on (at
least) Ampere, can leave DP links powered up that aren't being used to
display anything.  This confuses our tracking of SOR routing, with the
likely result being a failed modeset and display engine hang.

Fix this by (ab?)using the DisableLT IED script to power-down the link,
restoring HW to a state the driver expects.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c   | 2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h   | 1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c | 9 +++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
index 55fbfe28c6dc..9669472a2749 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -440,7 +440,7 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
 	return ret;
 }
 
-static void
+void
 nvkm_dp_disable(struct nvkm_outp *outp, struct nvkm_ior *ior)
 {
 	struct nvkm_dp *dp = nvkm_dp(outp);
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
index 428b3f488f03..e484d0c3b0d4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
@@ -32,6 +32,7 @@ struct nvkm_dp {
 
 int nvkm_dp_new(struct nvkm_disp *, int index, struct dcb_output *,
 		struct nvkm_outp **);
+void nvkm_dp_disable(struct nvkm_outp *, struct nvkm_ior *);
 
 /* DPCD Receiver Capabilities */
 #define DPCD_RC00_DPCD_REV                                              0x00000
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
index dffcac249211..129982fef7ef 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "outp.h"
+#include "dp.h"
 #include "ior.h"
 
 #include <subdev/bios.h>
@@ -257,6 +258,14 @@ nvkm_outp_init_route(struct nvkm_outp *outp)
 	if (!ior->arm.head || ior->arm.proto != proto) {
 		OUTP_DBG(outp, "no heads (%x %d %d)", ior->arm.head,
 			 ior->arm.proto, proto);
+
+		/* The EFI GOP driver on Ampere can leave unused DP links routed,
+		 * which we don't expect.  The DisableLT IED script *should* get
+		 * us back to where we need to be.
+		 */
+		if (ior->func->route.get && !ior->arm.head && outp->info.type == DCB_OUTPUT_DP)
+			nvkm_dp_disable(outp, ior);
+
 		return;
 	}
 
-- 
2.30.2

