Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1022840E0B8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhIPQXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhIPQVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A946140B;
        Thu, 16 Sep 2021 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808902;
        bh=Bxemffs1luq8b35EOX38WdqC11UYKbiJRwusEb19A48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISKcKcAkf793Y4VtyvykM4eJhHlyowRyhIc6Gvq5za/X+FNhKTXS3u8s/ffOinrrB
         euH2HzmQNFhulFW18gvh+Sm7S1hLt/sFkrcSlfDHnZT6OC22uDJs9IVHC6lxb0q9hi
         Zo/Z/4X5n3NHnGDHwFH0itnvIMZrz7mbaCXahFuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/306] iwlwifi: mvm: fix access to BSS elements
Date:   Thu, 16 Sep 2021 18:00:09 +0200
Message-Id: <20210916155803.074173155@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6c608cd6962ebdf84fd3de6d42f88ed64d2f4e1b ]

BSS elements are protected using RCU, so we need to use
RCU properly to access them, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210805130823.fd8b5791ab44.Iba26800a6301078d3782fb249c476dd8ac2bf3c6@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9caff70cbd27..6f301ac8cce2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3029,16 +3029,20 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 						    void *_data)
 {
 	struct iwl_mvm_he_obss_narrow_bw_ru_data *data = _data;
+	const struct cfg80211_bss_ies *ies;
 	const struct element *elem;
 
-	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, bss->ies->data,
-				  bss->ies->len);
+	rcu_read_lock();
+	ies = rcu_dereference(bss->ies);
+	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
+				  ies->len);
 
 	if (!elem || elem->datalen < 10 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
 	}
+	rcu_read_unlock();
 }
 
 static void iwl_mvm_check_he_obss_narrow_bw_ru(struct ieee80211_hw *hw,
-- 
2.30.2



