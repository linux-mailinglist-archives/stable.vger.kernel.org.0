Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E8C1677D6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgBUHvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729806AbgBUHvr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5711520578;
        Fri, 21 Feb 2020 07:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271506;
        bh=kHrVyKQu4EWN7X+O0OX9IdROv4KxjFWl9tyQX76enSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy5WrAKNKkJRYoj6fpFDRVkSc3KjpZ0BzKQpDQ+6NYC47XJtrflacbEP/JgnZk3/W
         rnOwmF0MuKpScOO8Kg/sHOATlEDmFqMtn2I2lE5m8QbLGAwYV3Gtnw/R0OaDQN8CPl
         bFGIkNtkl+sB9J/EjocOXem0WAXnySeu4Cmjgg4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamil Konieczny <k.konieczny@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 191/399] PM / devfreq: Change time stats to 64-bit
Date:   Fri, 21 Feb 2020 08:38:36 +0100
Message-Id: <20200221072421.377625465@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



