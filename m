Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA32F106F1B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfKVLMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:12:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbfKVK50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983D720718;
        Fri, 22 Nov 2019 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420245;
        bh=/h7+WxnT0pQCjhRylNYlpEwLKKiUKIyEzlcqA3+++JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhRUYdDSZBn8crz0plgGpLz+QxjE/ScBveS9QtrY91N37sSWZlou/v9zU5HE3YymQ
         24bJRgOSvdd68EvFfnCph5sIzuLKWBSat5RbmOiJZERMnuJZKaVlNPXArhCxalm5pL
         gV/5Bm7Yb+QfMgfwgS7n2WJySukdaxRDloCnIoc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/220] PM / devfreq: Fix handling of min/max_freq == 0
Date:   Fri, 22 Nov 2019 11:26:47 +0100
Message-Id: <20191122100915.310523363@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit df5cf4a36178c5d4f2b8b9469cb2f722e64cd102 ]

Commit ab8f58ad72c4 ("PM / devfreq: Set min/max_freq when adding the
devfreq device") initializes df->min/max_freq with the min/max OPP when
the device is added. Later commit f1d981eaecf8 ("PM / devfreq: Use the
available min/max frequency") adds df->scaling_min/max_freq and the
following to the frequency adjustment code:

  max_freq = MIN(devfreq->scaling_max_freq, devfreq->max_freq);

With the current handling of min/max_freq this is incorrect:

Even though df->max_freq is now initialized to a value != 0 user space
can still set it to 0, in this case max_freq would be 0 instead of
df->scaling_max_freq as intended. In consequence the frequency adjustment
is not performed:

  if (max_freq && freq > max_freq) {
	freq = max_freq;

To fix this set df->min/max freq to the min/max OPP in max/max_freq_store,
when the user passes a value of 0. This also prevents df->max_freq from
being set below the min OPP when df->min_freq is 0, and similar for
min_freq. Since it is now guaranteed that df->min/max_freq can't be 0 the
checks for this case can be removed.

Fixes: f1d981eaecf8 ("PM / devfreq: Use the available min/max frequency")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 42 ++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 62ead442a8721..8e21bedc74c38 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -327,11 +327,11 @@ int update_devfreq(struct devfreq *devfreq)
 	max_freq = MIN(devfreq->scaling_max_freq, devfreq->max_freq);
 	min_freq = MAX(devfreq->scaling_min_freq, devfreq->min_freq);
 
-	if (min_freq && freq < min_freq) {
+	if (freq < min_freq) {
 		freq = min_freq;
 		flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
 	}
-	if (max_freq && freq > max_freq) {
+	if (freq > max_freq) {
 		freq = max_freq;
 		flags |= DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use LUB */
 	}
@@ -1171,17 +1171,26 @@ static ssize_t min_freq_store(struct device *dev, struct device_attribute *attr,
 	struct devfreq *df = to_devfreq(dev);
 	unsigned long value;
 	int ret;
-	unsigned long max;
 
 	ret = sscanf(buf, "%lu", &value);
 	if (ret != 1)
 		return -EINVAL;
 
 	mutex_lock(&df->lock);
-	max = df->max_freq;
-	if (value && max && value > max) {
-		ret = -EINVAL;
-		goto unlock;
+
+	if (value) {
+		if (value > df->max_freq) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	} else {
+		unsigned long *freq_table = df->profile->freq_table;
+
+		/* Get minimum frequency according to sorting order */
+		if (freq_table[0] < freq_table[df->profile->max_state - 1])
+			value = freq_table[0];
+		else
+			value = freq_table[df->profile->max_state - 1];
 	}
 
 	df->min_freq = value;
@@ -1206,17 +1215,26 @@ static ssize_t max_freq_store(struct device *dev, struct device_attribute *attr,
 	struct devfreq *df = to_devfreq(dev);
 	unsigned long value;
 	int ret;
-	unsigned long min;
 
 	ret = sscanf(buf, "%lu", &value);
 	if (ret != 1)
 		return -EINVAL;
 
 	mutex_lock(&df->lock);
-	min = df->min_freq;
-	if (value && min && value < min) {
-		ret = -EINVAL;
-		goto unlock;
+
+	if (value) {
+		if (value < df->min_freq) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	} else {
+		unsigned long *freq_table = df->profile->freq_table;
+
+		/* Get maximum frequency according to sorting order */
+		if (freq_table[0] < freq_table[df->profile->max_state - 1])
+			value = freq_table[df->profile->max_state - 1];
+		else
+			value = freq_table[0];
 	}
 
 	df->max_freq = value;
-- 
2.20.1



