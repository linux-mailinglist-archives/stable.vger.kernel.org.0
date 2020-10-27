Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB029C27C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760832AbgJ0Rgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760804AbgJ0Ogd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A731C2222C;
        Tue, 27 Oct 2020 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809392;
        bh=hZ7gd0AfcfRYq0EOQUsHs1ZqsOn6ncwDMHF6lQ2LrWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RytIUMCBnIl8Ip4n7wTYZF2WTBO9v25C2RvUUuxo8bL74+diTSXAjVka8+tN2d1ML
         2MUiIvklkjGcFj089lpr99kduqElbnDiybPJiKLJh28XGLe8lr4S7wTOfmaAHRkS9a
         AMyPpqNftyPzcSkJlEPdZ4FtCzNOaFcglwjZVgiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/408] iwlwifi: mvm: split a print to avoid a WARNING in ROC
Date:   Tue, 27 Oct 2020 14:51:56 +0100
Message-Id: <20201027135503.358943552@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 903b3f9badf1d54f77b468b96706dab679b45b14 ]

A print in the remain on channel code was too long and caused
a WARNING, split it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: dc28e12f2125 ("iwlwifi: mvm: ROC: Extend the ROC max delay duration & limit ROC duration")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200930102759.58d57c0bdc68.Ib06008665e7bf1199c360aa92691d9c74fb84990@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ed92a8e8cd519..01b26b3327b01 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3650,9 +3650,12 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 	tail->apply_time_max_delay = cpu_to_le32(delay);
 
 	IWL_DEBUG_TE(mvm,
-		     "ROC: Requesting to remain on channel %u for %ums (requested = %ums, max_delay = %ums, dtim_interval = %ums)\n",
-		     channel->hw_value, req_dur, duration, delay,
-		     dtim_interval);
+		     "ROC: Requesting to remain on channel %u for %ums\n",
+		     channel->hw_value, req_dur);
+	IWL_DEBUG_TE(mvm,
+		     "\t(requested = %ums, max_delay = %ums, dtim_interval = %ums)\n",
+		     duration, delay, dtim_interval);
+
 	/* Set the node address */
 	memcpy(tail->node_addr, vif->addr, ETH_ALEN);
 
-- 
2.25.1



