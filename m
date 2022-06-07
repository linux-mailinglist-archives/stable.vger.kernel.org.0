Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0A540C8C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiFGShT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352171AbiFGSdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54117EF79;
        Tue,  7 Jun 2022 10:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54F03617A8;
        Tue,  7 Jun 2022 17:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E2BC34115;
        Tue,  7 Jun 2022 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624645;
        bh=UynMSYX24G6ad7dbw1EFimR4WCvj7HwCVUmxc3/FhBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdymvZeYw2D0LjCJZS+xTIUBa6hBCUtm5s+/uEvJsCu+gBEv+jWasBlLZV+KskVFi
         yWcS3E/iOScs41nJClpPEAZwIkTRm/BwTYqIC7MVHcHLbqEBbKyAsv2Prkav8Y5YFA
         JO5wYpAXAFqHrQmF94kL5xdtmh4/4uWJ/zSBt9gsJX5R6zFouZtyvmPtZXKi7RotKS
         gOOGJf30W3GRVPL8uv5vm5woCCYkT8j66gxo2Uw9flUgtm6Ue3csywZE3ahxhUP5+L
         egEl6IjVDu2ZQv32tLMIl9ZYkGN9X12Nn3kbKZMg8xCEJtfkBnMR1us1yCsdHRY0YN
         erT+kyTWuv2/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 29/51] kernfs: Separate kernfs_pr_cont_buf and rename_lock.
Date:   Tue,  7 Jun 2022 13:55:28 -0400
Message-Id: <20220607175552.479948-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Luo <haoluo@google.com>

[ Upstream commit 1a702dc88e150487c9c173a249b3d236498b9183 ]

Previously the protection of kernfs_pr_cont_buf was piggy backed by
rename_lock, which means that pr_cont() needs to be protected under
rename_lock. This can cause potential circular lock dependencies.

If there is an OOM, we have the following call hierarchy:

 -> cpuset_print_current_mems_allowed()
   -> pr_cont_cgroup_name()
     -> pr_cont_kernfs_name()

pr_cont_kernfs_name() will grab rename_lock and call printk. So we have
the following lock dependencies:

 kernfs_rename_lock -> console_sem

Sometimes, printk does a wakeup before releasing console_sem, which has
the dependence chain:

 console_sem -> p->pi_lock -> rq->lock

Now, imagine one wants to read cgroup_name under rq->lock, for example,
printing cgroup_name in a tracepoint in the scheduler code. They will
be holding rq->lock and take rename_lock:

 rq->lock -> kernfs_rename_lock

Now they will deadlock.

A prevention to this circular lock dependency is to separate the
protection of pr_cont_buf from rename_lock. In principle, rename_lock
is to protect the integrity of cgroup name when copying to buf. Once
pr_cont_buf has got its content, rename_lock can be dropped. So it's
safe to drop rename_lock after kernfs_name_locked (and
kernfs_path_from_node_locked) and rely on a dedicated pr_cont_lock
to protect pr_cont_buf.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
Link: https://lore.kernel.org/r/20220516190951.3144144-1-haoluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 8e0a1378a4b1..7bf1d5fc2e9c 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -19,7 +19,15 @@
 
 DECLARE_RWSEM(kernfs_rwsem);
 static DEFINE_SPINLOCK(kernfs_rename_lock);	/* kn->parent and ->name */
-static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by rename_lock */
+/*
+ * Don't use rename_lock to piggy back on pr_cont_buf. We don't want to
+ * call pr_cont() while holding rename_lock. Because sometimes pr_cont()
+ * will perform wakeups when releasing console_sem. Holding rename_lock
+ * will introduce deadlock if the scheduler reads the kernfs_name in the
+ * wakeup path.
+ */
+static DEFINE_SPINLOCK(kernfs_pr_cont_lock);
+static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by pr_cont_lock */
 static DEFINE_SPINLOCK(kernfs_idr_lock);	/* root->ino_idr */
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
@@ -230,12 +238,12 @@ void pr_cont_kernfs_name(struct kernfs_node *kn)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	kernfs_name_locked(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
+	kernfs_name(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
 	pr_cont("%s", kernfs_pr_cont_buf);
 
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -249,10 +257,10 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	unsigned long flags;
 	int sz;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	sz = kernfs_path_from_node_locked(kn, NULL, kernfs_pr_cont_buf,
-					  sizeof(kernfs_pr_cont_buf));
+	sz = kernfs_path_from_node(kn, NULL, kernfs_pr_cont_buf,
+				   sizeof(kernfs_pr_cont_buf));
 	if (sz < 0) {
 		pr_cont("(error)");
 		goto out;
@@ -266,7 +274,7 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	pr_cont("%s", kernfs_pr_cont_buf);
 
 out:
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -822,13 +830,12 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 
 	lockdep_assert_held_read(&kernfs_rwsem);
 
-	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
-	spin_lock_irq(&kernfs_rename_lock);
+	spin_lock_irq(&kernfs_pr_cont_lock);
 
 	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
 	if (len >= sizeof(kernfs_pr_cont_buf)) {
-		spin_unlock_irq(&kernfs_rename_lock);
+		spin_unlock_irq(&kernfs_pr_cont_lock);
 		return NULL;
 	}
 
@@ -840,7 +847,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 		parent = kernfs_find_ns(parent, name, ns);
 	}
 
-	spin_unlock_irq(&kernfs_rename_lock);
+	spin_unlock_irq(&kernfs_pr_cont_lock);
 
 	return parent;
 }
-- 
2.35.1

