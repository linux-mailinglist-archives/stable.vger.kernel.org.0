Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4031564ED4
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 09:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiGDHg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 03:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiGDHg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 03:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC56959A
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 00:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF9F0610A4
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 07:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07129C36AE2;
        Mon,  4 Jul 2022 07:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656920215;
        bh=C8rYmN+AKSB31aorhGRJgsswQ7bthb9gRSOuwLZltuo=;
        h=Subject:To:Cc:From:Date:From;
        b=f+w3HL6KnmLhPQ0Sm75Iz5MzHjV4QQJ79cWkZTc2Vi9i5DzRehwRaYdgRR+bwjiUz
         kK6CPXjW+cDYDQiYvKr6Th8AxPwS7kouNq1kKEwD4ggtAmlTTBGheMKX0YtkaSmloj
         dpga+3+DGjssBAC/upUefVYcoeWYQUAwGhbQLOI8=
Subject: FAILED: patch "[PATCH] PM / devfreq: Rework freq_table to be local to devfreq struct" failed to apply to 4.19-stable tree
To:     ansuelsmth@gmail.com, cw00.choi@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 09:36:45 +0200
Message-ID: <1656920205229224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5d281f6c16dd432b618bdfd36ddba1a58d5b603 Mon Sep 17 00:00:00 2001
From: Christian Marangi <ansuelsmth@gmail.com>
Date: Mon, 20 Jun 2022 00:03:51 +0200
Subject: [PATCH] PM / devfreq: Rework freq_table to be local to devfreq struct

On a devfreq PROBE_DEFER, the freq_table in the driver profile struct,
is never reset and may be leaved in an undefined state.

This comes from the fact that we store the freq_table in the driver
profile struct that is commonly defined as static and not reset on
PROBE_DEFER.
We currently skip the reinit of the freq_table if we found
it's already defined since a driver may declare his own freq_table.

This logic is flawed in the case devfreq core generate a freq_table, set
it in the profile struct and then PROBE_DEFER, freeing the freq_table.
In this case devfreq will found a NOT NULL freq_table that has been
freed, skip the freq_table generation and probe the driver based on the
wrong table.

To fix this and correctly handle PROBE_DEFER, use a local freq_table and
max_state in the devfreq struct and never modify the freq_table present
in the profile struct if it does provide it.

