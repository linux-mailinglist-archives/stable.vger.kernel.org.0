Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5796CC2D4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjC1OtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjC1Osq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D907E07C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA280B81D6E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A2C433EF;
        Tue, 28 Mar 2023 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014889;
        bh=hj4F96kTNcO46OUjbGpi6TrEQVvaLljbyYMaGYzVD6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6FlpS0Xiq0eEvyjzjCTjc4vttDUz2zXlxBqSkcMCe8/zxIV9ykRk7G1apmganlVc
         2CgDlpltRorObc8WX2pP39ynwJGVOOVptgNU/b9eQ9zLb9mVZgS0deCTlQX+RfRR4S
         R6EkAarRdyrj4v1nQL7S8jP9D1LgK1xOPkRb+6/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengping Jiang <jiangzp@google.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 089/240] Bluetooth: hci_sync: Resume adv with no RPA when active scan
Date:   Tue, 28 Mar 2023 16:40:52 +0200
Message-Id: <20230328142623.485594384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengping Jiang <jiangzp@google.com>

[ Upstream commit 3c44a431d62bf4a20d7b901f98266ae3f4676d48 ]

The address resolution should be disabled during the active scan,
so all the advertisements can reach the host. The advertising
has to be paused before disabling the address resolution,
because the advertising will prevent any changes to the resolving
list and the address resolution status. Skipping this will cause
the hci error and the discovery failure.

According to the bluetooth specification:
"7.8.44 LE Set Address Resolution Enable command

This command shall not be used when:
- Advertising (other than periodic advertising) is enabled,
- Scanning is enabled, or
- an HCI_LE_Create_Connection, HCI_LE_Extended_Create_Connection, or
  HCI_LE_Periodic_Advertising_Create_Sync command is outstanding."

If the host is using RPA, the controller needs to generate RPA for
the advertising, so the advertising must remain paused during the
active scan.

If the host is not using RPA, the advertising can be resumed after
disabling the address resolution.

Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan without RPA")
Signed-off-by: Zhengping Jiang <jiangzp@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 64 +++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f7099..7e152e912e8c9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2367,6 +2367,45 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 	return err;
 }
 
+static int hci_pause_addr_resolution(struct hci_dev *hdev)
+{
+	int err;
+
+	if (!use_ll_privacy(hdev))
+		return 0;
+
+	if (!hci_dev_test_flag(hdev, HCI_LL_RPA_RESOLUTION))
+		return 0;
+
+	/* Cannot disable addr resolution if scanning is enabled or
+	 * when initiating an LE connection.
+	 */
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN) ||
+	    hci_lookup_le_connect(hdev)) {
+		bt_dev_err(hdev, "Command not allowed when scan/LE connect");
+		return -EPERM;
+	}
+
+	/* Cannot disable addr resolution if advertising is enabled. */
+	err = hci_pause_advertising_sync(hdev);
+	if (err) {
+		bt_dev_err(hdev, "Pause advertising failed: %d", err);
+		return err;
+	}
+
+	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
+	if (err)
+		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
+			   err);
+
+	/* Return if address resolution is disabled and RPA is not used. */
+	if (!err && scan_use_rpa(hdev))
+		return err;
+
+	hci_resume_advertising_sync(hdev);
+	return err;
+}
+
 struct sk_buff *hci_read_local_oob_data_sync(struct hci_dev *hdev,
 					     bool extended, struct sock *sk)
 {
@@ -2402,7 +2441,7 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	u8 filter_policy;
 	int err;
 
-	/* Pause advertising if resolving list can be used as controllers are
+	/* Pause advertising if resolving list can be used as controllers
 	 * cannot accept resolving list modifications while advertising.
 	 */
 	if (use_ll_privacy(hdev)) {
@@ -5394,27 +5433,12 @@ static int hci_active_scan_sync(struct hci_dev *hdev, uint16_t interval)
 
 	cancel_interleave_scan(hdev);
 
-	/* Pause advertising since active scanning disables address resolution
-	 * which advertising depend on in order to generate its RPAs.
-	 */
-	if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY)) {
-		err = hci_pause_advertising_sync(hdev);
-		if (err) {
-			bt_dev_err(hdev, "pause advertising failed: %d", err);
-			goto failed;
-		}
-	}
-
-	/* Disable address resolution while doing active scanning since the
-	 * accept list shall not be used and all reports shall reach the host
-	 * anyway.
+	/* Pause address resolution for active scan and stop advertising if
+	 * privacy is enabled.
 	 */
-	err = hci_le_set_addr_resolution_enable_sync(hdev, 0x00);
-	if (err) {
-		bt_dev_err(hdev, "Unable to disable Address Resolution: %d",
-			   err);
+	err = hci_pause_addr_resolution(hdev);
+	if (err)
 		goto failed;
-	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
-- 
2.39.2



