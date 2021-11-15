Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7E450E4B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbhKOSOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240265AbhKOSH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9AA61163;
        Mon, 15 Nov 2021 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998253;
        bh=awqd3cUO2RXIryXAhBYLzQ2HsddUQyQmN0vjZkZCyYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Xz9CULGqMIKEpxjblg6uFWBG1tSpAa4AxTLwLYS5/53t28MTqFncP1XFe1xemy1O
         BMegIi4ZFKksC5Ju+41EaQFnY2Z321l3rN+gku823OAQuAtE3WoSBzzJUdl3rD6EHB
         EpsR1L0rFwmkD0n4SShye+IEfx7BLW0oOt47GtZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongwu Su <hongwus@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/575] scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk
Date:   Mon, 15 Nov 2021 18:02:49 +0100
Message-Id: <20211115165359.110911266@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 81309c247a4dcd597cbda5254fd0afdd61b93f14 ]

Remove the param skip_ref_clk from __ufshcd_setup_clocks(), but keep a flag
in struct ufs_clk_info to tell whether a clock can be disabled or not while
the link is active.

Link: https://lore.kernel.org/r/1606356063-38380-2-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c |  2 ++
 drivers/scsi/ufs/ufshcd.c        | 29 +++++++++--------------------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 24927cf485b47..68ce209577eca 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -92,6 +92,8 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
 		clki->name = kstrdup(name, GFP_KERNEL);
+		if (!strcmp(name, "ref_clk"))
+			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
 				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3139d9df6f320..930f35863cbb5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -221,8 +221,6 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -1714,11 +1712,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	ufshcd_disable_irq(hba);
 
-	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
-	else
-		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+	ufshcd_setup_clocks(hba, false);
 
 	/*
 	 * In case you are here to cancel this work the gating state
@@ -8055,8 +8049,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-					bool skip_ref_clk)
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
@@ -8074,7 +8067,12 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk)) {
-			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
+			/*
+			 * Don't disable clocks which are needed
+			 * to keep the link active.
+			 */
+			if (ufshcd_is_link_active(hba) &&
+			    clki->keep_link_active)
 				continue;
 
 			clk_state_changed = on ^ clki->enabled;
@@ -8119,11 +8117,6 @@ out:
 	return ret;
 }
 
-static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
-{
-	return  __ufshcd_setup_clocks(hba, on, false);
-}
-
 static int ufshcd_init_clocks(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -8642,11 +8635,7 @@ disable_clks:
 	 */
 	ufshcd_disable_irq(hba);
 
-	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
-	else
-		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+	ufshcd_setup_clocks(hba, false);
 
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 812aa348751eb..1ba9c786feb6d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -229,6 +229,8 @@ struct ufs_dev_cmd {
  * @max_freq: maximum frequency supported by the clock
  * @min_freq: min frequency that can be used for clock scaling
  * @curr_freq: indicates the current frequency that it is set to
+ * @keep_link_active: indicates that the clk should not be disabled if
+		      link is active
  * @enabled: variable to check against multiple enable/disable
  */
 struct ufs_clk_info {
@@ -238,6 +240,7 @@ struct ufs_clk_info {
 	u32 max_freq;
 	u32 min_freq;
 	u32 curr_freq;
+	bool keep_link_active;
 	bool enabled;
 };
 
-- 
2.33.0



