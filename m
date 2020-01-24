Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2E148009
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389083AbgAXLHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389422AbgAXLHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995DD2077C;
        Fri, 24 Jan 2020 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864030;
        bh=N8OxgHRE+OU7MyrhYIoZDhwBbJB1W+To60UzF2/y50s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOhVOXg74OqkO3CGvKI5227o09MsAhrpUrpJCIfMFiSb43za+0+pYVc+xEnGvjxxR
         n4saNiesmSqLIaTQVe4SmAO9AtiLYmsFwkD7jIEuG+M9wjP8U3dVcq09kYUgrQYcMU
         FcSKfS2oDr4YlHQl/W2IXjaTG2ml1y33A1PvMXAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Danny Alexander <danny.alexander@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/639] iwlwifi: mvm: fix A-MPDU reference assignment
Date:   Fri, 24 Jan 2020 10:25:22 +0100
Message-Id: <20200124093106.263397709@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1f7698abedeeb3fef3cbcf78e16f925df675a179 ]

The current code assigns the reference, and then goes to increment
it if the toggle bit has changed. That way, we get

Toggle  0  0  0  0  1  1  1  1
ID      1  1  1  1  1  2  2  2

Fix that by assigning the post-toggle ID to get

Toggle  0  0  0  0  1  1  1  1
ID      1  1  1  1  2  2  2  2

Reported-by: Danny Alexander <danny.alexander@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: fbe4112791b8 ("iwlwifi: mvm: update mpdu metadata API")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 036d1d82d93e7..77e3694536421 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1077,7 +1077,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			he_phy_data = le64_to_cpu(desc->v1.he_phy_data);
 
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-		rx_status->ampdu_reference = mvm->ampdu_ref;
 		/* toggle is switched whenever new aggregation starts */
 		if (toggle_bit != mvm->ampdu_toggle) {
 			mvm->ampdu_ref++;
@@ -1092,6 +1091,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 						RX_FLAG_AMPDU_EOF_BIT;
 			}
 		}
+		rx_status->ampdu_reference = mvm->ampdu_ref;
 	}
 
 	rcu_read_lock();
-- 
2.20.1



