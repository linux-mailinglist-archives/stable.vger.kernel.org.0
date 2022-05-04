Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4F351A989
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352523AbiEDRRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356484AbiEDRNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:13:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B14553A4C
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D584FB8278E
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776BFC385B2;
        Wed,  4 May 2022 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683482;
        bh=QMlm+XKrgNssklGI1kRhG/3Xj9lrO8dQUWeFrK4o3jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1X9jLeSPBGKSRm+Zn3r1tB4v/6hT48Qfo8RZ0jRp8c8FxRb3St6hm8EsgpcDcj20
         cW/fF5PsNASopi2NkIszN6mLcwdRanC4EzRbrfHHZSXVXhBlhutHpZ4/hQg4saWH1C
         tIl7tU1hYl8MnW2HzJ1ClTwmg0ooa9ayD09AC4WRKtmMazXd9dv7Hou5qqH9uPlg8e
         yNLIKnahImKFBJjEmXAUkbwcnsNxVmiEOUvFC3UNsx2e8l5JXwZnldnnDDvsJbb2ox
         cIIyuO1/3Dj4QYslDUrU8S01UGV0YqrCFQI/kEBlNDSj1etFraAyKfO5UAx2YQi1Sf
         gz71j5zr8+mhg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 02/30] PCI: pci-bridge-emul: Add definitions for missing capabilities registers
Date:   Wed,  4 May 2022 18:57:27 +0200
Message-Id: <20220504165755.30002-3-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 8ea673a8b30b4a32516b8adabb15e2a68ff02ec8 upstream.

pci-bridge-emul driver already allocates buffer for capabilities up to the
PCI_EXP_SLTSTA2 register, but does not define bit access behavior for these
registers. Add these missing definitions.

Link: https://lore.kernel.org/r/20211130172913.9727-3-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/pci-bridge-emul.c | 43 +++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index 0a4e71301537..c994ebec2360 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -270,6 +270,49 @@ struct pci_bridge_reg_behavior pcie_cap_regs_behavior[PCI_CAP_PCIE_SIZEOF / 4] =
 		.ro = GENMASK(15, 0) | PCI_EXP_RTSTA_PENDING,
 		.w1c = PCI_EXP_RTSTA_PME,
 	},
+
+	[PCI_EXP_DEVCAP2 / 4] = {
+		/*
+		 * Device capabilities 2 register has reserved bits [30:27].
+		 * Also bits [26:24] are reserved for non-upstream ports.
+		 */
+		.ro = BIT(31) | GENMASK(23, 0),
+	},
+
+	[PCI_EXP_DEVCTL2 / 4] = {
+		/*
+		 * Device control 2 register is RW. Bit 11 is reserved for
+		 * non-upstream ports.
+		 *
+		 * Device status 2 register is reserved.
+		 */
+		.rw = GENMASK(15, 12) | GENMASK(10, 0),
+	},
+
+	[PCI_EXP_LNKCAP2 / 4] = {
+		/* Link capabilities 2 register has reserved bits [30:25] and 0. */
+		.ro = BIT(31) | GENMASK(24, 1),
+	},
+
+	[PCI_EXP_LNKCTL2 / 4] = {
+		/*
+		 * Link control 2 register is RW.
+		 *
+		 * Link status 2 register has bits 5, 15 W1C;
+		 * bits 10, 11 reserved and others are RO.
+		 */
+		.rw = GENMASK(15, 0),
+		.w1c = (BIT(15) | BIT(5)) << 16,
+		.ro = (GENMASK(14, 12) | GENMASK(9, 6) | GENMASK(4, 0)) << 16,
+	},
+
+	[PCI_EXP_SLTCAP2 / 4] = {
+		/* Slot capabilities 2 register is reserved. */
+	},
+
+	[PCI_EXP_SLTCTL2 / 4] = {
+		/* Both Slot control 2 and Slot status 2 registers are reserved. */
+	},
 };
 
 /*
-- 
2.35.1

