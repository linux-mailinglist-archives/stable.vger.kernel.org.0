Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D975798A0
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfG2Tfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbfG2Tfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:35:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72EA52171F;
        Mon, 29 Jul 2019 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428936;
        bh=RhXlH+UNH9e1dlri2etCNTL86IgU0zFFYtzRoIaD7/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/NwaJl5mEk7yEz/vqsabqApS/sbQl72nLkXkUd4md0nyD8XTVQC8neEXeOcynUtd
         h5IXyqXD2DkNuXtNo5l/Z6QLKJ1zp4eM6In+nOqkBcg2jlpHB/mw1Pj6dzde84KrBs
         XspyE8QcrzwbpxyEidau8D700qeTx5tUD+v6zsHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 184/293] igmp: fix memory leak in igmpv3_del_delrec()
Date:   Mon, 29 Jul 2019 21:21:15 +0200
Message-Id: <20190729190838.594973468@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e5b1c6c6277d5a283290a8c033c72544746f9b5b ]

im->tomb and/or im->sources might not be NULL, but we
currently overwrite their values blindly.

Using swap() will make sure the following call to kfree_pmc(pmc)
will properly free the psf structures.

Tested with the C repro provided by syzbot, which basically does :

 socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
 setsockopt(3, SOL_IP, IP_ADD_MEMBERSHIP, "\340\0\0\2\177\0\0\1\0\0\0\0", 12) = 0
 ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=0}) = 0
 setsockopt(3, SOL_IP, IP_MSFILTER, "\340\0\0\2\177\0\0\1\1\0\0\0\1\0\0\0\377\377\377\377", 20) = 0
 ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=IFF_UP}) = 0
 exit_group(0)                    = ?

BUG: memory leak
unreferenced object 0xffff88811450f140 (size 64):
  comm "softirq", pid 0, jiffies 4294942448 (age 32.070s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000c7bad083>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
    [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
    [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
    [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
    [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
    [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930 net/ipv4/ip_sockglue.c:959
    [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
    [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
    [<000000009383a786>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3126
    [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
    [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
    [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
    [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
    [<00000000420d395e>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info when set link down")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1220,12 +1220,8 @@ static void igmpv3_del_delrec(struct in_
 		im->interface = pmc->interface;
 		im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
 		if (im->sfmode == MCAST_INCLUDE) {
-			im->tomb = pmc->tomb;
-			pmc->tomb = NULL;
-
-			im->sources = pmc->sources;
-			pmc->sources = NULL;
-
+			swap(im->tomb, pmc->tomb);
+			swap(im->sources, pmc->sources);
 			for (psf = im->sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = im->crcount;
 		}


