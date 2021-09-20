Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54A3411EC5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351479AbhITReJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351114AbhITRcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8B561B01;
        Mon, 20 Sep 2021 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157492;
        bh=k/JFqbMAkwKWnsqg6o17+2hxgGbzUEN6jaaWU+kLxdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F70su/EHDRiiITLVlRathnX9A+ofBFpigp5A8BAUchJbJ5+giPaCtU1up2/Qu4L6r
         6QmlMXNw5AKgZY7nv8wOTl60atO9LowatYP2KyzPuv56TuUyT0a9tMff629/r5u/ld
         /jxlib+tlaRhxlmhgYR/ZFm/JBQDuICMCyDSbPm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 016/293] igmp: Add ip_mc_list lock in ip_check_mc_rcu
Date:   Mon, 20 Sep 2021 18:39:38 +0200
Message-Id: <20210920163933.816889086@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

commit 23d2b94043ca8835bd1e67749020e839f396a1c2 upstream.

I got below panic when doing fuzz test:

Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 4056 Comm: syz-executor.3 Tainted: G    B             5.14.0-rc1-00195-gcff5c4254439-dirty #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
dump_stack_lvl+0x7a/0x9b
panic+0x2cd/0x5af
end_report.cold+0x5a/0x5a
kasan_report+0xec/0x110
ip_check_mc_rcu+0x556/0x5d0
__mkroute_output+0x895/0x1740
ip_route_output_key_hash_rcu+0x2d0/0x1050
ip_route_output_key_hash+0x182/0x2e0
ip_route_output_flow+0x28/0x130
udp_sendmsg+0x165d/0x2280
udpv6_sendmsg+0x121e/0x24f0
inet6_sendmsg+0xf7/0x140
sock_sendmsg+0xe9/0x180
____sys_sendmsg+0x2b8/0x7a0
___sys_sendmsg+0xf0/0x160
__sys_sendmmsg+0x17e/0x3c0
__x64_sys_sendmmsg+0x9e/0x100
do_syscall_64+0x3b/0x90
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x462eb9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8
 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3df5af1c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462eb9
RDX: 0000000000000312 RSI: 0000000020001700 RDI: 0000000000000007
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3df5af26bc
R13: 00000000004c372d R14: 0000000000700b10 R15: 00000000ffffffff

It is one use-after-free in ip_check_mc_rcu.
In ip_mc_del_src, the ip_sf_list of pmc has been freed under pmc->lock protection.
But access to ip_sf_list in ip_check_mc_rcu is not protected by the lock.

Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/igmp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2743,6 +2743,7 @@ int ip_check_mc_rcu(struct in_device *in
 		rv = 1;
 	} else if (im) {
 		if (src_addr) {
+			spin_lock_bh(&im->lock);
 			for (psf = im->sources; psf; psf = psf->sf_next) {
 				if (psf->sf_inaddr == src_addr)
 					break;
@@ -2753,6 +2754,7 @@ int ip_check_mc_rcu(struct in_device *in
 					im->sfcount[MCAST_EXCLUDE];
 			else
 				rv = im->sfcount[MCAST_EXCLUDE] != 0;
+			spin_unlock_bh(&im->lock);
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}


