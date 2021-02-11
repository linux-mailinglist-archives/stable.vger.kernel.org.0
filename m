Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290F0318ECB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBKPeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhBKPcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:32:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E88864F0A;
        Thu, 11 Feb 2021 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055940;
        bh=Hx9nF1kfvTvNLhr+iXaSP1q1WOzP+lk//ZN0zKVinl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op+xlblimTE5dOPZZm00HOPrspcWDmX5ZRtdiXxJHKe93SxnAS1sMSpl4UnvJ2nQS
         64/A3hNnePhEZnFGna1XoTtF7udtNQjGlfyN9YBSAm1dPoAFaWfK3sCtmtMQ04JsJX
         y/otejFVyWq1lrUc9LC5cYpMjv9A1Fsy5g2FmoDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/24] iwlwifi: mvm: invalidate IDs of internal stations at mvm start
Date:   Thu, 11 Feb 2021 16:02:36 +0100
Message-Id: <20210211150149.096442344@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit e223e42aac30bf81f9302c676cdf58cf2bf36950 ]

Having sta_id not set for aux_sta and snif_sta can potentially lead to a
hard to debug issue in case remove station is called without an add. In
this case sta_id 0, an unrelated regular station, will be removed.

In fact, we do have a FW assert that occures rarely and from the debug
data analysis it looks like sta_id 0 is removed by mistake, though it's
hard to pinpoint the exact flow. The WARN_ON in this patch should help
to find it.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.5dc6dd9b22d5.I2add1b5ad24d0d0a221de79d439c09f88fcaf15d@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index b04cc6214bac8..bc25a59807c34 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -838,6 +838,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (!mvm->scan_cmd)
 		goto out_free;
 
+	/* invalidate ids to prevent accidental removal of sta_id 0 */
+	mvm->aux_sta.sta_id = IWL_MVM_INVALID_STA;
+	mvm->snif_sta.sta_id = IWL_MVM_INVALID_STA;
+
 	/* Set EBS as successful as long as not stated otherwise by the FW. */
 	mvm->last_ebs_successful = true;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a36aa9e85e0b3..40cafcf40ccf0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2070,6 +2070,9 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON_ONCE(mvm->snif_sta.sta_id == IWL_MVM_INVALID_STA))
+		return -EINVAL;
+
 	iwl_mvm_disable_txq(mvm, NULL, mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
 	if (ret)
@@ -2084,6 +2087,9 @@ int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON_ONCE(mvm->aux_sta.sta_id == IWL_MVM_INVALID_STA))
+		return -EINVAL;
+
 	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
 	if (ret)
-- 
2.27.0



