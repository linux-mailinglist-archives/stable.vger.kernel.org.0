Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A606B615A3A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiKBD12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiKBD12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:27:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4FF25EA9
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D92E617D4
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FB4C433D6;
        Wed,  2 Nov 2022 03:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359644;
        bh=Sha0VsrmY7tz+IwQhbcqHWrbwgJ9iUFnQXN+teliuI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxSqQxeJtkZsE8xu4UFp35UZSVMATbrOSdUmP504cw2pM8eTwMrJx5kMYd7zdCBhW
         NaApZIFtT//33JH2rceRXpMx8nlsLJkT/iintjeDvGZm88YvQQGStm9TKzlmyxjBvn
         42D1kUUw6lz/7zJVBaVEhDt1kWHCAXaXBOkqq9Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 10/78] r8152: add PID for the Lenovo OneLink+ Dock
Date:   Wed,  2 Nov 2022 03:33:55 +0100
Message-Id: <20221102022053.223725452@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>

commit 1bd3a383075c64d638e65d263c9267b08ee7733c upstream.

The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
a broken CDC device by default. Add the custom Lenovo PID to the r8152
driver to support it properly.

Also, systems compatible with this dock provide a BIOS option to enable
MAC address passthrough (as per Lenovo document "ThinkPad Docking
Solutions 2017"). Add the custom PID to the MAC passthrough list too.

Tested on a ThinkPad 13 1st gen with the expected results:

passthrough disabled: Invalid header when reading pass-thru MAC addr
passthrough enabled:  Using pass-thru MAC addr XX:XX:XX:XX:XX:XX

Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/r8152.c     |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -777,6 +777,13 @@ static const struct usb_device_id	produc
 },
 #endif
 
+/* Lenovo ThinkPad OneLink+ Dock (based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3054, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x3062, USB_CLASS_COMM,
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5327,6 +5327,7 @@ static const struct usb_device_id rtl815
 	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},


