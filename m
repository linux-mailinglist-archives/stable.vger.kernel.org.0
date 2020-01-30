Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B914E29D
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgA3SxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgA3Sls (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D95205F4;
        Thu, 30 Jan 2020 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409708;
        bh=Hs5PgR11akM00vuuaeTXEUHOa44riobDyTbwi8I4R5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifeRGb19uaIM0y9IFlyKMQz331MCBotl9wCMO41cPNQheoYERaehj17j/Pbf+btcQ
         Eu+dMJQYdZ+VRPO3aOnMvTLR3B4UYdSFvGdEr2AyhP34UFaz+ot08CocTRaY83+B4Q
         f1dsedUoqGqRhvrMNDNZVVg+QVnugrnSBU5lGJ34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 37/56] net_sched: ematch: reject invalid TCF_EM_SIMPLE
Date:   Thu, 30 Jan 2020 19:38:54 +0100
Message-Id: <20200130183615.700152415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55cd9f67f1e45de8517cdaab985fb8e56c0bc1d8 ]

It is possible for malicious userspace to set TCF_EM_SIMPLE bit
even for matches that should not have this bit set.

This can fool two places using tcf_em_is_simple()

1) tcf_em_tree_destroy() -> memory leak of em->data
   if ops->destroy() is NULL

2) tcf_em_tree_dump() wrongly report/leak 4 low-order bytes
   of a kernel pointer.

BUG: memory leak
unreferenced object 0xffff888121850a40 (size 32):
  comm "syz-executor927", pid 7193, jiffies 4294941655 (age 19.840s)
  hex dump (first 32 bytes):
    00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
    [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
    [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
    [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
    [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
    [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
    [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
    [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
    [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
    [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
    [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
    [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
    [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/ematch.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -238,6 +238,9 @@ static int tcf_em_validate(struct tcf_pr
 			goto errout;
 
 		if (em->ops->change) {
+			err = -EINVAL;
+			if (em_hdr->flags & TCF_EM_SIMPLE)
+				goto errout;
 			err = em->ops->change(net, data, data_len, em);
 			if (err < 0)
 				goto errout;


