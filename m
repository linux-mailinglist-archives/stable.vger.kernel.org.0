Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A11314BB8F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbgA1ODB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgA1OC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DE6205F4;
        Tue, 28 Jan 2020 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220179;
        bh=UI4qpDBPZWL60iebMjsOsFxDjVRgMXoR9HmhwXFonz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXICbPpTXkwd1TEWBrEhP4iJE3g5X3y0aD9n5Mi8LKTdoTA/XepYaZ8gvhdfseX33
         Tsf6a6VetfIa0XdwCBmWfSDCXcjcVFKQu5aAlICcbxC/1QBdM9SmdvnK5Xp3IGXrly
         yoSc8bkGdC5tYMqcav+QqSZebGm633bbMoK1jAqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 049/104] iwlwifi: mvm: dont send the IWL_MVM_RXQ_NSSN_SYNC notif to Rx queues
Date:   Tue, 28 Jan 2020 15:00:10 +0100
Message-Id: <20200128135824.452356310@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit d829229e35f302fd49c052b5c5906c90ecf9911d upstream.

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -154,5 +154,6 @@
 #define IWL_MVM_D3_DEBUG			false
 #define IWL_MVM_USE_TWT				false
 #define IWL_MVM_AMPDU_CONSEC_DROPS_DELBA	10
+#define IWL_MVM_USE_NSSN_SYNC			0
 
 #endif /* __MVM_CONSTANTS_H */
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -514,14 +514,17 @@ static bool iwl_mvm_is_sn_less(u16 sn1,
 
 static void iwl_mvm_sync_nssn(struct iwl_mvm *mvm, u8 baid, u16 nssn)
 {
-	struct iwl_mvm_rss_sync_notif notif = {
-		.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
-		.metadata.sync = 0,
-		.nssn_sync.baid = baid,
-		.nssn_sync.nssn = nssn,
-	};
+	if (IWL_MVM_USE_NSSN_SYNC) {
+		struct iwl_mvm_rss_sync_notif notif = {
+			.metadata.type = IWL_MVM_RXQ_NSSN_SYNC,
+			.metadata.sync = 0,
+			.nssn_sync.baid = baid,
+			.nssn_sync.nssn = nssn,
+		};
 
-	iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif, sizeof(notif));
+		iwl_mvm_sync_rx_queues_internal(mvm, (void *)&notif,
+						sizeof(notif));
+	}
 }
 
 #define RX_REORDER_BUF_TIMEOUT_MQ (HZ / 10)


