Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77485C1585
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbfI2OCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730260AbfI2OCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64AF0218DE;
        Sun, 29 Sep 2019 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765758;
        bh=2zC0+TUGKe2DUJPprr29ayJRiDT5XGW6PsxWCASiPwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1oHSB9i0V3L2+9omuSma3EtAoozBWZePyZP4y2+D2Gc2VLZxjrRWQXFOIZHuj8wT
         vR1fcjYrlM3xUoqD7Zveweo1Q43eQ6wpjS3pSylqXeEvEDB/+mGU+eOY3Fmg4oq6sw
         Ar16bW5Xb7mo28nZ+ppoENtpMqlZi+TWQSa7FZOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 41/45] xfrm: policy: avoid warning splat when merging nodes
Date:   Sun, 29 Sep 2019 15:56:09 +0200
Message-Id: <20190929135033.467279157@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 769a807d0b41df4201dbeb01c22eaeb3e5905532 ]

syzbot reported a splat:
 xfrm_policy_inexact_list_reinsert+0x625/0x6e0 net/xfrm/xfrm_policy.c:877
 CPU: 1 PID: 6756 Comm: syz-executor.1 Not tainted 5.3.0-rc2+ #57
 Call Trace:
  xfrm_policy_inexact_node_reinsert net/xfrm/xfrm_policy.c:922 [inline]
  xfrm_policy_inexact_node_merge net/xfrm/xfrm_policy.c:958 [inline]
  xfrm_policy_inexact_insert_node+0x537/0xb50 net/xfrm/xfrm_policy.c:1023
  xfrm_policy_inexact_alloc_chain+0x62b/0xbd0 net/xfrm/xfrm_policy.c:1139
  xfrm_policy_inexact_insert+0xe8/0x1540 net/xfrm/xfrm_policy.c:1182
  xfrm_policy_insert+0xdf/0xce0 net/xfrm/xfrm_policy.c:1574
  xfrm_add_policy+0x4cf/0x9b0 net/xfrm/xfrm_user.c:1670
  xfrm_user_rcv_msg+0x46b/0x720 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x809/0x9a0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0xa70/0xd30 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]

There is no reproducer, however, the warning can be reproduced
by adding rules with ever smaller prefixes.

The sanity check ("does the policy match the node") uses the prefix value
of the node before its updated to the smaller value.

To fix this, update the prefix earlier.  The bug has no impact on tree
correctness, this is only to prevent a false warning.

Reported-by: syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c                     | 6 ++++--
 tools/testing/selftests/net/xfrm_policy.sh | 7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d5342687fdcaa..7c2fa80b20bdf 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -915,6 +915,7 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 		} else if (delta > 0) {
 			p = &parent->rb_right;
 		} else {
+			bool same_prefixlen = node->prefixlen == n->prefixlen;
 			struct xfrm_policy *tmp;
 
 			hlist_for_each_entry(tmp, &n->hhead, bydst) {
@@ -922,9 +923,11 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 				hlist_del_rcu(&tmp->bydst);
 			}
 
+			node->prefixlen = prefixlen;
+
 			xfrm_policy_inexact_list_reinsert(net, node, family);
 
-			if (node->prefixlen == n->prefixlen) {
+			if (same_prefixlen) {
 				kfree_rcu(n, rcu);
 				return;
 			}
@@ -932,7 +935,6 @@ static void xfrm_policy_inexact_node_reinsert(struct net *net,
 			rb_erase(*p, new);
 			kfree_rcu(n, rcu);
 			n = node;
-			n->prefixlen = prefixlen;
 			goto restart;
 		}
 	}
diff --git a/tools/testing/selftests/net/xfrm_policy.sh b/tools/testing/selftests/net/xfrm_policy.sh
index 5445943bf07f2..7a1bf94c5bd38 100755
--- a/tools/testing/selftests/net/xfrm_policy.sh
+++ b/tools/testing/selftests/net/xfrm_policy.sh
@@ -106,6 +106,13 @@ do_overlap()
     #
     # 10.0.0.0/24 and 10.0.1.0/24 nodes have been merged as 10.0.0.0/23.
     ip -net $ns xfrm policy add src 10.1.0.0/24 dst 10.0.0.0/23 dir fwd priority 200 action block
+
+    # similar to above: add policies (with partially random address), with shrinking prefixes.
+    for p in 29 28 27;do
+      for k in $(seq 1 32); do
+       ip -net $ns xfrm policy add src 10.253.1.$((RANDOM%255))/$p dst 10.254.1.$((RANDOM%255))/$p dir fwd priority $((200+k)) action block 2>/dev/null
+      done
+    done
 }
 
 do_esp_policy_get_check() {
-- 
2.20.1



