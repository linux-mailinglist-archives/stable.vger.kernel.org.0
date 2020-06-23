Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADCB2061BE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgFWUuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392963AbgFWUt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 730FB217A0;
        Tue, 23 Jun 2020 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945367;
        bh=MfHV6n29EQkpR0iW3A+P0eGP/4sOVVAR6DlSWS+zrhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iX82BPOgICXmBHottmDyNzs75JhFSYXo3X4Xte32yF9NHoUM1gso1FnOXSceJAOvV
         yG16AeOzKkBGWVpcjynW274MWKhteLT3ASWDWbOjERyIV+K22ICyxIn1yY9F6NI/Q0
         W8nO+TLUS1qRPXfxcvL7ll5Wx4liMB95zM0ikUzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 136/136] net: core: device_rename: Use rwsem instead of a seqcount
Date:   Tue, 23 Jun 2020 21:59:52 +0200
Message-Id: <20200623195310.673383038@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

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
index 9e4a00462f5c7..0aaa1426450fa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -83,6 +83,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/socket.h>
@@ -194,7 +195,7 @@ static DEFINE_SPINLOCK(napi_hash_lock);
 static unsigned int napi_gen_id = NR_CPUS;
 static DEFINE_READ_MOSTLY_HASHTABLE(napi_hash, 8);
 
-static seqcount_t devnet_rename_seq;
+static DECLARE_RWSEM(devnet_rename_sem);
 
 static inline void dev_base_seq_inc(struct net *net)
 {
@@ -898,33 +899,28 @@ EXPORT_SYMBOL(dev_get_by_napi_id);
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
@@ -1189,10 +1185,10 @@ int dev_change_name(struct net_device *dev, const char *newname)
 	if (dev->flags & IFF_UP)
 		return -EBUSY;
 
-	write_seqcount_begin(&devnet_rename_seq);
+	down_write(&devnet_rename_sem);
 
 	if (strncmp(newname, dev->name, IFNAMSIZ) == 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return 0;
 	}
 
@@ -1200,7 +1196,7 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	err = dev_get_valid_name(net, dev, newname);
 	if (err < 0) {
-		write_seqcount_end(&devnet_rename_seq);
+		up_write(&devnet_rename_sem);
 		return err;
 	}
 
@@ -1215,11 +1211,11 @@ rollback:
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
 
@@ -1240,7 +1236,7 @@ rollback:
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



