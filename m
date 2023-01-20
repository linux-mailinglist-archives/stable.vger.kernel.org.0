Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EE3674AA3
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 05:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjATEci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 23:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjATEbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 23:31:53 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DB7B4E31
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 20:31:39 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 203so1938607iou.13
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 20:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XRmkPKwVNodMUxYXDh8gPHDaU3z0szyk7eBiYasB2kc=;
        b=lWGrxRUFjfydaClXFfKMHfGYkVdqSBVh38g0A9zp2da7mNEjWQxU01P4BNvzPkqdyb
         BYik6oz0+5lexbuEgEYASKwM7uTMaquiM7X0GUyWv3MwtK+Sx5PyR74+v7jwlrd05Zlb
         sv1wP8Iu2ymWrwUOx7Qzdx9MWweXkBLWakaW5X4bYj6MsZCQfDsdZkdH05HXwH+efkWZ
         m91Vz5ESEsNTrTGrUdtwpFh+86KxOUbHx4qaaQyF+Z3Z7quzzkyXiVxwz+80G+XD2pjk
         OBEmOe2/w0LL/vqkPJQdwvg64EEJ/rwp+qGF737AtEBWjRDiWIjk0pWnSUhYO+Rc7Q6Y
         Tu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XRmkPKwVNodMUxYXDh8gPHDaU3z0szyk7eBiYasB2kc=;
        b=NW7dUi6kO3MC+xUWkJPQmiTyRuCeWM6esChZH8LR/WngTsvZJCIHZOREtQrLGNz0ZE
         XEZpzBaejP210j9aUHDa2K+d6PKi4wlsK8hoTfccOFSR8bvBe+3Mj8BM8QhQOGUc6IxT
         gqaIsTrV/6V/OleFPZx0pmXj0kmgPTTjse9RT2WFEHH12ZdsTNkH2XAlZ7VcVMvpwjN8
         KUX9toIO1I7NsTN4xY2msxWcRbP87wf0sdjPnHqUfn9MadAUzxHipTP3+lCi0U+HsduW
         CtxfwlkAFbfzVnigE7r/0ntbTisKe4skV5B+rrZSwmDFoE6W+UhbpsQTBztuwZB492UU
         Uncw==
X-Gm-Message-State: AFqh2kqnWykwZOw17YwE5Oq9ZJgKz2zwGzhTW7VQjZl43j0lzFXgnqAu
        KAavRqBPiH7DwL8IPFlJGCP+IXzdPIU=
X-Google-Smtp-Source: AMrXdXsPWWXF/fTE8f462/38O9Rx9ZJ5IvpQsZPuR9wxylGKY4dmyZ3H4nE7i25A3e29tXWfLUbMUw==
X-Received: by 2002:a05:6602:96:b0:6de:9711:9962 with SMTP id h22-20020a056602009600b006de97119962mr8788220iob.5.1674189098555;
        Thu, 19 Jan 2023 20:31:38 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id y88-20020a029561000000b0039e2e4c82c8sm12082402jah.123.2023.01.19.20.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 20:31:37 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15] cpufreq: governor: Use kobject release() method to free dbs_data
Date:   Fri, 20 Jan 2023 12:26:50 +0800
Message-Id: <20230120042650.3722921-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a85ee6401a47ae3fc64ba506cacb3e7873823c65 upstream.

