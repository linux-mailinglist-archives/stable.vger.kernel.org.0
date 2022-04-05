Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873E54F30B2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241870AbiDEIfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbiDEIT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA7381679;
        Tue,  5 Apr 2022 01:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 844E3B81A32;
        Tue,  5 Apr 2022 08:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39D5C385A1;
        Tue,  5 Apr 2022 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146258;
        bh=kyif2DLgMA6iqw9QlsLzO9GurCGw/kuOrr2fhzY+aLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFUmY6cVNGiDBk9UMiN5ueslaxa4c7Pe9KC+TNXzDgK8YKEBB7h279Ex2/9d5+EMA
         bKg7F+DecqLksGhvvxcViBrIkLwote2DsMDy5DUI30f415/eSiWKPf8OWpLupEOX/K
         1jfmee36diP0g3HcgQsmwmEMdoPBqSWQB3Jq0eSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mick Lorain <micklorain@protonmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0699/1126] PCI: Avoid broken MSI on SB600 USB devices
Date:   Tue,  5 Apr 2022 09:24:06 +0200
Message-Id: <20220405070428.126008163@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 65f7f6b0576c..da829274fc66 100644
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



