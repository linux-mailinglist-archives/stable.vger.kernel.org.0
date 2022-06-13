Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5163B549062
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355970AbiFMLre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356781AbiFMLpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF0E46;
        Mon, 13 Jun 2022 03:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20B0B80E56;
        Mon, 13 Jun 2022 10:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD56C34114;
        Mon, 13 Jun 2022 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117471;
        bh=Swyo9kPE4Q9+YBx8+848IwPjmWR8lTv5QeR8J+CHChA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqRvotWlTO5DjzMoFEL9Ub8jbswqqJA+z44mekK31zl568xDJhEHRcT1eFf2/JD+e
         86ZQrpQ7uVqlYRpJEmAx250qiieabcEA1rBnT/nfsfpwj/RXSuIGshIGTToJ0i7kU1
         xPCznI2hPSuOTOrgVfF4TJT06HY/Ote5vFUuLpv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Hao Luo <haoluo@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 383/411] kernfs: Separate kernfs_pr_cont_buf and rename_lock.
Date:   Mon, 13 Jun 2022 12:10:56 +0200
Message-Id: <20220613094940.149851134@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7d4af6cea2a6..99ee657596b5 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -19,7 +19,15 @@
 
 DEFINE_MUTEX(kernfs_mutex);
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
@@ -870,13 +878,12 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 
 	lockdep_assert_held(&kernfs_mutex);
 
-	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
-	spin_lock_irq(&kernfs_rename_lock);
+	spin_lock_irq(&kernfs_pr_cont_lock);
 
 	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
 	if (len >= sizeof(kernfs_pr_cont_buf)) {
-		spin_unlock_irq(&kernfs_rename_lock);
+		spin_unlock_irq(&kernfs_pr_cont_lock);
 		return NULL;
 	}
 
@@ -888,7 +895,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 		parent = kernfs_find_ns(parent, name, ns);
 	}
 
-	spin_unlock_irq(&kernfs_rename_lock);
+	spin_unlock_irq(&kernfs_pr_cont_lock);
 
 	return parent;
 }
-- 
2.35.1



