Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3470498909
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbiAXSwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245688AbiAXSvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:51:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D935C0613E6;
        Mon, 24 Jan 2022 10:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9068EB8121B;
        Mon, 24 Jan 2022 18:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE1C340E5;
        Mon, 24 Jan 2022 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050276;
        bh=x0GDq5/TGahdJpi0k1BZhKdPLlEVphD7FM3LYcMZxcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAD4+M46JYtUFi/fR0FiyNSnO/70mlGPHSF+QX8rebE24OWYfrHzYC4H7yHjtZBwI
         zpL0iLXQsw16Q1HZZf7VtlTb7udnZs4LLeletq6cDakoysgf/cRTF0T2Rx7fB7DDx/
         F+PysBrOotP1do6Jwe+gDW+3tOMqRm+UwZSMj/wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maximilian Ernestus <maximilian@ernestus.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 067/114] iwlwifi: mvm: synchronize with FW after multicast commands
Date:   Mon, 24 Jan 2022 19:42:42 +0100
Message-Id: <20220124183929.170826912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit db66abeea3aefed481391ecc564fb7b7fb31d742 ]

If userspace installs a lot of multicast groups very quickly, then
we may run out of command queue space as we send the updates in an
asynchronous fashion (due to locking concerns), and the CPU can
create them faster than the firmware can process them. This is true
even when mac80211 has a work struct that gets scheduled.

Fix this by synchronizing with the firmware after sending all those
commands - outside of the iteration we can send a synchronous echo
command that just has the effect of the CPU waiting for the prior
asynchronous commands to finish. This also will cause fewer of the
commands to be sent to the firmware overall, because the work will
only run once when rescheduled multiple times while it's running.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213649
Suggested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reported-by: Maximilian Ernestus <maximilian@ernestus.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204083238.51aea5b79ea4.I88a44798efda16e9fe480fb3e94224931d311b29@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ca498b1f1f568..6417fda88733c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1957,6 +1957,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	struct iwl_mvm_mc_iter_data iter_data = {
 		.mvm = mvm,
 	};
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1966,6 +1967,22 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_mc_iface_iterator, &iter_data);
+
+	/*
+	 * Send a (synchronous) ech command so that we wait for the
+	 * multiple asynchronous MCAST_FILTER_CMD commands sent by
+	 * the interface iterator. Otherwise, we might get here over
+	 * and over again (by userspace just sending a lot of these)
+	 * and the CPU can send them faster than the firmware can
+	 * process them.
+	 * Note that the CPU is still faster - but with this we'll
+	 * actually send fewer commands overall because the CPU will
+	 * not schedule the work in mac80211 as frequently if it's
+	 * still running when rescheduled (possibly multiple times).
+	 */
+	ret = iwl_mvm_send_cmd_pdu(mvm, ECHO_CMD, 0, 0, NULL);
+	if (ret)
+		IWL_ERR(mvm, "Failed to synchronize multicast groups update\n");
 }
 
 static u64 iwl_mvm_prepare_multicast(struct ieee80211_hw *hw,
-- 
2.34.1



