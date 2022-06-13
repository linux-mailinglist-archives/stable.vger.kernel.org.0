Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A6C54969F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378222AbiFMNmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379228AbiFMNkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B76D122;
        Mon, 13 Jun 2022 04:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3527360F18;
        Mon, 13 Jun 2022 11:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49030C34114;
        Mon, 13 Jun 2022 11:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119848;
        bh=71pftw3OoNE6+mQQHohO9Rn9Lsf9BTrdcnxHCcIWmas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZIno9HC2UieKZ8wJJuMhNloV8EEf24RbfJCfHR5ne6f8lZHK5L8N9hPTNJN8Fgz7
         jCG3RuaE9Kf0S33xSe/V/m6AQSfQ6gYIrqPgZZbrN2pX90papoc3bgJFPX5jY9EgGa
         ZTlyrH1sYSUMGBYKYkARt/XtRqJdMZLtqrSFa7zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 152/339] Bluetooth: hci_sync: Fix attempting to suspend with unfiltered passive scan
Date:   Mon, 13 Jun 2022 12:09:37 +0200
Message-Id: <20220613094931.293769457@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3b42055388c30f2761a2d9cd9af2c99611dfe457 ]

When suspending the passive scanning _must_ have its filter_policy set
to 0x01 to use the accept list otherwise _any_ advertise report would
end up waking up the system.

In order to fix the filter_policy the code now checks for
hdev->suspended && HCI_CONN_FLAG_REMOTE_WAKEUP
first, since the MGMT_OP_SET_DEVICE_FLAGS will reject any attempt to
set HCI_CONN_FLAG_REMOTE_WAKEUP when it cannot be programmed in the
acceptlist, so it can return success causing the proper filter_policy
to be used.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215768
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 58 +++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 13600bf120b0..6b8d1cd65de4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1664,20 +1664,19 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 	struct hci_cp_le_add_to_accept_list cp;
 	int err;
 
+	/* During suspend, only wakeable devices can be in acceptlist */
+	if (hdev->suspended &&
+	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
+		return 0;
+
 	/* Select filter policy to accept all advertising */
 	if (*num_entries >= hdev->le_accept_list_size)
 		return -ENOSPC;
 
 	/* Accept list can not be used with RPAs */
 	if (!use_ll_privacy(hdev) &&
-	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
+	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type))
 		return -EINVAL;
-	}
-
-	/* During suspend, only wakeable devices can be in acceptlist */
-	if (hdev->suspended &&
-	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
-		return 0;
 
 	/* Attempt to program the device in the resolving list first to avoid
 	 * having to rollback in case it fails since the resolving list is
@@ -4881,10 +4880,28 @@ static int hci_update_event_filter_sync(struct hci_dev *hdev)
 	return 0;
 }
 
+/* This function disables scan (BR and LE) and mark it as paused */
+static int hci_pause_scan_sync(struct hci_dev *hdev)
+{
+	if (hdev->scanning_paused)
+		return 0;
+
+	/* Disable page scan if enabled */
+	if (test_bit(HCI_PSCAN, &hdev->flags))
+		hci_write_scan_enable_sync(hdev, SCAN_DISABLED);
+
+	hci_scan_disable_sync(hdev);
+
+	hdev->scanning_paused = true;
+
+	return 0;
+}
+
 /* This function performs the HCI suspend procedures in the follow order:
  *
  * Pause discovery (active scanning/inquiry)
  * Pause Directed Advertising/Advertising
+ * Pause Scanning (passive scanning in case discovery was not active)
  * Disconnect all connections
  * Set suspend_status to BT_SUSPEND_DISCONNECT if hdev cannot wakeup
  * otherwise:
@@ -4910,15 +4927,11 @@ int hci_suspend_sync(struct hci_dev *hdev)
 	/* Pause other advertisements */
 	hci_pause_advertising_sync(hdev);
 
-	/* Disable page scan if enabled */
-	if (test_bit(HCI_PSCAN, &hdev->flags))
-		hci_write_scan_enable_sync(hdev, SCAN_DISABLED);
-
 	/* Suspend monitor filters */
 	hci_suspend_monitor_sync(hdev);
 
 	/* Prevent disconnects from causing scanning to be re-enabled */
-	hdev->scanning_paused = true;
+	hci_pause_scan_sync(hdev);
 
 	/* Soft disconnect everything (power off) */
 	err = hci_disconnect_all_sync(hdev, HCI_ERROR_REMOTE_POWER_OFF);
@@ -4989,6 +5002,22 @@ static void hci_resume_monitor_sync(struct hci_dev *hdev)
 	}
 }
 
+/* This function resume scan and reset paused flag */
+static int hci_resume_scan_sync(struct hci_dev *hdev)
+{
+	if (!hdev->scanning_paused)
+		return 0;
+
+	hci_update_scan_sync(hdev);
+
+	/* Reset passive scanning to normal */
+	hci_update_passive_scan_sync(hdev);
+
+	hdev->scanning_paused = false;
+
+	return 0;
+}
+
 /* This function performs the HCI suspend procedures in the follow order:
  *
  * Restore event mask
@@ -5011,10 +5040,9 @@ int hci_resume_sync(struct hci_dev *hdev)
 
 	/* Clear any event filters and restore scan state */
 	hci_clear_event_filter_sync(hdev);
-	hci_update_scan_sync(hdev);
 
-	/* Reset passive scanning to normal */
-	hci_update_passive_scan_sync(hdev);
+	/* Resume scanning */
+	hci_resume_scan_sync(hdev);
 
 	/* Resume monitor filters */
 	hci_resume_monitor_sync(hdev);
-- 
2.35.1



