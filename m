Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3052029B181
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896028AbgJ0Oaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902010AbgJ0O3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE6D22202;
        Tue, 27 Oct 2020 14:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808988;
        bh=bI/eNuQfeQJnX1eDN9y5UTC3AgV8bBNlMFuo2FawxY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii9TO/Nfrm3o++v3TjtePz1PG4XO/8mK9w9goofYwSibNqAs8hBt3cs+Qtl2vA3CO
         jYn1tYLZYZYPobjAl9PpZhTCeUQHTYZJVO0YkCcYeq5+ujMFte/LdefP/sYLVVBNeS
         2jBHY3bmbjiO/VNtNlLjlQ534piBOWZYOgYIguN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 034/408] nexthop: Fix performance regression in nexthop deletion
Date:   Tue, 27 Oct 2020 14:49:32 +0100
Message-Id: <20201027135456.657514891@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit df6afe2f7c19349de2ee560dc62ea4d9ad3ff889 ]

While insertion of 16k nexthops all using the same netdev ('dummy10')
takes less than a second, deletion takes about 130 seconds:

# time -p ip -b nexthop.batch
real 0.29
user 0.01
sys 0.15

# time -p ip link set dev dummy10 down
real 131.03
user 0.06
sys 0.52

This is because of repeated calls to synchronize_rcu() whenever a
nexthop is removed from a nexthop group:

# /usr/share/bcc/tools/offcputime -p `pgrep -nx ip` -K
...
    b'finish_task_switch'
    b'schedule'
    b'schedule_timeout'
    b'wait_for_completion'
    b'__wait_rcu_gp'
    b'synchronize_rcu.part.0'
    b'synchronize_rcu'
    b'__remove_nexthop'
    b'remove_nexthop'
    b'nexthop_flush_dev'
    b'nh_netdev_event'
    b'raw_notifier_call_chain'
    b'call_netdevice_notifiers_info'
    b'__dev_notify_flags'
    b'dev_change_flags'
    b'do_setlink'
    b'__rtnl_newlink'
    b'rtnl_newlink'
    b'rtnetlink_rcv_msg'
    b'netlink_rcv_skb'
    b'rtnetlink_rcv'
    b'netlink_unicast'
    b'netlink_sendmsg'
    b'____sys_sendmsg'
    b'___sys_sendmsg'
    b'__sys_sendmsg'
    b'__x64_sys_sendmsg'
    b'do_syscall_64'
    b'entry_SYSCALL_64_after_hwframe'
    -                ip (277)
        126554955

Since nexthops are always deleted under RTNL, synchronize_net() can be
used instead. It will call synchronize_rcu_expedited() which only blocks
for several microseconds as opposed to multiple milliseconds like
synchronize_rcu().

With this patch deletion of 16k nexthops takes less than a second:

# time -p ip link set dev dummy10 down
real 0.12
user 0.00
sys 0.04

Tested with fib_nexthops.sh which includes torture tests that prompted
the initial change:

# ./fib_nexthops.sh
...
Tests passed: 134
Tests failed:   0

Fixes: 90f33bffa382 ("nexthops: don't modify published nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20201016172914.643282-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -763,7 +763,7 @@ static void remove_nexthop_from_groups(s
 		remove_nh_grp_entry(net, nhge, nlinfo);
 
 	/* make sure all see the newly published array before releasing rtnl */
-	synchronize_rcu();
+	synchronize_net();
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)


