Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF993A072
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 17:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFHP3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 11:29:07 -0400
Received: from terminus.zytor.com ([198.137.202.136]:54009 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfFHP3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 11:29:07 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x58FSwk73028663
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 8 Jun 2019 08:28:59 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x58FSwk73028663
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1560007739;
        bh=KYTIx/H4anELnJtDKLUtS+cMS/Od2jw4KvGLBvOTeQQ=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=uKc9n070Tgq82O+VM23JqPtqQfES4zShajTiZ4oZHs2Uyt4zM5O7OGrn4ueELQ2GO
         VwegGXk332QbwDHCbMcARp6bKZ2M9KNrpjh/wWuiLh5qVZhnvF334T6RzlLOWavPfq
         cgcuXHmUBlZsQsJo5C+WsGUKGob131EPzQaMrfgKsLljkT8UdQycLrkjr1G7guRwES
         HheOsEDlcSlH6ZirnK6xZRxssNDMIos9TiI73dNQZv1Ez+fxjTSSAht+MEAOz7ncHm
         LGwBXmMGy0Gzz/05k3wwhdf5O/ULavtgf1Y9BDb7niRIPBSmbDRLoiqaVV5dP5sQgH
         S54dIthih5EGw==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x58FSwai3028660;
        Sat, 8 Jun 2019 08:28:58 -0700
Date:   Sat, 8 Jun 2019 08:28:58 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Cong Wang <tipbot@zytor.com>
Message-ID: <tip-0ade0b6240c4853cf9725924c46c10f4251639d7@git.kernel.org>
Cc:     xiyou.wangcong@gmail.com, linux-edac@vger.kernel.org, bp@suse.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        tony.luck@intel.com, hpa@zytor.com, stable@vger.kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, tony.luck@intel.com,
          linux-kernel@vger.kernel.org, bp@suse.de,
          linux-edac@vger.kernel.org, xiyou.wangcong@gmail.com,
          tglx@linutronix.de, stable@vger.kernel.org, hpa@zytor.com
In-Reply-To: <20190416213351.28999-2-xiyou.wangcong@gmail.com>
References: <20190416213351.28999-2-xiyou.wangcong@gmail.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:ras/urgent] RAS/CEC: Convert the timer callback to a workqueue
Git-Commit-ID: 0ade0b6240c4853cf9725924c46c10f4251639d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_96_Q,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  0ade0b6240c4853cf9725924c46c10f4251639d7
Gitweb:     https://git.kernel.org/tip/0ade0b6240c4853cf9725924c46c10f4251639d7
Author:     Cong Wang <xiyou.wangcong@gmail.com>
AuthorDate: Tue, 16 Apr 2019 14:33:51 -0700
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 7 Jun 2019 23:21:39 +0200

RAS/CEC: Convert the timer callback to a workqueue

cec_timer_fn() is a timer callback which reads ce_arr.array[] and
updates its decay values. However, it runs in interrupt context and the
mutex protection the CEC uses for that array, is inadequate. Convert the
used timer to a workqueue to keep the tasks the CEC performs preemptible
and thus low-prio.

 [ bp: Rewrite commit message.
   s/timer/decay/gi to make it agnostic as to what facility is used. ]

Fixes: 011d82611172 ("RAS: Add a Corrected Errors Collector")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190416213351.28999-2-xiyou.wangcong@gmail.com
---
 drivers/ras/cec.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index dbfe3e61d2c2..673f8a128397 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/workqueue.h>
 
 #include <asm/mce.h>
 
@@ -123,16 +124,12 @@ static u64 dfs_pfn;
 /* Amount of errors after which we offline */
 static unsigned int count_threshold = COUNT_MASK;
 
