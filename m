Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF4353FF7
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhDEJPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239742AbhDEJOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FD10611C1;
        Mon,  5 Apr 2021 09:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614048;
        bh=yG039+jPZVf/DvQWigmw0h1Bli+qR+vG+hQDykiptQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qf1U+jkFs7Hz/qGy9ysSPM3eENQIZQhAvBOO6VASoe2Yt4mRCd7DYFShGaNcDpbzn
         OFGnNkH9ZAt/9mTfF/LN+GhWAe1G66tm4GeLSFUlwTS7IrZkpN3Amb12u2ZrcoHrFt
         qb6ZVAB0F6QvR58vHbANVjF+Rw9/fOEgzDrkS+qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 063/152] net: ipa: use a separate pointer for adjusted GSI memory
Date:   Mon,  5 Apr 2021 10:53:32 +0200
Message-Id: <20210405085036.323590217@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 571b1e7e58ad30b3a842254aea50d2e83b2396e1 ]

This patch actually fixes a bug, though it doesn't affect the two
platforms supported currently.  The fix implements GSI memory
pointers a bit differently.

For IPA version 4.5 and above, the address space for almost all GSI
registers is adjusted downward by a fixed amount.  This is currently
handled by adjusting the I/O virtual address pointer after it has
been mapped.  The bug is that the pointer is not "de-adjusted" as it
should be when it's unmapped.

This patch fixes that error, but it does so by maintaining one "raw"
pointer for the mapped memory range.  This is assigned when the
memory is mapped and used to unmap the memory.  This pointer is also
used to access the two registers that do *not* sit in the "adjusted"
memory space.

Rather than adjusting *that* pointer, we maintain a separate pointer
that's an adjusted copy of the "raw" pointer, and that is used for
most GSI register accesses.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c     | 28 ++++++++++++----------------
 drivers/net/ipa/gsi.h     |  5 +++--
 drivers/net/ipa/gsi_reg.h | 21 +++++++++++++--------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b77f5fef7aec..febfac75dd6a 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/types.h>
@@ -195,8 +195,6 @@ static void gsi_irq_type_disable(struct gsi *gsi, enum gsi_irq_type_id type_id)
 /* Turn off all GSI interrupts initially */
 static void gsi_irq_setup(struct gsi *gsi)
 {
-	u32 adjust;
-
 	/* Disable all interrupt types */
 	gsi_irq_type_update(gsi, 0);
 
@@ -206,10 +204,9 @@ static void gsi_irq_setup(struct gsi *gsi)
 	iowrite32(0, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 	iowrite32(0, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET);
 
-	/* Reverse the offset adjustment for inter-EE register offsets */
-	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
-	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
-	iowrite32(0, gsi->virt + adjust + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
+	/* The inter-EE registers are in the non-adjusted address range */
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_CH_IRQ_OFFSET);
+	iowrite32(0, gsi->virt_raw + GSI_INTER_EE_SRC_EV_CH_IRQ_OFFSET);
 
 	iowrite32(0, gsi->virt + GSI_CNTXT_GSI_IRQ_EN_OFFSET);
 }
@@ -2115,9 +2112,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 	gsi->dev = dev;
 	gsi->version = version;
 
-	/* The GSI layer performs NAPI on all endpoints.  NAPI requires a
-	 * network device structure, but the GSI layer does not have one,
-	 * so we must create a dummy network device for this purpose.
+	/* GSI uses NAPI on all channels.  Create a dummy network device
+	 * for the channel NAPI contexts to be associated with.
 	 */
 	init_dummy_netdev(&gsi->dummy_dev);
 
@@ -2142,13 +2138,13 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	gsi->virt = ioremap(res->start, size);
-	if (!gsi->virt) {
+	gsi->virt_raw = ioremap(res->start, size);
+	if (!gsi->virt_raw) {
 		dev_err(dev, "unable to remap \"gsi\" memory\n");
 		return -ENOMEM;
 	}
-	/* Adjust register range pointer downward for newer IPA versions */
-	gsi->virt -= adjust;
+	/* Most registers are accessed using an adjusted register range */
+	gsi->virt = gsi->virt_raw - adjust;
 
 	init_completion(&gsi->completion);
 
@@ -2167,7 +2163,7 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev,
 err_irq_exit:
 	gsi_irq_exit(gsi);
 err_iounmap:
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 
 	return ret;
 }
@@ -2178,7 +2174,7 @@ void gsi_exit(struct gsi *gsi)
 	mutex_destroy(&gsi->mutex);
 	gsi_channel_exit(gsi);
 	gsi_irq_exit(gsi);
-	iounmap(gsi->virt);
+	iounmap(gsi->virt_raw);
 }
 
 /* The maximum number of outstanding TREs on a channel.  This limits
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 96c9aed397aa..696c9825834a 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 #ifndef _GSI_H_
 #define _GSI_H_
@@ -150,7 +150,8 @@ struct gsi {
 	struct device *dev;		/* Same as IPA device */
 	enum ipa_version version;
 	struct net_device dummy_dev;	/* needed for NAPI */
-	void __iomem *virt;
+	void __iomem *virt_raw;		/* I/O mapped address range */
+	void __iomem *virt;		/* Adjusted for most registers */
 	u32 irq;
 	u32 channel_count;
 	u32 evt_ring_count;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 299456e70f28..1622d8cf8dea 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 #ifndef _GSI_REG_H_
 #define _GSI_REG_H_
@@ -38,17 +38,21 @@
  * (though the actual limit is hardware-dependent).
  */
 
-/* GSI EE registers as a group are shifted downward by a fixed
- * constant amount for IPA versions 4.5 and beyond.  This applies
- * to all GSI registers we use *except* the ones that disable
- * inter-EE interrupts for channels and event channels.
+/* GSI EE registers as a group are shifted downward by a fixed constant amount
+ * for IPA versions 4.5 and beyond.  This applies to all GSI registers we use
+ * *except* the ones that disable inter-EE interrupts for channels and event
+ * channels.
  *
- * We handle this by adjusting the pointer to the mapped GSI memory
- * region downward.  Then in the one place we use them (gsi_irq_setup())
- * we undo that adjustment for the inter-EE interrupt registers.
+ * The "raw" (not adjusted) GSI register range is mapped, and a pointer to
+ * the mapped range is held in gsi->virt_raw.  The inter-EE interrupt
+ * registers are accessed using that pointer.
+ *
+ * Most registers are accessed using gsi->virt, which is a copy of the "raw"
+ * pointer, adjusted downward by the fixed amount.
  */
 #define GSI_EE_REG_ADJUST			0x0000d000	/* IPA v4.5+ */
 
+/* The two inter-EE IRQ register offsets are relative to gsi->virt_raw */
 #define GSI_INTER_EE_SRC_CH_IRQ_OFFSET \
 			GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
 #define GSI_INTER_EE_N_SRC_CH_IRQ_OFFSET(ee) \
@@ -59,6 +63,7 @@
 #define GSI_INTER_EE_N_SRC_EV_CH_IRQ_OFFSET(ee) \
 			(0x0000c01c + 0x1000 * (ee))
 
+/* All other register offsets are relative to gsi->virt */
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
 #define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
-- 
2.30.1



