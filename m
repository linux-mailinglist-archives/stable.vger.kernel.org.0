Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37536621528
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiKHOJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235117AbiKHOIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEF1BE08
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5C7D615B2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F8BC433C1;
        Tue,  8 Nov 2022 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916529;
        bh=UE4FPLP+wxzXZo5gWrANmyzgkxPCvjHQa1eHx3z2scQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcmFQlMs2LQB7AQQyDFC/vdZwBbX9BNSDkI+i3H0pKIoqLhn7puLDh3K/DNPVJv+G
         xsW82mhamFDcOepjKq/u/dGLd3CtcRYdkqXbzzUK47Cdy11AHnOStQUJjx9RHQsdFo
         HwjFNBbDkWtjp4m+ddwlKAEVWSo62GLoNRM8Qxyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pauli Virtanen <pav@iki.fi>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/197] Bluetooth: hci_conn: Fix CIS connection dst_type handling
Date:   Tue,  8 Nov 2022 14:38:08 +0100
Message-Id: <20221108133357.097561914@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit b36a234dc438cb6b76fc929a8df9a0e59c8acf23 ]

hci_connect_cis and iso_connect_cis call hci_bind_cis inconsistently
with dst_type being either ISO socket address type or the HCI type, but
these values cannot be mixed like this. Fix this by using only the HCI
type.

CIS connection dst_type was also not initialized in hci_bind_cis, even
though it is used in hci_conn_hash_lookup_cis to find existing
connections.  Set the value in hci_bind_cis, so that existing CIS
connections are found e.g. when doing deferred socket connections, also
when dst_type is not 0 (ADDR_LE_DEV_PUBLIC).

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c |  7 +------
 net/bluetooth/iso.c      | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 9777e7b109ee..f1263cdd71dd 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1697,6 +1697,7 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 		if (!cis)
 			return ERR_PTR(-ENOMEM);
 		cis->cleanup = cis_cleanup;
+		cis->dst_type = dst_type;
 	}
 
 	if (cis->state == BT_CONNECTED)
@@ -2076,12 +2077,6 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	struct hci_conn *le;
 	struct hci_conn *cis;
 
-	/* Convert from ISO socket address type to HCI address type  */
-	if (dst_type == BDADDR_LE_PUBLIC)
-		dst_type = ADDR_LE_DEV_PUBLIC;
-	else
-		dst_type = ADDR_LE_DEV_RANDOM;
-
 	if (hci_dev_test_flag(hdev, HCI_ADVERTISING))
 		le = hci_connect_le(hdev, dst, dst_type, false,
 				    BT_SECURITY_LOW,
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 613039ba5dbf..f825857db6d0 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -235,6 +235,14 @@ static int iso_chan_add(struct iso_conn *conn, struct sock *sk,
 	return err;
 }
 
+static inline u8 le_addr_type(u8 bdaddr_type)
+{
+	if (bdaddr_type == BDADDR_LE_PUBLIC)
+		return ADDR_LE_DEV_PUBLIC;
+	else
+		return ADDR_LE_DEV_RANDOM;
+}
+
 static int iso_connect_bis(struct sock *sk)
 {
 	struct iso_conn *conn;
@@ -328,14 +336,16 @@ static int iso_connect_cis(struct sock *sk)
 	/* Just bind if DEFER_SETUP has been set */
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hcon = hci_bind_cis(hdev, &iso_pi(sk)->dst,
-				    iso_pi(sk)->dst_type, &iso_pi(sk)->qos);
+				    le_addr_type(iso_pi(sk)->dst_type),
+				    &iso_pi(sk)->qos);
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto done;
 		}
 	} else {
 		hcon = hci_connect_cis(hdev, &iso_pi(sk)->dst,
-				       iso_pi(sk)->dst_type, &iso_pi(sk)->qos);
+				       le_addr_type(iso_pi(sk)->dst_type),
+				       &iso_pi(sk)->qos);
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto done;
-- 
2.35.1