Fixes: 0ec09ac2cebe ("PM / devfreq: Set the freq_table of devfreq device")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 80a1235ef8fb..9602141bb8ec 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -123,7 +123,7 @@ void devfreq_get_freq_range(struct devfreq *devfreq,
 			    unsigned long *min_freq,
 			    unsigned long *max_freq)
 {
-	unsigned long *freq_table = devfreq->profile->freq_table;
+	unsigned long *freq_table = devfreq->freq_table;
 	s32 qos_min_freq, qos_max_freq;
 
 	lockdep_assert_held(&devfreq->lock);
@@ -133,11 +133,11 @@ void devfreq_get_freq_range(struct devfreq *devfreq,
 	 * The devfreq drivers can initialize this in either ascending or
 	 * descending order and devfreq core supports both.
 	 */
-	if (freq_table[0] < freq_table[devfreq->profile->max_state - 1]) {
+	if (freq_table[0] < freq_table[devfreq->max_state - 1]) {
 		*min_freq = freq_table[0];
-		*max_freq = freq_table[devfreq->profile->max_state - 1];
+		*max_freq = freq_table[devfreq->max_state - 1];
 	} else {
-		*min_freq = freq_table[devfreq->profile->max_state - 1];
+		*min_freq = freq_table[devfreq->max_state - 1];
 		*max_freq = freq_table[0];
 	}
 
@@ -169,8 +169,8 @@ static int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
 {
 	int lev;
 
-	for (lev = 0; lev < devfreq->profile->max_state; lev++)
-		if (freq == devfreq->profile->freq_table[lev])
+	for (lev = 0; lev < devfreq->max_state; lev++)
+		if (freq == devfreq->freq_table[lev])
 			return lev;
 
 	return -EINVAL;
@@ -178,7 +178,6 @@ static int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
 
 static int set_freq_table(struct devfreq *devfreq)
 {
-	struct devfreq_dev_profile *profile = devfreq->profile;
 	struct dev_pm_opp *opp;
 	unsigned long freq;
 	int i, count;
@@ -188,25 +187,22 @@ static int set_freq_table(struct devfreq *devfreq)
 	if (count <= 0)
 		return -EINVAL;
 
-	profile->max_state = count;
-	profile->freq_table = devm_kcalloc(devfreq->dev.parent,
-					profile->max_state,
-					sizeof(*profile->freq_table),
-					GFP_KERNEL);
-	if (!profile->freq_table) {
-		profile->max_state = 0;
+	devfreq->max_state = count;
+	devfreq->freq_table = devm_kcalloc(devfreq->dev.parent,
+					   devfreq->max_state,
+					   sizeof(*devfreq->freq_table),
+					   GFP_KERNEL);
+	if (!devfreq->freq_table)
 		return -ENOMEM;
-	}
 
-	for (i = 0, freq = 0; i < profile->max_state; i++, freq++) {
+	for (i = 0, freq = 0; i < devfreq->max_state; i++, freq++) {
 		opp = dev_pm_opp_find_freq_ceil(devfreq->dev.parent, &freq);
 		if (IS_ERR(opp)) {
-			devm_kfree(devfreq->dev.parent, profile->freq_table);
-			profile->max_state = 0;
+			devm_kfree(devfreq->dev.parent, devfreq->freq_table);
 			return PTR_ERR(opp);
 		}
 		dev_pm_opp_put(opp);
-		profile->freq_table[i] = freq;
+		devfreq->freq_table[i] = freq;
 	}
 
 	return 0;
@@ -246,7 +242,7 @@ int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
 
 	if (lev != prev_lev) {
 		devfreq->stats.trans_table[
-			(prev_lev * devfreq->profile->max_state) + lev]++;
+			(prev_lev * devfreq->max_state) + lev]++;
 		devfreq->stats.total_trans++;
 	}
 
@@ -835,6 +831,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		if (err < 0)
 			goto err_dev;
 		mutex_lock(&devfreq->lock);
+	} else {
+		devfreq->freq_table = devfreq->profile->freq_table;
+		devfreq->max_state = devfreq->profile->max_state;
 	}
 
 	devfreq->scaling_min_freq = find_available_min_freq(devfreq);
@@ -870,8 +869,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	devfreq->stats.trans_table = devm_kzalloc(&devfreq->dev,
 			array3_size(sizeof(unsigned int),
-				    devfreq->profile->max_state,
-				    devfreq->profile->max_state),
+				    devfreq->max_state,
+				    devfreq->max_state),
 			GFP_KERNEL);
 	if (!devfreq->stats.trans_table) {
 		mutex_unlock(&devfreq->lock);
@@ -880,7 +879,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	}
 
 	devfreq->stats.time_in_state = devm_kcalloc(&devfreq->dev,
-			devfreq->profile->max_state,
+			devfreq->max_state,
 			sizeof(*devfreq->stats.time_in_state),
 			GFP_KERNEL);
 	if (!devfreq->stats.time_in_state) {
@@ -1666,9 +1665,9 @@ static ssize_t available_frequencies_show(struct device *d,
 
 	mutex_lock(&df->lock);
 
-	for (i = 0; i < df->profile->max_state; i++)
+	for (i = 0; i < df->max_state; i++)
 		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
-				"%lu ", df->profile->freq_table[i]);
+				"%lu ", df->freq_table[i]);
 
 	mutex_unlock(&df->lock);
 	/* Truncate the trailing space */
@@ -1691,7 +1690,7 @@ static ssize_t trans_stat_show(struct device *dev,
 
 	if (!df->profile)
 		return -EINVAL;
-	max_state = df->profile->max_state;
+	max_state = df->max_state;
 
 	if (max_state == 0)
 		return sprintf(buf, "Not Supported.\n");
@@ -1708,19 +1707,17 @@ static ssize_t trans_stat_show(struct device *dev,
 	len += sprintf(buf + len, "           :");
 	for (i = 0; i < max_state; i++)
 		len += sprintf(buf + len, "%10lu",
-				df->profile->freq_table[i]);
+				df->freq_table[i]);
 
 	len += sprintf(buf + len, "   time(ms)\n");
 
 	for (i = 0; i < max_state; i++) {
-		if (df->profile->freq_table[i]
-					== df->previous_freq) {
+		if (df->freq_table[i] == df->previous_freq)
 			len += sprintf(buf + len, "*");
-		} else {
+		else
 			len += sprintf(buf + len, " ");
-		}
-		len += sprintf(buf + len, "%10lu:",
-				df->profile->freq_table[i]);
+
+		len += sprintf(buf + len, "%10lu:", df->freq_table[i]);
 		for (j = 0; j < max_state; j++)
 			len += sprintf(buf + len, "%10u",
 				df->stats.trans_table[(i * max_state) + j]);
@@ -1744,7 +1741,7 @@ static ssize_t trans_stat_store(struct device *dev,
 	if (!df->profile)
 		return -EINVAL;
 
-	if (df->profile->max_state == 0)
+	if (df->max_state == 0)
 		return count;
 
 	err = kstrtoint(buf, 10, &value);
@@ -1752,11 +1749,11 @@ static ssize_t trans_stat_store(struct device *dev,
 		return -EINVAL;
 
 	mutex_lock(&df->lock);
-	memset(df->stats.time_in_state, 0, (df->profile->max_state *
+	memset(df->stats.time_in_state, 0, (df->max_state *
 					sizeof(*df->stats.time_in_state)));
 	memset(df->stats.trans_table, 0, array3_size(sizeof(unsigned int),
-					df->profile->max_state,
-					df->profile->max_state));
+					df->max_state,
+					df->max_state));
 	df->stats.total_trans = 0;
 	df->stats.last_update = get_jiffies_64();
 	mutex_unlock(&df->lock);
diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
index 69e06725d92b..406ef79c0c46 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -144,18 +144,18 @@ static int get_target_freq_with_devfreq(struct devfreq *devfreq,
 		goto out;
 
 	/* Use interpolation if required opps is not available */
-	for (i = 0; i < parent_devfreq->profile->max_state; i++)
-		if (parent_devfreq->profile->freq_table[i] == *freq)
+	for (i = 0; i < parent_devfreq->max_state; i++)
+		if (parent_devfreq->freq_table[i] == *freq)
 			break;
 
-	if (i == parent_devfreq->profile->max_state)
+	if (i == parent_devfreq->max_state)
 		return -EINVAL;
 
-	if (i < devfreq->profile->max_state) {
-		child_freq = devfreq->profile->freq_table[i];
+	if (i < devfreq->max_state) {
+		child_freq = devfreq->freq_table[i];
 	} else {
-		count = devfreq->profile->max_state;
-		child_freq = devfreq->profile->freq_table[count - 1];
+		count = devfreq->max_state;
+		child_freq = devfreq->freq_table[count - 1];
 	}
 
 out:
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index dc10bee75a72..34aab4dd336c 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -148,6 +148,8 @@ struct devfreq_stats {
  *		reevaluate operable frequencies. Devfreq users may use
  *		devfreq.nb to the corresponding register notifier call chain.
  * @work:	delayed work for load monitoring.
+ * @freq_table:		current frequency table used by the devfreq driver.
+ * @max_state:		count of entry present in the frequency table.
  * @previous_freq:	previously configured frequency value.
  * @last_status:	devfreq user device info, performance statistics
  * @data:	Private data of the governor. The devfreq framework does not
@@ -185,6 +187,9 @@ struct devfreq {
 	struct notifier_block nb;
 	struct delayed_work work;
 
+	unsigned long *freq_table;
+	unsigned int max_state;
+
 	unsigned long previous_freq;
 	struct devfreq_dev_status last_status;
 

