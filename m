Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1033D3AA68
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfFIQwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732229AbfFIQwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD347205ED;
        Sun,  9 Jun 2019 16:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099149;
        bh=jXzdCdvqLO7dRxoaSGasrDQlgBMktgZxARjGUFPRCO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9ZeLaJcpVsLafT7B295GSiyE3GIqgp1u3WjgdekhJz9wZ+LZwcEvhk4nS9reHs7+
         hVf4L9coKeS43C8shQ7UlToUEIoFASRMnKMq5Yka26fGTXIfZqnA57bdUjEIo89iKa
         V+SqMHwAABjpgsvD9+xGyckuhpUE0gV3YBKzybq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 09/83] ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
Date:   Sun,  9 Jun 2019 18:41:39 +0200
Message-Id: <20190609164128.356993536@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3580d04aa674383c42de7b635d28e52a1e5bc72c ]

syzbot reported memory leaks [1] that I have back tracked to
a missing cleanup from igmpv3_del_delrec() when
(im->sfmode != MCAST_INCLUDE)

Add ip_sf_list_clear_all() and kfree_pmc() helpers to explicitely
handle the cleanups before freeing.

[1]

BUG: memory leak
unreferenced object 0xffff888123e32b00 (size 64):
  comm "softirq", pid 0, jiffies 4294942968 (age 8.010s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 00 00 01 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000006105011b>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<000000006105011b>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<000000006105011b>] slab_alloc mm/slab.c:3326 [inline]
    [<000000006105011b>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<000000004bba8073>] kmalloc include/linux/slab.h:547 [inline]
    [<000000004bba8073>] kzalloc include/linux/slab.h:742 [inline]
    [<000000004bba8073>] ip_mc_add1_src net/ipv4/igmp.c:1961 [inline]
    [<000000004bba8073>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2085
    [<00000000a46a65a0>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2475
    [<000000005956ca89>] do_ip_setsockopt.isra.0+0x1795/0x1930 net/ipv4/ip_sockglue.c:957
    [<00000000848e2d2f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1246
    [<00000000b9db185c>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
    [<000000003028e438>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
    [<0000000015b65589>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
    [<00000000ac198ef0>] __do_sys_setsockopt net/socket.c:2089 [inline]
    [<00000000ac198ef0>] __se_sys_setsockopt net/socket.c:2086 [inline]
    [<00000000ac198ef0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
    [<000000000a770437>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<00000000d3adb93b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -635,6 +635,24 @@ static void igmpv3_clear_zeros(struct ip
 	}
 }
 
+static void ip_sf_list_clear_all(struct ip_sf_list *psf)
+{
+	struct ip_sf_list *next;
+
+	while (psf) {
+		next = psf->sf_next;
+		kfree(psf);
+		psf = next;
+	}
+}
+
+static void kfree_pmc(struct ip_mc_list *pmc)
+{
+	ip_sf_list_clear_all(pmc->sources);
+	ip_sf_list_clear_all(pmc->tomb);
+	kfree(pmc);
+}
+
 static void igmpv3_send_cr(struct in_device *in_dev)
 {
 	struct ip_mc_list *pmc, *pmc_prev, *pmc_next;
@@ -671,7 +689,7 @@ static void igmpv3_send_cr(struct in_dev
 			else
 				in_dev->mc_tomb = pmc_next;
 			in_dev_put(pmc->interface);
-			kfree(pmc);
+			kfree_pmc(pmc);
 		} else
 			pmc_prev = pmc;
 	}
@@ -1195,12 +1213,16 @@ static void igmpv3_del_delrec(struct in_
 		im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
 		if (im->sfmode == MCAST_INCLUDE) {
 			im->tomb = pmc->tomb;
+			pmc->tomb = NULL;
+
 			im->sources = pmc->sources;
+			pmc->sources = NULL;
+
 			for (psf = im->sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = im->crcount;
 		}
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	spin_unlock_bh(&im->lock);
 }
@@ -1221,21 +1243,18 @@ static void igmpv3_clear_delrec(struct i
 		nextpmc = pmc->next;
 		ip_mc_clear_src(pmc);
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	/* clear dead sources, too */
 	rcu_read_lock();
 	for_each_pmc_rcu(in_dev, pmc) {
-		struct ip_sf_list *psf, *psf_next;
+		struct ip_sf_list *psf;
 
 		spin_lock_bh(&pmc->lock);
 		psf = pmc->tomb;
 		pmc->tomb = NULL;
 		spin_unlock_bh(&pmc->lock);
-		for (; psf; psf = psf_next) {
-			psf_next = psf->sf_next;
-			kfree(psf);
-		}
+		ip_sf_list_clear_all(psf);
 	}
 	rcu_read_unlock();
 }
@@ -2099,7 +2118,7 @@ static int ip_mc_add_src(struct in_devic
 
 static void ip_mc_clear_src(struct ip_mc_list *pmc)
 {
-	struct ip_sf_list *psf, *nextpsf, *tomb, *sources;
+	struct ip_sf_list *tomb, *sources;
 
 	spin_lock_bh(&pmc->lock);
 	tomb = pmc->tomb;
@@ -2111,14 +2130,8 @@ static void ip_mc_clear_src(struct ip_mc
 	pmc->sfcount[MCAST_EXCLUDE] = 1;
 	spin_unlock_bh(&pmc->lock);
 
-	for (psf = tomb; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
-		kfree(psf);
-	}
-	for (psf = sources; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
-		kfree(psf);
-	}
+	ip_sf_list_clear_all(tomb);
+	ip_sf_list_clear_all(sources);
 }
 
 /* Join a multicast group


