Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD0C4FD69C
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353320AbiDLHq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357058AbiDLHjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42A5E9F;
        Tue, 12 Apr 2022 00:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36338616B2;
        Tue, 12 Apr 2022 07:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395C9C385A5;
        Tue, 12 Apr 2022 07:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747466;
        bh=sGHw+Qc1sKYhrFjSu0qr7jBNBmG3wNZQljjWBWyhD2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVu1/VZCcfnVH1/Ww3PKcWDT3M7jvlXXeUMSQ4OGcmU81UN8K9c974yaj2ZdDUi6O
         LeoboqMETbBPH/SdcF86IymB0Je5ShFjyik1uKfXeXz/f47wpj2OKvsqtrdVlmyiZ6
         xIe7jNe0F9IUF4NnVf5ls4DfognvkGsM7NlRlyt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 089/343] iwlwifi: mvm: move only to an enabled channel
Date:   Tue, 12 Apr 2022 08:28:27 +0200
Message-Id: <20220412062953.675935614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit e04135c07755d001b5cde61048c69a7cc84bb94b ]

During disassociation we're decreasing the phy's ref count.
If the ref count becomes 0, we're configuring the phy ctxt
to the default channel (the lowest channel which the device
can operate on). Currently we're not checking whether the
the default channel is enabled or not. Fix it by configuring
the phy ctxt to the lowest channel which is enabled.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220210181930.03f281b6a6bc.I5b63d43ec41996d599e6f37ec3f32e878b3e405e@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 31 +++++++++++++------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 9af40b0fa37a..a6e6673bf4ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -349,18 +349,31 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
 	 * otherwise we might not be able to reuse this phy.
 	 */
 	if (ctxt->ref == 0) {
-		struct ieee80211_channel *chan;
+		struct ieee80211_channel *chan = NULL;
 		struct cfg80211_chan_def chandef;
-		struct ieee80211_supported_band *sband = NULL;
-		enum nl80211_band band = NL80211_BAND_2GHZ;
+		struct ieee80211_supported_band *sband;
+		enum nl80211_band band;
+		int channel;
 
-		while (!sband && band < NUM_NL80211_BANDS)
-			sband = mvm->hw->wiphy->bands[band++];
+		for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
+			sband = mvm->hw->wiphy->bands[band];
 
-		if (WARN_ON(!sband))
-			return;
+			if (!sband)
+				continue;
+
+			for (channel = 0; channel < sband->n_channels; channel++)
+				if (!(sband->channels[channel].flags &
+						IEEE80211_CHAN_DISABLED)) {
+					chan = &sband->channels[channel];
+					break;
+				}
 
-		chan = &sband->channels[0];
+			if (chan)
+				break;
+		}
+
+		if (WARN_ON(!chan))
+			return;
 
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
 		iwl_mvm_phy_ctxt_changed(mvm, ctxt, &chandef, 1, 1);
-- 
2.35.1



