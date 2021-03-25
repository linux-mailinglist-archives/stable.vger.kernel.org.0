Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09646348F34
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhCYL0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhCYLZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C4861A24;
        Thu, 25 Mar 2021 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671542;
        bh=ym85RzS/JUtaS267Olck5OzQXWkc+gY0qQ3k0DdlQ2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtqfueUNe5XnLDLrBq3FXrJkEmDi719RaaNs1OnjcSgiGhm6GSxj0ajyoiYi72EUG
         FU1BsZl6xyEIe+dS/zpgUDOjnAxvvnXQfzYptaEEVuRcPMlijXImI6qvcuoFpUfpXc
         E/RTn+dHteMON9aHTS9hzmvw+Xfdghq0cbaLay0cxYl+grDyRjMP1vuW/V/OYlrDJT
         vFEfvKEKUeTbzLTE6twfJQujKq7Pj8t04V5KUsG56mUqElUJrqNISxEp0k6lqphHSJ
         E/U1MwJ8emaVFadUUiKyrW453DhHZ+F7CfFKfV5lJWCSR746skdDqGreDHR+6oO/KZ
         RUeDpgHhm0l7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 33/44] thermal/core: Add NULL pointer check before using cooling device stats
Date:   Thu, 25 Mar 2021 07:24:48 -0400
Message-Id: <20210325112459.1926846-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>

[ Upstream commit 2046a24ae121cd107929655a6aaf3b8c5beea01f ]

There is a possible chance that some cooling device stats buffer
allocation fails due to very high cooling device max state value.
Later cooling device update sysfs can try to access stats data
for the same cooling device. It will lead to NULL pointer
dereference issue.

Add a NULL pointer check before accessing thermal cooling device
stats data. It fixes the following bug

[ 26.812833] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004
[ 27.122960] Call trace:
[ 27.122963] do_raw_spin_lock+0x18/0xe8
[ 27.122966] _raw_spin_lock+0x24/0x30
[ 27.128157] thermal_cooling_device_stats_update+0x24/0x98
[ 27.128162] cur_state_store+0x88/0xb8
[ 27.128166] dev_attr_store+0x40/0x58
[ 27.128169] sysfs_kf_write+0x50/0x68
[ 27.133358] kernfs_fop_write+0x12c/0x1c8
[ 27.133362] __vfs_write+0x54/0x160
[ 27.152297] vfs_write+0xcc/0x188
[ 27.157132] ksys_write+0x78/0x108
[ 27.162050] ksys_write+0xf8/0x108
[ 27.166968] __arm_smccc_hvc+0x158/0x4b0
[ 27.166973] __arm_smccc_hvc+0x9c/0x4b0
[ 27.186005] el0_svc+0x8/0xc

Signed-off-by: Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/1607367181-24589-1-git-send-email-manafm@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 0866e949339b..9b73532464e5 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -754,6 +754,9 @@ void thermal_cooling_device_stats_update(struct thermal_cooling_device *cdev,
 {
 	struct cooling_dev_stats *stats = cdev->stats;
 
+	if (!stats)
+		return;
+
 	spin_lock(&stats->lock);
 
 	if (stats->state == new_state)
-- 
2.30.1

