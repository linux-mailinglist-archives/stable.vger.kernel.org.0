Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6226F3F54DF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhHXA5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234631AbhHXA4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72F10615E6;
        Tue, 24 Aug 2021 00:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766509;
        bh=3oFpym5obWf4C7G1zWW6A0n3Sifg6VWGqL+h9dzyjYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF7RzRTxJ38ONpWhM5p1YQKORpmSxU7Xe4K62MlO6aNIO9pUUn/0AksDcoAtoP7at
         3yLWECGdceF79K+cS6MvIY0oI/zTOBTqU3jLhcibNTTQSjcY5wAhnSqT/VEQi9nVqO
         whLggTsRxRu+zENC+wuu4ISTVN8XmlyRTC5zmig6+O4nHzqsk6HqaKyZhSPPLggt75
         T7zxaynPPteie26qwWHxSaXAw3GKvxRbMZKY32zjnl4i8xTx1VBlD1wRud9vA9/30z
         nyU7bgM/oP3w/v3Dzv/RHGQISDi4WmqgmaulDqwakJdwVILUjiU1D3ssw8mzsoTj0I
         D0b3l9Clp3NtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 08/10] drm/nouveau/disp: power down unused DP links during init
Date:   Mon, 23 Aug 2021 20:54:55 -0400
Message-Id: <20210824005458.631377-8-sashal@kernel.org>
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
index 818d21bd28d3..1d2837c5a8f2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -419,7 +419,7 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
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
index c62030c96fba..4b1c72fd8f03 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "outp.h"
+#include "dp.h"
 #include "ior.h"
 
 #include <subdev/bios.h>
@@ -216,6 +217,14 @@ nvkm_outp_init_route(struct nvkm_outp *outp)
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

