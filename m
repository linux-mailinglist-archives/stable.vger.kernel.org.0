Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C030CAA0
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhBBSzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 13:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233655AbhBBOCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D6364F84;
        Tue,  2 Feb 2021 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273656;
        bh=fkJeUKdL1V/samiczdKsnz1Bw8xGU0pNndxCnJXzS4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJRAuqjLTs/BOJBwCMjxyqc6k0fngur+LX1cStssVyrVRXEuQgkFzqnIR9dTnczfu
         2BWoyWykewK2iSlotlxxcoQpN504eus0A8yvzLY12oqXt/r8Y/rpiUo28SQnj6LqJU
         iZqJpCLNdnjl1pSNEtaTAIjw5NnHaBUgI1FLkg+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/61] iwlwifi: pcie: use jiffies for memory read spin time limit
Date:   Tue,  2 Feb 2021 14:38:21 +0100
Message-Id: <20210202132948.289251093@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
index ef5a8ecabc60a..d2ed9e0239cb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2183,7 +2183,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
 
 	while (offs < dwords) {
 		/* limit the time we spin here under lock to 1/2s */
-		ktime_t timeout = ktime_add_us(ktime_get(), 500 * USEC_PER_MSEC);
+		unsigned long end = jiffies + HZ / 2;
 
 		if (iwl_trans_grab_nic_access(trans, &flags)) {
 			iwl_write32(trans, HBUS_TARG_MEM_RADDR,
@@ -2194,11 +2194,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_trans *trans, u32 addr,
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



