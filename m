Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F190C3ED4A8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhHPNEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236768AbhHPNEe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBEB6328A;
        Mon, 16 Aug 2021 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119043;
        bh=YGtMbfjORPfjlB78Z8Qlceb7qSGvJTYSJdT83oe9c1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFh7DBsxOFjY55NSv5Ke7Xrtdz3IplWQDUtmVKrwbhi+2YgZfywFshq8d6UBvOHWA
         7Zum8l/yqXNGVN54GbwfRCvzY6iHeRCo62EBKmCSYFn/v8siRBqD+MYgvHdv+Pf645
         gif00RUHXYChfBpputmUpdAZOs4imryocWpbHz1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takeshi Misawa <jeliantsurux@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com
Subject: [PATCH 5.4 29/62] net: Fix memory leak in ieee802154_raw_deliver
Date:   Mon, 16 Aug 2021 15:02:01 +0200
Message-Id: <20210816125429.200225285@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>

[ Upstream commit 1090340f7ee53e824fd4eef66a4855d548110c5b ]

If IEEE-802.15.4-RAW is closed before receive skb, skb is leaked.
Fix this, by freeing sk_receive_queue in sk->sk_destruct().

syzbot report:
BUG: memory leak
unreferenced object 0xffff88810f644600 (size 232):
  comm "softirq", pid 0, jiffies 4294967032 (age 81.270s)
  hex dump (first 32 bytes):
    10 7d 4b 12 81 88 ff ff 10 7d 4b 12 81 88 ff ff  .}K......}K.....
    00 00 00 00 00 00 00 00 40 7c 4b 12 81 88 ff ff  ........@|K.....
  backtrace:
    [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
    [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
    [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
    [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
    [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
    [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
    [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
    [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
    [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
    [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
    [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
    [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
    [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
    [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
    [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
    [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
    [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
    [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
    [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
    [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
    [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
    [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
    [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
    [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
    [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985

Fixes: 9ec767160357 ("net: add IEEE 802.15.4 socket family implementation")
Reported-and-tested-by: syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210805075414.GA15796@DESKTOP
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/socket.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index d93d4531aa9b..9a675ba0bf0a 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -992,6 +992,11 @@ static const struct proto_ops ieee802154_dgram_ops = {
 #endif
 };
 
+static void ieee802154_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+}
+
 /* Create a socket. Initialise the socket, blank the addresses
  * set the state.
  */
@@ -1032,7 +1037,7 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 	sock->ops = ops;
 
 	sock_init_data(sock, sk);
-	/* FIXME: sk->sk_destruct */
+	sk->sk_destruct = ieee802154_sock_destruct;
 	sk->sk_family = PF_IEEE802154;
 
 	/* Checksums on by default */
-- 
2.30.2



