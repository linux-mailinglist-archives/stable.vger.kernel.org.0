Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6542D34C88D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbhC2IXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhC2IVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4528561580;
        Mon, 29 Mar 2021 08:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006071;
        bh=b3VEMJT60IezzqEOtJU0IXAyPbI/zH0cbmJTP/1S5g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmpyUYbA0U8G6MH9H/5b+3mktcnr355+ffO6BhjUIH59Bk1jXWvgmhSS3mtfZMrcL
         5rrWYj5HQikWq8k+a1214GaMxdtZLWRQW9HKWGB3b5scLEKoIeZ2p9mhkvlqGH3qWn
         4WgS/uBHmakbZYcpKc7Vyr9yad+fp0Hnk7Kee85k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/221] ipv6: fix suspecious RCU usage warning
Date:   Mon, 29 Mar 2021 09:57:11 +0200
Message-Id: <20210329075632.538293477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

[ Upstream commit 28259bac7f1dde06d8ba324e222bbec9d4e92f2b ]

Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
rcu_dereference_rtnl().
The fix proposed is to add a variant of nexthop_fib6_nh() to use
rcu_dereference_bh_rtnl() for ipv6_route_seq_show().

The reported trace is as follows:
./include/net/nexthop.h:416 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/17895:
     at: seq_read+0x71/0x12a0 fs/seq_file.c:169
     at: seq_file_net include/linux/seq_file_net.h:19 [inline]
     at: ipv6_route_seq_start+0xaf/0x300 net/ipv6/ip6_fib.c:2616

stack backtrace:
CPU: 1 PID: 17895 Comm: syz-executor.0 Not tainted 4.15.0-syzkaller #0
Call Trace:
 [<ffffffff849edf9e>] __dump_stack lib/dump_stack.c:17 [inline]
 [<ffffffff849edf9e>] dump_stack+0xd8/0x147 lib/dump_stack.c:53
 [<ffffffff8480b7fa>] lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5745
 [<ffffffff8459ada6>] nexthop_fib6_nh include/net/nexthop.h:416 [inline]
 [<ffffffff8459ada6>] ipv6_route_native_seq_show net/ipv6/ip6_fib.c:2488 [inline]
 [<ffffffff8459ada6>] ipv6_route_seq_show+0x436/0x7a0 net/ipv6/ip6_fib.c:2673
 [<ffffffff81c556df>] seq_read+0xccf/0x12a0 fs/seq_file.c:276
 [<ffffffff81dbc62c>] proc_reg_read+0x10c/0x1d0 fs/proc/inode.c:231
 [<ffffffff81bc28ae>] do_loop_readv_writev fs/read_write.c:714 [inline]
 [<ffffffff81bc28ae>] do_loop_readv_writev fs/read_write.c:701 [inline]
 [<ffffffff81bc28ae>] do_iter_read+0x49e/0x660 fs/read_write.c:935
 [<ffffffff81bc81ab>] vfs_readv+0xfb/0x170 fs/read_write.c:997
 [<ffffffff81c88847>] kernel_readv fs/splice.c:361 [inline]
 [<ffffffff81c88847>] default_file_splice_read+0x487/0x9c0 fs/splice.c:416
 [<ffffffff81c86189>] do_splice_to+0x129/0x190 fs/splice.c:879
 [<ffffffff81c86f66>] splice_direct_to_actor+0x256/0x890 fs/splice.c:951
 [<ffffffff81c8777d>] do_splice_direct+0x1dd/0x2b0 fs/splice.c:1060
 [<ffffffff81bc4747>] do_sendfile+0x597/0xce0 fs/read_write.c:1459
 [<ffffffff81bca205>] SYSC_sendfile64 fs/read_write.c:1520 [inline]
 [<ffffffff81bca205>] SyS_sendfile64+0x155/0x170 fs/read_write.c:1506
 [<ffffffff81015fcf>] do_syscall_64+0x1ff/0x310 arch/x86/entry/common.c:305
 [<ffffffff84a00076>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nexthop.h | 24 ++++++++++++++++++++++++
 net/ipv6/ip6_fib.c    |  2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2fd76a9b6dc8..4c8c9fe9a3f0 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -362,6 +362,7 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
 int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack);
 
+/* Caller should either hold rcu_read_lock(), or RTNL. */
 static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 {
 	struct nh_info *nhi;
@@ -382,6 +383,29 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 	return NULL;
 }
 
+/* Variant of nexthop_fib6_nh().
+ * Caller should either hold rcu_read_lock_bh(), or RTNL.
+ */
+static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
+		nh = nexthop_mpath_select(nh_grp, 0);
+		if (!nh)
+			return NULL;
+	}
+
+	nhi = rcu_dereference_bh_rtnl(nh->nh_info);
+	if (nhi->family == AF_INET6)
+		return &nhi->fib6_nh;
+
+	return NULL;
+}
+
 static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
 {
 	struct fib6_nh *fib6_nh;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index f43e27555725..1fb79dbde0cb 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2485,7 +2485,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 	const struct net_device *dev;
 
 	if (rt->nh)
-		fib6_nh = nexthop_fib6_nh(rt->nh);
+		fib6_nh = nexthop_fib6_nh_bh(rt->nh);
 
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
 
-- 
2.30.1



