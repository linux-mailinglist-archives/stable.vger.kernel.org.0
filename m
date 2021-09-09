Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA8404FC2
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348429AbhIIMWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352842AbhIIMTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14FD36127B;
        Thu,  9 Sep 2021 11:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188223;
        bh=7g7VFpPQn5V3ZUik6UpjDE8iJY3WAIaFuDLTsNOoHTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUz3gWMJfpGYF/0/TobKFSBSekj4/aANTEnjxe/pVpN3lIAGldxyx2K90TB/BeThc
         toUeNL513gyzVoDxlUJyfm/wqHIEgdS95aCppt34c+L1oHflDb4CBdJkxqE8d1lYq0
         41cn5vDJ4EVijca+kfejjGUtDgajH5Ze6cw/mXcsWsE7vUZuRwR+ZRRMqB7WJbyZL7
         tdervGA65jGyJl45bZWoxhM2EuGsLHtijawjEuYdRTmD1nPu5oJe33it4dgdaCFs6V
         aNLAQs6bF42oS017leOS2xm2QDFshiOe88z7ucKHuFomEC8GndwQmX6YN5I+FYcMUh
         9oEHaefFJcL6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 177/219] soundwire: intel: fix potential race condition during power down
Date:   Thu,  9 Sep 2021 07:45:53 -0400
Message-Id: <20210909114635.143983-177-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit ea6942dad4b2a7e1735aa0f10f3d0b04b847750f ]

The power down sequence sets the link_up flag as false outside of the
mutex_lock. This is potentially unsafe.

In additional the flow in that sequence can be improved by first
testing if the link was powered, setting the link_up flag as false and
proceeding with the power down. In case the CPA bits cannot be
cleared, we only flag an error since we cannot deal with interrupts
any longer.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20210818024954.16873-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index fd95f94630b1..c03d51ad40bf 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -537,12 +537,14 @@ static int intel_link_power_down(struct sdw_intel *sdw)
 
 	mutex_lock(sdw->link_res->shim_lock);
 
-	intel_shim_master_ip_to_glue(sdw);
-
 	if (!(*shim_mask & BIT(link_id)))
 		dev_err(sdw->cdns.dev,
 			"%s: Unbalanced power-up/down calls\n", __func__);
 
+	sdw->cdns.link_up = false;
+
+	intel_shim_master_ip_to_glue(sdw);
+
 	*shim_mask &= ~BIT(link_id);
 
 	if (!*shim_mask) {
@@ -559,18 +561,19 @@ static int intel_link_power_down(struct sdw_intel *sdw)
 		link_control &=  spa_mask;
 
 		ret = intel_clear_bit(shim, SDW_SHIM_LCTL, link_control, cpa_mask);
+		if (ret < 0) {
+			dev_err(sdw->cdns.dev, "%s: could not power down link\n", __func__);
+
+			/*
+			 * we leave the sdw->cdns.link_up flag as false since we've disabled
+			 * the link at this point and cannot handle interrupts any longer.
+			 */
+		}
 	}
 
 	mutex_unlock(sdw->link_res->shim_lock);
 
-	if (ret < 0) {
-		dev_err(sdw->cdns.dev, "%s: could not power down link\n", __func__);
-
-		return ret;
-	}
-
-	sdw->cdns.link_up = false;
-	return 0;
+	return ret;
 }
 
 static void intel_shim_sync_arm(struct sdw_intel *sdw)
-- 
2.30.2

