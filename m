Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCEF103F53
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfKTPnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52868 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730320AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004az-BB; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Kq-Or; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "syzbot" <syzkaller@googlegroups.com>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Wed, 20 Nov 2019 15:38:09 +0000
Message-ID: <lsq.1574264230.717832959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 59/83] mld: fix memory leak in mld_del_delrec()
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a84d016479896b5526a2cc54784e6ffc41c9d6f6 upstream.

Similar to the fix done for IPv4 in commit e5b1c6c6277d
("igmp: fix memory leak in igmpv3_del_delrec()"), we need to
make sure mca_tomb and mca_sources are not blindly overwritten.

Using swap() then a call to ip6_mc_clear_src() will take care
of the missing free.

BUG: memory leak
unreferenced object 0xffff888117d9db00 (size 64):
  comm "syz-executor247", pid 6918, jiffies 4294943989 (age 25.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 fe 88 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000005b463030>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<000000005b463030>] slab_post_alloc_hook mm/slab.h:522 [inline]
    [<000000005b463030>] slab_alloc mm/slab.c:3319 [inline]
    [<000000005b463030>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
    [<00000000939cbf94>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000939cbf94>] kzalloc include/linux/slab.h:748 [inline]
    [<00000000939cbf94>] ip6_mc_add1_src net/ipv6/mcast.c:2236 [inline]
    [<00000000939cbf94>] ip6_mc_add_src+0x31f/0x420 net/ipv6/mcast.c:2356
    [<00000000d8972221>] ip6_mc_source+0x4a8/0x600 net/ipv6/mcast.c:449
    [<000000002b203d0d>] do_ipv6_setsockopt.isra.0+0x1b92/0x1dd0 net/ipv6/ipv6_sockglue.c:748
    [<000000001f1e2d54>] ipv6_setsockopt+0x89/0xd0 net/ipv6/ipv6_sockglue.c:944
    [<00000000c8f7bdf9>] udpv6_setsockopt+0x4e/0x90 net/ipv6/udp.c:1558
    [<000000005a9a0c5e>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3139
    [<00000000910b37b2>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
    [<00000000e9108023>] __do_sys_setsockopt net/socket.c:2100 [inline]
    [<00000000e9108023>] __se_sys_setsockopt net/socket.c:2097 [inline]
    [<00000000e9108023>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
    [<00000000f4818160>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<000000008d367e8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/mcast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -807,12 +807,13 @@ static void mld_del_delrec(struct inet6_
 		im->idev = pmc->idev;
 		im->mca_crcount = idev->mc_qrv;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
-			im->mca_tomb = pmc->mca_tomb;
-			im->mca_sources = pmc->mca_sources;
+			swap(im->mca_tomb, pmc->mca_tomb);
+			swap(im->mca_sources, pmc->mca_sources);
 			for (psf = im->mca_sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = im->mca_crcount;
 		}
 		in6_dev_put(pmc->idev);
+		ip6_mc_clear_src(pmc);
 		kfree(pmc);
 	}
 	spin_unlock_bh(&im->mca_lock);

