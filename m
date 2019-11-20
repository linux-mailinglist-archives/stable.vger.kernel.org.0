Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D38F103B56
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 14:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfKTN0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 08:26:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:43274 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729457AbfKTN0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 08:26:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 05:26:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="218627112"
Received: from egrumbac-mobl1.jer.intel.com ([10.12.117.10])
  by orsmga002.jf.intel.com with ESMTP; 20 Nov 2019 05:26:35 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     luciano.coelho@intel.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
Date:   Wed, 20 Nov 2019 15:26:28 +0200
Message-Id: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The purpose of this was to keep all the queues updated with
the Rx sequence numbers because unlikely yet possible
situations where queues can't understand if a specific
packet needs to be dropped or not.

Unfortunately, it was reported that this caused issues in
our DMA engine. We don't fully understand how this is related,
but this is being currently debugged. For now, just don't send
this notification to the Rx queues. This de-facto reverts my
commit 3c514bf831ac12356b695ff054bef641b9e99593:

iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues

This issue was reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=204873
https://bugzilla.kernel.org/show_bug.cgi?id=205001
and others maybe.

Fixes: 3c514bf831ac ("iwlwifi: mvm: add a loose synchronization of the NSSN across Rx queues")
CC: <stable@vger.kernel.org> # 5.3+
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 75a7af5ad7b2..8925fe5976cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -521,7 +521,11 @@ static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
 		.nssn_sync.nssn = nssn,
 	};
 
-	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+	/*
+	 * This allow to synchronize the queues, but it has been reported
+	 * to cause FH issues. Don't send the notification for now.
+	 * iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+	 */
 }
 
 #define RX_REORDER_BUF_TIMEOUT_MQ (HZ / 10)
-- 
2.17.1

