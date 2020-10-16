Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64ED52900B6
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405479AbgJPJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394946AbgJPJIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:08:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A47A820872;
        Fri, 16 Oct 2020 09:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839283;
        bh=Ocuw6KufdcBtV6Q4Fl8ffU5fNhkL91RKlvDIOaKuLdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPtPC8r48mlpoBbN9m9lpR/4Z5I33wQk3SP+r2P6u2f6SlN+7ac6nG1KNJweQsILd
         jqZQyfpr787UnpRfz6NHaiPHGQ4EQqck/VwfOOMMzY7LbRtlK8q0YA2sUjrnXN04oc
         k2isUKoOaWhiBjrCjxvIp6rMjUuyYBFXIQkFORr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.9 07/16] Bluetooth: Disconnect if E0 is used for Level 4
Date:   Fri, 16 Oct 2020 11:07:11 +0200
Message-Id: <20201016090437.581507022@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.205626543@linuxfoundation.org>
References: <20201016090437.205626543@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 8746f135bb01872ff412d408ea1aa9ebd328c1f5 upstream.

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
Cc: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci_core.h |   10 ++++++----
 net/bluetooth/hci_conn.c         |   17 +++++++++++++++++
 net/bluetooth/hci_event.c        |   20 ++++++++------------
 3 files changed, 31 insertions(+), 16 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1271,11 +1271,13 @@ static inline void hci_encrypt_cfm(struc
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
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1163,6 +1163,23 @@ int hci_conn_check_link_mode(struct hci_
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
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2626,26 +2626,22 @@ static void hci_encrypt_change_evt(struc
 
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
-
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
 
 	/* Try reading the encryption key size for encrypted ACL links */
 	if (!ev->status && ev->encrypt && conn->type == ACL_LINK) {


