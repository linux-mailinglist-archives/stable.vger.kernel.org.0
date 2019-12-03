Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905FF111F24
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfLCWo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbfLCWoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C0C20803;
        Tue,  3 Dec 2019 22:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413063;
        bh=0zXPUIf9Rf5yHaATyC1GslscThVCO1PZ9HvWuVX6T0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjVBN+fdUKzoo4LVh+NL8nwg11nJ+HL1Ms0Mn0dkv7nIa7/40g79Ql4Kwb3wDF8Wq
         IyNN7VthgXvSGqsrcu5ocx/lj6NSbOCmycHc0krSVpANFGJO1Ms9EPLicc6sRKTw9J
         HjwvMmM+w3ZhQ2bzFV1X/FFuRQ4cxXuNNf2GkN/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.3 119/135] sctp: cache netns in sctp_ep_common
Date:   Tue,  3 Dec 2019 23:35:59 +0100
Message-Id: <20191203213043.772105510@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 312434617cb16be5166316cf9d08ba760b1042a1 ]

This patch is to fix a data-race reported by syzbot:

  BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj

  write to 0xffff8880b67c0020 of 8 bytes by task 18908 on cpu 1:
    sctp_assoc_migrate+0x1a6/0x290 net/sctp/associola.c:1091
    sctp_sock_migrate+0x8aa/0x9b0 net/sctp/socket.c:9465
    sctp_accept+0x3c8/0x470 net/sctp/socket.c:4916
    inet_accept+0x7f/0x360 net/ipv4/af_inet.c:734
    __sys_accept4+0x224/0x430 net/socket.c:1754
    __do_sys_accept net/socket.c:1795 [inline]
    __se_sys_accept net/socket.c:1792 [inline]
    __x64_sys_accept+0x4e/0x60 net/socket.c:1792
    do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

  read to 0xffff8880b67c0020 of 8 bytes by task 12003 on cpu 0:
    sctp_hash_obj+0x4f/0x2d0 net/sctp/input.c:894
    rht_key_get_hash include/linux/rhashtable.h:133 [inline]
    rht_key_hashfn include/linux/rhashtable.h:159 [inline]
    rht_head_hashfn include/linux/rhashtable.h:174 [inline]
    head_hashfn lib/rhashtable.c:41 [inline]
    rhashtable_rehash_one lib/rhashtable.c:245 [inline]
    rhashtable_rehash_chain lib/rhashtable.c:276 [inline]
    rhashtable_rehash_table lib/rhashtable.c:316 [inline]
    rht_deferred_worker+0x468/0xab0 lib/rhashtable.c:420
    process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
    worker_thread+0xa0/0x800 kernel/workqueue.c:2415
    kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

It was caused by rhashtable access asoc->base.sk when sctp_assoc_migrate
is changing its value. However, what rhashtable wants is netns from asoc
base.sk, and for an asoc, its netns won't change once set. So we can
simply fix it by caching netns since created.

Fixes: d6c0256a60e6 ("sctp: add the rhashtable apis for sctp global transport hashtable")
Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/structs.h |    3 +++
 net/sctp/associola.c       |    1 +
 net/sctp/endpointola.c     |    1 +
 net/sctp/input.c           |    4 ++--
 4 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1239,6 +1239,9 @@ struct sctp_ep_common {
 	/* What socket does this endpoint belong to?  */
 	struct sock *sk;
 
+	/* Cache netns and it won't change once set */
+	struct net *net;
+
 	/* This is where we receive inbound chunks.  */
 	struct sctp_inq	  inqueue;
 
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -65,6 +65,7 @@ static struct sctp_association *sctp_ass
 	/* Discarding const is appropriate here.  */
 	asoc->ep = (struct sctp_endpoint *)ep;
 	asoc->base.sk = (struct sock *)sk;
+	asoc->base.net = sock_net(sk);
 
 	sctp_endpoint_hold(asoc->ep);
 	sock_hold(asoc->base.sk);
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -152,6 +152,7 @@ static struct sctp_endpoint *sctp_endpoi
 
 	/* Remember who we are attached to.  */
 	ep->base.sk = sk;
+	ep->base.net = sock_net(sk);
 	sock_hold(ep->base.sk);
 
 	return ep;
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -876,7 +876,7 @@ static inline int sctp_hash_cmp(struct r
 	if (!sctp_transport_hold(t))
 		return err;
 
-	if (!net_eq(sock_net(t->asoc->base.sk), x->net))
+	if (!net_eq(t->asoc->base.net, x->net))
 		goto out;
 	if (x->lport != htons(t->asoc->base.bind_addr.port))
 		goto out;
@@ -891,7 +891,7 @@ static inline __u32 sctp_hash_obj(const
 {
 	const struct sctp_transport *t = data;
 
-	return sctp_hashfn(sock_net(t->asoc->base.sk),
+	return sctp_hashfn(t->asoc->base.net,
 			   htons(t->asoc->base.bind_addr.port),
 			   &t->ipaddr, seed);
 }


