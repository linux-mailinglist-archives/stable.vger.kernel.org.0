Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7649996A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455272AbiAXVfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452646AbiAXV0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:26:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA4F8B81061;
        Mon, 24 Jan 2022 21:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4FBC340E4;
        Mon, 24 Jan 2022 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059560;
        bh=02LVYUDW/mrOuwuMTZ8bCkojsOTTzLhDWhfOpPkpTUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yC07YOnhMlQ3Fm93NDeAhkzLk4r8QqqwpC/cqUZD/eYmhRCHugdXta8g7Uxq3AUQS
         lC4rmMqhc4UMu4xOkfdDrPcqCqVHppOSLBYdw1c9OT+MVf/gf+qyYEgqolufPaVq7Q
         jKk1PABQNzq5+SMWdGCp7Mjdg9x5R0F4/QgZE6J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maximilian Ernestus <maximilian@ernestus.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0624/1039] iwlwifi: mvm: synchronize with FW after multicast commands
Date:   Mon, 24 Jan 2022 19:40:13 +0100
Message-Id: <20220124184146.311973043@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 897e3b91ddb2f..9c5c10908f013 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1688,6 +1688,7 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
 	struct iwl_mvm_mc_iter_data iter_data = {
 		.mvm = mvm,
 	};
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1697,6 +1698,22 @@ static void iwl_mvm_recalc_multicast(struct iwl_mvm *mvm)
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



