Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC6A20E2F7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbgF2VK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgF2TAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6C02551D;
        Mon, 29 Jun 2020 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446080;
        bh=I9bBrounO9gZ9Qyw3N5oZhKEYMFFp9vCj/kcakWxcGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaeFk9LhQ/qjyJNxShnyyrew0k0uLu1Jdze2fC8Y2Oa+Asq3ALYo/+EZuCDX9eIhL
         G2ArzH9WofEEhypB1IWwsjuQ0TXoRw85O4xWL13sAbR4Mm0OAaTYGMaGLPVYMxZRg5
         AtSCIaC+G/opKzaxJIMCbj89m+wVl2JQJl8ihe7Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 076/135] net: core: device_rename: Use rwsem instead of a seqcount
Date:   Mon, 29 Jun 2020 11:52:10 -0400
Message-Id: <20200629155309.2495516-77-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

[ Upstream commit 11d6011c2cf29f7c8181ebde6c8bc0c4d83adcd7 ]

Sequence counters write paths are critical sections that must never be
preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.

Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
netdev name retrieval.") handled a deadlock, observed with
CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
infinitely spinning: it got scheduled after the seqcount write side
blocked inside its own critical section.

To fix that deadlock, among other issues, the commit added a
cond_resched() inside the read side section. While this will get the
non-preemptible kernel eventually unstuck, the seqcount reader is fully
exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.

The fix is also still broken: if the seqcount reader belongs to a
real-time scheduling policy, it can spin forever and the kernel will
livelock.

Disabling preemption over the seqcount write side critical section will
not work: inside it are a number of GFP_KERNEL allocations and mutex
locking through the drivers/base/ :: device_rename() call chain.

>From all the above, replace the seqcount with a rwsem.

Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
Cc: <stable@vger.kernel.org>
Reported-by: kbuild test robot <lkp@intel.com> [ v1 missing up_read() on error exit ]
Reported-by: Dan Carpenter <dan.carpenter@oracle.com> [ v1 missing up_read() on error exit ]
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 775c8dfeff848..82f9ec1bd94b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -82,6 +82,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
@@ -185,7 +186,7 @@ static DEFINE_SPINLOCK(napi_hash_lock);
 static unsigned int napi_gen_id = NR_CPUS;
 static DEFINE_HASHTABLE(napi_hash, 8);
 
-static seqcount_t devnet_rename_seq;
+static DECLARE_RWSEM(devnet_rename_sem);
 
 static inline void dev_base_seq_inc(struct net *net)
 {
@@ -862,33 +863,28 @@ EXPORT_SYMBOL(dev_get_by_index);
  *	@net: network namespace
  *	@name: a pointer to the buffer where the name will be stored.
  *	@ifindex: the ifindex of the interface to get the name from.
- *
- *	The use of raw_seqcount_begin() and cond_resched() before
- *	retrying is required as we want to give the writers a chance
- *	to complete when CONFIG_PREEMPTION is not set.
  */
 int netdev_get_name(struct net *net, char *name, int ifindex)
 {
 	struct net_device *dev;
-	unsigned int seq;
+	int ret;
 
-retry:
-	seq = raw_seqcount_begin(&devnet_rename_seq);
+	down_read(&devnet_rename_sem);
 	rcu_read_lock();
+
 	dev = dev_get_by_index_rcu(net, ifindex);
 	if (!dev) {
-		rcu_read_unlock();
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	strcpy(name, dev->name);
-	rcu_read_unlock();
-	if (read_seqcount_retry(&devnet_rename_seq, seq)) {
-		cond_resched();
-		goto retry;
-	}
 
-	return 0;
+	ret = 0;
+out:
+	rcu_read_unlock();
+	up_read(&devnet_rename_sem);
+	return ret;
 }
 
 /**
@@ -1153,10 +1149,10 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	if (dev->flags & IFF_UP)
 		return -EBUSY;
 
-	write_seqcount_begin(&devnet_rename_seq);
+	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return 0;
 	}
 
@@ -1164,7 +1160,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	err = dev_get_valid_name(net, dev, newname);
 	if (err < 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return err;
 	}
 
@@ -1179,11 +1175,11 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	if (ret) {
 		memcpy(dev->name, oldname, IFNAMSIZ);
 		dev->name_assign_type = old_assign_type;
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return ret;
 	}
 
-	write_seqcount_end(&devnet_rename_seq);
+	up_write(&devnet_rename_sem);
 
 	netdev_adjacent_rename_links(dev, oldname);
 
@@ -1204,7 +1200,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 		/* err >= 0 after dev_alloc_name() or stores the first errno */
 		if (err >= 0) {
 			err = ret;
-			write_seqcount_begin(&devnet_rename_seq);
+			down_write(&devnet_rename_sem);
 			memcpy(dev->name, oldname, IFNAMSIZ);
 			memcpy(oldname, newname, IFNAMSIZ);
 			dev->name_assign_type = old_assign_type;
-- 
2.25.1

