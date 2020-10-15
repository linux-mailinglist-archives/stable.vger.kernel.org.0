Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B458928FA8F
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgJOVTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 17:19:43 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:13547 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOVTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 17:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3067; q=dns/txt; s=iport;
  t=1602796782; x=1604006382;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lH6jrHLM2LX3foBPwgTy4DW20QBSCwznVHa81qFZOuI=;
  b=mFYQnfnEJmsiQEWFcMCYcrlsPunXm4zZpI1KjAo7tglt+dzpiZSQSoJ+
   O4AVJdRndiWAzCJ3grCwJHE/9vfc2jtlaCWTm1yORTcAXkuW7MQM1gbSV
   VkSHHvSCHGJJdzatzKwoaA9wYcqM9qhC6gR16QhUJvadNUyhakWTjN5sw
   w=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DSBAD5uohf/xbLJq1ghkcBIBIsjT+?=
 =?us-ascii?q?kPgsBAQEPLwQBAYRKggsmOBMCAwEBCwEBBQEBAQIBBgRthWiGIAsBRjCBIYM?=
 =?us-ascii?q?mgn2sT4F1M4pbgTiIN4RhMwaBQT+EX4UKhSoEkCmnT4J0ml8PIqFKLbNUgWs?=
 =?us-ascii?q?jgVdNIxWDJFAZDY4rFxSOEj8DMAI2AgYKAQEDCY5IAQE?=
X-IronPort-AV: E=Sophos;i="5.77,380,1596499200"; 
   d="scan'208";a="30328712"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Oct 2020 21:12:29 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.239])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09FLCTWS020769;
        Thu, 15 Oct 2020 21:12:29 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: [v4.4/bluetooth PATCH 1/3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
Date:   Thu, 15 Oct 2020 23:12:23 +0200
Message-Id: <20201015211225.1188104-1-hegtvedt@cisco.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.47.78.239, [10.47.78.239]
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This makes hci_encrypt_cfm calls hci_connect_cfm in case the connection
state is BT_CONFIG so callers don't have to check the state.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
(cherry picked from commit 3ca44c16b0dcc764b641ee4ac226909f5c421aa3)
Cc: stable@vger.kernel.org # 4.4
---
 include/net/bluetooth/hci_core.h | 20 ++++++++++++++++++--
 net/bluetooth/hci_event.c        | 28 +++-------------------------
 2 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 7c0c83dfe86e..0269a772bfe1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1235,10 +1235,26 @@ static inline void hci_auth_cfm(struct hci_conn *conn, __u8 status)
 		conn->security_cfm_cb(conn, status);
 }
 
-static inline void hci_encrypt_cfm(struct hci_conn *conn, __u8 status,
-								__u8 encrypt)
+static inline void hci_encrypt_cfm(struct hci_conn *conn, __u8 status)
 {
 	struct hci_cb *cb;
+	__u8 encrypt;
+
+	if (conn->state == BT_CONFIG) {
+		if (status)
+			conn->state = BT_CONNECTED;
+
+		hci_connect_cfm(conn, status);
+		hci_conn_drop(conn);
+		return;
+	}
+
+	if (!test_bit(HCI_CONN_ENCRYPT, &conn->flags))
+		encrypt = 0x00;
+	else if (test_bit(HCI_CONN_AES_CCM, &conn->flags))
+		encrypt = 0x02;
+	else
+		encrypt = 0x01;
 
 	if (conn->sec_level == BT_SECURITY_SDP)
 		conn->sec_level = BT_SECURITY_LOW;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 03319ab8a7c6..bb9c13506bca 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2479,7 +2479,7 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 				     &cp);
 		} else {
 			clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-			hci_encrypt_cfm(conn, ev->status, 0x00);
+			hci_encrypt_cfm(conn, ev->status);
 		}
 	}
 
@@ -2565,22 +2565,7 @@ static void read_enc_key_size_complete(struct hci_dev *hdev, u8 status,
 		conn->enc_key_size = rp->key_size;
 	}
 
-	if (conn->state == BT_CONFIG) {
-		conn->state = BT_CONNECTED;
-		hci_connect_cfm(conn, 0);
-		hci_conn_drop(conn);
-	} else {
-		u8 encrypt;
-
-		if (!test_bit(HCI_CONN_ENCRYPT, &conn->flags))
-			encrypt = 0x00;
-		else if (test_bit(HCI_CONN_AES_CCM, &conn->flags))
-			encrypt = 0x02;
-		else
-			encrypt = 0x01;
-
-		hci_encrypt_cfm(conn, 0, encrypt);
-	}
+	hci_encrypt_cfm(conn, 0);
 
 unlock:
 	hci_dev_unlock(hdev);
@@ -2674,14 +2659,7 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	}
 
 notify:
-	if (conn->state == BT_CONFIG) {
-		if (!ev->status)
-			conn->state = BT_CONNECTED;
-
-		hci_connect_cfm(conn, ev->status);
-		hci_conn_drop(conn);
-	} else
-		hci_encrypt_cfm(conn, ev->status, ev->encrypt);
+	hci_encrypt_cfm(conn, ev->status);
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
2.27.0

