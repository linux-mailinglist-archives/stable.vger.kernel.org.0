Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0DACDFF
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbfIHMtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731431AbfIHMtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:23 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72D3321971;
        Sun,  8 Sep 2019 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946961;
        bh=hQkkUKBVEgJx9TYb+9IwtLkkG5cRMyivysh7kjH0juk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6fqImRaiudI2GzaumZhGfc5fE00HxI1iaAU0ppZokSTltt7JH8/juL6RoAePPXC8
         ZYGvDBNNE9mQA/BZpH6mpEwFD+I1mDTWa8YrYAflDZb5oB1sqSLQwPAxUM00vUNwx4
         7KEIhEax6J7os5xUTm3Flj1tgcbgWBiwHR51VU3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 01/94] mld: fix memory leak in mld_del_delrec()
Date:   Sun,  8 Sep 2019 13:40:57 +0100
Message-Id: <20190908121150.470693460@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a84d016479896b5526a2cc54784e6ffc41c9d6f6 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -787,14 +787,15 @@ static void mld_del_delrec(struct inet6_
 	if (pmc) {
 		im->idev = pmc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
-			im->mca_tomb = pmc->mca_tomb;
-			im->mca_sources = pmc->mca_sources;
+			swap(im->mca_tomb, pmc->mca_tomb);
+			swap(im->mca_sources, pmc->mca_sources);
 			for (psf = im->mca_sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = idev->mc_qrv;
 		} else {
 			im->mca_crcount = idev->mc_qrv;
 		}
 		in6_dev_put(pmc->idev);
+		ip6_mc_clear_src(pmc);
 		kfree(pmc);
 	}
 	spin_unlock_bh(&im->mca_lock);


