Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155B448E628
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbiANIYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:24:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33836 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbiANIWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD637B82437;
        Fri, 14 Jan 2022 08:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29750C36AE9;
        Fri, 14 Jan 2022 08:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148541;
        bh=LBOwUlxMhtjD9DVMb/GAVGXnp7L+8vQbZgAMIdy2IKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i301T3Xvkl49PhAAb8YgEJa+/QQWmLhUzRpcdHPdOv+yWcgzMX/KMyWKXGDJOkexK
         oSZzO75gPXDK6dx3HtL4YA/SOwObFVCV89yGuRFuL0tCFHI7RdetMtGZATfQQcHDhj
         X29125bwlmFjM3gEPb4G7JwDnNOt7WgFBHJdlc+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 22/37] Bluetooth: btbcm: disable read tx power for some Macs with the T2 Security chip
Date:   Fri, 14 Jan 2022 09:16:36 +0100
Message-Id: <20220114081545.574497194@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit 801b4c027b44a185292007d3cf7513999d644723 upstream.

Some Macs with the T2 security chip had Bluetooth not working.
To fix it we add DMI based quirks to disable querying of LE Tx power.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btbcm.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
+#include <linux/dmi.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -343,6 +344,40 @@ static struct sk_buff *btbcm_read_usb_pr
 	return skb;
 }
 
+static const struct dmi_system_id disable_broken_read_transmit_power[] = {
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,2"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,4"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,1"),
+		},
+	},
+	{
+		 .matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac20,2"),
+		},
+	},
+	{ }
+};
+
 static int btbcm_read_info(struct hci_dev *hdev)
 {
 	struct sk_buff *skb;
@@ -363,6 +398,10 @@ static int btbcm_read_info(struct hci_de
 	bt_dev_info(hdev, "BCM: features 0x%2.2x", skb->data[1]);
 	kfree_skb(skb);
 
+	/* Read DMI and disable broken Read LE Min/Max Tx Power */
+	if (dmi_first_match(disable_broken_read_transmit_power))
+		set_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks);
+
 	return 0;
 }
 


