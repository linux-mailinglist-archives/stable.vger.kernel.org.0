Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68B12F008
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgABWYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgABWYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8804D20863;
        Thu,  2 Jan 2020 22:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003851;
        bh=ahhPLmHnpeiZ5zIMVY1mHLBA2HgPkgXBFbDu4dmrIR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZDWA9FmMfQuuUnvl+R93EK8pvXpcaMdFPy7XKDGDKi09Ngy9v77H49sGEnztqAh+
         tqTBhjNVdR5nmNyjaAcc3J7H579ODYUlvqoRU69TbUajVYJXP7Xk7PtPwLzVlf87d0
         It+bFfJo1xLMMP0YvVGKdhVdL21Bzsw/wMzIk+MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/91] fs/quota: handle overflows of sysctl fs.quota.* and report as unsigned long
Date:   Thu,  2 Jan 2020 23:07:07 +0100
Message-Id: <20200102220425.643813788@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit 6fcbcec9cfc7b3c6a2c1f1a23ebacedff7073e0a ]

Quota statistics counted as 64-bit per-cpu counter. Reading sums per-cpu
fractions as signed 64-bit int, filters negative values and then reports
lower half as signed 32-bit int.

Result may looks like:

fs.quota.allocated_dquots = 22327
fs.quota.cache_hits = -489852115
fs.quota.drops = -487288718
fs.quota.free_dquots = 22083
fs.quota.lookups = -486883485
fs.quota.reads = 22327
fs.quota.syncs = 335064
fs.quota.writes = 3088689

Values bigger than 2^31-1 reported as negative.

All counters except "allocated_dquots" and "free_dquots" are monotonic,
thus they should be reported as is without filtering negative values.

Kernel doesn't have generic helper for 64-bit sysctl yet,
let's use at least unsigned long.

Link: https://lore.kernel.org/r/157337934693.2078.9842146413181153727.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c      | 29 +++++++++++++++++------------
 include/linux/quota.h |  2 +-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 3254c90fd899..3fdbdd29702b 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2849,68 +2849,73 @@ EXPORT_SYMBOL(dquot_quotactl_sysfile_ops);
 static int do_proc_dqstats(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	unsigned int type = (int *)table->data - dqstats.stat;
+	unsigned int type = (unsigned long *)table->data - dqstats.stat;
+	s64 value = percpu_counter_sum(&dqstats.counter[type]);
+
+	/* Filter negative values for non-monotonic counters */
+	if (value < 0 && (type == DQST_ALLOC_DQUOTS ||
+			  type == DQST_FREE_DQUOTS))
+		value = 0;
 
 	/* Update global table */
-	dqstats.stat[type] =
-			percpu_counter_sum_positive(&dqstats.counter[type]);
-	return proc_dointvec(table, write, buffer, lenp, ppos);
+	dqstats.stat[type] = value;
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 
 static struct ctl_table fs_dqstats_table[] = {
 	{
 		.procname	= "lookups",
 		.data		= &dqstats.stat[DQST_LOOKUPS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "drops",
 		.data		= &dqstats.stat[DQST_DROPS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "reads",
 		.data		= &dqstats.stat[DQST_READS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "writes",
 		.data		= &dqstats.stat[DQST_WRITES],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "cache_hits",
 		.data		= &dqstats.stat[DQST_CACHE_HITS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "allocated_dquots",
 		.data		= &dqstats.stat[DQST_ALLOC_DQUOTS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "free_dquots",
 		.data		= &dqstats.stat[DQST_FREE_DQUOTS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
 	{
 		.procname	= "syncs",
 		.data		= &dqstats.stat[DQST_SYNCS],
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0444,
 		.proc_handler	= do_proc_dqstats,
 	},
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 5ac9de4fcd6f..aa9a42eceab0 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -263,7 +263,7 @@ enum {
 };
 
 struct dqstats {
-	int stat[_DQST_DQSTAT_LAST];
+	unsigned long stat[_DQST_DQSTAT_LAST];
 	struct percpu_counter counter[_DQST_DQSTAT_LAST];
 };
 
-- 
2.20.1



