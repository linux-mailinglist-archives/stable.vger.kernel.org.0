Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753463F63FE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbhHXRAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhHXQ6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCA361439;
        Tue, 24 Aug 2021 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824243;
        bh=Ho0dsANWaUEUZJGkSTgGmhQ4WBcsHJcvkmzUZUI6bfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN8qHzIyp748MZ6Z1uA3ibLTPu9JnHtT3iaD2UQKSyEsJ0qmhdPsWJadWvFyPVmHO
         PgqqK8hRTqPWC7ngUkPyLeQwY564dHzN+FOkspOdpf1KifGdl3NUFTs1ftSQPfK3Dn
         8iK3z0An7DMHTPFlw/bfyLuxTqxzqqEkBFWCYTfEjlxfbS/wY6qoE/kKtI6730R6Ok
         +xfLaN52llP8asr2i43y6HlREviyygNxN/HwHqVaIe9y2Z2MU1G9U9fa7CEmrrC6fT
         yyGt4pc3HK1v3QPyxmXrT/fs/Ar3WvBnxtCkHihENrkDFvi6EP91tgQjUCzNH/DzTf
         lOXbL+gt8Mgsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 076/127] mptcp: fix memory leak on address flush
Date:   Tue, 24 Aug 2021 12:55:16 -0400
Message-Id: <20210824165607.709387-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit a0eea5f10eeb5180d115452b0d77afa6603dfe18 ]

The endpoint cleanup path is prone to a memory leak, as reported
by syzkaller:

 BUG: memory leak
 unreferenced object 0xffff88810680ea00 (size 64):
   comm "syz-executor.6", pid 6191, jiffies 4295756280 (age 24.138s)
   hex dump (first 32 bytes):
     58 75 7d 3c 80 88 ff ff 22 01 00 00 00 00 ad de  Xu}<....".......
     01 00 02 00 00 00 00 00 ac 1e 00 07 00 00 00 00  ................
   backtrace:
     [<0000000072a9f72a>] kmalloc include/linux/slab.h:591 [inline]
     [<0000000072a9f72a>] mptcp_nl_cmd_add_addr+0x287/0x9f0 net/mptcp/pm_netlink.c:1170
     [<00000000f6e931bf>] genl_family_rcv_msg_doit.isra.0+0x225/0x340 net/netlink/genetlink.c:731
     [<00000000f1504a2c>] genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
     [<00000000f1504a2c>] genl_rcv_msg+0x341/0x5b0 net/netlink/genetlink.c:792
     [<0000000097e76f6a>] netlink_rcv_skb+0x148/0x430 net/netlink/af_netlink.c:2504
     [<00000000ceefa2b8>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
     [<000000008ff91aec>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
     [<000000008ff91aec>] netlink_unicast+0x537/0x750 net/netlink/af_netlink.c:1340
     [<0000000041682c35>] netlink_sendmsg+0x846/0xd80 net/netlink/af_netlink.c:1929
     [<00000000df3aa8e7>] sock_sendmsg_nosec net/socket.c:704 [inline]
     [<00000000df3aa8e7>] sock_sendmsg+0x14e/0x190 net/socket.c:724
     [<000000002154c54c>] ____sys_sendmsg+0x709/0x870 net/socket.c:2403
     [<000000001aab01d7>] ___sys_sendmsg+0xff/0x170 net/socket.c:2457
     [<00000000fa3b1446>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
     [<00000000db2ee9c7>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
     [<00000000db2ee9c7>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
     [<000000005873517d>] entry_SYSCALL_64_after_hwframe+0x44/0xae

We should not require an allocation to cleanup stuff.

Rework the code a bit so that the additional RCU work is no more needed.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 44 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fce1d057d19e..45b414efc001 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1135,36 +1135,12 @@ next:
 	return 0;
 }
 
-struct addr_entry_release_work {
-	struct rcu_work	rwork;
-	struct mptcp_pm_addr_entry *entry;
-};
-
-static void mptcp_pm_release_addr_entry(struct work_struct *work)
+/* caller must ensure the RCU grace period is already elapsed */
+static void __mptcp_pm_release_addr_entry(struct mptcp_pm_addr_entry *entry)
 {
-	struct addr_entry_release_work *w;
-	struct mptcp_pm_addr_entry *entry;
-
-	w = container_of(to_rcu_work(work), struct addr_entry_release_work, rwork);
-	entry = w->entry;
-	if (entry) {
-		if (entry->lsk)
-			sock_release(entry->lsk);
-		kfree(entry);
-	}
-	kfree(w);
-}
-
-static void mptcp_pm_free_addr_entry(struct mptcp_pm_addr_entry *entry)
-{
-	struct addr_entry_release_work *w;
-
-	w = kmalloc(sizeof(*w), GFP_ATOMIC);
-	if (w) {
-		INIT_RCU_WORK(&w->rwork, mptcp_pm_release_addr_entry);
-		w->entry = entry;
-		queue_rcu_work(system_wq, &w->rwork);
-	}
+	if (entry->lsk)
+		sock_release(entry->lsk);
+	kfree(entry);
 }
 
 static int mptcp_nl_remove_id_zero_address(struct net *net,
@@ -1244,7 +1220,8 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	spin_unlock_bh(&pernet->lock);
 
 	mptcp_nl_remove_subflow_and_signal_addr(sock_net(skb->sk), &entry->addr);
-	mptcp_pm_free_addr_entry(entry);
+	synchronize_rcu();
+	__mptcp_pm_release_addr_entry(entry);
 
 	return ret;
 }
@@ -1297,6 +1274,7 @@ static void mptcp_nl_remove_addrs_list(struct net *net,
 	}
 }
 
+/* caller must ensure the RCU grace period is already elapsed */
 static void __flush_addrs(struct list_head *list)
 {
 	while (!list_empty(list)) {
@@ -1305,7 +1283,7 @@ static void __flush_addrs(struct list_head *list)
 		cur = list_entry(list->next,
 				 struct mptcp_pm_addr_entry, list);
 		list_del_rcu(&cur->list);
-		mptcp_pm_free_addr_entry(cur);
+		__mptcp_pm_release_addr_entry(cur);
 	}
 }
 
@@ -1329,6 +1307,7 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
 	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
+	synchronize_rcu();
 	__flush_addrs(&free_list);
 	return 0;
 }
@@ -1936,7 +1915,8 @@ static void __net_exit pm_nl_exit_net(struct list_head *net_list)
 		struct pm_nl_pernet *pernet = net_generic(net, pm_nl_pernet_id);
 
 		/* net is removed from namespace list, can't race with
-		 * other modifiers
+		 * other modifiers, also netns core already waited for a
+		 * RCU grace period.
 		 */
 		__flush_addrs(&pernet->local_addr_list);
 	}
-- 
2.30.2

