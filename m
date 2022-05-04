Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEC51A9E4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357803AbiEDRUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357143AbiEDROs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE40554197;
        Wed,  4 May 2022 09:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567F761912;
        Wed,  4 May 2022 16:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC5CC385B3;
        Wed,  4 May 2022 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683483;
        bh=arkoNboqqWCWLyLsjMunKLSYNWc8N9GyNjsjgTaMs30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btELwcrtuN8JitTUdCjnSLFC2BCBrGe6Dbus746u3sp0tG+0TvEFtwSks8MErGF2+
         0Tbfq3ibPPi+vnK4mIXlQgNU0rU/TpXtzmK1JFibrL628A6/PJWH9MjoUe9weP7Wnn
         n/z1Neerc7JOqFwC1GBQtej4aDPnhcLnpK36z5SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 135/225] Bluetooth: hci_event: Fix checking for invalid handle on error status
Date:   Wed,  4 May 2022 18:46:13 +0200
Message-Id: <20220504153122.340840202@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c86cc5a3ec70f5644f1fa21610b943d0441bc1f7 ]

Commit d5ebaa7c5f6f6 introduces checks for handle range
(e.g HCI_CONN_HANDLE_MAX) but controllers like Intel AX200 don't seem
to respect the valid range int case of error status:

> HCI Event: Connect Complete (0x03) plen 11
        Status: Page Timeout (0x04)
        Handle: 65535
        Address: 94:DB:56:XX:XX:XX (Sony Home Entertainment&
	Sound Products Inc)
        Link type: ACL (0x01)
        Encryption: Disabled (0x00)
[1644965.827560] Bluetooth: hci0: Ignoring HCI_Connection_Complete for invalid handle

Because of it is impossible to cleanup the connections properly since
the stack would attempt to cancel the connection which is no longer in
progress causing the following trace:

< HCI Command: Create Connection Cancel (0x01|0x0008) plen 6
        Address: 94:DB:56:XX:XX:XX (Sony Home Entertainment&
	Sound Products Inc)
= bluetoothd: src/profile.c:record_cb() Unable to get Hands-Free Voice
	gateway SDP record: Connection timed out
> HCI Event: Command Complete (0x0e) plen 10
      Create Connection Cancel (0x01|0x0008) ncmd 1
        Status: Unknown Connection Identifier (0x02)
        Address: 94:DB:56:XX:XX:XX (Sony Home Entertainment&
	Sound Products Inc)
< HCI Command: Create Connection Cancel (0x01|0x0008) plen 6
        Address: 94:DB:56:XX:XX:XX (Sony Home Entertainment&
	Sound Products Inc)

