Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5969F5405E9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346950AbiFGRcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347733AbiFGRbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00AC11AFFD;
        Tue,  7 Jun 2022 10:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DB30B80B66;
        Tue,  7 Jun 2022 17:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D584C385A5;
        Tue,  7 Jun 2022 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622888;
        bh=X6xGrTQ19sclz00yUju7tgj46+EC0IZq+CAtfEv2qlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8OtVZjpgSCfaInf21eYzXIQRbcOfx9HJB7HanszmN0TvWfF8xqSeBwQ9P8muz3hv
         Inaigo3IZIEgTBGjGds4IjlrSloSucLXylscORWG7UPOc2jvShk6MyYI0ZomI+iBz1
         cVUTDmGehqIi8tWW/M4qKcj41vqal97ZqP9bzgvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Archie Pusaka <apusaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/452] Bluetooth: use inclusive language in HCI role comments
Date:   Tue,  7 Jun 2022 19:01:16 +0200
Message-Id: <20220607164915.087520648@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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

From: Archie Pusaka <apusaka@chromium.org>

[ Upstream commit 74be523ce6bed0531e4f31c3e1387909589e9bfe ]

This patch replaces some non-inclusive terms based on the appropriate
language mapping table compiled by the Bluetooth SIG:
https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf

Specifically, these terms are replaced:
master -> initiator (for smp) or central (everything else)
slave  -> responder (for smp) or peripheral (everything else)

The #define preprocessor terms are unchanged for now to not disturb
dependent APIs.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c   | 8 ++++----
 net/bluetooth/hci_event.c  | 6 +++---
 net/bluetooth/l2cap_core.c | 2 +-
 net/bluetooth/smp.c        | 6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ecd2ffcf2ba2..140d9764c77e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -240,7 +240,7 @@ int hci_disconnect(struct hci_conn *conn, __u8 reason)
 {
 	BT_DBG("hcon %p", conn);
 
-	/* When we are master of an established connection and it enters
+	/* When we are central of an established connection and it enters
 	 * the disconnect timeout, then go ahead and try to read the
 	 * current clock offset.  Processing of the result is done
 	 * within the event handling and hci_clock_offset_evt function.
@@ -1065,16 +1065,16 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 
 	hci_req_init(&req, hdev);
 
-	/* Disable advertising if we're active. For master role
+	/* Disable advertising if we're active. For central role
 	 * connections most controllers will refuse to connect if
-	 * advertising is enabled, and for slave role connections we
+	 * advertising is enabled, and for peripheral role connections we
 	 * anyway have to disable it in order to start directed
 	 * advertising.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
 		 __hci_req_disable_advertising(&req);
 
-	/* If requested to connect as slave use directed advertising */
+	/* If requested to connect as peripheral use directed advertising */
 	if (conn->role == HCI_ROLE_SLAVE) {
 		/* If we're active scanning most controllers are unable
 		 * to initiate advertising. Simply reject the attempt.
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index e926e80d9731..061ef20e135e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2759,9 +2759,9 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		bacpy(&cp.bdaddr, &ev->bdaddr);
 
 		if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_MASTER))
-			cp.role = 0x00; /* Become master */
+			cp.role = 0x00; /* Become central */
 		else
-			cp.role = 0x01; /* Remain slave */
+			cp.role = 0x01; /* Remain peripheral */
 
 		hci_send_cmd(hdev, HCI_OP_ACCEPT_CONN_REQ, sizeof(cp), &cp);
 	} else if (!(flags & HCI_PROTO_DEFER)) {
@@ -5153,7 +5153,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		conn->dst_type = bdaddr_type;
 
 		/* If we didn't have a hci_conn object previously
-		 * but we're in master role this must be something
+		 * but we're in central role this must be something
 		 * initiated using a white list. Since white list based
 		 * connections are not "first class citizens" we don't
 		 * have full tracking of them. Therefore, we go ahead
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ad33c592cde4..6c80e62cea0c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1688,7 +1688,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
 	if (hcon->out)
 		smp_conn_security(hcon, hcon->pending_sec_level);
 
-	/* For LE slave connections, make sure the connection interval
+	/* For LE peripheral connections, make sure the connection interval
 	 * is in the range of the minimum and maximum interval that has
 	 * been configured for this connection. If not, then trigger
 	 * the connection update procedure.
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 2b7879afc333..b7374dbee23a 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -909,8 +909,8 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 			hcon->pending_sec_level = BT_SECURITY_HIGH;
 	}
 
-	/* If both devices have Keyoard-Display I/O, the master
-	 * Confirms and the slave Enters the passkey.
+	/* If both devices have Keyboard-Display I/O, the initiator
+	 * Confirms and the responder Enters the passkey.
 	 */
 	if (smp->method == OVERLAP) {
 		if (hcon->role == HCI_ROLE_MASTER)
@@ -3076,7 +3076,7 @@ static void bredr_pairing(struct l2cap_chan *chan)
 	if (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags))
 		return;
 
-	/* Only master may initiate SMP over BR/EDR */
+	/* Only initiator may initiate SMP over BR/EDR */
 	if (hcon->role != HCI_ROLE_MASTER)
 		return;
 
-- 
2.35.1



