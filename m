Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463B75068A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfFXJ7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 05:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfFXJ7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 05:59:25 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48888205ED;
        Mon, 24 Jun 2019 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370363;
        bh=o5lqBtLUiFv/iq/u1s40v6Xuha8XP3zaolDZQOU/YPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfwnCAcOGQXI6/wcM+ZGmxaNx55mdLLgeUfieoUYPGFU4VE1hPqRvJvrSN2DR2X53
         zQ35V3Wi5/sFjEQA6HysTEYb3PXkQ26tgZJtV+9V/OAJ6Zct0uZxRKNLvd8yPjksGl
         oV2x7GUEecdNmxuapVrcmjF1Uxc6i3isjOIZIl3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 46/51] Bluetooth: Fix regression with minimum encryption key size alignment
Date:   Mon, 24 Jun 2019 17:57:04 +0800
Message-Id: <20190624092311.200143589@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092305.919204959@linuxfoundation.org>
References: <20190624092305.919204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c   |   18 +++++++++---------
 net/bluetooth/l2cap_core.c |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 14 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1165,14 +1165,6 @@ int hci_conn_check_link_mode(struct hci_
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
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
 
@@ -1289,8 +1281,16 @@ auth:
 		return 0;
 
 encrypt:
-	if (test_bit(HCI_CONN_ENCRYPT, &conn->flags))
+	if (test_bit(HCI_CONN_ENCRYPT, &conn->flags)) {
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
@@ -1340,6 +1340,21 @@ static void l2cap_request_info(struct l2
 		       sizeof(req), &req);
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
+	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
+		hcon->enc_key_size > HCI_MIN_ENC_KEY_SIZE);
+}
+
 static void l2cap_do_start(struct l2cap_chan *chan)
 {
 	struct l2cap_conn *conn = chan->conn;
@@ -1357,9 +1372,14 @@ static void l2cap_do_start(struct l2cap_
 	if (!(conn->info_state & L2CAP_INFO_FEAT_MASK_REQ_DONE))
 		return;
 
-	if (l2cap_chan_check_security(chan, true) &&
-	    __l2cap_no_conn_pending(chan))
+	if (!l2cap_chan_check_security(chan, true) ||
+	    !__l2cap_no_conn_pending(chan))
+		return;
+
+	if (l2cap_check_enc_key_size(conn->hcon))
 		l2cap_start_connection(chan);
+	else
+		__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
 }
 
 static inline int l2cap_mode_supported(__u8 mode, __u32 feat_mask)
@@ -1438,7 +1458,10 @@ static void l2cap_conn_start(struct l2ca
 				continue;
 			}
 
-			l2cap_start_connection(chan);
+			if (l2cap_check_enc_key_size(conn->hcon))
+				l2cap_start_connection(chan);
+			else
+				l2cap_chan_close(chan, ECONNREFUSED);
 
 		} else if (chan->state == BT_CONNECT2) {
 			struct l2cap_conn_rsp rsp;
@@ -7455,7 +7478,7 @@ static void l2cap_security_cfm(struct hc
 		}
 
 		if (chan->state == BT_CONNECT) {
-			if (!status)
+			if (!status && l2cap_check_enc_key_size(hcon))
 				l2cap_start_connection(chan);
 			else
 				__set_chan_timer(chan, L2CAP_DISC_TIMEOUT);
@@ -7464,7 +7487,7 @@ static void l2cap_security_cfm(struct hc
 			struct l2cap_conn_rsp rsp;
 			__u16 res, stat;
 
-			if (!status) {
+			if (!status && l2cap_check_enc_key_size(hcon)) {
 				if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 					res = L2CAP_CR_PEND;
 					stat = L2CAP_CS_AUTHOR_PEND;


