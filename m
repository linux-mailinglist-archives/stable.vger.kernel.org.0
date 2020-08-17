Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7E2469C0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgHQPZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729456AbgHQPZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ECF02053B;
        Mon, 17 Aug 2020 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677933;
        bh=y++K4L8lsUhHLOP4E6b9FyypC8XKvr/3Uarqcsdcx08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIYvhsl+Glyybt0XvyYB/UhljBb92K8OG7r8OOa/2wFPj8m74PYp7fCAt8GwyIIQx
         XyCIbR1wtHhKxc3k9kNrzqIjA+F/7VGjkLSl88RL0PM4WV3vuAQOZOaIbayWkdkKXQ
         hpjuZGjiEioyFgNzkVsF0J+A2HviCE74WAnKmuyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 161/464] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Mon, 17 Aug 2020 17:11:54 +0200
Message-Id: <20200817143841.521215260@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit b1bf66d1d5a8fcb54f0e584db5d196ef015b5172 ]

The UFS load calculation is based on "total_time" and "busy_time" in a
devfreq window.  However, the source of time is different for both
parameters: "busy_time" is assigned from "jiffies" thus has different
accuracy from "total_time" which is assigned from ktime_get().

In addition, the time of window boundary is not exactly the same as the
starting busy time in this window if UFS is actually busy in the beginning
of the window. A similar accuracy error may also happen for the end of busy
time in current window.

To guarantee the precision of load calculation, we need to

1. Align time accuracy of both devfreq_dev_status.total_time and
   devfreq_dev_status.busy_time. For example, use "ktime_get()" directly.

2. Align the following timelines:
   - The beginning time of devfreq windows
   - The beginning of busy time in a new window
   - The end of busy time in the current window

Link: https://lore.kernel.org/r/20200611101043.6379-1-stanley.chu@mediatek.com
Fixes: a3cd5ec55f6c ("scsi: ufs: add load based scaling of UFS gear")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++--------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a483c0720a0c1..ec93bec8e78d8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1314,6 +1314,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	unsigned long flags;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
+	ktime_t curr_t;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
@@ -1321,6 +1322,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	memset(stat, 0, sizeof(*stat));
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
 
@@ -1332,18 +1334,17 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	 */
 	stat->current_frequency = clki->curr_freq;
 	if (scaling->is_busy_started)
-		scaling->tot_busy_t += ktime_to_us(ktime_sub(ktime_get(),
-					scaling->busy_start_t));
+		scaling->tot_busy_t += ktime_us_delta(curr_t,
+				scaling->busy_start_t);
 
-	stat->total_time = jiffies_to_usecs((long)jiffies -
-				(long)scaling->window_start_t);
+	stat->total_time = ktime_us_delta(curr_t, scaling->window_start_t);
 	stat->busy_time = scaling->tot_busy_t;
 start_window:
-	scaling->window_start_t = jiffies;
+	scaling->window_start_t = curr_t;
 	scaling->tot_busy_t = 0;
 
 	if (hba->outstanding_reqs) {
-		scaling->busy_start_t = ktime_get();
+		scaling->busy_start_t = curr_t;
 		scaling->is_busy_started = true;
 	} else {
 		scaling->busy_start_t = 0;
@@ -1877,6 +1878,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
+	ktime_t curr_t = ktime_get();
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
@@ -1892,13 +1894,13 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 			   &hba->clk_scaling.resume_work);
 
 	if (!hba->clk_scaling.window_start_t) {
-		hba->clk_scaling.window_start_t = jiffies;
+		hba->clk_scaling.window_start_t = curr_t;
 		hba->clk_scaling.tot_busy_t = 0;
 		hba->clk_scaling.is_busy_started = false;
 	}
 
 	if (!hba->clk_scaling.is_busy_started) {
-		hba->clk_scaling.busy_start_t = ktime_get();
+		hba->clk_scaling.busy_start_t = curr_t;
 		hba->clk_scaling.is_busy_started = true;
 	}
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index bf97d616e597c..16187be98a94c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -411,7 +411,7 @@ struct ufs_saved_pwr_info {
 struct ufs_clk_scaling {
 	int active_reqs;
 	unsigned long tot_busy_t;
-	unsigned long window_start_t;
+	ktime_t window_start_t;
 	ktime_t busy_start_t;
 	struct device_attribute enable_attr;
 	struct ufs_saved_pwr_info saved_pwr_info;
-- 
2.25.1



