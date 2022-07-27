Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9AD582B18
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiG0Q1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiG0Q1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:27:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F0C4B0DB;
        Wed, 27 Jul 2022 09:24:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0027ACE2306;
        Wed, 27 Jul 2022 16:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA81C433D6;
        Wed, 27 Jul 2022 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939029;
        bh=AW5RXxI/zOyzH4BAEaTiesoBUF+TPpnxWXvCKwuUL9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Thm+8mgKYEjPYJwIFXdPofvtcXeAA7XF7fRdjdEmW232vJr6NM48g/jfJKElnYbbz
         fGMLizA57krEeSJBfqMfyiKUrMlg9xg9dT5Fl8i6gHKvq8OUCq8qCtRfEQLqwhJqdu
         8QnwUd2JGPGHuJQxhZYqCG6zrNpf4ETStxd96+2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.14 26/37] Bluetooth: SCO: Fix sco_send_frame returning skb->len
Date:   Wed, 27 Jul 2022 18:10:52 +0200
Message-Id: <20220727161001.905918967@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

commit 037ce005af6b8a3e40ee07c6e9266c8997e6a4d6 upstream.

The skb in modified by hci_send_sco which pushes SCO headers thus
changing skb->len causing sco_sock_sendmsg to fail.

Fixes: 0771cbb3b97d ("Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg")
Tested-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -282,16 +282,17 @@ static int sco_connect(struct hci_dev *h
 static int sco_send_frame(struct sock *sk, struct sk_buff *skb)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
+	int len = skb->len;
 
 	/* Check outgoing MTU */
-	if (skb->len > conn->mtu)
+	if (len > conn->mtu)
 		return -EINVAL;
 
-	BT_DBG("sk %p len %d", sk, skb->len);
+	BT_DBG("sk %p len %d", sk, len);
 
 	hci_send_sco(conn->hcon, skb);
 
-	return skb->len;
+	return len;
 }
 
 static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
@@ -732,7 +733,8 @@ static int sco_sock_sendmsg(struct socke
 		err = -ENOTCONN;
 
 	release_sock(sk);
-	if (err)
+
+	if (err < 0)
 		kfree_skb(skb);
 	return err;
 }


