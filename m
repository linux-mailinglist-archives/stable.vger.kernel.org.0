Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443FC2F55E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfE3Eqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbfE3DLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:40 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EE6244A6;
        Thu, 30 May 2019 03:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185899;
        bh=qSGAm3ySwwe1r1Jo0mKGE3uXUctJ7VgWT9hCHmPXyjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxZwNhYkcHzPLK1g+WNCcobcA/B7UgZtlJh0VqgG13aLdqaKcPYSKKOLir/l/uiqs
         UdpU+V1nAEvsviWRjdCZ6OgXEGLm+JPb9p3DA7OXdnU2SS2Bh69TNX7QvCjWmODdNZ
         cxa2J/YBffJD6rdOMvJMa5ZiYXJdCmgzQDN0w1i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 266/405] iwlwifi: mvm: IBSS: use BE FIFO for multicast
Date:   Wed, 29 May 2019 20:04:24 -0700
Message-Id: <20190530030554.385469838@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 192a7e1f731fd9a64216cce35287eb23360437f6 ]

Back in commit 4d339989acd7 ("iwlwifi: mvm: support ibss in dqa mode")
we changed queue selection for IBSS to be:

    if (ieee80211_is_probe_resp(fc) || ieee80211_is_auth(fc) ||
        ieee80211_is_deauth(fc))
            return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;
    if (info->hw_queue == info->control.vif->cab_queue)
            return info->hw_queue;
    return IWL_MVM_DQA_AP_PROBE_RESP_QUEUE;

Clearly, the thought at the time must've been that mac80211 will
select the hw_queue as the cab_queue, so that we'll return and use
that, where we store the multicast queue for IBSS. This, however,
isn't true because mac80211 doesn't implement powersave for IBSS
and thus selects the normal IBSS interface AC queue (best effort).

This therefore always used the probe response queue, which maps to
the BE FIFO.

In commit cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
we rethought this code, and as a consequence now started mapping the
multicast traffic to the multicast hardware queue since we no longer
relied on mac80211 selecting the queue, doing it ourselves instead.
This queue is mapped to the MCAST FIFO. however, this isn't actually
enabled/controlled by the firmware in IBSS mode because we don't
implement powersave, and frames from this queue can never go out in
this case.

Therefore, we got queue hang reports such as
https://bugzilla.kernel.org/show_bug.cgi?id=201707

Fix this by mapping the multicast queue to the BE FIFO in IBSS so
that all the frames can go out.

Fixes: cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 98d123dd71778..eb452e9dce057 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2277,7 +2277,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	static const u8 _maddr[] = {0x03, 0x00, 0x00, 0x00, 0x00, 0x00};
 	const u8 *maddr = _maddr;
 	struct iwl_trans_txq_scd_cfg cfg = {
-		.fifo = IWL_MVM_TX_FIFO_MCAST,
+		.fifo = vif->type == NL80211_IFTYPE_AP ?
+			IWL_MVM_TX_FIFO_MCAST : IWL_MVM_TX_FIFO_BE,
 		.sta_id = msta->sta_id,
 		.tid = 0,
 		.aggregate = false,
-- 
2.20.1



