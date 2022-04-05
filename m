Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62614F380D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376269AbiDELVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349348AbiDEJtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2A7645F;
        Tue,  5 Apr 2022 02:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14A396164D;
        Tue,  5 Apr 2022 09:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE36C385A2;
        Tue,  5 Apr 2022 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151859;
        bh=IUboqo4iJ3n7otCQXs7prFXc0z51J73FM0eOCExijfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3qnT3qQZCZishpst/TqlzrOvkXA63bi2d79PnAvM2qMQ3y10ImW+vuv8p2fGaDPi
         YsNskDCSM0TfnN60aLv4ro3unhBSvWdAfGPFF2/++W7AvZTww+qtKvLon3yMRgW2hY
         k0ICwtwhjxTLeNQ4Og2nhpUyl5q0rQRPgzpHVsCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mick Lorain <micklorain@protonmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 566/913] PCI: Avoid broken MSI on SB600 USB devices
Date:   Tue,  5 Apr 2022 09:27:08 +0200
Message-Id: <20220405070356.810084675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 63cd736f449445edcd7f0bcc7d84453e9beec0aa ]

Some ATI SB600 USB adapters advertise MSI, but if INTx is disabled by
setting PCI_COMMAND_INTX_DISABLE, MSI doesn't work either.  The PCI/PCIe
specs do not require software to set PCI_COMMAND_INTX_DISABLE when enabling
MSI, but Linux has done that for many years.

Mick reported that 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI
devices") broke these devices.  Prior to 306c54d0edb6, they used INTx.
Starting with 306c54d0edb6, they use MSI, and and the fact that Linux sets
PCI_COMMAND_INTX_DISABLE means both INTx and MSI are disabled on these
devices.

Avoid this SB600 defect by disabling MSI so we use INTx as before.

Fixes: 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI devices")
Link: https://lore.kernel.org/r/20220321183446.1108325-1-helgaas@kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215690
Link: https://lore.kernel.org/all/PxIByDyBRcsbpcmVhGSNDFAoUcMmb78ctXCkw6fbpx25TGlCHvA6SJjjFkNr1FfQZMntYPTNyvEnblxzAZ8a6jP9ddLpKeCN6Chi_2FuexU=@protonmail.com/
Link: https://lore.kernel.org/r/20220314101448.90074-1-andriy.shevchenko@linux.intel.com
BugLink: https://lore.kernel.org/all/20200702143045.23429-1-andriy.shevchenko@linux.intel.com/
Reported-by: Mick Lorain <micklorain@protonmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e7cd8b504535..4893b1e82403 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1811,6 +1811,18 @@ static void quirk_alder_ioapic(struct pci_dev *pdev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_EESSC,	quirk_alder_ioapic);
 #endif
 
+static void quirk_no_msi(struct pci_dev *dev)
+{
+	pci_info(dev, "avoiding MSI to work around a hardware defect\n");
+	dev->no_msi = 1;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4386, quirk_no_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4387, quirk_no_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4388, quirk_no_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4389, quirk_no_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438a, quirk_no_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x438b, quirk_no_msi);
+
 static void quirk_pcie_mch(struct pci_dev *pdev)
 {
 	pdev->no_msi = 1;
-- 
2.34.1



