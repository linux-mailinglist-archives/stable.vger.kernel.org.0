Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABB12D600E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390751AbgLJPkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391317AbgLJOkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:36 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Hoang Huu Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 63/75] tipc: fix a deadlock when flushing scheduled work
Date:   Thu, 10 Dec 2020 15:27:28 +0100
Message-Id: <20201210142609.147246614@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Huu Le <hoang.h.le@dektech.com.au>

commit d966ddcc38217a6110a6a0ff37ad2dee7d42e23e upstream.

In the commit fdeba99b1e58
("tipc: fix use-after-free in tipc_bcast_get_mode"), we're trying
to make sure the tipc_net_finalize_work work item finished if it
enqueued. But calling flush_scheduled_work() is not just affecting
above work item but either any scheduled work. This has turned out
to be overkill and caused to deadlock as syzbot reported:

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc2-next-20200828-syzkaller #0 Not tainted
------------------------------------------------------
kworker/u4:6/349 is trying to acquire lock:
ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: flush_workqueue+0xe1/0x13e0 kernel/workqueue.c:2777

but task is already holding lock:
ffffffff8a879430 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:565

[...]
 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(pernet_ops_rwsem);
                               lock(&sb->s_type->i_mutex_key#13);
                               lock(pernet_ops_rwsem);
  lock((wq_completion)events);

 *** DEADLOCK ***
[...]

v1:
To fix the original issue, we replace above calling by introducing
a bit flag. When a namespace cleaned-up, bit flag is set to zero and:
- tipc_net_finalize functionial just does return immediately.
- tipc_net_finalize_work does not enqueue into the scheduled work queue.

v2:
Use cancel_work_sync() helper to make sure ONLY the
tipc_net_finalize_work() stopped before releasing bcbase object.

Reported-by: syzbot+d5aa7e0385f6a5d0f4fd@syzkaller.appspotmail.com
Fixes: fdeba99b1e58 ("tipc: fix use-after-free in tipc_bcast_get_mode")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tipc/core.c |    9 +++++----
 net/tipc/core.h |    8 ++++++++
 net/tipc/net.c  |   20 +++++---------------
 net/tipc/net.h  |    1 +
 4 files changed, 19 insertions(+), 19 deletions(-)

--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -60,6 +60,7 @@ static int __net_init tipc_init_net(stru
 	tn->trial_addr = 0;
 	tn->addr_trial_end = 0;
 	tn->capabilities = TIPC_NODE_CAPABILITIES;
+	INIT_WORK(&tn->final_work.work, tipc_net_finalize_work);
 	memset(tn->node_id, 0, sizeof(tn->node_id));
 	memset(tn->node_id_string, 0, sizeof(tn->node_id_string));
 	tn->mon_threshold = TIPC_DEF_MON_THRESHOLD;
@@ -107,13 +108,13 @@ out_crypto:
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
+	struct tipc_net *tn = tipc_net(net);
+
 	tipc_detach_loopback(net);
+	/* Make sure the tipc_net_finalize_work() finished */
+	cancel_work_sync(&tn->final_work.work);
 	tipc_net_stop(net);
 
-	/* Make sure the tipc_net_finalize_work stopped
-	 * before releasing the resources.
-	 */
-	flush_scheduled_work();
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -90,6 +90,12 @@ extern unsigned int tipc_net_id __read_m
 extern int sysctl_tipc_rmem[3] __read_mostly;
 extern int sysctl_tipc_named_timeout __read_mostly;
 
+struct tipc_net_work {
+	struct work_struct work;
+	struct net *net;
+	u32 addr;
+};
+
 struct tipc_net {
 	u8  node_id[NODE_ID_LEN];
 	u32 node_addr;
@@ -143,6 +149,8 @@ struct tipc_net {
 	/* TX crypto handler */
 	struct tipc_crypto *crypto_tx;
 #endif
+	/* Work item for net finalize */
+	struct tipc_net_work final_work;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -105,12 +105,6 @@
  *     - A local spin_lock protecting the queue of subscriber events.
 */
 
-struct tipc_net_work {
-	struct work_struct work;
-	struct net *net;
-	u32 addr;
-};
-
 static void tipc_net_finalize(struct net *net, u32 addr);
 
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr)
@@ -142,25 +136,21 @@ static void tipc_net_finalize(struct net
 			     TIPC_CLUSTER_SCOPE, 0, addr);
 }
 
-static void tipc_net_finalize_work(struct work_struct *work)
+void tipc_net_finalize_work(struct work_struct *work)
 {
 	struct tipc_net_work *fwork;
 
 	fwork = container_of(work, struct tipc_net_work, work);
 	tipc_net_finalize(fwork->net, fwork->addr);
-	kfree(fwork);
 }
 
 void tipc_sched_net_finalize(struct net *net, u32 addr)
 {
-	struct tipc_net_work *fwork = kzalloc(sizeof(*fwork), GFP_ATOMIC);
+	struct tipc_net *tn = tipc_net(net);
 
-	if (!fwork)
-		return;
-	INIT_WORK(&fwork->work, tipc_net_finalize_work);
-	fwork->net = net;
-	fwork->addr = addr;
-	schedule_work(&fwork->work);
+	tn->final_work.net = net;
+	tn->final_work.addr = addr;
+	schedule_work(&tn->final_work.work);
 }
 
 void tipc_net_stop(struct net *net)
--- a/net/tipc/net.h
+++ b/net/tipc/net.h
@@ -42,6 +42,7 @@
 extern const struct nla_policy tipc_nl_net_policy[];
 
 int tipc_net_init(struct net *net, u8 *node_id, u32 addr);
+void tipc_net_finalize_work(struct work_struct *work);
 void tipc_sched_net_finalize(struct net *net, u32 addr);
 void tipc_net_stop(struct net *net);
 int tipc_nl_net_dump(struct sk_buff *skb, struct netlink_callback *cb);


