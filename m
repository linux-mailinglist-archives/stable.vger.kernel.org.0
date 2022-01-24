Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443D3499B22
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574638AbiAXVuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377400AbiAXVha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D766DC0BD11D;
        Mon, 24 Jan 2022 12:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9665CB8122D;
        Mon, 24 Jan 2022 20:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DF0C340E5;
        Mon, 24 Jan 2022 20:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055802;
        bh=SFpaN1Q+FQLxVudgmI3DnJry1PBPmM+zzf/zOsrDouM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bti/cxbvA0uOxw8Gt089m+vggJkFsy/aPwAW6jnldkg42U4ngJy5IzPO5Ib+f9GR3
         j6BdtE78Us5vLIBiT3UsKiXN7QK4c3Sci6geX5RJrTWklTDXRoZOn6taLG2dXZ8alt
         mtlgPCgY4gb/Dzbwnh6Lmj2SIfcYg2syiDya7fg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Errera <nathan.errera@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/846] iwlwifi: mvm: test roc running status bits before removing the sta
Date:   Mon, 24 Jan 2022 19:36:28 +0100
Message-Id: <20220124184110.278730882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index e91f8e889df70..f93f15357a3f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -49,14 +49,13 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
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
 
@@ -82,9 +81,19 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
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



