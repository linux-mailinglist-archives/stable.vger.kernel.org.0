Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA53628FA8D
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 23:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgJOVTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 17:19:41 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:13547 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOVTl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 17:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3072; q=dns/txt; s=iport;
  t=1602796780; x=1604006380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PNtbRP73E6eesRZXcmFFUegzFKee0Hjb+BIuVI2Hkv0=;
  b=l+o/9NKp0UBinMpwTi4KmzplgpY2pxEc3N3dCZYwN0NtaGVFNwGCEFY9
   ibmSSIxENbYSUYL/IIiS36045MnU3nB4sP7Ut9I9M6QIAo7chOzgurXZu
   axqzWHD82el175NyasLHAyEZWUSY6RkAOq+q2CjIXakAjTq5HWErgkLzg
   w=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BWBAD5uohf/xbLJq1ggliDbwEgEiy?=
 =?us-ascii?q?NP6Q+CwEBAQ8vBAEBhEqCCyY3Bg4CAwEBCwEBBQEBAQIBBgRthWiGIAsBRjC?=
 =?us-ascii?q?BIYMmgn2sT4F1M4pbgTiIN4RhMwaBQT+EX4UKhSoEkCmnT4J0ml8PIqFKLbN?=
 =?us-ascii?q?UgWokgVdNIxWDJFAZDY4rFxSOEj8DMAI2AgYKAQEDCY5IAQE?=
X-IronPort-AV: E=Sophos;i="5.77,380,1596499200"; 
   d="scan'208";a="30328710"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Oct 2020 21:12:06 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.239])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09FLC3V3020717;
        Thu, 15 Oct 2020 21:12:04 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: [v4.9..v5.4/bluetooth PATCH 1/3] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
Date:   Thu, 15 Oct 2020 23:12:00 +0200
Message-Id: <20201015211202.1188015-1-hegtvedt@cisco.com>
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
Cc: stable@vger.kernel.org # 4.9..5.4
---
 include/net/bluetooth/hci_core.h | 20 ++++++++++++++++++--
 net/bluetooth/hci_event.c        | 28 +++-------------------------
 2 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index b689aceb636b..ffd0eedd27ab 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1308,10 +1308,26 @@ static inline void hci_auth_cfm(struct hci_conn *conn, __u8 status)
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
index fd436e5d7b54..de4cce5f1bd8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2840,7 +2840,7 @@ static void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 				     &cp);
 		} else {
 			clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-			hci_encrypt_cfm(conn, ev->status, 0x00);
+			hci_encrypt_cfm(conn, ev->status);
 		}
 	}
 
@@ -2925,22 +2925,7 @@ static void read_enc_key_size_complete(struct hci_dev *hdev, u8 status,
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
@@ -3058,14 +3043,7 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
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

