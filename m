Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844333F54AD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhHXA4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234444AbhHXAzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3EE6152B;
        Tue, 24 Aug 2021 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766492;
        bh=vnPqbr+xlZk1FuW1/mSsJ3hRghBhnkIStU/5Cl7ncv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrwsZ9wknI2yvQNUM2R2l0UDCZiE9o8SYuo0RafbH8lFXzKiChgroIeM6v8fRWiJy
         fqxF6ZEDhrsNZ6EZV5kWlfWahvQg6jcveTZj64HGdlC4ZVPskFXnoEfKi6G+BwItLp
         4MqgGRHAcc0cBjxQf8n/WL08YEdsXGL6lBudYKUj9tZT6pTNuz2ki1syQCJuYJgKng
         FSowuKXke0Ne6J4Qc2SNZZJnk1eao0oWg4nEM9lVf/+f2C0p2J+ohRPOEpQHTIKjWg
         gBoP4BefqvDOwCltmNefCCG774j7MvQIJsoD2ZB4+rJB7l5CWNfvwsLxCA/bO3ZZAb
         6yOUSpe+sD8Ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 15/18] drm/nouveau/disp: power down unused DP links during init
Date:   Mon, 23 Aug 2021 20:54:29 -0400
Message-Id: <20210824005432.631154-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
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
index 3800aeb507d0..2a7b8bc3ec4d 100644
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

