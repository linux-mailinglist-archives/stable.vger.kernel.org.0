Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29883AEFCA
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhFUQl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhFUQj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A996A6135D;
        Mon, 21 Jun 2021 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293019;
        bh=lNfDjPhhfB4yjGG7SUymDWseI5BRKBUwphpFwJAfbK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neSdYr7Y88yOpgTHZGqRf8ZkeoMASzM5AoFm0OPTfJE7iqfSnsZ9Oocvz7oe6/l5d
         jw9LANP8SCb+lOQUAffmsHrdyRzygyDRMXe1EODyiuaEv/MvLV6+goKyhO+WSfF/f1
         preOe7GfKQHnvF0wsqNQLJ/D3bTLYifFVrZ/vJ8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Chengyang Fan <cy.fan@huawei.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 069/178] net: ipv4: fix memory leak in ip_mc_add1_src
Date:   Mon, 21 Jun 2021 18:14:43 +0200
Message-Id: <20210621154924.883698840@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengyang Fan <cy.fan@huawei.com>

[ Upstream commit d8e2973029b8b2ce477b564824431f3385c77083 ]

BUG: memory leak
unreferenced object 0xffff888101bc4c00 (size 32):
  comm "syz-executor527", pid 360, jiffies 4294807421 (age 19.329s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    01 00 00 00 00 00 00 00 ac 14 14 bb 00 00 02 00 ................
  backtrace:
    [<00000000f17c5244>] kmalloc include/linux/slab.h:558 [inline]
    [<00000000f17c5244>] kzalloc include/linux/slab.h:688 [inline]
    [<00000000f17c5244>] ip_mc_add1_src net/ipv4/igmp.c:1971 [inline]
    [<00000000f17c5244>] ip_mc_add_src+0x95f/0xdb0 net/ipv4/igmp.c:2095
    [<000000001cb99709>] ip_mc_source+0x84c/0xea0 net/ipv4/igmp.c:2416
    [<0000000052cf19ed>] do_ip_setsockopt net/ipv4/ip_sockglue.c:1294 [inline]
    [<0000000052cf19ed>] ip_setsockopt+0x114b/0x30c0 net/ipv4/ip_sockglue.c:1423
    [<00000000477edfbc>] raw_setsockopt+0x13d/0x170 net/ipv4/raw.c:857
    [<00000000e75ca9bb>] __sys_setsockopt+0x158/0x270 net/socket.c:2117
    [<00000000bdb993a8>] __do_sys_setsockopt net/socket.c:2128 [inline]
    [<00000000bdb993a8>] __se_sys_setsockopt net/socket.c:2125 [inline]
    [<00000000bdb993a8>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2125
    [<000000006a1ffdbd>] do_syscall_64+0x40/0x80 arch/x86/entry/common.c:47
    [<00000000b11467c4>] entry_SYSCALL_64_after_hwframe+0x44/0xae

In commit 24803f38a5c0 ("igmp: do not remove igmp souce list info when set
link down"), the ip_mc_clear_src() in ip_mc_destroy_dev() was removed,
because it was also called in igmpv3_clear_delrec().

Rough callgraph:

inetdev_destroy
-> ip_mc_destroy_dev
     -> igmpv3_clear_delrec
        -> ip_mc_clear_src
-> RCU_INIT_POINTER(dev->ip_ptr, NULL)

However, ip_mc_clear_src() called in igmpv3_clear_delrec() doesn't
release in_dev->mc_list->sources. And RCU_INIT_POINTER() assigns the
NULL to dev->ip_ptr. As a result, in_dev cannot be obtained through
inetdev_by_index() and then in_dev->mc_list->sources cannot be released
by ip_mc_del1_src() in the sock_close. Rough call sequence goes like:

sock_close
-> __sock_release
   -> inet_release
      -> ip_mc_drop_socket
         -> inetdev_by_index
         -> ip_mc_leave_src
            -> ip_mc_del_src
               -> ip_mc_del1_src

So we still need to call ip_mc_clear_src() in ip_mc_destroy_dev() to free
in_dev->mc_list->sources.

Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
Acked-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..6b3c558a4f23 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1801,6 +1801,7 @@ void ip_mc_destroy_dev(struct in_device *in_dev)
 	while ((i = rtnl_dereference(in_dev->mc_list)) != NULL) {
 		in_dev->mc_list = i->next_rcu;
 		in_dev->mc_count--;
+		ip_mc_clear_src(i);
 		ip_ma_put(i);
 	}
 }
-- 
2.30.2



