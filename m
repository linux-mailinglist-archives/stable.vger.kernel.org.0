Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8722F075
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbgG0OYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730619AbgG0OYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF361208E4;
        Mon, 27 Jul 2020 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859889;
        bh=JfB1Zl1taTnjxsD1iQ0MHKt1q1YqdCcsz0pQJBK6fDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmaz4fp7xE4eKKnvNW3oP/FUjIyaRsOjcCO/u6lXu6SduUUuHJI/tEJXTBz8MnW9K
         aaXTRIbCXh6S4cL26/cc8Ml8W6rvMVyuqlOoYpjqrCYYN2wrO8XaehfaXMnT7hrY+F
         nFtFi8gML9afHGezD2OQuaHf4Sgm+42KJKYa8A10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.7 144/179] iwlwifi: mvm: dont call iwl_mvm_free_inactive_queue() under RCU
Date:   Mon, 27 Jul 2020 16:05:19 +0200
Message-Id: <20200727134939.661424853@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit fbb1461ad1d6eacca9beb69a2f3ce1b5398d399b upstream.

iwl_mvm_free_inactive_queue() will sleep in synchronize_net() under
some circumstances, so don't call it under RCU. There doesn't appear
to be a need for RCU protection around this particular call.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200403112332.0f49448c133d.I17fd308bc4a9491859c9b112f4eb5d2c3fc18d7d@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1184,17 +1184,15 @@ static int iwl_mvm_inactivity_check(stru
 	for_each_set_bit(i, &changetid_queues, IWL_MAX_HW_QUEUES)
 		iwl_mvm_change_queue_tid(mvm, i);
 
+	rcu_read_unlock();
+
 	if (free_queue >= 0 && alloc_for_sta != IWL_MVM_INVALID_STA) {
 		ret = iwl_mvm_free_inactive_queue(mvm, free_queue, queue_owner,
 						  alloc_for_sta);
-		if (ret) {
-			rcu_read_unlock();
+		if (ret)
 			return ret;
-		}
 	}
 
-	rcu_read_unlock();
-
 	return free_queue;
 }
 


