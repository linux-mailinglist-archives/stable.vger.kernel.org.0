Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2C4994F7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391920AbiAXUuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388894AbiAXUkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903DC04591A;
        Mon, 24 Jan 2022 11:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D93F6090C;
        Mon, 24 Jan 2022 19:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83766C340E5;
        Mon, 24 Jan 2022 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053899;
        bh=kbRf5scrruy7y6jvXJpnetLiMFEv5Gi2TPuf03fCRF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6itZoRLfbbi85oNQISlqRDilkLQ1HyeTJY45zCb16TPQcBAGj1gcY8E38PMXDkAt
         xmN1/T3gNeKZTWCELJ7+wAhJv91jmTBostLeI2id6ewPFOhUU0EJKZJd/ON0wfe7TG
         o22dbJ1/F3XdMRsEYgy8jzWCN/tKV05wWaz3yiGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/563] iwlwifi: mvm: fix 32-bit build in FTM
Date:   Mon, 24 Jan 2022 19:39:05 +0100
Message-Id: <20220124184030.645268819@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index a0ce761d0c59b..fe3d52620a897 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -967,7 +967,8 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 	overshoot = IWL_MVM_FTM_INITIATOR_SMOOTH_OVERSHOOT;
 	alpha = IWL_MVM_FTM_INITIATOR_SMOOTH_ALPHA;
 
-	rtt_avg = (alpha * rtt + (100 - alpha) * resp->rtt_avg) / 100;
+	rtt_avg = alpha * rtt + (100 - alpha) * resp->rtt_avg;
+	do_div(rtt_avg, 100);
 
 	IWL_DEBUG_INFO(mvm,
 		       "%pM: prev rtt_avg=%lld, new rtt_avg=%lld, rtt=%lld\n",
-- 
2.34.1



