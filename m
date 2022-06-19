Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E15550D60
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 00:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiFSWE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 18:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiFSWE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 18:04:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720D7626A;
        Sun, 19 Jun 2022 15:04:25 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c21so12243061wrb.1;
        Sun, 19 Jun 2022 15:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1XCwl40jW+y3W13A4MjOClb2M3wEJj8NMxXEg2H/jU8=;
        b=Pl3GqvICQ+BJo8L/bBRPppbsxcm8Pc9hlUhVdypG7MNMVOGfdF2uTrRw/jXlm/AnJw
         TsIisDhLgYxoykovn99rPOakXGAwQ7Or+P+7XWCLh2kWwNH25am5u2pGqfkgos1TvIW+
         1DMMq8JeXZE4nMB4NsnubMix0bflC+BAhvT9Ld2Q9ScuGLgCf/cKvO9tnr23qsjHS2K9
         GwFFkq3ApaJ257xthINE4eaOW2UHQRh+HQQN8we9EiSTyCHriFhGszPpop7mmYcifuYa
         17YewX7aW1BoBKpSjCg851K0LXp11sTOAnpetfXJBI/nNpWvOessptkGkm9Y60uMkerV
         2HWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1XCwl40jW+y3W13A4MjOClb2M3wEJj8NMxXEg2H/jU8=;
        b=S4McVcwBWAqF+lR3A272WdbrNqitb+eydlFueK1s8B8cRQasvihapnAPykwa5GgYtd
         Qy93/DDsIY34mkH0R3WlAXLm9JHxoSvwEIsanlkCj1fgvX50iriumpmLjn0FMKIrYK7B
         btnanT9/J6ijJwSO6NcaLed0U22uUIKpYXo8kUco5GPnfQAU4HliHfd1Eg8qz24R+eW5
         XivWok68eSKbIkQ+Hv2ECraryiU3HrSYydWegAsesuRVPqv+lDaVI0WFHG7AXipfWuEv
         GifHLOYMNQRVj50ShIxpqoeepV3xPvSGDl+RFIhzt+aD2TuE9SrcwOoMSWiZ1mUAki++
         BTbA==
X-Gm-Message-State: AJIora931mNTSex74zcejCwERy70oGC9FChOy/NGovl4DoawjM6pGmzt
        6tL57Igul83WPb+7d1f+870GP3K7gTg=
X-Google-Smtp-Source: AGRyM1tWKFhhGrlBkNaKxDQ72Q6JkTFgLPbWht6D7dnj8Dv35Sr72uYeUM/oPN1h1O2i5n26HGarLQ==
X-Received: by 2002:a05:6000:381:b0:219:b9dd:af2b with SMTP id u1-20020a056000038100b00219b9ddaf2bmr20465086wrf.75.1655676263681;
        Sun, 19 Jun 2022 15:04:23 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id w3-20020adfec43000000b0021b89c07b6asm4129030wrn.108.2022.06.19.15.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 15:04:23 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] PM / devfreq: Rework freq_table to be local to devfreq struct
Date:   Mon, 20 Jun 2022 00:03:51 +0200
Message-Id: <20220619220351.29891-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/devfreq/devfreq.c          | 71 ++++++++++++++----------------
 drivers/devfreq/governor_passive.c | 14 +++---
 include/linux/devfreq.h            |  5 +++
 3 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 01474daf4548..2e2b3b414d67 100644
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
@@ -1665,9 +1664,9 @@ static ssize_t available_frequencies_show(struct device *d,
 
 	mutex_lock(&df->lock);
 
-	for (i = 0; i < df->profile->max_state; i++)
+	for (i = 0; i < df->max_state; i++)
 		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
-				"%lu ", df->profile->freq_table[i]);
+				"%lu ", df->freq_table[i]);
 
 	mutex_unlock(&df->lock);
 	/* Truncate the trailing space */
@@ -1690,7 +1689,7 @@ static ssize_t trans_stat_show(struct device *dev,
 
 	if (!df->profile)
 		return -EINVAL;
-	max_state = df->profile->max_state;
+	max_state = df->max_state;
 
 	if (max_state == 0)
 		return sprintf(buf, "Not Supported.\n");
@@ -1707,19 +1706,17 @@ static ssize_t trans_stat_show(struct device *dev,
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
@@ -1743,7 +1740,7 @@ static ssize_t trans_stat_store(struct device *dev,
 	if (!df->profile)
 		return -EINVAL;
 
-	if (df->profile->max_state == 0)
+	if (df->max_state == 0)
 		return count;
 
 	err = kstrtoint(buf, 10, &value);
@@ -1751,11 +1748,11 @@ static ssize_t trans_stat_store(struct device *dev,
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
index 72c67979ebe1..ce24a262aa16 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -131,18 +131,18 @@ static int get_target_freq_with_devfreq(struct devfreq *devfreq,
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
 
-- 
2.36.1

