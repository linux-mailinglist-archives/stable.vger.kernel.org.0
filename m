Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9BB521B36
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343494AbiEJOJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245303AbiEJOId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA380F74BB;
        Tue, 10 May 2022 06:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C959617E4;
        Tue, 10 May 2022 13:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F52C385A6;
        Tue, 10 May 2022 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190154;
        bh=gMEZZrGEXDBxjgFrR9l7x3f67M/rbglw+4K1OE9QDA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcETni2VZ+mJra4w/Yv+/Wo96V3faOoTimRz8z50VbwBz0HWjA5qz1BSU+mP9TC3I
         X8KMmb4jaoyBvvejhQsYa6rGvEd2jr5qAy8DkLmapqip8i+DnrniaVaOIsSNkKIn4T
         fdi0rtrY3QgVSvJw714eozsMaRzWkouW6rOYQ11E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.17 133/140] PCI: aardvark: Optimize writing PCI_EXP_RTCTL_PMEIE and PCI_EXP_RTSTA_PME on emulated bridge
Date:   Tue, 10 May 2022 15:08:43 +0200
Message-Id: <20220510130745.395544146@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -925,19 +925,21 @@ advk_pci_bridge_emul_pcie_conf_write(str
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


