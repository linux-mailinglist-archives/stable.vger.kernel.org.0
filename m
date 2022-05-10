Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD75219AC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbiEJNug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245043AbiEJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCC7E080;
        Tue, 10 May 2022 06:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C43B3B81DA8;
        Tue, 10 May 2022 13:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058B1C385A6;
        Tue, 10 May 2022 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189648;
        bh=pVaz+wkZjguHefPMnnE6xU5RTtQ+84NCQi/e2p+M3vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHPJCorqp93eQiVRGxvr/HHAhG8y+HTVG+eh2++TFlP/EpjIkpMzJK2AcN5uvk/0A
         1lOsygwHsD2bwpGmlDUmZ0vH+eMmlaO1YQU1BMjHl2r1p0msGM6LzOm2oj0+9FhId8
         3Q6Wp13wLdhkYEX75QwaEG/e5VLUBhdXavmxM44E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 117/135] PCI: aardvark: Replace custom PCIE_CORE_INT_* macros with PCI_INTERRUPT_*
Date:   Tue, 10 May 2022 15:08:19 +0200
Message-Id: <20220510130743.756175307@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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

commit 1d86abf1f89672a70f2ab65f6000299feb1f1781 upstream.

Header file linux/pci.h defines enum pci_interrupt_pin with corresponding
PCI_INTERRUPT_* values.

Link: https://lore.kernel.org/r/20220110015018.26359-2-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -38,10 +38,6 @@
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHK_TX_EN			BIT(6)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHCK			BIT(7)
 #define     PCIE_CORE_ERR_CAPCTL_ECRC_CHCK_RCV			BIT(8)
-#define     PCIE_CORE_INT_A_ASSERT_ENABLE			1
-#define     PCIE_CORE_INT_B_ASSERT_ENABLE			2
-#define     PCIE_CORE_INT_C_ASSERT_ENABLE			3
-#define     PCIE_CORE_INT_D_ASSERT_ENABLE			4
 /* PIO registers base address and register offsets */
 #define PIO_BASE_ADDR				0x4000
 #define PIO_CTRL				(PIO_BASE_ADDR + 0x0)
@@ -961,7 +957,7 @@ static int advk_sw_pci_bridge_init(struc
 	bridge->conf.pref_mem_limit = cpu_to_le16(PCI_PREF_RANGE_TYPE_64);
 
 	/* Support interrupt A for MSI feature */
-	bridge->conf.intpin = PCIE_CORE_INT_A_ASSERT_ENABLE;
+	bridge->conf.intpin = PCI_INTERRUPT_INTA;
 
 	/* Aardvark HW provides PCIe Capability structure in version 2 */
 	bridge->pcie_conf.cap = cpu_to_le16(2);


