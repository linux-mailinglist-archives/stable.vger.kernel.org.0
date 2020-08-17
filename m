Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBBF2473DB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbgHQTCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbgHQPrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:47:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D31B2177B;
        Mon, 17 Aug 2020 15:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679236;
        bh=tCeRoaRe2xPSsMOAuWeOZ6tvJVbEv7DCv9nGGGaLoUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuesfTqliRUWyZjyQ2P8DQlwx4Fp5aeBBVm3DRyxn/oqUFckMtIQ2zX5H8S2fDnXG
         bmaEFrqpuMg8p5K+P83/YfjS4GcIFrHnjOrPSqBbSG8AROclyteVwzwvr+rMXjal3x
         gT4D/4fK7AFXWw673BvNtuBPyI43zD0tq5sMi3mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 142/393] scsi: ufs: Fix imprecise load calculation in devfreq window
Date:   Mon, 17 Aug 2020 17:13:12 +0200
Message-Id: <20200817143826.498070174@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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
index 7ca32ede5e172..477b6cfff381b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1280,6 +1280,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	unsigned long flags;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
+	ktime_t curr_t;
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return -EINVAL;
@@ -1287,6 +1288,7 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
 	memset(stat, 0, sizeof(*stat));
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	curr_t = ktime_get();
 	if (!scaling->window_start_t)
 		goto start_window;
 
@@ -1298,18 +1300,17 @@ static int ufshcd_devfreq_get_dev_status(struct device *dev,
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
@@ -1860,6 +1861,7 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 {
 	bool queue_resume_work = false;
+	ktime_t curr_t = ktime_get();
 
 	if (!ufshcd_is_clkscaling_supported(hba))
 		return;
@@ -1875,13 +1877,13 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
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
index 6ffc08ad85f63..2315ecc209272 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -409,7 +409,7 @@ struct ufs_saved_pwr_info {
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



