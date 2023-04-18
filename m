Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238766E6486
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjDRMuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbjDRMt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDD515A0A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE22563405
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF85C433D2;
        Tue, 18 Apr 2023 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822193;
        bh=hUhH4UZYXMJ8PKOZYaInp7KKb0cyL+zSVe5yqg4Nf8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcu+7DN2PZJrX1lrXktGKO8oS2erPsTitY/vx0UA3J0oyWYifYI3lhygQ94oqFXcg
         k3Xbt8LxAjmidogjcax//G7owWJjtGAQrZdbdQpjJchQcVKHyT6wTqbHuYL2cYfRrw
         DfzC8Z6UnXA47sOongvSU6J1Qird10AQZvfoV5Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 057/139] Bluetooth: Fix printing errors if LE Connection times out
Date:   Tue, 18 Apr 2023 14:22:02 +0200
Message-Id: <20230418120315.895401713@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b62e72200eaad523f08d8319bba50fc652e032a8 ]

This fixes errors like bellow when LE Connection times out since that
is actually not a controller error:

 Bluetooth: hci0: Opcode 0x200d failed: -110
 Bluetooth: hci0: request failed to create LE connection: err -110

Instead the code shall properly detect if -ETIMEDOUT is returned and
send HCI_OP_LE_CREATE_CONN_CANCEL to give up on the connection.

Link: https://github.com/bluez/bluez/issues/340
Fixes: 8e8b92ee60de ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_conn.c         |  7 +++++--
 net/bluetooth/hci_event.c        | 16 ++++++----------
 net/bluetooth/hci_sync.c         | 13 ++++++++++---
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 7254edfba4c9c..ffb89b98b2714 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -954,6 +954,7 @@ enum {
 	HCI_CONN_STK_ENCRYPT,
 	HCI_CONN_AUTH_INITIATOR,
 	HCI_CONN_DROP,
+	HCI_CONN_CANCEL,
 	HCI_CONN_PARAM_REMOVAL_PEND,
 	HCI_CONN_NEW_LINK_KEY,
 	HCI_CONN_SCANNING,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6fbc1fe7b1dcb..bd38e36e5a58a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1245,6 +1245,8 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct hci_conn *conn = data;
 
+	bt_dev_dbg(hdev, "err %d", err);
+
 	hci_dev_lock(hdev);
 
 	if (!err) {
@@ -1252,8 +1254,6 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 		goto done;
 	}
 
-	bt_dev_err(hdev, "request failed to create LE connection: err %d", err);
-
 	/* Check if connection is still pending */
 	if (conn != hci_lookup_le_connect(hdev))
 		goto done;
@@ -2787,6 +2787,9 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	int r = 0;
 
+	if (test_and_set_bit(HCI_CONN_CANCEL, &conn->flags))
+		return 0;
+
 	switch (conn->state) {
 	case BT_CONNECTED:
 	case BT_CONFIG:
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ad92a4be58517..e68f2a7d863ac 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2881,16 +2881,6 @@ static void cs_le_create_conn(struct hci_dev *hdev, bdaddr_t *peer_addr,
 
 	conn->resp_addr_type = peer_addr_type;
 	bacpy(&conn->resp_addr, peer_addr);
-
-	/* We don't want the connection attempt to stick around
-	 * indefinitely since LE doesn't have a page timeout concept
-	 * like BR/EDR. Set a timer for any connection that doesn't use
-	 * the accept list for connecting.
-	 */
-	if (filter_policy == HCI_LE_USE_PEER_ADDR)
-		queue_delayed_work(conn->hdev->workqueue,
-				   &conn->le_conn_timeout,
-				   conn->conn_timeout);
 }
 
 static void hci_cs_le_create_conn(struct hci_dev *hdev, u8 status)
@@ -5902,6 +5892,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	if (status)
 		goto unlock;
 
+	/* Drop the connection if it has been aborted */
+	if (test_bit(HCI_CONN_CANCEL, &conn->flags)) {
+		hci_conn_drop(conn);
+		goto unlock;
+	}
+
 	if (conn->dst_type == ADDR_LE_DEV_PUBLIC)
 		addr_type = BDADDR_LE_PUBLIC;
 	else
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5a6aa1627791b..632be12672887 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -246,8 +246,9 @@ int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	skb = __hci_cmd_sync_sk(hdev, opcode, plen, param, event, timeout, sk);
 	if (IS_ERR(skb)) {
-		bt_dev_err(hdev, "Opcode 0x%4x failed: %ld", opcode,
-				PTR_ERR(skb));
+		if (!event)
+			bt_dev_err(hdev, "Opcode 0x%4x failed: %ld", opcode,
+				   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
 
@@ -5126,8 +5127,11 @@ static int hci_le_connect_cancel_sync(struct hci_dev *hdev,
 	if (test_bit(HCI_CONN_SCANNING, &conn->flags))
 		return 0;
 
+	if (test_and_set_bit(HCI_CONN_CANCEL, &conn->flags))
+		return 0;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_CREATE_CONN_CANCEL,
-				     6, &conn->dst, HCI_CMD_TIMEOUT);
+				     0, NULL, HCI_CMD_TIMEOUT);
 }
 
 static int hci_connect_cancel_sync(struct hci_dev *hdev, struct hci_conn *conn)
@@ -6102,6 +6106,9 @@ int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn)
 				       conn->conn_timeout, NULL);
 
 done:
+	if (err == -ETIMEDOUT)
+		hci_le_connect_cancel_sync(hdev, conn);
+
 	/* Re-enable advertising after the connection attempt is finished. */
 	hci_resume_advertising_sync(hdev);
 	return err;
-- 
2.39.2



