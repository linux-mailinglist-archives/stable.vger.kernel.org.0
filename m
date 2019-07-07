Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44B1616B9
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbfGGTl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57732 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727627AbfGGTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:13 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006kR-QD; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005e8-CD; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Ido Schimmel" <idosch@mellanox.com>,
        "Amit Cohen" <amitc@mellanox.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.691156682@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 097/129] ip6mr: Do not call __IP6_INC_STATS() from
 preemptible context
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@mellanox.com>

commit 87c11f1ddbbad38ad8bad47af133a8208985fbdf upstream.

Similar to commit 44f49dd8b5a6 ("ipmr: fix possible race resulting from
improper usage of IP_INC_STATS_BH() in preemptible context."), we cannot
assume preemption is disabled when incrementing the counter and
accessing a per-CPU variable.

Preemption can be enabled when we add a route in process context that
corresponds to packets stored in the unresolved queue, which are then
forwarded using this route [1].

Fix this by using IP6_INC_STATS() which takes care of disabling
preemption on architectures where it is needed.

[1]
[  157.451447] BUG: using __this_cpu_add() in preemptible [00000000] code: smcrouted/2314
[  157.460409] caller is ip6mr_forward2+0x73e/0x10e0
[  157.460434] CPU: 3 PID: 2314 Comm: smcrouted Not tainted 5.0.0-rc7-custom-03635-g22f2712113f1 #1336
[  157.460449] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
[  157.460461] Call Trace:
[  157.460486]  dump_stack+0xf9/0x1be
[  157.460553]  check_preemption_disabled+0x1d6/0x200
[  157.460576]  ip6mr_forward2+0x73e/0x10e0
[  157.460705]  ip6_mr_forward+0x9a0/0x1510
[  157.460771]  ip6mr_mfc_add+0x16b3/0x1e00
[  157.461155]  ip6_mroute_setsockopt+0x3cb/0x13c0
[  157.461384]  do_ipv6_setsockopt.isra.8+0x348/0x4060
[  157.462013]  ipv6_setsockopt+0x90/0x110
[  157.462036]  rawv6_setsockopt+0x4a/0x120
[  157.462058]  __sys_setsockopt+0x16b/0x340
[  157.462198]  __x64_sys_setsockopt+0xbf/0x160
[  157.462220]  do_syscall_64+0x14d/0x610
[  157.462349]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 0912ea38de61 ("[IPV6] MROUTE: Add stats in multicast routing module method ip6_mr_forward().")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6mr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1984,10 +1984,10 @@ int ip6mr_compat_ioctl(struct sock *sk,
 
 static inline int ip6mr_forward2_finish(struct sk_buff *skb)
 {
-	IP6_INC_STATS_BH(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
-			 IPSTATS_MIB_OUTFORWDATAGRAMS);
-	IP6_ADD_STATS_BH(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
-			 IPSTATS_MIB_OUTOCTETS, skb->len);
+	IP6_INC_STATS(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
+		      IPSTATS_MIB_OUTFORWDATAGRAMS);
+	IP6_ADD_STATS(dev_net(skb_dst(skb)->dev), ip6_dst_idev(skb_dst(skb)),
+		      IPSTATS_MIB_OUTOCTETS, skb->len);
 	return dst_output(skb);
 }
 

