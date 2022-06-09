Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4451354424F
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 06:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiFIEEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 00:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiFIEEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 00:04:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656731A1944
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 21:04:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso25603769pjl.3
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 21:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zY5mFinMaMydRM+H9UjtKkuWSUe8T7k3YskeQQPjglc=;
        b=5pcuzgGc3KBBFq/TL1YCOhhPlIrvGxqmJS9pDZOYdOG1VGHxT+uZqf9JOa/4l1K6X5
         092+6X4ZZO+JXbC4846duJGZd5Wq/uOAFkUeq2NAJ2U6oXcxvor25M8/SfcMktkETzH/
         VUgKoR43Ka+v5PDqZYzLlChYpe24PNasEDGR9GsJepygHa7n0+SCzVXSIuGBxxHwFM6l
         dngHYNvRBLMCxY5jYSBB4eAtY1IUsdAOZJNY7GNU7+aBOdX01+Jdp+vktzgtWKmb5saH
         0NUlHFKxQzknqYr/D26kG/DXegbR0aA6vk/0i+YgfrR7aXTAO9qy0t/ykINGPvQwmZtQ
         /RlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zY5mFinMaMydRM+H9UjtKkuWSUe8T7k3YskeQQPjglc=;
        b=ICnu2xPSDJ7PYHrYbS9T1ynpvAhuwfHoHfBmnOkI4DUYQAEvAfDU+FtILTQE24aKkP
         QuTSMiD5CYHnJ2ZWpuN2JgK5zotKbhzZp8FmtJTmGmTaLuF3oWKc+2p/+bqAIlXW/WU4
         8Gq5lvI/IM+U0YoNuJOwdh2UQ+F22ArXAhhm9CeibZfDQjTEUk+W08WZkPcTxGMMVKUm
         aN0tNgzlHDVhRbt2DriwqZKoybzccnrRREILaTK6JCc2VAg5PUD1iaZ0v5LAY0Lfw9ku
         CfHssP4VOfGWNBIXqUYWLW4aVbclNZpFSa1QuQowtDbzdiJHE6Onc2DQj/49LYAexvwa
         XBtA==
X-Gm-Message-State: AOAM5301rhAHkkX1I4a6myvUegUeDHgTZewlGRuxyR9Dfhvm0q5g+vDI
        2RpkPrHGAORQm52o8h++pvS+Sg==
X-Google-Smtp-Source: ABdhPJwLD5D90RbLdd1NhQp9diUE2EhXlyXUqaO7S6k3tR7O5xwtfMN8z7LwN9K2fHURcGSStMdhCA==
X-Received: by 2002:a17:903:228c:b0:163:baf6:582a with SMTP id b12-20020a170903228c00b00163baf6582amr37184890plh.43.1654747481887;
        Wed, 08 Jun 2022 21:04:41 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902e84500b00163ffe73300sm15887049plg.137.2022.06.08.21.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 21:04:41 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com,
        akpm@linux-foundation.org, vbabka@suse.cz,
        mgorman@techsingularity.net, peterz@infradead.org,
        dhowells@redhat.com, willy@infradead.org, Liam.Howlett@Oracle.com,
        kemi.wang@intel.com, mhocko@suse.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>,
        stable@vger.kernel.org
Subject: [PATCH] mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE
Date:   Thu,  9 Jun 2022 12:03:42 +0800
Message-Id: <20220609040342.2703-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"numa_stat" should not be included in the scope of CONFIG_HUGETLB_PAGE,
if CONFIG_HUGETLB_PAGE is not configured even if CONFIG_NUMA is configured,
"numa_stat" is missed form /proc.  Remove it out of CONFIG_HUGETLB_PAGE
and move numa_stat sysctl handling to mm/vmstat.c.

Fixes: 4518085e127d ("mm, sysctl: make NUMA stats configurable")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/vmstat.h |  5 -----
 kernel/sysctl.c        |  9 ---------
 mm/vmstat.c            | 52 +++++++++++++++++++++++++-------------------------
 3 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index bfe38869498d..1297a6b8ba23 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -13,12 +13,7 @@
 extern int sysctl_stat_interval;
 
 #ifdef CONFIG_NUMA
-#define ENABLE_NUMA_STAT   1
-#define DISABLE_NUMA_STAT   0
-extern int sysctl_vm_numa_stat;
 DECLARE_STATIC_KEY_TRUE(vm_numa_stat_key);
-int sysctl_vm_numa_stat_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos);
 #endif
 
 struct reclaim_stat {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e52b6e372c60..3d6f36f230bb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2107,15 +2107,6 @@ static struct ctl_table vm_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
 	},
-	{
-		.procname		= "numa_stat",
-		.data			= &sysctl_vm_numa_stat,
-		.maxlen			= sizeof(int),
-		.mode			= 0644,
-		.proc_handler	= sysctl_vm_numa_stat_handler,
-		.extra1			= SYSCTL_ZERO,
-		.extra2			= SYSCTL_ONE,
-	},
 #endif
 	 {
 		.procname	= "hugetlb_shm_group",
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 373d2730fcf2..e10afbee888e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -33,8 +33,6 @@
 #include "internal.h"
 
 #ifdef CONFIG_NUMA
-int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
-
 /* zero numa counters within a zone */
 static void zero_zone_numa_counters(struct zone *zone)
 {
@@ -73,35 +71,37 @@ static void invalid_numa_statistics(void)
 	zero_global_numa_counters();
 }
 
-static DEFINE_MUTEX(vm_numa_stat_lock);
-
-int sysctl_vm_numa_stat_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
+static int sysctl_numa_stat_handler(struct ctl_table *table, int write,
+				    void *buffer, size_t *length, loff_t *ppos)
 {
-	int ret, oldval;
+	int ret;
+	struct static_key *key = table->data;
+	static DEFINE_MUTEX(lock);
 
-	mutex_lock(&vm_numa_stat_lock);
-	if (write)
-		oldval = sysctl_vm_numa_stat;
-	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (ret || !write)
-		goto out;
-
-	if (oldval == sysctl_vm_numa_stat)
-		goto out;
-	else if (sysctl_vm_numa_stat == ENABLE_NUMA_STAT) {
-		static_branch_enable(&vm_numa_stat_key);
-		pr_info("enable numa statistics\n");
-	} else {
-		static_branch_disable(&vm_numa_stat_key);
+	mutex_lock(&lock);
+	ret = proc_do_static_key(table, write, buffer, length, ppos);
+	if (!ret && write && !static_key_enabled(key))
 		invalid_numa_statistics();
-		pr_info("disable numa statistics, and clear numa counters\n");
-	}
-
-out:
-	mutex_unlock(&vm_numa_stat_lock);
+	mutex_unlock(&lock);
 	return ret;
 }
+
+static struct ctl_table numa_stat_sysctl[] = {
+	{
+		.procname	= "numa_stat",
+		.data		= &vm_numa_stat_key.key,
+		.mode		= 0644,
+		.proc_handler	= sysctl_numa_stat_handler,
+	},
+	{ }
+};
+
+static int __init numa_stat_sysctl_init(void)
+{
+	register_sysctl_init("vm", numa_stat_sysctl);
+	return 0;
+}
+late_initcall(numa_stat_sysctl_init);
 #endif
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
-- 
2.11.0

