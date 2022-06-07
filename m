Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534B45414BE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355158AbiFGUVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359622AbiFGUU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DABC1D2AE2;
        Tue,  7 Jun 2022 11:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56AA3614D7;
        Tue,  7 Jun 2022 18:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623D7C385A2;
        Tue,  7 Jun 2022 18:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626632;
        bh=iihB1Nj/oC6Dql4f7TYbefgPehcT4wyHwaG7/rB40vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovl5LUGY76zlkGhAtsXaaId/0RtTPVjmoORcuKHig8fhgiHjsgKSz7UFcEvglFPkF
         mHrP5lHKBvZdVorejofsyPxx18o6OgE6JQFOBvE4l4UCaYZxkm2fY59FnNj3+fy0id
         BDz1447nxSSQ97LBK/hjdiUAlAI9wxmpR3Q9ym+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 448/772] Bluetooth: hci_sync: Cleanup hci_conn if it cannot be aborted
Date:   Tue,  7 Jun 2022 19:00:40 +0200
Message-Id: <20220607165002.203044274@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit 9b3628d79b46f06157affc56fdb218fdd4988321 ]

This attempts to cleanup the hci_conn if it cannot be aborted as
otherwise it would likely result in having the controller and host
stack out of sync with respect to connection handle.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/hci_conn.c         | 32 ++++++++++++++++++++++++--------
 net/bluetooth/hci_event.c        | 13 ++++---------
 net/bluetooth/hci_sync.c         | 11 ++++++++++-
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 49a88b2f4678..4524920e4895 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1147,7 +1147,7 @@ int hci_conn_switch_role(struct hci_conn *conn, __u8 role);
 
 void hci_conn_enter_active_mode(struct hci_conn *conn, __u8 force_active);
 
-void hci_le_conn_failed(struct hci_conn *conn, u8 status);
+void hci_conn_failed(struct hci_conn *conn, u8 status);
 
 /*
  * hci_conn_get() and hci_conn_put() are used to control the life-time of an
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index cd51bf2a709b..882a7df13005 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -670,7 +670,7 @@ static void le_conn_timeout(struct work_struct *work)
 		/* Disable LE Advertising */
 		le_disable_advertising(hdev);
 		hci_dev_lock(hdev);
-		hci_le_conn_failed(conn, HCI_ERROR_ADVERTISING_TIMEOUT);
+		hci_conn_failed(conn, HCI_ERROR_ADVERTISING_TIMEOUT);
 		hci_dev_unlock(hdev);
 		return;
 	}
@@ -873,7 +873,7 @@ struct hci_dev *hci_get_route(bdaddr_t *dst, bdaddr_t *src, uint8_t src_type)
 EXPORT_SYMBOL(hci_get_route);
 
 /* This function requires the caller holds hdev->lock */
-void hci_le_conn_failed(struct hci_conn *conn, u8 status)
+static void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_conn_params *params;
@@ -886,8 +886,6 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 		params->conn = NULL;
 	}
 
-	conn->state = BT_CLOSED;
-
 	/* If the status indicates successful cancellation of
 	 * the attempt (i.e. Unknown Connection Id) there's no point of
 	 * notifying failure since we'll go back to keep trying to
@@ -899,10 +897,6 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 		mgmt_connect_failed(hdev, &conn->dst, conn->type,
 				    conn->dst_type, status);
 
-	hci_connect_cfm(conn, status);
-
-	hci_conn_del(conn);
-
 	/* Since we may have temporarily stopped the background scanning in
 	 * favor of connection establishment, we should restart it.
 	 */
@@ -914,6 +908,28 @@ void hci_le_conn_failed(struct hci_conn *conn, u8 status)
 	hci_enable_advertising(hdev);
 }
 
+/* This function requires the caller holds hdev->lock */
+void hci_conn_failed(struct hci_conn *conn, u8 status)
+{
+	struct hci_dev *hdev = conn->hdev;
+
+	bt_dev_dbg(hdev, "status 0x%2.2x", status);
+
+	switch (conn->type) {
+	case LE_LINK:
+		hci_le_conn_failed(conn, status);
+		break;
+	case ACL_LINK:
+		mgmt_connect_failed(hdev, &conn->dst, conn->type,
+				    conn->dst_type, status);
+		break;
+	}
+
+	conn->state = BT_CLOSED;
+	hci_connect_cfm(conn, status);
+	hci_conn_del(conn);
+}
+
 static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct hci_conn *conn = data;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4002a47832bc..1be745b228c1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2846,7 +2846,7 @@ static void hci_cs_le_create_conn(struct hci_dev *hdev, u8 status)
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	/* All connection failure handling is taken care of by the
-	 * hci_le_conn_failed function which is triggered by the HCI
+	 * hci_conn_failed function which is triggered by the HCI
 	 * request completion callbacks used for connecting.
 	 */
 	if (status)
@@ -2871,7 +2871,7 @@ static void hci_cs_le_ext_create_conn(struct hci_dev *hdev, u8 status)
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	/* All connection failure handling is taken care of by the
-	 * hci_le_conn_failed function which is triggered by the HCI
+	 * hci_conn_failed function which is triggered by the HCI
 	 * request completion callbacks used for connecting.
 	 */
 	if (status)
@@ -3185,12 +3185,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 
 done:
 	if (status) {
-		conn->state = BT_CLOSED;
-		if (conn->type == ACL_LINK)
-			mgmt_connect_failed(hdev, &conn->dst, conn->type,
-					    conn->dst_type, status);
-		hci_connect_cfm(conn, status);
-		hci_conn_del(conn);
+		hci_conn_failed(conn, status);
 	} else if (ev->link_type == SCO_LINK) {
 		switch (conn->setting & SCO_AIRMODE_MASK) {
 		case SCO_AIRMODE_CVSD:
@@ -5626,7 +5621,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	}
 
 	if (status) {
-		hci_le_conn_failed(conn, status);
+		hci_conn_failed(conn, status);
 		goto unlock;
 	}
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 8f4c5698913d..13600bf120b0 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4408,12 +4408,21 @@ static int hci_reject_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
 static int hci_abort_conn_sync(struct hci_dev *hdev, struct hci_conn *conn,
 			       u8 reason)
 {
+	int err;
+
 	switch (conn->state) {
 	case BT_CONNECTED:
 	case BT_CONFIG:
 		return hci_disconnect_sync(hdev, conn, reason);
 	case BT_CONNECT:
-		return hci_connect_cancel_sync(hdev, conn);
+		err = hci_connect_cancel_sync(hdev, conn);
+		/* Cleanup hci_conn object if it cannot be cancelled as it
+		 * likelly means the controller and host stack are out of sync.
+		 */
+		if (err)
+			hci_conn_failed(conn, err);
+
+		return err;
 	case BT_CONNECT2:
 		return hci_reject_conn_sync(hdev, conn, reason);
 	default:
-- 
2.35.1



