Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CD15DCC1
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbgBNPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbgBNPyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6637B2465D;
        Fri, 14 Feb 2020 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695684;
        bh=kHrVyKQu4EWN7X+O0OX9IdROv4KxjFWl9tyQX76enSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyTR6JGeJBVjr+Lb53+bGATpqUQ40QYomJ5ImiJpxJMxnYEtD/bSYia/aBEI6/XC0
         3EVlcPZ0ECy8epEbrXqFq03r0/VBcM8ELg5f7Yt4pjlfuAoyxF6KnrEO8keuia1Xjw
         abHVRgSGRKk5OTVUYQX0g7QIM7A4OpKLewQFcukU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamil Konieczny <k.konieczny@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 269/542] PM / devfreq: Change time stats to 64-bit
Date:   Fri, 14 Feb 2020 10:44:21 -0500
Message-Id: <20200214154854.6746-269-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamil Konieczny <k.konieczny@samsung.com>

[ Upstream commit b76b3479dab948bea0a98b6d263eb56d8f358528 ]

Change time stats counting to bigger type by using 64-bit jiffies.
This will make devfreq stats code look similar to cpufreq stats and
prevents overflow (for HZ = 1000 after 49.7 days).

Signed-off-by: Kamil Konieczny <k.konieczny@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 14 +++++++-------
 include/linux/devfreq.h   |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 07602083c743e..554d155106a5f 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -209,10 +209,10 @@ static int set_freq_table(struct devfreq *devfreq)
 int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
 {
 	int lev, prev_lev, ret = 0;
-	unsigned long cur_time;
+	u64 cur_time;
 
 	lockdep_assert_held(&devfreq->lock);
-	cur_time = jiffies;
+	cur_time = get_jiffies_64();
 
 	/* Immediately exit if previous_freq is not initialized yet. */
 	if (!devfreq->previous_freq)
@@ -535,7 +535,7 @@ void devfreq_monitor_resume(struct devfreq *devfreq)
 			msecs_to_jiffies(devfreq->profile->polling_ms));
 
 out_update:
-	devfreq->last_stat_updated = jiffies;
+	devfreq->last_stat_updated = get_jiffies_64();
 	devfreq->stop_polling = false;
 
 	if (devfreq->profile->get_cur_freq &&
@@ -820,7 +820,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	devfreq->time_in_state = devm_kcalloc(&devfreq->dev,
 			devfreq->profile->max_state,
-			sizeof(unsigned long),
+			sizeof(*devfreq->time_in_state),
 			GFP_KERNEL);
 	if (!devfreq->time_in_state) {
 		mutex_unlock(&devfreq->lock);
@@ -828,7 +828,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		goto err_devfreq;
 	}
 
-	devfreq->last_stat_updated = jiffies;
+	devfreq->last_stat_updated = get_jiffies_64();
 
 	srcu_init_notifier_head(&devfreq->transition_notifier_list);
 
@@ -1589,8 +1589,8 @@ static ssize_t trans_stat_show(struct device *dev,
 		for (j = 0; j < max_state; j++)
 			len += sprintf(buf + len, "%10u",
 				devfreq->trans_table[(i * max_state) + j]);
-		len += sprintf(buf + len, "%10u\n",
-			jiffies_to_msecs(devfreq->time_in_state[i]));
+		len += sprintf(buf + len, "%10llu\n", (u64)
+			jiffies64_to_msecs(devfreq->time_in_state[i]));
 	}
 
 	len += sprintf(buf + len, "Total transition : %u\n",
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index fb376b5b72819..95816a8e3d266 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -177,8 +177,8 @@ struct devfreq {
 	/* information for device frequency transition */
 	unsigned int total_trans;
 	unsigned int *trans_table;
-	unsigned long *time_in_state;
-	unsigned long last_stat_updated;
+	u64 *time_in_state;
+	u64 last_stat_updated;
 
 	struct srcu_notifier_head transition_notifier_list;
 
-- 
2.20.1

