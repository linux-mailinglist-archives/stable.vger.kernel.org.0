Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C50C328CD2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhCAS7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239894AbhCASxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BE9650B7;
        Mon,  1 Mar 2021 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620483;
        bh=DidcVKk6uM/nYXA9NTG3oYw/7TYNPA9SrQp7B1nHP0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJgCMRev/oGXp49XNI9s4w/IPd+kABSeSFolYjFQKsxKUnLAjqY2lF5+QqqLSV0L8
         C6qcPdAA8xDw+CPlrGgSXmvn2iZMYk2+lbTCV2dJ5cngXtZODNyEq8+JRUOBLYGSP9
         qSRzTKZ2kf9et6CVtMj+jSkVqBU8gc7oUUGzr3uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 140/775] Bluetooth: Remove hci_req_le_suspend_config
Date:   Mon,  1 Mar 2021 17:05:08 +0100
Message-Id: <20210301161208.579812043@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit 295fa2a5647b13681594bb1bcc76c74619035218 ]

Add a missing SUSPEND_SCAN_ENABLE in passive scan, remove the separate
function for configuring le scan during suspend and update the request
complete function to clear both enable and disable tasks.

Fixes: dce0a4be8054 ("Bluetooth: Set missing suspend task bits")
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 71bffd7454720..5aa7bd5030a21 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1087,6 +1087,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 	if (hdev->suspended) {
 		window = hdev->le_scan_window_suspend;
 		interval = hdev->le_scan_int_suspend;
+
+		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
 	} else if (hci_is_le_conn_scanning(hdev)) {
 		window = hdev->le_scan_window_connect;
 		interval = hdev->le_scan_int_connect;
@@ -1170,19 +1172,6 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	hci_req_add(req, HCI_OP_WRITE_SCAN_ENABLE, 1, &scan);
 }
 
-static void hci_req_config_le_suspend_scan(struct hci_request *req)
-{
-	/* Before changing params disable scan if enabled */
-	if (hci_dev_test_flag(req->hdev, HCI_LE_SCAN))
-		hci_req_add_le_scan_disable(req, false);
-
-	/* Configure params and enable scanning */
-	hci_req_add_le_passive_scan(req);
-
-	/* Block suspend notifier on response */
-	set_bit(SUSPEND_SCAN_ENABLE, req->hdev->suspend_tasks);
-}
-
 static void cancel_adv_timeout(struct hci_dev *hdev)
 {
 	if (hdev->adv_instance_timeout) {
@@ -1245,8 +1234,10 @@ static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
 		   status);
-	if (test_and_clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
-	    test_and_clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+	if (test_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks) ||
+	    test_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks)) {
+		clear_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
+		clear_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
 		wake_up(&hdev->suspend_wait_q);
 	}
 }
@@ -1336,7 +1327,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Enable event filter for paired devices */
 		hci_req_set_event_filter(&req);
 		/* Enable passive scan at lower duty cycle */
-		hci_req_config_le_suspend_scan(&req);
+		__hci_update_background_scan(&req);
 		/* Pause scan changes again. */
 		hdev->scanning_paused = true;
 		hci_req_run(&req, suspend_req_complete);
@@ -1346,7 +1337,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 		hci_req_clear_event_filter(&req);
 		/* Reset passive/background scanning to normal */
-		hci_req_config_le_suspend_scan(&req);
+		__hci_update_background_scan(&req);
 
 		/* Unpause directed advertising */
 		hdev->advertising_paused = false;
-- 
2.27.0



