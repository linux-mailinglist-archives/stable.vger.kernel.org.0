Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE03C9C3E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 11:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbhGOJ6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 05:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhGOJ6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 05:58:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8FDC06175F;
        Thu, 15 Jul 2021 02:55:58 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c1so867136pfc.13;
        Thu, 15 Jul 2021 02:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VcnGkjDZFa8z0H/fggAeDFo4mkozyR5aRNl6timG9I=;
        b=oISZ+O/WWt543Ed43W2IohbTV1yUPNp0CtZrrUtxpvBVEAY2TdOMTHRZIeF/9e0C1D
         fMHbiwlZj/ODS1ryPMEQUBz1Vo/aNMhxtxTEXre+3cRT4SJHShZz82k7h5rTEhL9gl3t
         EIqo8n98FgGELG3121jKgii+RXAxAb+9SfWHmdiY+QCWH8HpSIDz5Ww3FlgL1Q9jzeih
         3FmFY1p1DPtFgq16EO+FchS6R0GeZ6a1igY6z2Cu14+X7ri+OHr/fVEL8RJMyrT85A4k
         9YoVcvUbTLgmzJGEf5Fj0cv/h6C1H1gjOgjzk2UCZ1u/D1LlTpFzWTw0AGf+6fINeal4
         9yEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3VcnGkjDZFa8z0H/fggAeDFo4mkozyR5aRNl6timG9I=;
        b=Qt3XxaEcKRbmneYtWcBWTRxlm1ykQBbDzLgJo/ZwO9dTRMc4M15hAZHlGaPF4UoDx6
         xReMgfA3PxQLufDfYK4qlhXl/75Nj4mwCHgKxJlSQp7cpPFLmTkOZt72EroQxFeukIhB
         ttXeEavzbXXWxB+5BIT1jzp0mHnYtnoleOMdm8M8GqcE7+dkwgpyAB6TGD+AnpgozlGg
         JLBz1DCgJlOsnmsmwzivSe1HdXupCKi1muaE0IU9UHHJe8U4RlHiaU5+4Wm8j7oO2I5A
         +hinMJy/pebWdKZ9jfaTlW3O7HpsbqXoxbcM8FTG6GuE8OsZTImDvLRFdbxvFqjl25WD
         yfHw==
X-Gm-Message-State: AOAM533/eZcEUREfcZCbazqvnrZTWfId/1X0acVALJvBRNVf6z0qdiEd
        3Y7neVNLz3qL8XIBoOii4UE=
X-Google-Smtp-Source: ABdhPJxuLPDHjlUiZJPc4bl93iXRU5GbhIn2tKLDR2FHP9F2zEeWq1LWqYuEdiDoDXUJttfcv/80Ew==
X-Received: by 2002:a63:5345:: with SMTP id t5mr3750092pgl.167.1626342958050;
        Thu, 15 Jul 2021 02:55:58 -0700 (PDT)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id p3sm6561290pgi.20.2021.07.15.02.55.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jul 2021 02:55:57 -0700 (PDT)
From:   Kevin Hao <haokexin@gmail.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] cpufreq: schedutil: Use kobject release() method to free sugov_tunables
Date:   Thu, 15 Jul 2021 17:53:37 +0800
Message-Id: <20210715095337.19453-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The struct sugov_tunables is protected by the kobject, so we can't free
it directly. Otherwise we would get a call trace like this:
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x30
  WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
  Modules linked in:
  CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-next-20210715-yocto-standard+ #507
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
  pc : debug_print_object+0xb8/0x100
  lr : debug_print_object+0xb8/0x100
  sp : ffff80001ecaf910
  x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
  x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
  x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
  x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
  x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
  x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
  x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
  x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
  x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
  x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
  Call trace:
   debug_print_object+0xb8/0x100
   __debug_check_no_obj_freed+0x1c0/0x230
   debug_check_no_obj_freed+0x20/0x88
   slab_free_freelist_hook+0x154/0x1c8
   kfree+0x114/0x5d0
   sugov_exit+0xbc/0xc0
   cpufreq_exit_governor+0x44/0x90
   cpufreq_set_policy+0x268/0x4a8
   store_scaling_governor+0xe0/0x128
   store+0xc0/0xf0
   sysfs_kf_write+0x54/0x80
   kernfs_fop_write_iter+0x128/0x1c0
   new_sync_write+0xf0/0x190
   vfs_write+0x2d4/0x478
   ksys_write+0x74/0x100
   __arm64_sys_write+0x24/0x30
   invoke_syscall.constprop.0+0x54/0xe0
   do_el0_svc+0x64/0x158
   el0_svc+0x2c/0xb0
   el0t_64_sync_handler+0xb0/0xb8
   el0t_64_sync+0x198/0x19c
  irq event stamp: 5518
  hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock+0x554/0x6c8
  hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0xa0
  softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0x4d0/0x6c0
  softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0/0x1b8

So add a release() method for sugov_tunables_ktype to release the
sugov_tunables safely.

Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 kernel/sched/cpufreq_schedutil.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 57124614363d..ac171496da4b 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -537,9 +537,17 @@ static struct attribute *sugov_attrs[] = {
 };
 ATTRIBUTE_GROUPS(sugov);
 
+static void sugov_tunables_free(struct kobject *kobj)
+{
+	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
+
+	kfree(to_sugov_tunables(attr_set));
+}
+
 static struct kobj_type sugov_tunables_ktype = {
 	.default_groups = sugov_groups,
 	.sysfs_ops = &governor_sysfs_ops,
+	.release = &sugov_tunables_free,
 };
 
 /********************** cpufreq governor interface *********************/
@@ -639,14 +647,6 @@ static struct sugov_tunables *sugov_tunables_alloc(struct sugov_policy *sg_polic
 	return tunables;
 }
 
-static void sugov_tunables_free(struct sugov_tunables *tunables)
-{
-	if (!have_governor_per_policy())
-		global_tunables = NULL;
-
-	kfree(tunables);
-}
-
 static int sugov_init(struct cpufreq_policy *policy)
 {
 	struct sugov_policy *sg_policy;
@@ -707,7 +707,8 @@ static int sugov_init(struct cpufreq_policy *policy)
 fail:
 	kobject_put(&tunables->attr_set.kobj);
 	policy->governor_data = NULL;
-	sugov_tunables_free(tunables);
+	if (!have_governor_per_policy())
+		global_tunables = NULL;
 
 stop_kthread:
 	sugov_kthread_stop(sg_policy);
@@ -733,8 +734,8 @@ static void sugov_exit(struct cpufreq_policy *policy)
 
 	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
 	policy->governor_data = NULL;
-	if (!count)
-		sugov_tunables_free(tunables);
+	if (!count && !have_governor_per_policy())
+		global_tunables = NULL;
 
 	mutex_unlock(&global_tunables_lock);
 
-- 
2.31.1

