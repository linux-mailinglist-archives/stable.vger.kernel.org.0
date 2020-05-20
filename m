Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8931DB669
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgETOYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:24:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33202 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPby-00037t-PB; Wed, 20 May 2020 15:22:22 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DUu-RY; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com,
        "Cong Wang" <xiyou.wangcong@gmail.com>
Date:   Wed, 20 May 2020 15:14:43 +0100
Message-ID: <lsq.1589984009.775927238@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 75/99] net_sched: ematch: reject invalid TCF_EM_SIMPLE
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 55cd9f67f1e45de8517cdaab985fb8e56c0bc1d8 upstream.

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
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/ematch.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -241,6 +241,9 @@ static int tcf_em_validate(struct tcf_pr
 			goto errout;
 
 		if (em->ops->change) {
+			err = -EINVAL;
+			if (em_hdr->flags & TCF_EM_SIMPLE)
+				goto errout;
 			err = em->ops->change(tp, data, data_len, em);
 			if (err < 0)
 				goto errout;

