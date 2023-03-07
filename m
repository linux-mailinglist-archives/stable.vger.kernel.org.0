Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7452D6AF108
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbjCGSid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbjCGSiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:38:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34538B5B58
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D85BCE1C92
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8143AC4339B;
        Tue,  7 Mar 2023 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213677;
        bh=o3F1U4B5QGySixeXa1P2a2Itljzw/v2Bu5y194DP/tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wB8GA3vcEeBp03soz8hG9MmmclRlLSjxGf8LA5ToA0fq4MOch+lwua2aqPyAa1w8S
         Qpd0JFLmuGVSXN71z50wdBDwFfV/a2AHkKUJb8Uab9TIPAGWayxWY5/kzrZJumZMhT
         sMioDfTMmc4CE+bBv/GO/q3IetVG9Lx20grjuTqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 584/885] Bluetooth: Fix issue with Actions Semi ATS2851 based devices
Date:   Tue,  7 Mar 2023 17:58:38 +0100
Message-Id: <20230307170027.741156867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

[ Upstream commit 5d44f76fab0839799b19cbc88d13575da968dc08 ]

Their devices claim to support the erroneous data reporting, but don't
actually support the required commands. So blacklist them and add a
quirk.

  < HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
  > HCI Event: Command Status (0x0f) plen 4
        Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
          Status: Unknown HCI Command (0x01)

T:  Bus=02 Lev=02 Prnt=08 Port=02 Cnt=01 Dev#= 10 Spd=12   MxCh= 0
D:  Ver= 2.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=10d7 ProdID=b012 Rev=88.91
S:  Manufacturer=Actions
S:  Product=general adapter
S:  SerialNumber=ACTIONS1234
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=01(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 93e9ae928e4e8..4394a0e40c733 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -63,6 +63,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_INTEL_BROKEN_SHUTDOWN_LED	BIT(24)
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD BIT(25)
 #define BTUSB_INTEL_NO_WBS_SUPPORT	BIT(26)
+#define BTUSB_ACTIONS_SEMI		BIT(27)
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -663,6 +664,9 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x0cb5, 0xc547), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 
+	/* Actions Semiconductor ATS2851 based devices */
+	{ USB_DEVICE(0x10d7, 0xb012), .driver_info = BTUSB_ACTIONS_SEMI },
+
 	/* Silicon Wave based devices */
 	{ USB_DEVICE(0x0c10, 0x0000), .driver_info = BTUSB_SWAVE },
 
@@ -4012,6 +4016,11 @@ static int btusb_probe(struct usb_interface *intf,
 		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}
 
+	if (id->driver_info & BTUSB_ACTIONS_SEMI) {
+		/* Support is advertised, but not implemented */
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
+	}
+
 	if (!reset)
 		set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
 
-- 
2.39.2



