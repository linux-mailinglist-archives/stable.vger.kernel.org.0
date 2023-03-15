Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0363D6BB0F2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjCOMXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjCOMW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:22:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29AA9008B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8271061D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94295C433EF;
        Wed, 15 Mar 2023 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882903;
        bh=hB/5EUj0iTww9sDBBTdjFB80M1DxbE1yIRDYrdKA2gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUyC4F3YJJ/3pzxE6NTL3ghshO8+mJy+fb7itPSxi8bkxaxypig+OsoWsXf/dbHhh
         Q/9lqfznZnoSv6v00yycj3naIOq2E4eIHtDPokfG6vIWPSrcZXaENgO/MkDShlwlj4
         DLweX2uPiSUKrTvlJ3lahwZeB+Hwhy6sElrsZMk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/104] ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
Date:   Wed, 15 Mar 2023 13:12:09 +0100
Message-Id: <20230315115733.594088933@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 693aa2c0d9b6d5b1f2745d31b6e70d09dbbaf06e ]

ila_xlat_nl_cmd_get_mapping() generates an empty skb,
triggerring a recent sanity check [1].

Instead, return an error code, so that user space
can get it.

[1]
skb_assert_len
WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 skb_assert_len include/linux/skbuff.h:2527 [inline]
WARNING: CPU: 0 PID: 5923 at include/linux/skbuff.h:2527 __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
Modules linked in:
CPU: 0 PID: 5923 Comm: syz-executor269 Not tainted 6.2.0-syzkaller-18300-g2ebd1fbb946d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_assert_len include/linux/skbuff.h:2527 [inline]
pc : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
lr : skb_assert_len include/linux/skbuff.h:2527 [inline]
lr : __dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
sp : ffff80001e0d6c40
x29: ffff80001e0d6e60 x28: dfff800000000000 x27: ffff0000c86328c0
x26: dfff800000000000 x25: ffff0000c8632990 x24: ffff0000c8632a00
x23: 0000000000000000 x22: 1fffe000190c6542 x21: ffff0000c8632a10
x20: ffff0000c8632a00 x19: ffff80001856e000 x18: ffff80001e0d5fc0
x17: 0000000000000000 x16: ffff80001235d16c x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
x11: ff80800008353a30 x10: 0000000000000000 x9 : 21567eaf25bfb600
x8 : 21567eaf25bfb600 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80001e0d6558 x4 : ffff800015c74760 x3 : ffff800008596744
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000000e
Call trace:
skb_assert_len include/linux/skbuff.h:2527 [inline]
__dev_queue_xmit+0x1bc0/0x3488 net/core/dev.c:4156
dev_queue_xmit include/linux/netdevice.h:3033 [inline]
__netlink_deliver_tap_skb net/netlink/af_netlink.c:307 [inline]
__netlink_deliver_tap+0x45c/0x6f8 net/netlink/af_netlink.c:325
netlink_deliver_tap+0xf4/0x174 net/netlink/af_netlink.c:338
__netlink_sendskb net/netlink/af_netlink.c:1283 [inline]
netlink_sendskb+0x6c/0x154 net/netlink/af_netlink.c:1292
netlink_unicast+0x334/0x8d4 net/netlink/af_netlink.c:1380
nlmsg_unicast include/net/netlink.h:1099 [inline]
genlmsg_unicast include/net/genetlink.h:433 [inline]
genlmsg_reply include/net/genetlink.h:443 [inline]
ila_xlat_nl_cmd_get_mapping+0x620/0x7d0 net/ipv6/ila/ila_xlat.c:493
genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
genl_rcv_msg+0x938/0xc1c net/netlink/genetlink.c:1065
netlink_rcv_skb+0x214/0x3c4 net/netlink/af_netlink.c:2574
genl_rcv+0x38/0x50 net/netlink/genetlink.c:1076
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x660/0x8d4 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x800/0xae0 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0x558/0x844 net/socket.c:2479
___sys_sendmsg net/socket.c:2533 [inline]
__sys_sendmsg+0x26c/0x33c net/socket.c:2562
__do_sys_sendmsg net/socket.c:2571 [inline]
__se_sys_sendmsg net/socket.c:2569 [inline]
__arm64_sys_sendmsg+0x80/0x94 net/socket.c:2569
__invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
irq event stamp: 136484
hardirqs last enabled at (136483): [<ffff800008350244>] __up_console_sem+0x60/0xb4 kernel/printk/printk.c:345
hardirqs last disabled at (136484): [<ffff800012358d60>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last enabled at (136418): [<ffff800008020ea8>] softirq_handle_end kernel/softirq.c:414 [inline]
softirqs last enabled at (136418): [<ffff800008020ea8>] __do_softirq+0xd4c/0xfa4 kernel/softirq.c:600
softirqs last disabled at (136371): [<ffff80000802b4a4>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
skb len=0 headroom=0 headlen=0 tailroom=192
mac=(0,0) net=(0,-1) trans=-1
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0010 pkttype=6 iif=0
dev name=nlmon0 feat=0x0000000000005861

Fixes: 7f00feaf1076 ("ila: Add generic ILA translation facility")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_xlat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index a1ac0e3d8c60c..163668531a57f 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -477,6 +477,7 @@ int ila_xlat_nl_cmd_get_mapping(struct sk_buff *skb, struct genl_info *info)
 
 	rcu_read_lock();
 
+	ret = -ESRCH;
 	ila = ila_lookup_by_params(&xp, ilan);
 	if (ila) {
 		ret = ila_dump_info(ila,
-- 
2.39.2



