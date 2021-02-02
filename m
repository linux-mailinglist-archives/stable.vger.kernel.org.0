Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5EA30C879
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhBBRvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhBBOJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:09:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3444164F99;
        Tue,  2 Feb 2021 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273858;
        bh=2ZQdflJ0IRcFyn4Mg7yQRUPkfdekW4o3Inms5uQK7QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFdCzzslt4x6fdcXeL1S30qzRGRGPjwBVGSAS0+ol7H/DZ7pOB34Mq8R2K7v5apSn
         xV/vOcmvFJpUSXBcko91drEQd4/07Hkx0/CrtwZy7m0g9kT6xO3F4k3GHEwRbqx8aR
         xEE9S5uKLLBq6tYlkqO9CMQNv0WPMH3F0V2LzwpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/32] iwlwifi: pcie: reschedule in long-running memory reads
Date:   Tue,  2 Feb 2021 14:38:49 +0100
Message-Id: <20210202132943.060104477@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3d372c4edfd4dffb7dea71c6b096fb414782b776 ]

If we spin for a long time in memory reads that (for some reason in
hardware) take a long time, then we'll eventually get messages such
as

  watchdog: BUG: soft lockup - CPU#2 stuck for 24s! [kworker/2:2:272]

This is because the reading really does take a very long time, and
we don't schedule, so we're hogging the CPU with this task, at least
if CONFIG_PREEMPT is not set, e.g. with CONFIG_PREEMPT_VOLUNTARY=y.

Previously I misinterpreted the situation and thought that this was
only going to happen if we had interrupts disabled, and then fixed
this (which is good anyway, however), but that didn't always help;
looking at it again now I realized that the spin unlock will only
reschedule if CONFIG_PREEMPT is used.

In order to avoid this issue, change the code to cond_resched() if
we've been spinning for too long here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 04516706bb99 ("iwlwifi: pcie: limit memory read spin time")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130253.217a9d6a6a12.If964cb582ab0aaa94e81c4ff3b279eaafda0fd3f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ed90f46626e7d..71edbf7a42ed4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1910,6 +1910,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 	while (offs < dwords) {
 		/* limit the time we spin here under lock to 1/2s */
 		unsigned long end = jiffies + HZ / 2;
+		bool resched = false;
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
@@ -1920,10 +1921,15 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 							HBUS_TARG_MEM_RDAT);
 				offs++;
 
-				if (time_after(jiffies, end))
+				if (time_after(jiffies, end)) {
+					resched = true;
 					break;
+				}
 			}
 			iwl_trans_release_nic_access(trans, &flags);
+
+			if (resched)
+				cond_resched();
 		} else {
 			return -EBUSY;
 		}
-- 
2.27.0



