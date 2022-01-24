Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90247499B96
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574922AbiAXVuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357731AbiAXVhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436B7C0604FC;
        Mon, 24 Jan 2022 12:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5E11614EC;
        Mon, 24 Jan 2022 20:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0BAC340E5;
        Mon, 24 Jan 2022 20:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055799;
        bh=e8XSjosMnT+AVvfXTWREU5HrdWjIpTnD5X6dAIMx0uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv8NuYBbk0R+NeLUh9TxxQJkt/lolYKZ5tT3REhtDmMwIVK+IuVzI955pU6AygiDJ
         WalxeoO2EfR6XZiGiGOHWkOEr0IYUxAlNuPojIeK3osN6+dV+T0+T9Rhe85fXTap0S
         iDZ8J2cXWcLR21TZWiHKlRNwPZ56jQ7caMriSxmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/846] iwlwifi: mvm: fix 32-bit build in FTM
Date:   Mon, 24 Jan 2022 19:36:27 +0100
Message-Id: <20220124184110.240654842@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b0f92549f2c2458200935c12a2e2a6e80234cf5 ]

On a 32-bit build, the division here needs to be done
using do_div(), otherwise the compiler will try to call
a function that doesn't exist, thus failing to build.

Fixes: b68bd2e3143a ("iwlwifi: mvm: Add FTM initiator RTT smoothing logic")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219111352.e56cbf614a4d.Ib98004ccd2c7a55fd883a8ea7eebd810f406dec6@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 03e5bf5cb9094..c7fee6a2f7fd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -1054,7 +1054,8 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 	overshoot = IWL_MVM_FTM_INITIATOR_SMOOTH_OVERSHOOT;
 	alpha = IWL_MVM_FTM_INITIATOR_SMOOTH_ALPHA;
 
-	rtt_avg = (alpha * rtt + (100 - alpha) * resp->rtt_avg) / 100;
+	rtt_avg = alpha * rtt + (100 - alpha) * resp->rtt_avg;
+	do_div(rtt_avg, 100);
 
 	IWL_DEBUG_INFO(mvm,
 		       "%pM: prev rtt_avg=%lld, new rtt_avg=%lld, rtt=%lld\n",
-- 
2.34.1



