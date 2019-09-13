Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF6B1E6D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbfIMNKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388579AbfIMNKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:10:03 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11762208C0;
        Fri, 13 Sep 2019 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380202;
        bh=xHGKZYRYZZCmv8FBlLbE77wCZ22V4FAgpkrLIjJPL7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVwZYwsEBbXMF46PmZoZFph82RxuZv4o8nUFh+JoPe9XOnCapvAzR9VyfyrY7XuuA
         4irvWP2bwsAluxcrppQqnpg7esQZ8dOatVWGyy5sMXxI/QpLRA7HMPbdDPLU/vymBN
         p/zjX2eYtGyulBDJMvGf3f1HyuaSHxW7MWJZaIbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 12/21] batman-adv: fix uninit-value in batadv_netlink_get_ifindex()
Date:   Fri, 13 Sep 2019 14:07:05 +0100
Message-Id: <20190913130506.581710560@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
References: <20190913130501.285837292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 3ee1bb7aae97324ec9078da1f00cb2176919563f upstream.

batadv_netlink_get_ifindex() needs to make sure user passed
a correct u32 attribute.

syzbot reported :
BUG: KMSAN: uninit-value in batadv_netlink_dump_hardif+0x70d/0x880 net/batman-adv/netlink.c:968
CPU: 1 PID: 11705 Comm: syz-executor888 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
 batadv_netlink_dump_hardif+0x70d/0x880 net/batman-adv/netlink.c:968
 genl_lock_dumpit+0xc6/0x130 net/netlink/genetlink.c:482
 netlink_dump+0xa84/0x1ab0 net/netlink/af_netlink.c:2253
 __netlink_dump_start+0xa3a/0xb30 net/netlink/af_netlink.c:2361
 genl_family_rcv_msg net/netlink/genetlink.c:550 [inline]
 genl_rcv_msg+0xfc1/0x1a40 net/netlink/genetlink.c:627
 netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2486
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:638
 netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
 netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1337
 netlink_sendmsg+0x127e/0x12f0 net/netlink/af_netlink.c:1926
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:661 [inline]
 ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
 __sys_sendmsg net/socket.c:2298 [inline]
 __do_sys_sendmsg net/socket.c:2307 [inline]
 __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
 do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x440209

Fixes: b60620cf567b ("batman-adv: netlink: hardif query")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -110,7 +110,7 @@ batadv_netlink_get_ifindex(const struct
 {
 	struct nlattr *attr = nlmsg_find_attr(nlh, GENL_HDRLEN, attrtype);
 
-	return attr ? nla_get_u32(attr) : 0;
+	return (attr && nla_len(attr) == sizeof(u32)) ? nla_get_u32(attr) : 0;
 }
 
 /**


