Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB70928FA8A
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 23:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgJOVS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 17:18:58 -0400
Received: from aer-iport-3.cisco.com ([173.38.203.53]:53671 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOVS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 17:18:58 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 17:18:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=5129; q=dns/txt; s=iport;
  t=1602796737; x=1604006337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QKebK94YF5cEd86XgeWb7fUHb+MisaI7RKCCk0/pS8w=;
  b=e5nO3lIIP2QHFNeeoOxZcOV7V75Pgqv11lC8gpL7YzCj4KjSIgWWohdb
   13kNdlEWVJtx7eqr41I9awwDLVMqU4lDgkqfo7pwwcfKFIXxL8IpYYpu0
   5ZV1tUnAAVy7tNKJq6vni3nBEAVt6poTvXVB3ZvxiqFayu/u3vhEMZoa9
   8=;
X-IPAS-Result: =?us-ascii?q?A0DeBADcuohf/xbLJq1ghFOBdAEgEiyNP4gXnCYLAQEBD?=
 =?us-ascii?q?y8EAQGESoILJjgTAgMBAQEDAgMBAQEBBQEBAQIBBgRthWiFcgEBBCgLAUYFK?=
 =?us-ascii?q?4EhgltLgl0grE+BdTOKW4E4iDeEYQEyBoFBP4ERgmJsijQEkCUEp0+CdJpfD?=
 =?us-ascii?q?yKDFo9OjmaOSaU4gWsjgVdNIxU7gmlQGQ2OKxeOJj8DMAI2AgYKAQEDCY5IA?=
 =?us-ascii?q?QE?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.77,380,1596499200"; 
   d="scan'208";a="27953076"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Oct 2020 21:11:30 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.239])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09FLBSje020535;
        Thu, 15 Oct 2020 21:11:28 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: [v5.8/bluetooth PATCH] Bluetooth: Disconnect if E0 is used for Level 4
Date:   Thu, 15 Oct 2020 23:11:24 +0200
Message-Id: <20201015211124.1187822-1-hegtvedt@cisco.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.47.78.239, [10.47.78.239]
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

E0 is not allowed with Level 4:

BLUETOOTH CORE SPECIFICATION Version 5.2 | Vol 3, Part C page 1319:

  '128-bit equivalent strength for link and encryption keys
   required using FIPS approved algorithms (E0 not allowed,
   SAFER+ not allowed, and P-192 not allowed; encryption key
   not shortened'

SC enabled:

> HCI Event: Read Remote Extended Features (0x23) plen 13
        Status: Success (0x00)
        Handle: 256
        Page: 1/2
        Features: 0x0b 0x00 0x00 0x00 0x00 0x00 0x00 0x00
          Secure Simple Pairing (Host Support)
          LE Supported (Host)
          Secure Connections (Host Support)
> HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 256
        Encryption: Enabled with AES-CCM (0x02)

SC disabled:

> HCI Event: Read Remote Extended Features (0x23) plen 13
        Status: Success (0x00)
        Handle: 256
        Page: 1/2
        Features: 0x03 0x00 0x00 0x00 0x00 0x00 0x00 0x00
          Secure Simple Pairing (Host Support)
          LE Supported (Host)
> HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 256
        Encryption: Enabled with E0 (0x01)
[May 8 20:23] Bluetooth: hci0: Invalid security: expect AES but E0 was used
< HCI Command: Disconnect (0x01|0x0006) plen 3
        Handle: 256
        Reason: Authentication Failure (0x05)

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
(cherry picked from commit 8746f135bb01872ff412d408ea1aa9ebd328c1f5)
Cc: stable@vger.kernel.org # 5.8
---
 include/net/bluetooth/hci_core.h | 10 ++++++----
 net/bluetooth/hci_conn.c         | 17 +++++++++++++++++
 net/bluetooth/hci_event.c        | 20 ++++++++------------
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index da3728871e85..78970afa96f9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1402,11 +1402,13 @@ static inline void hci_encrypt_cfm(struct hci_conn *conn, __u8 status)
 	else
 		encrypt = 0x01;
 
-	if (conn->sec_level == BT_SECURITY_SDP)
-		conn->sec_level = BT_SECURITY_LOW;
+	if (!status) {
+		if (conn->sec_level == BT_SECURITY_SDP)
+			conn->sec_level = BT_SECURITY_LOW;
 
-	if (conn->pending_sec_level > conn->sec_level)
-		conn->sec_level = conn->pending_sec_level;
+		if (conn->pending_sec_level > conn->sec_level)
+			conn->sec_level = conn->pending_sec_level;
+	}
 
 	mutex_lock(&hci_cb_list_lock);
 	list_for_each_entry(cb, &hci_cb_list, list) {
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 307800fd18e6..b99b5c6de55a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1323,6 +1323,23 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
 			return 0;
 	}
 
+	 /* AES encryption is required for Level 4:
+	  *
+	  * BLUETOOTH CORE SPECIFICATION Version 5.2 | Vol 3, Part C
+	  * page 1319:
+	  *
+	  * 128-bit equivalent strength for link and encryption keys
+	  * required using FIPS approved algorithms (E0 not allowed,
+	  * SAFER+ not allowed, and P-192 not allowed; encryption key
+	  * not shortened)
+	  */
+	if (conn->sec_level == BT_SECURITY_FIPS &&
+	    !test_bit(HCI_CONN_AES_CCM, &conn->flags)) {
+		bt_dev_err(conn->hdev,
+			   "Invalid security: Missing AES-CCM usage");
+		return 0;
+	}
+
 	if (hci_conn_ssp_enabled(conn) &&
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		return 0;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6c6c9a81bee2..ff38f98988db 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3068,27 +3068,23 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 
+	/* Check link security requirements are met */
+	if (!hci_conn_check_link_mode(conn))
+		ev->status = HCI_ERROR_AUTH_FAILURE;
+
 	if (ev->status && conn->state == BT_CONNECTED) {
 		if (ev->status == HCI_ERROR_PIN_OR_KEY_MISSING)
 			set_bit(HCI_CONN_AUTH_FAILURE, &conn->flags);
 
+		/* Notify upper layers so they can cleanup before
+		 * disconnecting.
+		 */
+		hci_encrypt_cfm(conn, ev->status);
 		hci_disconnect(conn, HCI_ERROR_AUTH_FAILURE);
 		hci_conn_drop(conn);
 		goto unlock;
 	}
 
-	/* In Secure Connections Only mode, do not allow any connections
-	 * that are not encrypted with AES-CCM using a P-256 authenticated
-	 * combination key.
-	 */
-	if (hci_dev_test_flag(hdev, HCI_SC_ONLY) &&
-	    (!test_bit(HCI_CONN_AES_CCM, &conn->flags) ||
-	     conn->key_type != HCI_LK_AUTH_COMBINATION_P256)) {
-		hci_connect_cfm(conn, HCI_ERROR_AUTH_FAILURE);
-		hci_conn_drop(conn);
-		goto unlock;
-	}
-
 	/* Try reading the encryption key size for encrypted ACL links */
 	if (!ev->status && ev->encrypt && conn->type == ACL_LINK) {
 		struct hci_cp_read_enc_key_size cp;
-- 
2.27.0

