Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31A6CC40E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjC1O7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233718AbjC1O7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD7DDBCA
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44EF6177C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C483DC4339B;
        Tue, 28 Mar 2023 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015558;
        bh=8zbsJtsSrm8R7ZnzbjM8sB6rsXxI4PWxDro3PBeXtxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQhpNEhnGZBKXzPGvYg3InkNlJaHQWmM3uFiv5HeFoSDxQULHrtOMNPYPRbWfEPwp
         pCKrYnBrcx9mLR+nGoStPqT9yGD5sIJc2BWGRxMxlX/1QYgCIh5EpqZH/Z3lB9xucd
         oEXGAdF3JJuamHm35Z76+gzBUzmB+yU4KY1TQ7d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/224] Bluetooth: L2CAP: Fix responding with wrong PDU type
Date:   Tue, 28 Mar 2023 16:41:29 +0200
Message-Id: <20230328142621.119448331@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9aa9d9473f1550d1936c31259720b3f1f4690576 ]

L2CAP_ECRED_CONN_REQ shall be responded with L2CAP_ECRED_CONN_RSP not
L2CAP_LE_CONN_RSP:

L2CAP LE EATT Server - Reject - run
  Listening for connections
  New client connection with handle 0x002a
  Sending L2CAP Request from client
  Client received response code 0x15
  Unexpected L2CAP response code (expected 0x18)
L2CAP LE EATT Server - Reject - test failed

> ACL Data RX: Handle 42 flags 0x02 dlen 26
      LE L2CAP: Enhanced Credit Connection Request (0x17) ident 1 len 18
        PSM: 39 (0x0027)
        MTU: 64
        MPS: 64
        Credits: 5
        Source CID: 65
        Source CID: 66
        Source CID: 67
        Source CID: 68
        Source CID: 69
< ACL Data TX: Handle 42 flags 0x00 dlen 16
      LE L2CAP: LE Connection Response (0x15) ident 1 len 8
        invalid size
        00 00 00 00 00 00 06 00

L2CAP LE EATT Server - Reject - run
  Listening for connections
  New client connection with handle 0x002a
  Sending L2CAP Request from client
  Client received response code 0x18
L2CAP LE EATT Server - Reject - test passed

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 117 +++++++++++++++++++++++++------------
 1 file changed, 79 insertions(+), 38 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index da85768b04b76..b6f69d1feeeec 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -708,6 +708,17 @@ void l2cap_chan_del(struct l2cap_chan *chan, int err)
 }
 EXPORT_SYMBOL_GPL(l2cap_chan_del);
 
+static void __l2cap_chan_list_id(struct l2cap_conn *conn, u16 id,
+				 l2cap_chan_func_t func, void *data)
+{
+	struct l2cap_chan *chan, *l;
+
+	list_for_each_entry_safe(chan, l, &conn->chan_l, list) {
+		if (chan->ident == id)
+			func(chan, data);
+	}
+}
+
 static void __l2cap_chan_list(struct l2cap_conn *conn, l2cap_chan_func_t func,
 			      void *data)
 {
@@ -775,23 +786,9 @@ static void l2cap_chan_le_connect_reject(struct l2cap_chan *chan)
 
 static void l2cap_chan_ecred_connect_reject(struct l2cap_chan *chan)
 {
-	struct l2cap_conn *conn = chan->conn;
-	struct l2cap_ecred_conn_rsp rsp;
-	u16 result;
-
-	if (test_bit(FLAG_DEFER_SETUP, &chan->flags))
-		result = L2CAP_CR_LE_AUTHORIZATION;
-	else
-		result = L2CAP_CR_LE_BAD_PSM;
-
 	l2cap_state_change(chan, BT_DISCONN);
 
-	memset(&rsp, 0, sizeof(rsp));
-
-	rsp.result  = cpu_to_le16(result);
-
-	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
-		       &rsp);
+	__l2cap_ecred_conn_rsp_defer(chan);
 }
 
 static void l2cap_chan_connect_reject(struct l2cap_chan *chan)
@@ -846,7 +843,7 @@ void l2cap_chan_close(struct l2cap_chan *chan, int reason)
 					break;
 				case L2CAP_MODE_EXT_FLOWCTL:
 					l2cap_chan_ecred_connect_reject(chan);
-					break;
+					return;
 				}
 			}
 		}
@@ -3938,43 +3935,86 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 		       &rsp);
 }
 
-void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
 {
+	int *result = data;
+
+	if (*result || test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	switch (chan->state) {
+	case BT_CONNECT2:
+		/* If channel still pending accept add to result */
+		(*result)++;
+		return;
+	case BT_CONNECTED:
+		return;
+	default:
+		/* If not connected or pending accept it has been refused */
+		*result = -ECONNREFUSED;
+		return;
+	}
+}
+
+struct l2cap_ecred_rsp_data {
 	struct {
 		struct l2cap_ecred_conn_rsp rsp;
-		__le16 dcid[5];
+		__le16 scid[L2CAP_ECRED_MAX_CID];
 	} __packed pdu;
+	int count;
+};
+
+static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
+{
+	struct l2cap_ecred_rsp_data *rsp = data;
+
+	if (test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	/* Reset ident so only one response is sent */
+	chan->ident = 0;
+
+	/* Include all channels pending with the same ident */
+	if (!rsp->pdu.rsp.result)
+		rsp->pdu.rsp.dcid[rsp->count++] = cpu_to_le16(chan->scid);
+	else
+		l2cap_chan_del(chan, ECONNRESET);
+}
+
+void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+{
 	struct l2cap_conn *conn = chan->conn;
-	u16 ident = chan->ident;
-	int i = 0;
+	struct l2cap_ecred_rsp_data data;
+	u16 id = chan->ident;
+	int result = 0;
 
-	if (!ident)
+	if (!id)
 		return;
 
-	BT_DBG("chan %p ident %d", chan, ident);
+	BT_DBG("chan %p id %d", chan, id);
 
-	pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
-	pdu.rsp.mps     = cpu_to_le16(chan->mps);
-	pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
-	pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
+	memset(&data, 0, sizeof(data));
 
-	mutex_lock(&conn->chan_lock);
+	data.pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
+	data.pdu.rsp.mps     = cpu_to_le16(chan->mps);
+	data.pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
+	data.pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
-		if (chan->ident != ident)
-			continue;
+	/* Verify that all channels are ready */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_list_defer, &result);
 
-		/* Reset ident so only one response is sent */
-		chan->ident = 0;
+	if (result > 0)
+		return;
 
-		/* Include all channels pending with the same ident */
-		pdu.dcid[i++] = cpu_to_le16(chan->scid);
-	}
+	if (result < 0)
+		data.pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_AUTHORIZATION);
 
-	mutex_unlock(&conn->chan_lock);
+	/* Build response */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_rsp_defer, &data);
 
-	l2cap_send_cmd(conn, ident, L2CAP_ECRED_CONN_RSP,
-			sizeof(pdu.rsp) + i * sizeof(__le16), &pdu);
+	l2cap_send_cmd(conn, id, L2CAP_ECRED_CONN_RSP,
+		       sizeof(data.pdu.rsp) + (data.count * sizeof(__le16)),
+		       &data.pdu);
 }
 
 void __l2cap_connect_rsp_defer(struct l2cap_chan *chan)
@@ -6078,6 +6118,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 		chan->ident = cmd->ident;
+		chan->mode = L2CAP_MODE_EXT_FLOWCTL;
 
 		if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 			l2cap_state_change(chan, BT_CONNECT2);
-- 
2.39.2



