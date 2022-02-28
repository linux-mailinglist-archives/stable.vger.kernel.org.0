Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCCB4C6345
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiB1GmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiB1GmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 01:42:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58FE66FBA
        for <stable@vger.kernel.org>; Sun, 27 Feb 2022 22:41:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98CB9B80DDF
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 06:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE96DC340E7;
        Mon, 28 Feb 2022 06:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646030494;
        bh=09tqJNGcddKczdE+/0c0Mpt/rSz4pqk3UzmKafmbg7c=;
        h=Subject:To:Cc:From:Date:From;
        b=0FEVi1PLVCseu5LCwsHxlqNOoU4bvxQp1oLVEBwqtWPQbkuTLjPX3QoDcGznP0Xu4
         TtA/Q5goBF8uKXsMOkPxnkGTtcEYdoI/LK0WF26Pl0fMTZx6WFR3P1rmcu8Va1zLQ6
         Xaua7HgeR8mrdpYeuV7OwoHD8o/Id96oFPVW8Ip8=
Subject: FAILED: patch "[PATCH] usb: dwc3: pci: Add "snps,dis_u2_susphy_quirk" for Intel Bay" failed to apply to 5.10-stable tree
To:     hdegoede@redhat.com, Sergey.Semin@baikalelectronics.ru,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 07:41:31 +0100
Message-ID: <164603049112022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d7c93a903f33ff35aa0e6b5a8032eb9755b00826 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 13 Feb 2022 14:05:16 +0100
Subject: [PATCH] usb: dwc3: pci: Add "snps,dis_u2_susphy_quirk" for Intel Bay
 Trail

Commit e0082698b689 ("usb: dwc3: ulpi: conditionally resume ULPI PHY")
fixed an issue where ULPI transfers would timeout if any requests where
send to the phy sometime after init, giving it enough time to auto-suspend.

Commit e5f4ca3fce90 ("usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend
regression") changed the behavior to instead of clearing the
DWC3_GUSB2PHYCFG_SUSPHY bit, add an extra sleep when it is set.

But on Bay Trail devices, when phy_set_mode() gets called during init,
this leads to errors like these:
[   28.451522] tusb1210 dwc3.ulpi: error -110 writing val 0x01 to reg 0x0a
[   28.464089] tusb1210 dwc3.ulpi: error -110 writing val 0x01 to reg 0x0a

Add "snps,dis_u2_susphy_quirk" to the settings for Bay Trail devices to
fix this. This restores the old behavior for Bay Trail devices, since
previously the DWC3_GUSB2PHYCFG_SUSPHY bit would get cleared on the first
ulpi_read/_write() and then was never set again.

Fixes: e5f4ca3fce90 ("usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression")
Cc: stable@kernel.org
Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220213130524.18748-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 4e69a9d829f2..18ab49b8e66e 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -120,6 +120,13 @@ static const struct property_entry dwc3_pci_intel_properties[] = {
 	{}
 };
 
+static const struct property_entry dwc3_pci_intel_byt_properties[] = {
+	PROPERTY_ENTRY_STRING("dr_mode", "peripheral"),
+	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
+	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
+	{}
+};
+
 static const struct property_entry dwc3_pci_mrfld_properties[] = {
 	PROPERTY_ENTRY_STRING("dr_mode", "otg"),
 	PROPERTY_ENTRY_STRING("linux,extcon-name", "mrfld_bcove_pwrsrc"),
@@ -162,6 +169,10 @@ static const struct software_node dwc3_pci_intel_swnode = {
 	.properties = dwc3_pci_intel_properties,
 };
 
+static const struct software_node dwc3_pci_intel_byt_swnode = {
+	.properties = dwc3_pci_intel_byt_properties,
+};
+
 static const struct software_node dwc3_pci_intel_mrfld_swnode = {
 	.properties = dwc3_pci_mrfld_properties,
 };
@@ -345,7 +356,7 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BYT),
-	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+	  (kernel_ulong_t) &dwc3_pci_intel_byt_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
 	  (kernel_ulong_t) &dwc3_pci_intel_mrfld_swnode, },

