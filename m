Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336286B4691
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjCJOoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjCJOny (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C709B101109
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 538C3618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A531C4339C;
        Fri, 10 Mar 2023 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459431;
        bh=673vXCtGS1xPmJCtJG0R0xisxCiwYt4Q7vdWp2HMpnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4vSN4E0qA/NhO8RG4BJzYRFogeakfTg3VZhAzrwzKlby5kyZ7ixQesyQDf6VFdLW
         VoR59TkKk8e37zGFyjHkxsshitI30FL6Rqyr54AlKKoor700So7ObMBLwON7BgfhRl
         dqy2hO5WedSVtQZuxosy2hZzLnIeXg6/LSera94I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nguyen Dinh Phi <phind.uet@gmail.com>,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.4 352/357] Bluetooth: hci_sock: purge socket queues in the destruct() callback
Date:   Fri, 10 Mar 2023 14:40:41 +0100
Message-Id: <20230310133750.194615125@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit 709fca500067524381e28a5f481882930eebac88 upstream.

The receive path may take the socket right before hci_sock_release(),
but it may enqueue the packets to the socket queues after the call to
skb_queue_purge(), therefore the socket can be destroyed without clear
its queues completely.

Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
issue, because nothing is referencing the socket at this point.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -881,10 +881,6 @@ static int hci_sock_release(struct socke
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -1985,6 +1981,12 @@ done:
 	return err;
 }
 
+static void hci_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_write_queue);
+}
+
 static const struct proto_ops hci_sock_ops = {
 	.family		= PF_BLUETOOTH,
 	.owner		= THIS_MODULE,
@@ -2035,6 +2037,7 @@ static int hci_sock_create(struct net *n
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;


