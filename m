Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809921059E1
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUSpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:45:35 -0500
Received: from mga05.intel.com ([192.55.52.43]:19591 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfKUSpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 13:45:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 10:45:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="357885322"
Received: from antonma-mobl.ger.corp.intel.com (HELO egrumbac-mobl1.ger.corp.intel.com) ([10.255.202.138])
  by orsmga004.jf.intel.com with ESMTP; 21 Nov 2019 10:45:33 -0800
From:   Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To:     linux-wireless@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] iwlwifi: mvm: don't send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
Date:   Thu, 21 Nov 2019 20:45:30 +0200
Message-Id: <20191121184530.5393-1-emmanuel.grumbach@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
References: <20191120132628.30731-1-emmanuel.grumbach@intel.com>
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
v2: avoid the unused variable warning
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 75a7af5ad7b2..392bfa4b496c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -514,14 +514,20 @@ static bool iwl_mvm_is_sn_less(u16 sn1, u16 sn2, u16 buffer_size)
 
 static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
 {
-	struct iwl_mvm_rss_sync_notif notif = {
-		.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
-		.metadata.sync = 0,
-		.nssn_sync.baid = baid,
-		.nssn_sync.nssn = nssn,
-	};
-
-	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+	/*
+	 * This allow to synchronize the queues, but it has been reported
+	 * to cause FH issues. Don't send the notification for now.
+	 *
+	 * struct iwl_mvm_rss_sync_notif notif = {
+	 *	.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
+	 *	.metadata.sync = 0,
+	 *	.nssn_sync.baid = baid,
+	 *	.nssn_sync.nssn = nssn,
+	 * };
+	 *
+	 *
+	 * iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+	 */
 }
 
 #define RX_REORDER_BUF_TIMEOUT_MQ (HZ / 10)
-- 
2.17.1

