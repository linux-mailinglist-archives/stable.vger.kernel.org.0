Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC54CF779
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbiCGJqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240874AbiCGJli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0656F6B0A4;
        Mon,  7 Mar 2022 01:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D96C61052;
        Mon,  7 Mar 2022 09:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C104C340E9;
        Mon,  7 Mar 2022 09:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645910;
        bh=+ydD8jfkmQrg22C8MDPUxGUem+btIMG6oKkZUd0OCME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/eoOW00yOQ8zbcI+cX/TH45Fujfxysw6gdwM0z+N3hcb5csFTvbnCqaKFre+AGCv
         QLwpiEnDW80sss5lD09tyqJb1PxabWmbte9PARr/yAhX8w78OvR+ZQnw770SJa5yJq
         82Im1DHw8cUUQaXe4n9kqd9wMUBhde6LuzUHD3qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/262] PCI: mvebu: Fix support for PCI_EXP_RTSTA on emulated bridge
Date:   Mon,  7 Mar 2022 10:16:57 +0100
Message-Id: <20220307091704.556896173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 838ff44a398ff47fe9b924961d91aee325821220 ]

PME Status bit in Root Status Register (PCIE_RC_RTSTA_OFF) is read-only and
can be cleared only by writing 0b to the Interrupt Cause RW0C register
(PCIE_INT_CAUSE_OFF).

Link: https://lore.kernel.org/r/20211125124605.25915-15-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 6100608e6413e..b690768d5a413 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -51,6 +51,8 @@
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where) | \
 	 PCIE_CONF_ADDR_EN)
 #define PCIE_CONF_DATA_OFF	0x18fc
+#define PCIE_INT_CAUSE_OFF	0x1900
+#define  PCIE_INT_PM_PME		BIT(28)
 #define PCIE_MASK_OFF		0x1910
 #define  PCIE_MASK_ENABLE_INTS          0x0f000000
 #define PCIE_CTRL_OFF		0x1a00
@@ -604,7 +606,14 @@ mvebu_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 		break;
 
 	case PCI_EXP_RTSTA:
-		mvebu_writel(port, new, PCIE_RC_RTSTA);
+		/*
+		 * PME Status bit in Root Status Register (PCIE_RC_RTSTA)
+		 * is read-only and can be cleared only by writing 0b to the
+		 * Interrupt Cause RW0C register (PCIE_INT_CAUSE_OFF). So
+		 * clear PME via Interrupt Cause.
+		 */
+		if (new & PCI_EXP_RTSTA_PME)
+			mvebu_writel(port, ~PCIE_INT_PM_PME, PCIE_INT_CAUSE_OFF);
 		break;
 	}
 }
-- 
2.34.1



