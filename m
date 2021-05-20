Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F1438A191
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhETJcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhETJaY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:30:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B79E4613CE;
        Thu, 20 May 2021 09:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502852;
        bh=pOfwm89cUHBpxYLQskHH/ypACF79RGqRGMrk5ES2oj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L176cD1SvWZ3/qFIA3rb9kknDwdZdwTep2J3cdyFNtfsdmWRbqGL0HzdiJ7mQE8lk
         PjDWD4Ly1QNJD4BupK3llPjiXWRMzg3+ovU7Tb2+91QIkMHfeB3OqnOKps+t+aWwKn
         1mnZ4NJnRrfW7716vXcAu8IXJKLiymCUV63HJvoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 42/47] ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
Date:   Thu, 20 May 2021 11:22:40 +0200
Message-Id: <20210520092054.900699486@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 7f700334be9aeb91d5d86ef9ad2d901b9b453e9b upstream.

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding dev_hold(),
  and vice versa.

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

ip6_gre for example (among others problematic drivers)
has to use dev_hold() in ip6gre_tunnel_init_common()
instead of from ip6gre_newlink_common(), covering
both ip6gre_tunnel_init() and ip6gre_tap_init()/

Note that ip6gre_tunnel_init_common() is not called from
ip6erspan_tap_init() thus we also need to add a dev_hold() there,
as ip6erspan_tunnel_uninit() does call dev_put()

[1]
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 8422 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 1 PID: 8422 Comm: syz-executor854 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 6a 5a e8 09 31 ff 89 de e8 8d 1a ab fd 84 db 75 e0 e8 d4 13 ab fd 48 c7 c7 a0 e1 c1 89 c6 05 4a 5a e8 09 01 e8 2e 36 fb 04 <0f> 0b eb c4 e8 b8 13 ab fd 0f b6 1d 39 5a e8 09 31 ff 89 de e8 58
RSP: 0018:ffffc900018befd0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801ef19c40 RSI: ffffffff815c51f5 RDI: fffff52000317dec
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf8e R11: 0000000000000000 R12: ffff888018cf4568
R13: ffff888018cf4c00 R14: ffff8880228f2000 R15: ffffffff8d659b80
FS:  00000000014eb300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d7bf2b3138 CR3: 0000000014933000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4135 [inline]
 ip6gre_tunnel_uninit+0x3d7/0x440 net/ipv6/ip6_gre.c:420
 register_netdevice+0xadf/0x1500 net/core/dev.c:10308
 ip6gre_newlink_common.constprop.0+0x158/0x410 net/ipv6/ip6_gre.c:1984
 ip6gre_newlink+0x275/0x7a0 net/ipv6/ip6_gre.c:2017
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3443
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1496,6 +1496,7 @@ static int ip6gre_tunnel_init_common(str
 	}
 	ip6gre_tnl_init_features(dev);
 
+	dev_hold(dev);
 	return 0;
 
 cleanup_dst_cache_init:
@@ -1889,6 +1890,7 @@ static int ip6erspan_tap_init(struct net
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	ip6erspan_tnl_link_config(tunnel, 1);
 
+	dev_hold(dev);
 	return 0;
 
 cleanup_dst_cache_init:
@@ -1988,8 +1990,6 @@ static int ip6gre_newlink_common(struct
 	if (tb[IFLA_MTU])
 		ip6_tnl_change_mtu(dev, nla_get_u32(tb[IFLA_MTU]));
 
-	dev_hold(dev);
-
 out:
 	return err;
 }


