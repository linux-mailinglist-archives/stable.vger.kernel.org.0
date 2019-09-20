Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D66B91C0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbfITOZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36962 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388421AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-0004y5-Ot; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sz-HB; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Marcel Holtmann" <marcel@holtmann.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.829214272@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 055/132] Bluetooth: Fix regression with minimum
 encryption key size alignment
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 693cd8ce3f882524a5d06f7800dd8492411877b3 upstream.

When trying to align the minimum encryption key size requirement for
Bluetooth connections, it turns out doing this in a central location in
the HCI connection handling code is not possible.

Original Bluetooth version up to 2.0 used a security model where the
L2CAP service would enforce authentication and encryption.  Starting
with Bluetooth 2.1 and Secure Simple Pairing that model has changed into
that the connection initiator is responsible for providing an encrypted
ACL link before any L2CAP communication can happen.

Now connecting Bluetooth 2.1 or later devices with Bluetooth 2.0 and
before devices are causing a regression.  The encryption key size check
needs to be moved out of the HCI connection handling into the L2CAP
channel setup.

To achieve this, the current check inside hci_conn_security() has been
moved into l2cap_check_enc_key_size() helper function and then called
from four decisions point inside L2CAP to cover all combinations of
Secure Simple Pairing enabled devices and device using legacy pairing
and legacy service security model.

Fixes: d5bb334a8e17 ("Bluetooth: Align minimum encryption key size for LE and BR/EDR connections")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203643
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16:
 - Encryption flag is in hci_conn::link_mode not hci_conn::flags
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hci_conn.c   | 18 +++++++++---------
 net/bluetooth/l2cap_core.c | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 14 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -868,14 +868,6 @@ int hci_conn_check_link_mode(struct hci_
 	if (hci_conn_ssp_enabled(conn) && !(conn->link_mode & HCI_LM_ENCRYPT))
 		return 0;
 
-	/* The minimum encryption key size needs to be enforced by the
-	 * host stack before establishing any L2CAP connections. The
-	 * specification in theory allows a minimum of 1, but to align
-	 * BR/EDR and LE transports, a minimum of 7 is chosen.
-	 */
-	if (conn->enc_key_size < HCI_MIN_ENC_KEY_SIZE)
-		return 0;
-
 	return 1;
 }
 
@@ -988,8 +980,16 @@ auth:
 		return 0;
 
 encrypt:
-	if (conn->link_mode & HCI_LM_ENCRYPT)
+	if (conn->link_mode & HCI_LM_ENCRYPT) {
+		/* Ensure that the encryption key size has been read,
+		 * otherwise stall the upper layer responses.
+		 */
+		if (!conn->enc_key_size)
+			return 0;
+
+		/* Nothing else needed, all requirements are met */
 		return 1;
+	}
 
 	hci_conn_encrypt(conn);
 	return 0;
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1260,6 +1260,21 @@ static void l2cap_start_connection(struc
 	}
 }
 
+static bool l2cap_check_enc_key_size(struct hci_conn *hcon)
+{
+	/* The minimum encryption key size needs to be enforced by the
+	 * host stack before establishing any L2CAP connections. The
+	 * specification in theory allows a minimum of 1, but to align
+	 * BR/EDR and LE transports, a minimum of 7 is chosen.
+	 *
+	 * This check might also be called for unencrypted connections
+	 * that have no key size requirements. Ensure that the link is
+	 * actually encrypted before enforcing a key size.
+	 */
+	return (!(hcon->link_mode & HCI_LM_ENCRYPT) ||
+		hcon->enc_key_size > HCI_MIN_ENC_KEY_SIZE);
+}
+
 static void l2cap_do_start(struct l2cap_chan *chan)
 {
 	struct l2cap_conn *conn = chan->conn;
@@ -1273,10 +1288,14 @@ static void l2cap_do_start(struct l2cap_
 		if (!(conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_DONE))
 			return;
 
-		if (l2cap_chan_check_security(chan) &&
-		    __l2cap_no_conn_pending(chan)) {
+		if (!l2cap_chan_check_security(chan) ||
+		    !__l2cap_no_conn_pending(chan))
+			return;
+
+		if (l2cap_check_enc_key_size(conn->hcon))
 			l2cap_start_connection(chan);
-		}
+		else
+			__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 	} else {
 		struct l2cap_info_req req;
 		req.type = cpu_to_le16(L2CAP_IT_FEAT_MASK);
@@ -1366,7 +1385,10 @@ static void l2cap_conn_start(struct l2ca
 				continue;
 			}
 
-			l2cap_start_connection(chan);
+			if (l2cap_check_enc_key_size(conn->hcon))
+				l2cap_start_connection(chan);
+			else
+				l2cap_chan_close(chan, ECONNREFUSED);
 
 		} else if (chan->state == BT_CONNECT2) {
 			struct l2cap_conn_rsp rsp;
@@ -7352,7 +7374,7 @@ int l2cap_security_cfm(struct hci_conn *
 		}
 
 		if (chan->state == BT_CONNECT) {
-			if (!status)
+			if (!status && l2cap_check_enc_key_size(hcon))
 				l2cap_start_connection(chan);
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -7360,7 +7382,7 @@ int l2cap_security_cfm(struct hci_conn *
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
 
-			if (!status) {
+			if (!status && l2cap_check_enc_key_size(hcon)) {
 				if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 					res = L2CAP_CR_PEND;
 					stat = L2CAP_CS_AUTHOR_PEND;

