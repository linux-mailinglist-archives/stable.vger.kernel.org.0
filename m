Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A3940E49F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbhIPREx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347307AbhIPQ6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A29D610A6;
        Thu, 16 Sep 2021 16:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809916;
        bh=YSgzmEAdQE7tXJ2RhuZPDeRbSkGlOH9uX5878HXAkE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqP8bPEmEY//PaNCxLcjxSarx6EuhiUkrTZSSkq6iMWFI/bt/V/O+UjUi39j9qhjJ
         j1CS/RyXsbLlHYaX8v5bnw7s0lkQwrOLVjMgGdev1jNvNqNx1rSBUhzoToWrUzdHXJ
         AX7NLSgJ8p6zx6vhePTo7iIAFEkhc8jF17cFQaNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 331/380] iwlwifi: mvm: fix access to BSS elements
Date:   Thu, 16 Sep 2021 18:01:28 +0200
Message-Id: <20210916155815.309091879@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 141d9fc299b0..6981608ef165 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2987,16 +2987,20 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
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



