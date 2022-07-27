Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCBC582B93
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiG0QfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiG0Qew (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A947F4F659;
        Wed, 27 Jul 2022 09:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77B9EB821BF;
        Wed, 27 Jul 2022 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23C7C433D6;
        Wed, 27 Jul 2022 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939201;
        bh=tS+ar2byvGXQkV54OvZ4Jwy6/JT/BUmN8BRsenhz6fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRQQp57W4DJp6oDKK+2WINwBFizrCB9DuEcxuwk1HHnm+ijMp6SN/X3iaMncEGers
         Um5LrRqFFwHeEkLLqjOw6VLePDW59Gq6yT9v7tX6zub78V/pa3aP0pCKObQxo3zOnZ
         HGnb9Kjj9a0kKk9aIxRiB+NHtsYo5RjdRxVPu4cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.19 47/62] Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
Date:   Wed, 27 Jul 2022 18:10:56 +0200
Message-Id: <20220727161005.976577904@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 0771cbb3b97d3c1d68eecd7f00055f599954c34e upstream.

This makes use of bt_skb_sendmsg instead of allocating a different
buffer to be used with memcpy_from_msg which cause one extra copy.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -279,27 +279,19 @@ static int sco_connect(struct hci_dev *h
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, void *buf, int len,
-			  unsigned int msg_flags)
+static int sco_send_frame(struct sock *sk, struct sk_buff *skb)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
-	struct sk_buff *skb;
-	int err;
 
 	/* Check outgoing MTU */
-	if (len > conn->mtu)
+	if (skb->len > conn->mtu)
 		return -EINVAL;
 
-	BT_DBG("sk %p len %d", sk, len);
-
-	skb = bt_skb_send_alloc(sk, len, msg_flags & MSG_DONTWAIT, &err);
-	if (!skb)
-		return err;
+	BT_DBG("sk %p len %d", sk, skb->len);
 
-	memcpy(skb_put(skb, len), buf, len);
 	hci_send_sco(conn->hcon, skb);
 
-	return len;
+	return skb->len;
 }
 
 static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
@@ -715,7 +707,7 @@ static int sco_sock_sendmsg(struct socke
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
-	void *buf;
+	struct sk_buff *skb;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -727,24 +719,20 @@ static int sco_sock_sendmsg(struct socke
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (memcpy_from_msg(buf, msg, len)) {
-		kfree(buf);
-		return -EFAULT;
-	}
+	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
+	if (IS_ERR_OR_NULL(skb))
+		return PTR_ERR(skb);
 
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECTED)
-		err = sco_send_frame(sk, buf, len, msg->msg_flags);
+		err = sco_send_frame(sk, skb);
 	else
 		err = -ENOTCONN;
 
 	release_sock(sk);
-	kfree(buf);
+	if (err)
+		kfree_skb(skb);
 	return err;
 }
 


