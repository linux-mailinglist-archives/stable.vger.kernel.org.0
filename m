Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E2B4F32B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiDEJap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241039AbiDEIsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5071F289B2;
        Tue,  5 Apr 2022 01:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5955CB81B92;
        Tue,  5 Apr 2022 08:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99903C385A5;
        Tue,  5 Apr 2022 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147798;
        bh=oQCCMyAG9uXwmvosH2y0DN3mABh0AUvwuzkV1JR0Ik0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weBbHu5sJWaFagx72a3oQgFJ/TkcCuFSZTfCfsmorGq3M1XXTBTf7VNhVX6HJXBT5
         JHs/5UvLGuA+O5kcF4kZLS/tCbfCs1qg28NOyw//AQt/JuFoBCKuxGq7ihr8ZqBUQ2
         B0ge9Z1KDy++m/nVqP2XN6EMh5Bb8FW0fdc5pWl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: [PATCH 5.16 0126/1017] PCI: fu740: Force 2.5GT/s for initial device probe
Date:   Tue,  5 Apr 2022 09:17:19 +0200
Message-Id: <20220405070357.939710531@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit a382c757ec5ef83137a86125f43a4c43dc2ab50b upstream.

The fu740 PCIe core does not probe any devices on the SiFive Unmatched
board without this fix (or having U-Boot explicitly start the PCIe via
either boot-script or user command). The fix is to start the link at
2.5GT/s speeds and once the link is up then change the maximum speed back
to the default.

The U-Boot driver claims to set the link-speed to 2.5GT/s to get the probe
to work (and U-Boot does print link up at 2.5GT/s) in the following code:
https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/pci/pcie_dw_sifive.c?id=v2022.01#L271

Link: https://lore.kernel.org/r/20220318152430.526320-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-fu740.c |   51 +++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-fu740.c
+++ b/drivers/pci/controller/dwc/pcie-fu740.c
@@ -181,10 +181,59 @@ static int fu740_pcie_start_link(struct
 {
 	struct device *dev = pci->dev;
 	struct fu740_pcie *afp = dev_get_drvdata(dev);
+	u8 cap_exp = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	int ret;
+	u32 orig, tmp;
+
+	/*
+	 * Force 2.5GT/s when starting the link, due to some devices not
+	 * probing at higher speeds. This happens with the PCIe switch
+	 * on the Unmatched board when U-Boot has not initialised the PCIe.
+	 * The fix in U-Boot is to force 2.5GT/s, which then gets cleared
+	 * by the soft reset done by this driver.
+	 */
+	dev_dbg(dev, "cap_exp at %x\n", cap_exp);
+	dw_pcie_dbi_ro_wr_en(pci);
+
+	tmp = dw_pcie_readl_dbi(pci, cap_exp + PCI_EXP_LNKCAP);
+	orig = tmp & PCI_EXP_LNKCAP_SLS;
+	tmp &= ~PCI_EXP_LNKCAP_SLS;
+	tmp |= PCI_EXP_LNKCAP_SLS_2_5GB;
+	dw_pcie_writel_dbi(pci, cap_exp + PCI_EXP_LNKCAP, tmp);
 
 	/* Enable LTSSM */
 	writel_relaxed(0x1, afp->mgmt_base + PCIEX8MGMT_APP_LTSSM_ENABLE);
-	return 0;
+
+	ret = dw_pcie_wait_for_link(pci);
+	if (ret) {
+		dev_err(dev, "error: link did not start\n");
+		goto err;
+	}
+
+	tmp = dw_pcie_readl_dbi(pci, cap_exp + PCI_EXP_LNKCAP);
+	if ((tmp & PCI_EXP_LNKCAP_SLS) != orig) {
+		dev_dbg(dev, "changing speed back to original\n");
+
+		tmp &= ~PCI_EXP_LNKCAP_SLS;
+		tmp |= orig;
+		dw_pcie_writel_dbi(pci, cap_exp + PCI_EXP_LNKCAP, tmp);
+
+		tmp = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
+		tmp |= PORT_LOGIC_SPEED_CHANGE;
+		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, tmp);
+
+		ret = dw_pcie_wait_for_link(pci);
+		if (ret) {
+			dev_err(dev, "error: link did not start at new speed\n");
+			goto err;
+		}
+	}
+
+	ret = 0;
+err:
+	WARN_ON(ret);	/* we assume that errors will be very rare */
+	dw_pcie_dbi_ro_wr_dis(pci);
+	return ret;
 }
 
 static int fu740_pcie_host_init(struct pcie_port *pp)


