Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48B4C76F8
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiB1SKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbiB1SH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FE55D64D;
        Mon, 28 Feb 2022 09:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E44DB810DB;
        Mon, 28 Feb 2022 17:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFBCC340E7;
        Mon, 28 Feb 2022 17:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070499;
        bh=E6574w75kqATyqu0nXYHqLTZcMPRkRFDJ7mSeoReHQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WX8q+6y/tsZMd+q58+AvtwIXgBpahy89seoavjQbnBy/L5spJWuw5VmJg9m0JSU8s
         pyPcmzbIqqfrNnmZp2nWIfRfVP8qGG9KMnetelHiK8OLh0Z1YebfgJz6nd9nUnT5Xh
         VP9sS+jmk2QyU2D9zxOKOpjAm+asyCBI9LiSbNuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.16 130/164] usb: dwc3: pci: Add "snps,dis_u2_susphy_quirk" for Intel Bay Trail
Date:   Mon, 28 Feb 2022 18:24:52 +0100
Message-Id: <20220228172411.881459435@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Hans de Goede <hdegoede@redhat.com>

commit d7c93a903f33ff35aa0e6b5a8032eb9755b00826 upstream.

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
---
 drivers/usb/dwc3/dwc3-pci.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -119,6 +119,13 @@ static const struct property_entry dwc3_
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
@@ -161,6 +168,10 @@ static const struct software_node dwc3_p
 	.properties = dwc3_pci_intel_properties,
 };
 
+static const struct software_node dwc3_pci_intel_byt_swnode = {
+	.properties = dwc3_pci_intel_byt_properties,
+};
+
 static const struct software_node dwc3_pci_intel_mrfld_swnode = {
 	.properties = dwc3_pci_mrfld_properties,
 };
@@ -344,7 +355,7 @@ static const struct pci_device_id dwc3_p
 	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BYT),
-	  (kernel_ulong_t) &dwc3_pci_intel_swnode, },
+	  (kernel_ulong_t) &dwc3_pci_intel_byt_swnode, },
 
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
 	  (kernel_ulong_t) &dwc3_pci_intel_mrfld_swnode, },


