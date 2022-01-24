Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D43499AE8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574135AbiAXVrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377443AbiAXVh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC7EC05A1A4;
        Mon, 24 Jan 2022 12:23:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F463614E2;
        Mon, 24 Jan 2022 20:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5A4C340E5;
        Mon, 24 Jan 2022 20:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055811;
        bh=Ze5VekDJFQ9F4Lq5FKHeY0TK6oTja4UldYieM8HT1Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUK6yVMyIiTzvRLFDHgLopblvAh47WcHGBnHUZsflF6t1KpcRLLAQHifZlKAT9Blf
         /loQXAZlZvDOk60F7UsCx7nCr3PjmaMCk5Ey2Wi0kVBkBbwvMk7c7AS9Fxf+TmmqnV
         PMnsP7cw7JRl1us95nMhi9+rXgy7w9c/9Pk/7KSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/846] iwlwifi: mvm: set protected flag only for NDP ranging
Date:   Mon, 24 Jan 2022 19:36:30 +0100
Message-Id: <20220124184110.349637437@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 6bb2ea37c02db98cb677f978cfcb833ca608c5eb ]

Don't use protected ranging negotiation for FTM ranging as responders
that support only FTM ranging don't expect the FTM request to be
protected.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Fixes: 517a5eb9fab2 ("iwlwifi: mvm: when associated with PMF, use protected NDP ranging negotiation")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219132536.f50ed0e3c6b3.Ibff247ee9d4e6e0a1a2d08a3c8a4bbb37e6829dd@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index c7fee6a2f7fd4..6e1d37f258035 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -499,7 +499,7 @@ iwl_mvm_ftm_put_target(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		rcu_read_lock();
 
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id]);
-		if (sta->mfp)
+		if (sta->mfp && (peer->ftm.trigger_based || peer->ftm.non_trigger_based))
 			FTM_PUT_FLAG(PMF);
 
 		rcu_read_unlock();
-- 
2.34.1



