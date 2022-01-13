Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DCB48D5FB
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 11:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiAMKr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 05:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiAMKrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 05:47:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFBBC06173F
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 02:47:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E65661366
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 10:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8881C36AE9;
        Thu, 13 Jan 2022 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642070844;
        bh=fsfwdmQfxUBGrA3CGqy564LboT6NIpRf386J57Xqfyo=;
        h=Subject:To:Cc:From:Date:From;
        b=zfVma9kC/0/YdVnmF6oq/ve2UZuD2OXcZhOw4x11SP0vKG4WCcO05smd9cXdOKWbY
         iGT30dEmj6TmqOgcDS8iA7vcMOJ/66+QuP57Kx0BiFTusFKoes5gPJp+k7hxQ0i2j6
         ILZbTWo8KwQ58K96pLNhFXe3XwKI++0xCa36rLQM=
Subject: FAILED: patch "[PATCH] Bluetooth: add quirk disabling LE Read Transmit Power" failed to apply to 5.16-stable tree
To:     gargaditya08@live.com, marcel@holtmann.org,
        redecorating@protonmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Jan 2022 11:47:13 +0100
Message-ID: <164207083324474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2f8114f9574509580a8506d2ef72e7e43d1a5bd Mon Sep 17 00:00:00 2001
From: Aditya Garg <gargaditya08@live.com>
Date: Thu, 2 Dec 2021 12:41:59 +0000
Subject: [PATCH] Bluetooth: add quirk disabling LE Read Transmit Power

Some devices have a bug causing them to not work if they query
LE tx power on startup. Thus we add a quirk in order to not query it
and default min/max tx power values to HCI_TX_POWER_INVALID.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Reported-by: Orlando Chamberlain <redecorating@protonmail.com>
Tested-by: Orlando Chamberlain <redecorating@protonmail.com>
Link:
https://lore.kernel.org/r/4970a940-211b-25d6-edab-21a815313954@protonmail.com
Fixes: 7c395ea521e6 ("Bluetooth: Query LE tx power on startup")
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 4343f79bd02c..c5f6b82b9d11 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -246,6 +246,15 @@ enum {
 	 * HCI after resume.
 	 */
 	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
+
+	/*
+	 * When this quirk is set, LE tx power is not queried on startup
+	 * and the min/max tx power values default to HCI_TX_POWER_INVALID.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7ac6c170ec49..ff3f561a45a2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3300,7 +3300,8 @@ static int hci_le_read_adv_tx_power_sync(struct hci_dev *hdev)
 /* Read LE Min/Max Tx Power*/
 static int hci_le_read_tx_power_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[38] & 0x80))
+	if (!(hdev->commands[38] & 0x80) ||
+	    test_bit(HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_READ_TRANSMIT_POWER,

