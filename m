Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46496126BCC
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfLSSxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730243AbfLSSxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B54A20674;
        Thu, 19 Dec 2019 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781619;
        bh=Uj9E8kuIcuJcaFvwCz3724I4GeY3wXgkV4YygOur5hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtXcLJLaNKN576itynnB9PuaeoJ+5m9mdL01gix3LUk1fvjX2GZQliGs6WxIKxWKF
         xqKBIZ2lQXTXIh+P6k2E6U6zU3IEaHyWZs3un5YnxxlcgVyeqLqcYS/Hg1uurJz93x
         khohwbJQKhn8BavZeAjqqhgUENw3s9A3ti/vaDCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 12/80] PCI: rcar: Fix missing MACCTLR register setting in initialization sequence
Date:   Thu, 19 Dec 2019 19:34:04 +0100
Message-Id: <20191219183048.378988598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 7c7e53e1c93df14690bd12c1f84730fef927a6f1 upstream.

The R-Car Gen2/3 manual - available at:

https://www.renesas.com/eu/en/products/microcontrollers-microprocessors/rz/rzg/rzg1m.html#documents

"RZ/G Series User's Manual: Hardware" section

strictly enforces the MACCTLR inizialization value - 39.3.1 - "Initial
Setting of PCI Express":

"Be sure to write the initial value (= H'80FF 0000) to MACCTLR before
enabling PCIETCTLR.CFINIT".

To avoid unexpected behavior and to match the SW initialization sequence
guidelines, this patch programs the MACCTLR with the correct value.

Note that the MACCTLR.SPCHG bit in the MACCTLR register description
reports that "Only writing 1 is valid and writing 0 is invalid" but this
"invalid" has to be interpreted as a write-ignore aka "ignored", not
"prohibited".

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pcie-rcar.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -93,8 +93,11 @@
 #define  LINK_SPEED_2_5GTS	(1 << 16)
 #define  LINK_SPEED_5_0GTS	(2 << 16)
 #define MACCTLR			0x011058
+#define  MACCTLR_NFTS_MASK	GENMASK(23, 16)	/* The name is from SH7786 */
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
+#define  LTSMDIS		BIT(31)
+#define  MACCTLR_INIT_VAL	(LTSMDIS | MACCTLR_NFTS_MASK)
 #define PMSR			0x01105c
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
@@ -615,6 +618,8 @@ static int rcar_pcie_hw_init(struct rcar
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
 
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
+
 	/* Finish initialization - establish a PCI Express link */
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 
@@ -1237,6 +1242,7 @@ static int rcar_pcie_resume_noirq(struct
 		return 0;
 
 	/* Re-establish the PCIe link */
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 	return rcar_pcie_wait_for_dl(pcie);
 }


