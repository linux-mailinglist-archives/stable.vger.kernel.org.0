Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377BD64A194
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiLLNmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiLLNmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:42:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3001573E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41F60B80D4F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B28C433D2;
        Mon, 12 Dec 2022 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852474;
        bh=34ZkLhg6ZyTG2pee4LvAyBHfMmdbqqGvQJNEEJxlOkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Phlq3k9bElEDmNgBgE+M1hM66rw6StKGMJ5Tj55zWexj9HAKY4WkGtwApa11EY9Xm
         k4IlzTwLfsEs6w10kti6LHIwe6ygKXTTV8Ku1XGYegLLJj5dLuYcGdaz81E0W1+uYM
         EEWOA9kkRhZax1bWE1d22rdp93aIKqG98lDQ7GCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zijun Hu <quic_zijuhu@quicinc.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Subject: [PATCH 6.0 061/157] Bluetooth: btusb: Fix CSR clones again by re-adding ERR_DATA_REPORTING quirk
Date:   Mon, 12 Dec 2022 14:16:49 +0100
Message-Id: <20221212130937.022580812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit 42d7731e3e7409f9444ff44e30c025958f1b14f0 upstream.

A patch series by a Qualcomm engineer essentially removed my
quirk/workaround because they thought it was unnecessary.

It wasn't, and it broke everything again:

https://patchwork.kernel.org/project/netdevbpf/list/?series=661703&archive=both&state=*

He argues that the quirk is not necessary because the code should check
if the dongle says if it's supported or not. The problem is that for
these Chinese CSR clones they say that it would work:

= New Index: 00:00:00:00:00:00 (Primary,USB,hci0)
= Open Index: 00:00:00:00:00:00
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> HCI Event: Command Complete (0x0e) plen 12
> [hci0] 11.276039
      Read Local Version Information (0x04|0x0001) ncmd 1
        Status: Success (0x00)
        HCI version: Bluetooth 5.0 (0x09) - Revision 2064 (0x0810)
        LMP version: Bluetooth 5.0 (0x09) - Subversion 8978 (0x2312)
        Manufacturer: Cambridge Silicon Radio (10)
...
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 68
> [hci0] 11.668030
      Read Local Supported Commands (0x04|0x0002) ncmd 1
        Status: Success (0x00)
        Commands: 163 entries
          ...
          Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
          Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
          ...
...
< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
= Close Index: 00:1A:7D:DA:71:XX

So bring it back wholesale.

Fixes: 63b1a7dd38bf ("Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING")
Fixes: e168f6900877 ("Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR")
Fixes: 766ae2422b43 ("Bluetooth: hci_sync: Check LMP feature bit instead of quirk")
Cc: stable@vger.kernel.org
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c   |    1 +
 include/net/bluetooth/hci.h |   11 +++++++++++
 net/bluetooth/hci_sync.c    |    9 +++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2104,6 +2104,7 @@ static int btusb_setup_csr(struct hci_de
 		 * without these the controller will lock up.
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
 		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,6 +228,17 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
+	/* When this quirk is set, then erroneous data reporting
+	 * is ignored. This is mainly due to the fact that the HCI
+	 * Read Default Erroneous Data Reporting command is advertised,
+	 * but not supported; these controllers often reply with unknown
+	 * command and tend to lock up randomly. Needing a hard reset.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
+
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3459,7 +3459,8 @@ static int hci_read_page_scan_activity_s
 static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
 {
 	if (!(hdev->commands[18] & 0x04) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
@@ -3977,7 +3978,8 @@ static int hci_set_err_data_report_sync(
 	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
 
 	if (!(hdev->commands[18] & 0x08) ||
-	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
+	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
+	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		return 0;
 
 	if (enabled == hdev->err_data_reporting)
@@ -4136,6 +4138,9 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
+	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
+			 "HCI Read Default Erroneous Data Reporting command is "
+			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),


