Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA67594399
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347934AbiHOWUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350816AbiHOWSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64E941D18;
        Mon, 15 Aug 2022 12:42:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4424A60FB9;
        Mon, 15 Aug 2022 19:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDE1C433C1;
        Mon, 15 Aug 2022 19:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592542;
        bh=lgfKPFDQtQEogGOeGwA0Ha6ezymCN6n3CtRD7Q5DEYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5ptbaLHK0nlH0Rnq30hH36A7+V0iKz8z2MJEI+CSTZM1QD0lCvUCiJEgxY93+qWB
         94SFIUCPjLp8Lq6zx3k2XwbSr0kmmQl7VcugHglmB0SjW9ykQn5pu3s/MvUYZdLgbd
         Uwplt4bOIm4bfiPulAiB5zNHmIO8MYPdlFkhQdUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 0127/1157] powerpc/fsl-pci: Fix Class Code of PCIe Root Port
Date:   Mon, 15 Aug 2022 19:51:23 +0200
Message-Id: <20220815180444.689903503@linuxfoundation.org>
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

commit 0c551abfa004ce154d487d91777bf221c808a64f upstream.

By default old pre-3.0 Freescale PCIe controllers reports invalid PCI Class
Code 0x0b20 for PCIe Root Port. It can be seen by lspci -b output on P2020
board which has this pre-3.0 controller:

  $ lspci -bvnn
  00:00.0 Power PC [0b20]: Freescale Semiconductor Inc P2020E [1957:0070] (rev 21)
          !!! Invalid class 0b20 for header type 01
          Capabilities: [4c] Express Root Port (Slot-), MSI 00

Fix this issue by programming correct PCI Class Code 0x0604 for PCIe Root
Port to the Freescale specific PCIe register 0x474.

With this change lspci -b output is:

  $ lspci -bvnn
  00:00.0 PCI bridge [0604]: Freescale Semiconductor Inc P2020E [1957:0070] (rev 21) (prog-if 00 [Normal decode])
          Capabilities: [4c] Express Root Port (Slot-), MSI 00

Without any "Invalid class" error. So class code was properly reflected
into standard (read-only) PCI register 0x08.

Same fix is already implemented in U-Boot pcie_fsl.c driver in commit:
http://source.denx.de/u-boot/u-boot/-/commit/d18d06ac35229345a0af80977a408cfbe1d1015b

Fix activated by U-Boot stay active also after booting Linux kernel.
But boards which use older U-Boot version without that fix are affected and
still require this fix.

So implement this class code fix also in kernel fsl_pci.c driver.

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220706101043.4867-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/sysdev/fsl_pci.c |    8 ++++++++
 arch/powerpc/sysdev/fsl_pci.h |    1 +
 2 files changed, 9 insertions(+)

--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -521,6 +521,7 @@ int fsl_add_bridge(struct platform_devic
 	struct resource rsrc;
 	const int *bus_range;
 	u8 hdr_type, progif;
+	u32 class_code;
 	struct device_node *dev;
 	struct ccsr_pci __iomem *pci;
 	u16 temp;
@@ -594,6 +595,13 @@ int fsl_add_bridge(struct platform_devic
 			PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS;
 		if (fsl_pcie_check_link(hose))
 			hose->indirect_type |= PPC_INDIRECT_TYPE_NO_PCIE_LINK;
+		/* Fix Class Code to PCI_CLASS_BRIDGE_PCI_NORMAL for pre-3.0 controller */
+		if (in_be32(&pci->block_rev1) < PCIE_IP_REV_3_0) {
+			early_read_config_dword(hose, 0, 0, PCIE_FSL_CSR_CLASSCODE, &class_code);
+			class_code &= 0xff;
+			class_code |= PCI_CLASS_BRIDGE_PCI_NORMAL << 8;
+			early_write_config_dword(hose, 0, 0, PCIE_FSL_CSR_CLASSCODE, class_code);
+		}
 	} else {
 		/*
 		 * Set PBFR(PCI Bus Function Register)[10] = 1 to
--- a/arch/powerpc/sysdev/fsl_pci.h
+++ b/arch/powerpc/sysdev/fsl_pci.h
@@ -18,6 +18,7 @@ struct platform_device;
 
 #define PCIE_LTSSM	0x0404		/* PCIE Link Training and Status */
 #define PCIE_LTSSM_L0	0x16		/* L0 state */
+#define PCIE_FSL_CSR_CLASSCODE	0x474	/* FSL GPEX CSR */
 #define PCIE_IP_REV_2_2		0x02080202 /* PCIE IP block version Rev2.2 */
 #define PCIE_IP_REV_3_0		0x02080300 /* PCIE IP block version Rev3.0 */
 #define PIWAR_EN		0x80000000	/* Enable */


