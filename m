Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D973F6709
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhHXRaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241178AbhHXR1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A07AA61B4B;
        Tue, 24 Aug 2021 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824711;
        bh=2h3ljlZYIBgNVEXjKt6mkgoIpaJorRhKoWLK5q6s3JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMmXKRaHb1Pigy8o+TrccUdIh+7V8j4YhsE1yQCxNpLwVnigmafUW/MipOWi3bwcE
         /n4Rq5SDZ+mA3WfbTf8Euyovth0G5Kd4wgaj2neTRBTjyChmvsYLgPMbm1mHkf0phB
         6G6BbYjE6ub5YEvH0HOIdHcO2MvPZd9Tj0YNLhKkmBk96dLqQF9QHRMLZyYuAtW/so
         sSnmMQT3qMdysTHs/rv6fgvZ2J4yezEqfP9EzIBADnt5gfQRqdpx+hRdvETRbaE9HV
         eQcxM0fNp2vOPIfSS/16n0YW506quAio4JUuN16yxZGi5q2QdEa7kx3CAQNNJ4ga5n
         sl+c+nqHwwJ6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takeshi Misawa <jeliantsurux@gmail.com>,
        syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/64] net: Fix memory leak in ieee802154_raw_deliver
Date:   Tue, 24 Aug 2021 13:04:06 -0400
Message-Id: <20210824170457.710623-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index e95004b507d3..9d46d9462129 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -985,6 +985,11 @@ static const struct proto_ops ieee802154_dgram_ops = {
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
@@ -1025,7 +1030,7 @@ static int ieee802154_create(struct net *net, struct socket *sock,
 	sock->ops = ops;
 
 	sock_init_data(sock, sk);
-	/* FIXME: sk->sk_destruct */
+	sk->sk_destruct = ieee802154_sock_destruct;
 	sk->sk_family = PF_IEEE802154;
 
 	/* Checksums on by default */
-- 
2.30.2

