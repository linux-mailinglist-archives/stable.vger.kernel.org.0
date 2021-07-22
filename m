Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF583D27F9
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhGVPyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229960AbhGVPx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC75F6136E;
        Thu, 22 Jul 2021 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971673;
        bh=yGVwql+kevVAzuDNKujLF2Fnwwu6Ty3IXs0G42vF01U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL9AWN95TqOyAHczF8TnCNQc+buupnVwML/tRn6KyuIMl+v6rjbqTVHjS9pcPODnC
         DNYBZ01Ne+ONzKasRjuyh7J9jk9CmqSqtX/y5kU1Vq+F/BALkWNtPgV+JuZizqzevl
         L7CJegFUuKPvd0jK9IGiqysgp9Ktzzsmwu2TuJjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 55/71] netfilter: ctnetlink: suspicious RCU usage in ctnetlink_dump_helpinfo
Date:   Thu, 22 Jul 2021 18:31:30 +0200
Message-Id: <20210722155619.735223316@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit c23a9fd209bc6f8c1fa6ee303fdf037d784a1627 upstream.

Two patches listed below removed ctnetlink_dump_helpinfo call from under
rcu_read_lock. Now its rcu_dereference generates following warning:
=============================
WARNING: suspicious RCU usage
5.13.0+ #5 Not tainted
-----------------------------
net/netfilter/nf_conntrack_netlink.c:221 suspicious rcu_dereference_check() usage!

other info that might help us debug this:
rcu_scheduler_active = 2, debug_locks = 1
stack backtrace:
CPU: 1 PID: 2251 Comm: conntrack Not tainted 5.13.0+ #5
Call Trace:
 dump_stack+0x7f/0xa1
 ctnetlink_dump_helpinfo+0x134/0x150 [nf_conntrack_netlink]
 ctnetlink_fill_info+0x2c2/0x390 [nf_conntrack_netlink]
 ctnetlink_dump_table+0x13f/0x370 [nf_conntrack_netlink]
 netlink_dump+0x10c/0x370
 __netlink_dump_start+0x1a7/0x260
 ctnetlink_get_conntrack+0x1e5/0x250 [nf_conntrack_netlink]
 nfnetlink_rcv_msg+0x613/0x993 [nfnetlink]
 netlink_rcv_skb+0x50/0x100
 nfnetlink_rcv+0x55/0x120 [nfnetlink]
 netlink_unicast+0x181/0x260
 netlink_sendmsg+0x23f/0x460
 sock_sendmsg+0x5b/0x60
 __sys_sendto+0xf1/0x160
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x36/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 49ca022bccc5 ("netfilter: ctnetlink: don't dump ct extensions of unconfirmed conntracks")
Fixes: 0b35f6031a00 ("netfilter: Remove duplicated rcu_read_lock.")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -211,6 +211,7 @@ static int ctnetlink_dump_helpinfo(struc
 	if (!help)
 		return 0;
 
+	rcu_read_lock();
 	helper = rcu_dereference(help->helper);
 	if (!helper)
 		goto out;
@@ -226,9 +227,11 @@ static int ctnetlink_dump_helpinfo(struc
 
 	nla_nest_end(skb, nest_helper);
 out:
+	rcu_read_unlock();
 	return 0;
 
 nla_put_failure:
+	rcu_read_unlock();
 	return -1;
 }
 


