Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9E6ECF0F
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjDXNhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjDXNhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9740693DD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 463AA62415
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55938C433D2;
        Mon, 24 Apr 2023 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343423;
        bh=H679DEubx8698IukzNFuB3GEdAoJiuYjRCsCrGJwtz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/V/HjDQyKZvT7Zks8xrw8Yv53sPs3EVrJIghJQQPPxslVSEWyURrEZKRJ1GKJOAn
         oXbSG3nobmTvSkVNY79vbPvxmioc69VGXIRmbai37TxwOsp4HzaKH3yUquh+gEE0gc
         d164dPyYYIQqyxjSA+E9I+TG6UUfXgRS4a4DYGLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gwangun Jung <exsociety@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/28] net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg
Date:   Mon, 24 Apr 2023 15:18:23 +0200
Message-Id: <20230424131121.403819552@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwangun Jung <exsociety@gmail.com>

[ Upstream commit 3037933448f60f9acb705997eae62013ecb81e0d ]

If the TCA_QFQ_LMAX value is not offered through nlattr, lmax is determined by the MTU value of the network device.
The MTU of the loopback device can be set up to 2^31-1.
As a result, it is possible to have an lmax value that exceeds QFQ_MIN_LMAX.

Due to the invalid lmax value, an index is generated that exceeds the QFQ_MAX_INDEX(=24) value, causing out-of-bounds read/write errors.

The following reports a oob access:

[   84.582666] BUG: KASAN: slab-out-of-bounds in qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
[   84.583267] Read of size 4 at addr ffff88810f676948 by task ping/301
[   84.583686]
[   84.583797] CPU: 3 PID: 301 Comm: ping Not tainted 6.3.0-rc5 #1
[   84.584164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   84.584644] Call Trace:
[   84.584787]  <TASK>
[   84.584906] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
[   84.585108] print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
[   84.585570] kasan_report (mm/kasan/report.c:538)
[   84.585988] qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
[   84.586599] qfq_enqueue (net/sched/sch_qfq.c:1255)
[   84.587607] dev_qdisc_enqueue (net/core/dev.c:3776)
[   84.587749] __dev_queue_xmit (./include/net/sch_generic.h:186 net/core/dev.c:3865 net/core/dev.c:4212)
[   84.588763] ip_finish_output2 (./include/net/neighbour.h:546 net/ipv4/ip_output.c:228)
[   84.589460] ip_output (net/ipv4/ip_output.c:430)
[   84.590132] ip_push_pending_frames (./include/net/dst.h:444 net/ipv4/ip_output.c:126 net/ipv4/ip_output.c:1586 net/ipv4/ip_output.c:1606)
[   84.590285] raw_sendmsg (net/ipv4/raw.c:649)
[   84.591960] sock_sendmsg (net/socket.c:724 net/socket.c:747)
[   84.592084] __sys_sendto (net/socket.c:2142)
[   84.593306] __x64_sys_sendto (net/socket.c:2150)
[   84.593779] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[   84.593902] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[   84.594070] RIP: 0033:0x7fe568032066
[   84.594192] Code: 0e 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c09[ 84.594796] RSP: 002b:00007ffce388b4e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c

Code starting with the faulting instruction
===========================================
[   84.595047] RAX: ffffffffffffffda RBX: 00007ffce388cc70 RCX: 00007fe568032066
[   84.595281] RDX: 0000000000000040 RSI: 00005605fdad6d10 RDI: 0000000000000003
[   84.595515] RBP: 00005605fdad6d10 R08: 00007ffce388eeec R09: 0000000000000010
[   84.595749] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
[   84.595984] R13: 00007ffce388cc30 R14: 00007ffce388b4f0 R15: 0000001d00000001
[   84.596218]  </TASK>
[   84.596295]
[   84.596351] Allocated by task 291:
[   84.596467] kasan_save_stack (mm/kasan/common.c:46)
[   84.596597] kasan_set_track (mm/kasan/common.c:52)
[   84.596725] __kasan_kmalloc (mm/kasan/common.c:384)
[   84.596852] __kmalloc_node (./include/linux/kasan.h:196 mm/slab_common.c:967 mm/slab_common.c:974)
[   84.596979] qdisc_alloc (./include/linux/slab.h:610 ./include/linux/slab.h:731 net/sched/sch_generic.c:938)
[   84.597100] qdisc_create (net/sched/sch_api.c:1244)
[   84.597222] tc_modify_qdisc (net/sched/sch_api.c:1680)
[   84.597357] rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
[   84.597495] netlink_rcv_skb (net/netlink/af_netlink.c:2574)
[   84.597627] netlink_unicast (net/netlink/af_netlink.c:1340 net/netlink/af_netlink.c:1365)
[   84.597759] netlink_sendmsg (net/netlink/af_netlink.c:1942)
[   84.597891] sock_sendmsg (net/socket.c:724 net/socket.c:747)
[   84.598016] ____sys_sendmsg (net/socket.c:2501)
[   84.598147] ___sys_sendmsg (net/socket.c:2557)
[   84.598275] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:2586)
[   84.598399] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[   84.598520] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
[   84.598688]
[   84.598744] The buggy address belongs to the object at ffff88810f674000
[   84.598744]  which belongs to the cache kmalloc-8k of size 8192
[   84.599135] The buggy address is located 2664 bytes to the right of
[   84.599135]  allocated 7904-byte region [ffff88810f674000, ffff88810f675ee0)
[   84.599544]
[   84.599598] The buggy address belongs to the physical page:
[   84.599777] page:00000000e638567f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10f670
[   84.600074] head:00000000e638567f order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   84.600330] flags: 0x200000000010200(slab|head|node=0|zone=2)
[   84.600517] raw: 0200000000010200 ffff888100043180 dead000000000122 0000000000000000
[   84.600764] raw: 0000000000000000 0000000080020002 00000001ffffffff 0000000000000000
[   84.601009] page dumped because: kasan: bad access detected
[   84.601187]
[   84.601241] Memory state around the buggy address:
[   84.601396]  ffff88810f676800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.601620]  ffff88810f676880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.601845] >ffff88810f676900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602069]                                               ^
[   84.602243]  ffff88810f676980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602468]  ffff88810f676a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   84.602693] ==================================================================
[   84.602924] Disabling lock debugging due to kernel taint

Fixes: 3015f3d2a3cd ("pkt_sched: enable QFQ to support TSO/GSO")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: Gwangun Jung <exsociety@gmail.com>
Acked-by: Jamal Hadi Salim<jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 4701019768955..2832e16b6c2e1 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -432,15 +432,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	} else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
+	if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
+		pr_notice("qfq: invalid max length %u\n", lmax);
+		return -EINVAL;
+	}
+
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
 
-- 
2.39.2



