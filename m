Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176BA595125
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiHPEwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiHPEu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9CCB6D37;
        Mon, 15 Aug 2022 13:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B3BF60F60;
        Mon, 15 Aug 2022 20:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191EFC433C1;
        Mon, 15 Aug 2022 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596427;
        bh=vCPeWwgznvklFv4hoDbAASDpeO2w4DaSp+Sa8JYqtic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTwFDiU9jUqdTqjE8dX2GOE2Rt7Kp9OKVY046qpeUM1jTRWGsaS5GziYDIfj+Upwq
         RIZ0sQkLYjC1uwWzWfOU0PSXSLb2tMSoWRIlMP7dwRFsl5KS9rX4oYtAeTSNGmjsYu
         yjRIbToVAvrjom3m3pn5D+6kZ0bSc52LOhFLzVco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1075/1157] ARM: Marvell: Update PCIe fixup
Date:   Mon, 15 Aug 2022 20:07:11 +0200
Message-Id: <20220815180523.119205309@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit fdaa3725831972284ef2779ddba00491d9dbbfca ]

- The code relies on rc_pci_fixup being called, which only happens
  when CONFIG_PCI_QUIRKS is enabled, so add that to Kconfig. Omitting
  this causes a booting failure with a non-obvious cause.
- Update rc_pci_fixup to set the class properly, copying the
  more modern style from other places
- Correct the rc_pci_fixup comment

This patch just re-applies commit 1dc831bf53fd ("ARM: Kirkwood: Update
PCI-E fixup") for all other Marvell ARM platforms which have same buggy
PCIe controller and do not use pci-mvebu.c controller driver yet.

Long-term goal for these Marvell ARM platforms should be conversion to
pci-mvebu.c controller driver and removal of these fixups in arch code.

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-dove/Kconfig    |  1 +
 arch/arm/mach-dove/pcie.c     | 11 ++++++++---
 arch/arm/mach-mv78xx0/pcie.c  | 11 ++++++++---
 arch/arm/mach-orion5x/Kconfig |  1 +
 arch/arm/mach-orion5x/pci.c   | 12 +++++++++---
 5 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index c30c69c664ea..a568ef90633e 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -8,6 +8,7 @@ menuconfig ARCH_DOVE
 	select PINCTRL_DOVE
 	select PLAT_ORION_LEGACY
 	select PM_GENERIC_DOMAINS if PM
+	select PCI_QUIRKS if PCI
 	help
 	  Support for the Marvell Dove SoC 88AP510
 
diff --git a/arch/arm/mach-dove/pcie.c b/arch/arm/mach-dove/pcie.c
index 2a493bdfffc6..f90f42fc495e 100644
--- a/arch/arm/mach-dove/pcie.c
+++ b/arch/arm/mach-dove/pcie.c
@@ -136,14 +136,19 @@ static struct pci_ops pcie_ops = {
 	.write = pcie_wr_conf,
 };
 
+/*
+ * The root complex has a hardwired class of PCI_CLASS_MEMORY_OTHER, when it
+ * is operating as a root complex this needs to be switched to
+ * PCI_CLASS_BRIDGE_HOST or Linux will errantly try to process the BAR's on
+ * the device. Decoding setup is handled by the orion code.
+ */
 static void rc_pci_fixup(struct pci_dev *dev)
 {
-	/*
-	 * Prevent enumeration of root complex.
-	 */
 	if (dev->bus->parent == NULL && dev->devfn == 0) {
 		int i;
 
+		dev->class &= 0xff;
+		dev->class |= PCI_CLASS_BRIDGE_HOST << 8;
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
diff --git a/arch/arm/mach-mv78xx0/pcie.c b/arch/arm/mach-mv78xx0/pcie.c
index e15646af7f26..4f1847babef2 100644
--- a/arch/arm/mach-mv78xx0/pcie.c
+++ b/arch/arm/mach-mv78xx0/pcie.c
@@ -180,14 +180,19 @@ static struct pci_ops pcie_ops = {
 	.write = pcie_wr_conf,
 };
 
+/*
+ * The root complex has a hardwired class of PCI_CLASS_MEMORY_OTHER, when it
+ * is operating as a root complex this needs to be switched to
+ * PCI_CLASS_BRIDGE_HOST or Linux will errantly try to process the BAR's on
+ * the device. Decoding setup is handled by the orion code.
+ */
 static void rc_pci_fixup(struct pci_dev *dev)
 {
-	/*
-	 * Prevent enumeration of root complex.
-	 */
 	if (dev->bus->parent == NULL && dev->devfn == 0) {
 		int i;
 
+		dev->class &= 0xff;
+		dev->class |= PCI_CLASS_BRIDGE_HOST << 8;
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
diff --git a/arch/arm/mach-orion5x/Kconfig b/arch/arm/mach-orion5x/Kconfig
index bf833b51931d..aeac281c8764 100644
--- a/arch/arm/mach-orion5x/Kconfig
+++ b/arch/arm/mach-orion5x/Kconfig
@@ -7,6 +7,7 @@ menuconfig ARCH_ORION5X
 	select GPIOLIB
 	select MVEBU_MBUS
 	select FORCE_PCI
+	select PCI_QUIRKS
 	select PHYLIB if NETDEVICES
 	select PLAT_ORION_LEGACY
 	help
diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 92e938bba20d..9574c73f3c03 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -515,14 +515,20 @@ static int __init pci_setup(struct pci_sys_data *sys)
 /*****************************************************************************
  * General PCIe + PCI
  ****************************************************************************/
+
+/*
+ * The root complex has a hardwired class of PCI_CLASS_MEMORY_OTHER, when it
+ * is operating as a root complex this needs to be switched to
+ * PCI_CLASS_BRIDGE_HOST or Linux will errantly try to process the BAR's on
+ * the device. Decoding setup is handled by the orion code.
+ */
 static void rc_pci_fixup(struct pci_dev *dev)
 {
-	/*
-	 * Prevent enumeration of root complex.
-	 */
 	if (dev->bus->parent == NULL && dev->devfn == 0) {
 		int i;
 
+		dev->class &= 0xff;
+		dev->class |= PCI_CLASS_BRIDGE_HOST << 8;
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			dev->resource[i].start = 0;
 			dev->resource[i].end   = 0;
-- 
2.35.1



