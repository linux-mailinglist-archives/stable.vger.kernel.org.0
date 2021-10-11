Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF82429061
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbhJKOHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238203AbhJKOFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2874461040;
        Mon, 11 Oct 2021 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960792;
        bh=ax1BJIPKzb6ChsxwUbh2N9uhgspZdUY7uAaeLxR64ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7zIZkOhMgBQASIw7MkPfJMEeNJj7cbgG5DO673J8QdXbbzc6eWbmWRwbmjwVYAK4
         UZm8z/4/8BQ61tggsNRPmFvtWcHvU+GDAXGKoY9A06LHm2CSb8LvUirOue06P26uah
         T8Ok21pGn2aPBei5mqfShviArXVI8zO0Fh/1Ijrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 041/151] iwlwifi: mvm: Fix possible NULL dereference
Date:   Mon, 11 Oct 2021 15:45:13 +0200
Message-Id: <20211011134519.178072223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 24d5f16e407b75bc59d5419b957a9cab423b2681 ]

In __iwl_mvm_remove_time_event() check that 'te_data->vif' is NULL
before dereferencing it.

Fixes: 7b3954a1d69a ("iwlwifi: mvm: Explicitly stop session protection before unbinding")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 24b658a3098a..3ae727bc4e94 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -652,12 +652,13 @@ static bool __iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 					u32 *uid)
 {
 	u32 id;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
+	struct iwl_mvm_vif *mvmvif;
 	enum nl80211_iftype iftype;
 
 	if (!te_data->vif)
 		return false;
 
+	mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
 	iftype = te_data->vif->type;
 
 	/*
-- 
2.33.0



