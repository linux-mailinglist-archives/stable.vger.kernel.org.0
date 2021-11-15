Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2427451135
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243707AbhKOTCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243368AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6960633C7;
        Mon, 15 Nov 2021 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999935;
        bh=VJK1eqF61bLQOlNDzkfvJUfZcM6k8U2w5+ZaU0CfM14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdJaDqBAu7YLWagqDA4xi2IiuMZ48zPBbO+Xe2T53pcKmK5fX0iLiqK0Ct3c1qjT/
         7A8m/wQ9PUWiJtTbkkW9bHFreBffDeN2aMlAOM+s0sElS4omGJBIgtiJp6F7fcKUs1
         AVo12KJsfEsNmkB5m3WtyKCKJTBGtTh8fzDw+ZOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 478/849] iwlwifi: mvm: reset PM state on unsuccessful resume
Date:   Mon, 15 Nov 2021 17:59:21 +0100
Message-Id: <20211115165436.452112893@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 6a259d867d90e..9ed56c68a506a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2093,7 +2093,6 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
 					false, 0);
 		ret = 1;
-		mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 		goto err;
 	}
 
@@ -2142,6 +2141,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 		}
 	}
 
+	/* after the successful handshake, we're out of D3 */
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 
 	/*
@@ -2212,6 +2212,9 @@ out:
 	 */
 	set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 
+	/* regardless of what happened, we're now out of D3 */
+	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
+
 	return 1;
 }
 
-- 
2.33.0



