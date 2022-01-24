Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83FF499496
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359018AbiAXUn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389064AbiAXUkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CF0C04591E;
        Mon, 24 Jan 2022 11:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1B86090B;
        Mon, 24 Jan 2022 19:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE95C340E7;
        Mon, 24 Jan 2022 19:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053902;
        bh=0dTjDPuPh42l9Elb2mTzWgKjEFKlEsgebhqLwC16fN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUsTsqmSS7Tv98W3Yh3dLaOrqvtE5c70fB3YjCTN6UcIlffoAGAm0y5BJfjwuoHGt
         w41hBTOQr6wt0TZ15VUeZshlzVYz7o4UZ5W3OTR6pQcrghDU+CyDhQxgSjtAMnBM7n
         WC4zcAz9t1DR8/rgRlYLfbHnHn6xikI6VX9DauHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Errera <nathan.errera@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/563] iwlwifi: mvm: test roc running status bits before removing the sta
Date:   Mon, 24 Jan 2022 19:39:06 +0100
Message-Id: <20220124184030.678301912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Errera <nathan.errera@intel.com>

[ Upstream commit 998e1aba6e5eb35370eaf30ccc1823426ec11f90 ]

In some cases the sta is being removed twice since we do not test the
roc aux running before removing it. Start looking at the bit before
removing the sta.

Signed-off-by: Nathan Errera <nathan.errera@intel.com>
Fixes: 2c2c3647cde4 ("iwlwifi: mvm: support ADD_STA_CMD_API_S ver 12")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219121514.d5376ac6bcb0.Ic5f8470ea60c072bde9d1503e5f528b65e301e20@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/time-event.c   | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 394598b14a173..a633ad5f8ca4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -98,14 +98,13 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm, roc_done_wk);
 
 	/*
-	 * Clear the ROC_RUNNING /ROC_AUX_RUNNING status bit.
+	 * Clear the ROC_RUNNING status bit.
 	 * This will cause the TX path to drop offchannel transmissions.
 	 * That would also be done by mac80211, but it is racy, in particular
 	 * in the case that the time event actually completed in the firmware
 	 * (which is handled in iwl_mvm_te_handle_notif).
 	 */
 	clear_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
-	clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status);
 
 	synchronize_net();
 
@@ -131,9 +130,19 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 			mvmvif = iwl_mvm_vif_from_mac80211(mvm->p2p_device_vif);
 			iwl_mvm_flush_sta(mvm, &mvmvif->bcast_sta, true);
 		}
-	} else {
+	}
+
+	/*
+	 * Clear the ROC_AUX_RUNNING status bit.
+	 * This will cause the TX path to drop offchannel transmissions.
+	 * That would also be done by mac80211, but it is racy, in particular
+	 * in the case that the time event actually completed in the firmware
+	 * (which is handled in iwl_mvm_te_handle_notif).
+	 */
+	if (test_and_clear_bit(IWL_MVM_STATUS_ROC_AUX_RUNNING, &mvm->status)) {
 		/* do the same in case of hot spot 2.0 */
 		iwl_mvm_flush_sta(mvm, &mvm->aux_sta, true);
+
 		/* In newer version of this command an aux station is added only
 		 * in cases of dedicated tx queue and need to be removed in end
 		 * of use */
-- 
2.34.1



