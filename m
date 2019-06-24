Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06942508D1
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbfFXKWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbfFXKWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:22:04 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159DC2146E;
        Mon, 24 Jun 2019 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371723;
        bh=vXxZdof0fj3EGo3Sl0TaM9lj10tLhaQcGMTDjVs0RdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSEQiSpnR1zbwi5BIkylSlDf7BgfOnz//hf0beUnH9obofYASLT5eV9dUm9lwlhnl
         NOahKRhmVrhFh+icIOItmlu/aR6Zf2luV7mNDYIzn+7+QWq+T68BxDT4MFZZIc1E4D
         g+cxwJfrMMRe9eRVusAp7lUzfRBw+VoscTBt1LH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 5.1 110/121] Bluetooth: Align minimum encryption key size for LE and BR/EDR connections
Date:   Mon, 24 Jun 2019 17:57:22 +0800
Message-Id: <20190624092326.298695374@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

commit d5bb334a8e171b262e48f378bd2096c0ea458265 upstream.

The minimum encryption key size for LE connections is 56 bits and to
align LE with BR/EDR, enforce 56 bits of minimum encryption key size for
BR/EDR connections as well.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci_core.h |    3 +++
 net/bluetooth/hci_conn.c         |    8 ++++++++
 2 files changed, 11 insertions(+)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -190,6 +190,9 @@ struct adv_info {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
+/* Min encryption key size to match with SMP */
+#define HCI_MIN_ENC_KEY_SIZE		7
+
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1276,6 +1276,14 @@ int hci_conn_check_link_mode(struct hci_
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		return 0;
 
+	/* The minimum encryption key size needs to be enforced by the
+	 * host stack before establishing any L2CAP connections. The
+	 * specification in theory allows a minimum of 1, but to align
+	 * BR/EDR and LE transports, a minimum of 7 is chosen.
+	 */
+	if (conn->enc_key_size < HCI_MIN_ENC_KEY_SIZE)
+		return 0;
+
 	return 1;
 }
 


