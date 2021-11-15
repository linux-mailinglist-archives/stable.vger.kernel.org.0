Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8994F4513E4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348694AbhKOT7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344099AbhKOTXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46FA563621;
        Mon, 15 Nov 2021 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002298;
        bh=ayjlyXL5m5MPBmtT2+kL138bzp65d/1LHkFG3R/UhfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLd46S5arkdmldR5qFu5nU+EvONncnSAAu39Kc6vPhnVXM+eaMroB5t8bpqQ/z2Ac
         YwDMyWPz6S4hCCX3dOGEye+6B0eCB/a2rmt1j21pCE3hd9RQZslGy3Ey+2KYFD9QDa
         ePz1nwsV5fYoHj5StDbqkKksLXwM+/aNxkge6et8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 486/917] iwlwifi: mvm: reset PM state on unsuccessful resume
Date:   Mon, 15 Nov 2021 17:59:41 +0100
Message-Id: <20211115165445.269586020@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2f629a7772e2a7bdaff25178917a40073f79702c ]

If resume fails for some reason, we need to set the PM state
back to normal so we're able to send commands during firmware
reset, rather than failing all of them because we're in D3.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 708a39aaca22 ("iwlwifi: mvm: don't send commands during suspend\resume transition")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20211016114029.7ceb9eaca9f6.If0cbef38c6d07ec1ddce125878a4bdadcb35d2c9@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 9f706fffb5922..d3013a51a5096 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2336,7 +2336,6 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
 					false, 0);
 		ret = 1;
-		mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 		goto err;
 	}
 
@@ -2385,6 +2384,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		}
 	}
 
+	/* after the successful handshake, we're out of D3 */
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 
 	/*
@@ -2455,6 +2455,9 @@ out:
 	 */
 	set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 
+	/* regardless of what happened, we're now out of D3 */
+	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
+
 	return 1;
 }
 
-- 
2.33.0