-/*
- * The timer "decays" element count each timer_interval which is 24hrs by
- * default.
- */
-
-#define CEC_TIMER_DEFAULT_INTERVAL	24 * 60 * 60	/* 24 hrs */
-#define CEC_TIMER_MIN_INTERVAL		 1 * 60 * 60	/* 1h */
-#define CEC_TIMER_MAX_INTERVAL	   30 *	24 * 60 * 60	/* one month */
-static struct timer_list cec_timer;
-static u64 timer_interval = CEC_TIMER_DEFAULT_INTERVAL;
+/* Each element "decays" each decay_interval which is 24hrs by default. */
+#define CEC_DECAY_DEFAULT_INTERVAL	24 * 60 * 60	/* 24 hrs */
+#define CEC_DECAY_MIN_INTERVAL		 1 * 60 * 60	/* 1h */
+#define CEC_DECAY_MAX_INTERVAL	   30 *	24 * 60 * 60	/* one month */
+static struct delayed_work cec_work;
+static u64 decay_interval = CEC_DECAY_DEFAULT_INTERVAL;
 
 /*
  * Decrement decay value. We're using DECAY_BITS bits to denote decay of an
@@ -160,20 +157,21 @@ static void do_spring_cleaning(struct ce_array *ca)
 /*
  * @interval in seconds
  */
-static void cec_mod_timer(struct timer_list *t, unsigned long interval)
+static void cec_mod_work(unsigned long interval)
 {
 	unsigned long iv;
 
-	iv = interval * HZ + jiffies;
-
-	mod_timer(t, round_jiffies(iv));
+	iv = interval * HZ;
+	mod_delayed_work(system_wq, &cec_work, round_jiffies(iv));
 }
 
-static void cec_timer_fn(struct timer_list *unused)
+static void cec_work_fn(struct work_struct *work)
 {
+	mutex_lock(&ce_mutex);
 	do_spring_cleaning(&ce_arr);
+	mutex_unlock(&ce_mutex);
 
-	cec_mod_timer(&cec_timer, timer_interval);
+	cec_mod_work(decay_interval);
 }
 
 /*
@@ -380,15 +378,15 @@ static int decay_interval_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
 
-	if (val < CEC_TIMER_MIN_INTERVAL)
+	if (val < CEC_DECAY_MIN_INTERVAL)
 		return -EINVAL;
 
-	if (val > CEC_TIMER_MAX_INTERVAL)
+	if (val > CEC_DECAY_MAX_INTERVAL)
 		return -EINVAL;
 
-	timer_interval = val;
+	decay_interval = val;
 
-	cec_mod_timer(&cec_timer, timer_interval);
+	cec_mod_work(decay_interval);
 	return 0;
 }
 DEFINE_DEBUGFS_ATTRIBUTE(decay_interval_ops, u64_get, decay_interval_set, "%lld\n");
@@ -432,7 +430,7 @@ static int array_dump(struct seq_file *m, void *v)
 
 	seq_printf(m, "Flags: 0x%x\n", ca->flags);
 
-	seq_printf(m, "Timer interval: %lld seconds\n", timer_interval);
+	seq_printf(m, "Decay interval: %lld seconds\n", decay_interval);
 	seq_printf(m, "Decays: %lld\n", ca->decays_done);
 
 	seq_printf(m, "Action threshold: %d\n", count_threshold);
@@ -478,7 +476,7 @@ static int __init create_debugfs_nodes(void)
 	}
 
 	decay = debugfs_create_file("decay_interval", S_IRUSR | S_IWUSR, d,
-				    &timer_interval, &decay_interval_ops);
+				    &decay_interval, &decay_interval_ops);
 	if (!decay) {
 		pr_warn("Error creating decay_interval debugfs node!\n");
 		goto err;
@@ -514,8 +512,8 @@ void __init cec_init(void)
 	if (create_debugfs_nodes())
 		return;
 
-	timer_setup(&cec_timer, cec_timer_fn, 0);
-	cec_mod_timer(&cec_timer, CEC_TIMER_DEFAULT_INTERVAL);
+	INIT_DELAYED_WORK(&cec_work, cec_work_fn);
+	schedule_delayed_work(&cec_work, CEC_DECAY_DEFAULT_INTERVAL);
 
 	pr_info("Correctable Errors collector initialized.\n");
 }