Fixes: d5ebaa7c5f6f6 ("Bluetooth: hci_event: Ignore multiple conn complete events")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 65 ++++++++++++++++++++-----------------
 2 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 5cb095b09a94..69ef31cea582 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -578,6 +578,7 @@ enum {
 #define HCI_ERROR_CONNECTION_TIMEOUT	0x08
 #define HCI_ERROR_REJ_LIMITED_RESOURCES	0x0d
 #define HCI_ERROR_REJ_BAD_ADDR		0x0f
+#define HCI_ERROR_INVALID_PARAMETERS	0x12
 #define HCI_ERROR_REMOTE_USER_TERM	0x13
 #define HCI_ERROR_REMOTE_LOW_RESOURCES	0x14
 #define HCI_ERROR_REMOTE_POWER_OFF	0x15
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d984777c9b58..33a1b4115194 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3067,13 +3067,9 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 {
 	struct hci_ev_conn_complete *ev = data;
 	struct hci_conn *conn;
+	u8 status = ev->status;
 
-	if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
-		bt_dev_err(hdev, "Ignoring HCI_Connection_Complete for invalid handle");
-		return;
-	}
-
-	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
 
@@ -3122,8 +3118,14 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	if (!ev->status) {
+	if (!status) {
 		conn->handle = __le16_to_cpu(ev->handle);
+		if (conn->handle > HCI_CONN_HANDLE_MAX) {
+			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
+				   conn->handle, HCI_CONN_HANDLE_MAX);
+			status = HCI_ERROR_INVALID_PARAMETERS;
+			goto done;
+		}
 
 		if (conn->type == ACL_LINK) {
 			conn->state = BT_CONFIG;
@@ -3164,18 +3166,18 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 			hci_send_cmd(hdev, HCI_OP_CHANGE_CONN_PTYPE, sizeof(cp),
 				     &cp);
 		}
-	} else {
-		conn->state = BT_CLOSED;
-		if (conn->type == ACL_LINK)
-			mgmt_connect_failed(hdev, &conn->dst, conn->type,
-					    conn->dst_type, ev->status);
 	}
 
 	if (conn->type == ACL_LINK)
 		hci_sco_setup(conn, ev->status);
 
-	if (ev->status) {
-		hci_connect_cfm(conn, ev->status);
+done:
+	if (status) {
+		conn->state = BT_CLOSED;
+		if (conn->type == ACL_LINK)
+			mgmt_connect_failed(hdev, &conn->dst, conn->type,
+					    conn->dst_type, status);
+		hci_connect_cfm(conn, status);
 		hci_conn_del(conn);
 	} else if (ev->link_type == SCO_LINK) {
 		switch (conn->setting & SCO_AIRMODE_MASK) {
@@ -3185,7 +3187,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 			break;
 		}
 
-		hci_connect_cfm(conn, ev->status);
+		hci_connect_cfm(conn, status);
 	}
 
 unlock:
@@ -4676,6 +4678,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 {
 	struct hci_ev_sync_conn_complete *ev = data;
 	struct hci_conn *conn;
+	u8 status = ev->status;
 
 	switch (ev->link_type) {
 	case SCO_LINK:
@@ -4690,12 +4693,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 		return;
 	}
 
-	if (__le16_to_cpu(ev->handle) > HCI_CONN_HANDLE_MAX) {
-		bt_dev_err(hdev, "Ignoring HCI_Sync_Conn_Complete for invalid handle");
-		return;
-	}
-
-	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
 
@@ -4729,9 +4727,17 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 		goto unlock;
 	}
 
-	switch (ev->status) {
+	switch (status) {
 	case 0x00:
 		conn->handle = __le16_to_cpu(ev->handle);
+		if (conn->handle > HCI_CONN_HANDLE_MAX) {
+			bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x",
+				   conn->handle, HCI_CONN_HANDLE_MAX);
+			status = HCI_ERROR_INVALID_PARAMETERS;
+			conn->state = BT_CLOSED;
+			break;
+		}
+
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
 
@@ -4775,8 +4781,8 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 		}
 	}
 
-	hci_connect_cfm(conn, ev->status);
-	if (ev->status)
+	hci_connect_cfm(conn, status);
+	if (status)
 		hci_conn_del(conn);
 
 unlock:
@@ -5527,11 +5533,6 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	struct smp_irk *irk;
 	u8 addr_type;
 
-	if (handle > HCI_CONN_HANDLE_MAX) {
-		bt_dev_err(hdev, "Ignoring HCI_LE_Connection_Complete for invalid handle");
-		return;
-	}
-
 	hci_dev_lock(hdev);
 
 	/* All controllers implicitly stop advertising in the event of a
@@ -5603,6 +5604,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 
 	conn->dst_type = ev_bdaddr_type(hdev, conn->dst_type, NULL);
 
+	if (handle > HCI_CONN_HANDLE_MAX) {
+		bt_dev_err(hdev, "Invalid handle: 0x%4.4x > 0x%4.4x", handle,
+			   HCI_CONN_HANDLE_MAX);
+		status = HCI_ERROR_INVALID_PARAMETERS;
+	}
+
 	if (status) {
 		hci_le_conn_failed(conn, status);
 		goto unlock;
-- 
2.35.1



