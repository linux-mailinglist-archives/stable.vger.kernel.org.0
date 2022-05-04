Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6825051A9D0
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357544AbiEDRTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358028AbiEDRPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB707562E0
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FEC86194D
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5C8C385AA;
        Wed,  4 May 2022 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683555;
        bh=TLOowRI6D6oK2Rf8WSDxJO6Pi+s+b6Yrkw8yE5t0t8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUTQBGazRF0DmzdiUaFPAGdna40s7SniYbBRaPZxj7xBa62iv5rOuxmQXjPSxUXtk
         UlZlhsH/XHIIvLYKGjsT6iXf6QGHqV2P7MprlbrtCxYUuzoz5neoZggiBL5Ys4I5IH
         TKGL8DBJ/1ZXWKXm6kibPGno+NT1s8D5YinHE+sN50SRQX1/trUizUSYs5jcV0tCI/
         Cx3jTm3HlhyhOnPH3Ba6hWoanxa1FvUuFYjVvtF+kylWX8zwUU8s5OS3befov6qCyw
         ELLhB7hhx1h3ArgEeP4x+Ea8Q24Dymz5LBkd3zgkfk2IIMHciJOmrP/63Efn9vsOOr
         orENjHm2dAdMw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 12/19] PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and PCI_EXP_RTSTA_PME on emulated bridge
Date:   Wed,  4 May 2022 18:58:45 +0200
Message-Id: <20220504165852.30089-13-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
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

commit 7122bcb33295228c882c0aa32a04b2547beba2c3 upstream.

To optimize advk_pci_bridge_emul_pcie_conf_write() code, touch
PCIE_ISR0_REG and PCIE_ISR0_MASK_REG registers only when it is really
needed, when processing PCI_EXP_RTCTL_PMEIE and PCI_EXP_RTSTA_PME bits.

Link: https://lore.kernel.org/r/20220110015018.26359-16-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 2b50c9e2339a..2ae43992cd06 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -925,19 +925,21 @@ advk_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 			advk_pcie_wait_for_retrain(pcie);
 		break;
 
-	case PCI_EXP_RTCTL: {
+	case PCI_EXP_RTCTL:
 		/* Only mask/unmask PME interrupt */
-		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG) &
-			~PCIE_MSG_PM_PME_MASK;
-		if ((new & PCI_EXP_RTCTL_PMEIE) == 0)
-			val |= PCIE_MSG_PM_PME_MASK;
-		advk_writel(pcie, val, PCIE_ISR0_MASK_REG);
+		if (mask & PCI_EXP_RTCTL_PMEIE) {
+			u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
+			if (new & PCI_EXP_RTCTL_PMEIE)
+				val &= ~PCIE_MSG_PM_PME_MASK;
+			else
+				val |= PCIE_MSG_PM_PME_MASK;
+			advk_writel(pcie, val, PCIE_ISR0_MASK_REG);
+		}
 		break;
-	}
 
 	case PCI_EXP_RTSTA:
-		new = (new & PCI_EXP_RTSTA_PME) >> 9;
-		advk_writel(pcie, new, PCIE_ISR0_REG);
+		if (new & PCI_EXP_RTSTA_PME)
+			advk_writel(pcie, PCIE_MSG_PM_PME_MASK, PCIE_ISR0_REG);
 		break;
 
 	case PCI_EXP_DEVCTL:
-- 
2.35.1

