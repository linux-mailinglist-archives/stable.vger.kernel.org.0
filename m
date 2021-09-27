Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D280419B96
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhI0RUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237319AbhI0RST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6398B61371;
        Mon, 27 Sep 2021 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762741;
        bh=Ldceq8DADxE4S2kzlI+02ioyl6fZEYp2GY74RXkXMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzoqiOqsaqj2B+rDbdqIqaMiteoHq75t6iiEvW0oQV4qDqYIcMfVFdwLCoenznK4k
         7tJ8OU5533eEbehg8edqgxMfn4mkt7bF81XcCVDpewYx7ETdaf1U//rG+xjaOtQHjd
         6XMEgdGS2U+mGZvHpKYA/S601PzGwNARM2ZMr3TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 035/162] nexthop: Fix division by zero while replacing a resilient group
Date:   Mon, 27 Sep 2021 19:01:21 +0200
Message-Id: <20210927170234.694692941@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit 563f23b002534176f49524b5ca0e1d94d8906c40 upstream.

The resilient nexthop group torture tests in fib_nexthop.sh exposed a
possible division by zero while replacing a resilient group [1]. The
division by zero occurs when the data path sees a resilient nexthop
group with zero buckets.

The tests replace a resilient nexthop group in a loop while traffic is
forwarded through it. The tests do not specify the number of buckets
while performing the replacement, resulting in the kernel allocating a
stub resilient table (i.e, 'struct nh_res_table') with zero buckets.

This table should never be visible to the data path, but the old nexthop
group (i.e., 'oldg') might still be used by the data path when the stub
table is assigned to it.

Fix this by only assigning the stub table to the old nexthop group after
making sure the group is no longer used by the data path.

Tested with fib_nexthops.sh:

Tests passed: 222
Tests failed:   0

[1]
 divide error: 0000 [#1] PREEMPT SMP KASAN
 CPU: 0 PID: 1850 Comm: ping Not tainted 5.14.0-custom-10271-ga86eb53057fe #1107
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
 RIP: 0010:nexthop_select_path+0x2d2/0x1a80
[...]
 Call Trace:
  fib_select_multipath+0x79b/0x1530
  fib_select_path+0x8fb/0x1c10
  ip_route_output_key_hash_rcu+0x1198/0x2da0
  ip_route_output_key_hash+0x190/0x340
  ip_route_output_flow+0x21/0x120
  raw_sendmsg+0x91d/0x2e10
  inet_sendmsg+0x9e/0xe0
  __sys_sendto+0x23d/0x360
  __x64_sys_sendto+0xe1/0x1b0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: stable@vger.kernel.org
Fixes: 283a72a5599e ("nexthop: Add implementation of resilient next-hop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/nexthop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1982,6 +1982,8 @@ static int replace_nexthop_grp(struct ne
 	rcu_assign_pointer(old->nh_grp, newg);
 
 	if (newg->resilient) {
+		/* Make sure concurrent readers are not using 'oldg' anymore. */
+		synchronize_net();
 		rcu_assign_pointer(oldg->res_table, tmp_table);
 		rcu_assign_pointer(oldg->spare->res_table, tmp_table);
 	}


