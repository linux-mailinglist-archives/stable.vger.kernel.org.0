Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB4130C7CB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbhBBRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234190AbhBBONC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:13:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B25265044;
        Tue,  2 Feb 2021 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273962;
        bh=dKKQoKOKyYbIkhIm19gSAmck+LwuDoNt5QsER+EdwP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7l0pCYvG+j/tFXTDRwE3gaoTBeE9z1+KM1+nyRRgVN6+h9HdMdY2BFO1k4jKhGSw
         HHRJvwUWIjPCYLY+f0w16l2VvYZ5w6WGJpuS8x24rvQSRogT1a5tvX9w6xgLS/XiTe
         h+fUVBblep9WWt2KIfyhTVWZu3XMT3ItxO0iOTFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/30] iwlwifi: pcie: use jiffies for memory read spin time limit
Date:   Tue,  2 Feb 2021 14:39:00 +0100
Message-Id: <20210202132942.927764583@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6701317476bbfb1f341aa935ddf75eb73af784f9 ]

There's no reason to use ktime_get() since we don't need any better
precision than jiffies, and since we no longer disable interrupts
around this code (when grabbing NIC access), jiffies will work fine.
Use jiffies instead of ktime_get().

This cleanup is preparation for the following patch "iwlwifi: pcie: reschedule
in long-running memory reads". The code gets simpler with the weird clock use
etc. removed before we add cond_resched().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130253.621c948b1fad.I3ee9f4bc4e74a0c9125d42fb7c35cd80df4698a1@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 910edd034fe3a..0bdb02e9baef6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1932,7 +1932,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 
 	while (offs < dwords) {
 		/* limit the time we spin here under lock to 1/2s */
-		ktime_t timeout = ktime_add_us(ktime_get(), 500 * USEC_PER_MSEC);
+		unsigned long end = jiffies + HZ / 2;
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
@@ -1943,11 +1943,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 							HBUS_TARG_MEM_RDAT);
 				offs++;
 
-				/* calling ktime_get is expensive so
-				 * do it once in 128 reads
-				 */
-				if (offs % 128 == 0 && ktime_after(ktime_get(),
-								   timeout))
+				if (time_after(jiffies, end))
 					break;
 			}
 			iwl_trans_release_nic_access(trans, &flags);
-- 
2.27.0



