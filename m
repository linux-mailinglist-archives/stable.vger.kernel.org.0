Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1235534D579
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 18:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhC2QvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 12:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhC2Qu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 12:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B2161920;
        Mon, 29 Mar 2021 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617036655;
        bh=qzY2Rf6Roc+FV9ZFcWM+w/LXiMuGVCQ0h9TDIlNqAs0=;
        h=From:To:Cc:Subject:Date:From;
        b=KlrjYEB+3Qf7PDYuOYUUcfduckhXVzzdPooeBExE+x6x5IAu8ATjHp2S3mrzyz17U
         kK7kcWbi5q2/+g582TzEtGw2jC/GEs+LAgN/AiSkZ9cn/dFs1bqP43pXJKl+nnEqQx
         FgFXhZdOzM4K2ZeOLBGzVcvm00kF9hxUoWucL2rnFPOUUFkxb9Holt+vb/EfqUCIQP
         o1kXsbQyOPhrNsW4Qa9JwTzF/DrbUapzBr6cTeJ1nn0GJRHhRYBGdFlw0FgFl1FE2w
         DWLfX78Ax3gKTW4UTl3vsZ0oKw4I17BN2vyW+XR8/5pe7kHSl22ojyXa0FnH6UwKTx
         OBuqy8xESJc0w==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, vladimir.oltean@nxp.com
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: FAILED: Patch "net: bridge: don't notify switchdev for local FDB addresses" failed to apply to 4.19-stable tree
Date:   Mon, 29 Mar 2021 12:50:54 -0400
Message-Id: <20210329165054.2358935-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 6ab4c3117aec4e08007d9e971fa4133e1de1082d Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 22 Mar 2021 20:21:08 +0200
Subject: [PATCH] net: bridge: don't notify switchdev for local FDB addresses

As explained in this discussion:
https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/

the switchdev notifiers for FDB entries managed to have a zero-day bug.
The bridge would not say that this entry is local:

ip link add br0 type bridge
ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master local

and the switchdev driver would be more than happy to offload it as a
normal static FDB entry. This is despite the fact that 'local' and
non-'local' entries have completely opposite directions: a local entry
is locally terminated and not forwarded, whereas a static entry is
forwarded and not locally terminated. So, for example, DSA would install
this entry on swp0 instead of installing it on the CPU port as it should.

There is an even sadder part, which is that the 'local' flag is implicit
if 'static' is not specified, meaning that this command produces the
same result of adding a 'local' entry:

bridge fdb add dev swp0 00:01:02:03:04:05 master

I've updated the man pages for 'bridge', and after reading it now, it
should be pretty clear to any user that the commands above were broken
and should have never resulted in the 00:01:02:03:04:05 address being
forwarded (this behavior is coherent with non-switchdev interfaces):
https://patchwork.kernel.org/project/netdevbpf/cover/20210211104502.2081443-1-olteanv@gmail.com/
If you're a user reading this and this is what you want, just use:

bridge fdb add dev swp0 00:01:02:03:04:05 master static

Because switchdev should have given drivers the means from day one to
classify FDB entries as local/non-local, but didn't, it means that all
drivers are currently broken. So we can just as well omit the switchdev
notifications for local FDB entries, which is exactly what this patch
does to close the bug in stable trees. For further development work
where drivers might want to trap the local FDB entries to the host, we
can add a 'bool is_local' to br_switchdev_fdb_call_notifiers(), and
selectively make drivers act upon that bit, while all the others ignore
those entries if the 'is_local' bit is set.

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/bridge/br_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b89503832fcc..1e24d9a2c9a7 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -128,6 +128,8 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
 	if (!fdb->dst)
 		return;
+	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-- 
2.30.1




