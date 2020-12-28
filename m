Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37AA2E6634
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388368AbgL1NW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387590AbgL1NUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89FE222583;
        Mon, 28 Dec 2020 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161596;
        bh=h+e//3wSsKhNj5m4c/zqqorIHwL0AJS3ppIz62t7CJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFXNEKp9JcWB2MZQprAyi0Pb9smyhlemIOIRJiB/AN5SYA52F1/tdHVAhU9sQkX33
         TSlJM9VStqJDvmG/1CQSoHJLJYGdGjwGDO96RUbEHOkuQkD07BOxJD2A8GBTWDtT/L
         PEha9oaZHVTl4d6gMt9wMWwwDtgse6MksLwSWQ7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/346] iwlwifi: mvm: fix kernel panic in case of assert during CSA
Date:   Mon, 28 Dec 2020 13:45:26 +0100
Message-Id: <20201228124920.112093096@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit fe56d05ee6c87f6a1a8c7267affd92c9438249cc ]

During CSA, we briefly nullify the phy context, in __iwl_mvm_unassign_vif_chanctx.
In case we have a FW assert right after it, it remains NULL though.
We end up running into endless loop due to mac80211 trying repeatedly to
move us to ASSOC state, and we keep returning -EINVAL. Later down the road
we hit a kernel panic.

Detect and avoid this endless loop.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201107104557.d64de2c17bff.Iedd0d2afa20a2aacba5259a5cae31cb3a119a4eb@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 525b26e0f65ee..2fad20c845b47 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2880,7 +2880,7 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 
 	/* this would be a mac80211 bug ... but don't crash */
 	if (WARN_ON_ONCE(!mvmvif->phy_ctxt))
-		return -EINVAL;
+		return test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status) ? 0 : -EINVAL;
 
 	/*
 	 * If we are in a STA removal flow and in DQA mode:
-- 
2.27.0



