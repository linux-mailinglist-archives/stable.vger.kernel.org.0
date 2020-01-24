Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A6C147C06
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgAXJsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgAXJsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:48:30 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 333D920718;
        Fri, 24 Jan 2020 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859309;
        bh=397TAFOZ9B5BamrBQvBNE0GIVGJqI2DAukQZQ861zZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2DV5mibED9XdgXm1aib/tqp6NBlMaof48O92Lg3vY+gTzdrXq8FimVYRmoJS2rev
         SKq1s/oAjJE6BcGanWQ9c1vCvdQGFeWKRH8ZC7dx6fJzYgMsrYDGZwaaQ6TRVWIhAU
         dw/4KPSe/c6L9Hx0r5ACozmbdh6IfO6jJdhBgXLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Danny Alexander <danny.alexander@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/343] iwlwifi: mvm: fix A-MPDU reference assignment
Date:   Fri, 24 Jan 2020 10:28:14 +0100
Message-Id: <20200124092929.865148569@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 7fb8bbaf21420..1a12e829e98b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -871,12 +871,12 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
 
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-		rx_status->ampdu_reference = mvm->ampdu_ref;
 		/* toggle is switched whenever new aggregation starts */
 		if (toggle_bit != mvm->ampdu_toggle) {
 			mvm->ampdu_ref++;
 			mvm->ampdu_toggle = toggle_bit;
 		}
+		rx_status->ampdu_reference = mvm->ampdu_ref;
 	}
 
 	rcu_read_lock();
-- 
2.20.1



