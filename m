Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C18290090
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405372AbgJPJHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405364AbgJPJHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:07:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B4620723;
        Fri, 16 Oct 2020 09:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839227;
        bh=2L2ux120QPGpyjx7XWQnUMBXMZB9iPPsakRROkyTTag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyXiTlG+XsSI6HcSTN+f6WCFmVX6roBo4n6sMMgoJXoplxLuD1RxqCs9TwCO7x7K0
         ZJj98ZlTjZ0xxn5lCXfoZ+z+kLugX5HXpnali6a6nH4fuC+K/visBrAlr0DhqiZIMJ
         bOIG6ZORzpZvAL0Ba23iIdNHRkjbUNeILPlxntKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.4 04/16] Bluetooth: Consolidate encryption handling in hci_encrypt_cfm
Date:   Fri, 16 Oct 2020 11:06:57 +0200
Message-Id: <20201016090435.646632869@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090435.423923738@linuxfoundation.org>
References: <20201016090435.423923738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 3ca44c16b0dcc764b641ee4ac226909f5c421aa3 upstream.

This makes hci_encrypt_cfm calls hci_connect_cfm in case the connection
state is BT_CONFIG so callers don't have to check the state.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci_core.h |   20 ++++++++++++++++++--
 net/bluetooth/hci_event.c        |   28 +++-------------------------
 2 files changed, 21 insertions(+), 27 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1235,10 +1235,26 @@ static inline void hci_auth_cfm(struct h
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
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2482,7 +2482,7 @@ static void hci_auth_complete_evt(struct
 				     &cp);
 		} else {
 			clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-			hci_encrypt_cfm(conn, ev->status, 0x00);
+			hci_encrypt_cfm(conn, ev->status);
 		}
 	}
 
@@ -2568,22 +2568,7 @@ static void read_enc_key_size_complete(s
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
@@ -2677,14 +2662,7 @@ static void hci_encrypt_change_evt(struc
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


