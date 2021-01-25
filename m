Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5C303393
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbhAZE7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731066AbhAYSuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB0A224B8;
        Mon, 25 Jan 2021 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600569;
        bh=tkRm8I8OG2GTvTEPQ7/nYssvYEKXkyiQeKqAZLNClwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gK1djtmLMdcrjQtNi0wJfrPlIIumAYbCHVQEmFmKQWVmQsaNSwQHgJbLkkodwf9GF
         t7Spn/eCYlT5QuBpsDcLcpPLgtrkzFyfgFWd+azDv99VSvHkM0PGF5pcPRXS11JUEj
         44N8b0VGsfaNkT0g8+vhU1K21QusXYM0CE2SDAX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/199] drm/nouveau/privring: ack interrupts the same way as RM
Date:   Mon, 25 Jan 2021 19:38:08 +0100
Message-Id: <20210125183219.054567603@linuxfoundation.org>
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

[ Upstream commit e05e06cd34f5311f677294a08b609acfbc315236 ]

Whatever it is that we were doing before doesn't work on Ampere.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c | 10 +++++++---
 drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c | 10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c
index 2340040942c93..1115376bc85f5 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gf100.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "priv.h"
+#include <subdev/timer.h>
 
 static void
 gf100_ibus_intr_hub(struct nvkm_subdev *ibus, int i)
@@ -31,7 +32,6 @@ gf100_ibus_intr_hub(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x122124 + (i * 0x0400));
 	u32 stat = nvkm_rd32(device, 0x122128 + (i * 0x0400));
 	nvkm_debug(ibus, "HUB%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x122128 + (i * 0x0400), 0x00000200, 0x00000000);
 }
 
 static void
@@ -42,7 +42,6 @@ gf100_ibus_intr_rop(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x124124 + (i * 0x0400));
 	u32 stat = nvkm_rd32(device, 0x124128 + (i * 0x0400));
 	nvkm_debug(ibus, "ROP%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x124128 + (i * 0x0400), 0x00000200, 0x00000000);
 }
 
 static void
@@ -53,7 +52,6 @@ gf100_ibus_intr_gpc(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x128124 + (i * 0x0400));
 	u32 stat = nvkm_rd32(device, 0x128128 + (i * 0x0400));
 	nvkm_debug(ibus, "GPC%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x128128 + (i * 0x0400), 0x00000200, 0x00000000);
 }
 
 void
@@ -90,6 +88,12 @@ gf100_ibus_intr(struct nvkm_subdev *ibus)
 			intr1 &= ~stat;
 		}
 	}
+
+	nvkm_mask(device, 0x121c4c, 0x0000003f, 0x00000002);
+	nvkm_msec(device, 2000,
+		if (!(nvkm_rd32(device, 0x121c4c) & 0x0000003f))
+			break;
+	);
 }
 
 static int
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c b/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c
index f3915f85838ed..22e487b493ad1 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/ibus/gk104.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "priv.h"
+#include <subdev/timer.h>
 
 static void
 gk104_ibus_intr_hub(struct nvkm_subdev *ibus, int i)
@@ -31,7 +32,6 @@ gk104_ibus_intr_hub(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x122124 + (i * 0x0800));
 	u32 stat = nvkm_rd32(device, 0x122128 + (i * 0x0800));
 	nvkm_debug(ibus, "HUB%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x122128 + (i * 0x0800), 0x00000200, 0x00000000);
 }
 
 static void
@@ -42,7 +42,6 @@ gk104_ibus_intr_rop(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x124124 + (i * 0x0800));
 	u32 stat = nvkm_rd32(device, 0x124128 + (i * 0x0800));
 	nvkm_debug(ibus, "ROP%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x124128 + (i * 0x0800), 0x00000200, 0x00000000);
 }
 
 static void
@@ -53,7 +52,6 @@ gk104_ibus_intr_gpc(struct nvkm_subdev *ibus, int i)
 	u32 data = nvkm_rd32(device, 0x128124 + (i * 0x0800));
 	u32 stat = nvkm_rd32(device, 0x128128 + (i * 0x0800));
 	nvkm_debug(ibus, "GPC%d: %06x %08x (%08x)\n", i, addr, data, stat);
-	nvkm_mask(device, 0x128128 + (i * 0x0800), 0x00000200, 0x00000000);
 }
 
 void
@@ -90,6 +88,12 @@ gk104_ibus_intr(struct nvkm_subdev *ibus)
 			intr1 &= ~stat;
 		}
 	}
+
+	nvkm_mask(device, 0x12004c, 0x0000003f, 0x00000002);
+	nvkm_msec(device, 2000,
+		if (!(nvkm_rd32(device, 0x12004c) & 0x0000003f))
+			break;
+	);
 }
 
 static int
-- 
2.27.0