The struct dbs_data embeds a struct gov_attr_set and
the struct gov_attr_set embeds a kobject. Since every kobject must have
a release() method and we can't use kfree() to free it directly,
so introduce cpufreq_dbs_data_release() to release the dbs_data via
the kobject::release() method. This fixes the calltrace like below:

  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x34
  WARNING: CPU: 12 PID: 810 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
  Modules linked in:
  CPU: 12 PID: 810 Comm: sh Not tainted 5.16.0-next-20220120-yocto-standard+ #536
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : debug_print_object+0xb8/0x100
  lr : debug_print_object+0xb8/0x100
  sp : ffff80001dfcf9a0
  x29: ffff80001dfcf9a0 x28: 0000000000000001 x27: ffff0001464f0000
  x26: 0000000000000000 x25: ffff8000090e3f00 x24: ffff80000af60210
  x23: ffff8000094dfb78 x22: ffff8000090e3f00 x21: ffff0001080b7118
  x20: ffff80000aeb2430 x19: ffff800009e8f5e0 x18: 0000000000000000
  x17: 0000000000000002 x16: 00004d62e58be040 x15: 013590470523aff8
  x14: ffff8000090e1828 x13: 0000000001359047 x12: 00000000f5257d14
  x11: 0000000000040591 x10: 0000000066c1ffea x9 : ffff8000080d15e0
  x8 : ffff80000a1765a8 x7 : 0000000000000000 x6 : 0000000000000001
  x5 : ffff800009e8c000 x4 : ffff800009e8c760 x3 : 0000000000000000
  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0001474ed040
  Call trace:
   debug_print_object+0xb8/0x100
   __debug_check_no_obj_freed+0x1d0/0x25c
   debug_check_no_obj_freed+0x24/0xa0
   kfree+0x11c/0x440
   cpufreq_dbs_governor_exit+0xa8/0xac
   cpufreq_exit_governor+0x44/0x90
   cpufreq_set_policy+0x29c/0x570
   store_scaling_governor+0x110/0x154
   store+0xb0/0xe0
   sysfs_kf_write+0x58/0x84
   kernfs_fop_write_iter+0x12c/0x1c0
   new_sync_write+0xf0/0x18c
   vfs_write+0x1cc/0x220
   ksys_write+0x74/0x100
   __arm64_sys_write+0x28/0x3c
   invoke_syscall.constprop.0+0x58/0xf0
   do_el0_svc+0x70/0x170
   el0_svc+0x54/0x190
   el0t_64_sync_handler+0xa4/0x130
   el0t_64_sync+0x1a0/0x1a4
  irq event stamp: 189006
  hardirqs last  enabled at (189005): [<ffff8000080849d0>] finish_task_switch.isra.0+0xe0/0x2c0
  hardirqs last disabled at (189006): [<ffff8000090667a4>] el1_dbg+0x24/0xa0
  softirqs last  enabled at (188966): [<ffff8000080106d0>] __do_softirq+0x4b0/0x6a0
  softirqs last disabled at (188957): [<ffff80000804a618>] __irq_exit_rcu+0x108/0x1a4

[ rjw: Because can be freed by the gov_attr_set_put() in
  cpufreq_dbs_governor_exit() now, it is also necessary to put the
  invocation of the governor ->exit() callback into the new
  cpufreq_dbs_data_release() function. ]

Fixes: c4435630361d ("cpufreq: governor: New sysfs show/store callbacks for governor tunables")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
Hi,

The original upstream patch has the Fixes tag, but I have no idea why it
wasn't picked up by the 5.15 stable kernel. So resend it to the linux stable.
The original upstream patch can apply to the 5.15.y kernel cleanly.

 drivers/cpufreq/cpufreq_governor.c | 20 +++++++++++++-------
 drivers/cpufreq/cpufreq_governor.h |  1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 63f7c219062b..55c80319d268 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -388,6 +388,15 @@ static void free_policy_dbs_info(struct policy_dbs_info *policy_dbs,
 	gov->free(policy_dbs);
 }
 
+static void cpufreq_dbs_data_release(struct kobject *kobj)
+{
+	struct dbs_data *dbs_data = to_dbs_data(to_gov_attr_set(kobj));
+	struct dbs_governor *gov = dbs_data->gov;
+
+	gov->exit(dbs_data);
+	kfree(dbs_data);
+}
+
 int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 {
 	struct dbs_governor *gov = dbs_governor_of(policy);
@@ -425,6 +434,7 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 		goto free_policy_dbs_info;
 	}
 
+	dbs_data->gov = gov;
 	gov_attr_set_init(&dbs_data->attr_set, &policy_dbs->list);
 
 	ret = gov->init(dbs_data);
@@ -447,6 +457,7 @@ int cpufreq_dbs_governor_init(struct cpufreq_policy *policy)
 	policy->governor_data = policy_dbs;
 
 	gov->kobj_type.sysfs_ops = &governor_sysfs_ops;
+	gov->kobj_type.release = cpufreq_dbs_data_release;
 	ret = kobject_init_and_add(&dbs_data->attr_set.kobj, &gov->kobj_type,
 				   get_governor_parent_kobj(policy),
 				   "%s", gov->gov.name);
@@ -488,13 +499,8 @@ void cpufreq_dbs_governor_exit(struct cpufreq_policy *policy)
 
 	policy->governor_data = NULL;
 
-	if (!count) {
-		if (!have_governor_per_policy())
-			gov->gdbs_data = NULL;
-
-		gov->exit(dbs_data);
-		kfree(dbs_data);
-	}
+	if (!count && !have_governor_per_policy())
+		gov->gdbs_data = NULL;
 
 	free_policy_dbs_info(policy_dbs, gov);
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index bab8e6140377..a6de26318abb 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -37,6 +37,7 @@ enum {OD_NORMAL_SAMPLE, OD_SUB_SAMPLE};
 /* Governor demand based switching data (per-policy or global). */
 struct dbs_data {
 	struct gov_attr_set attr_set;
+	struct dbs_governor *gov;
 	void *tuners;
 	unsigned int ignore_nice_load;
 	unsigned int sampling_rate;
-- 
2.38.1

