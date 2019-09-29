Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFB1C14D4
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfI2N6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbfI2N6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8680421882;
        Sun, 29 Sep 2019 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765502;
        bh=4+kZGCbJLxhcOOFJQC0TqsQIxXAH4owJOsplLFhJJPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP3Jw5RQfNWbe9HG6LWAPrAHowyzZNCjSPhdYR2zuuYh8Lxg9dkCAefEOeNtmvZ/T
         eGnUVLaR/9gW0EbB8oiRlxHlt9duHNdbK9Lvi85CawItt6M9J+RS7YVEzyh5rPovEk
         cRxa4IONnj3FT5+5h8xuSHrYuKumtT3NOOMayW4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 4.19 23/63] iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates
Date:   Sun, 29 Sep 2019 15:53:56 +0200
Message-Id: <20190929135036.697281866@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

commit 2859de7637b541dc7191f4d3fce4a1adba80fb3e upstream.

As with the non-offloaded rs case, during assoc on the ap side the phy
context is set to 20MHz until authorization of a client that supports
wider channel-widths. Support this by sending the initial
tlc_config_cmd with max supported channel width of 20MHz until
authorization succeeds.

Fixes: 6b7a5aea71b3 ("iwlwifi: mvm: always init rs with 20mhz bandwidth rates")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c |    5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c    |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h    |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -315,7 +315,7 @@ out:
 }
 
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		     enum nl80211_band band)
+		     enum nl80211_band band, bool update)
 {
 	struct ieee80211_hw *hw = mvm->hw;
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -324,7 +324,8 @@ void rs_fw_rate_init(struct iwl_mvm *mvm
 	struct ieee80211_supported_band *sband;
 	struct iwl_tlc_config_cmd cfg_cmd = {
 		.sta_id = mvmsta->sta_id,
-		.max_ch_width = rs_fw_bw_from_sta_bw(sta),
+		.max_ch_width = update ?
+			rs_fw_bw_from_sta_bw(sta) : RATE_MCS_CHAN_WIDTH_20,
 		.flags = cpu_to_le16(rs_fw_set_config_flags(mvm, sta)),
 		.chains = rs_fw_set_active_chains(iwl_mvm_get_valid_tx_ant(mvm)),
 		.max_mpdu_len = cpu_to_le16(sta->max_amsdu_len),
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4113,7 +4113,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm
 			  enum nl80211_band band, bool update)
 {
 	if (iwl_mvm_has_tlc_offload(mvm))
-		rs_fw_rate_init(mvm, sta, band);
+		rs_fw_rate_init(mvm, sta, band, update);
 	else
 		rs_drv_rate_init(mvm, sta, band, update);
 }
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -461,7 +461,7 @@ void rs_remove_sta_debugfs(void *mvm, vo
 
 void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta);
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		     enum nl80211_band band);
+		     enum nl80211_band band, bool update);
 int rs_fw_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			bool enable);
 void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,


