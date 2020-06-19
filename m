Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98632013CA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391589AbgFSQED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403814AbgFSPLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:11:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC15A206FA;
        Fri, 19 Jun 2020 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579465;
        bh=gt02xV2gTXAGJGD8SHqqXs6e/DU/oGfgASH0Dlqg5Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnzXoAeR07UBiLyseJxFYodbVhA4gAHXEZL/D6vKuvlfi5CiGrvocHdYZfOW7rcs3
         dft7gYU+QWh1RyAd4tQquV7h2oKuE9YmZLs6uK6ZbMsxShxoBMOfhZrfyooWaELfVc
         VpfFwrDr3sax2CZhZpbg3Rf3APJlWHQJ731RqJYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/261] iwlwifi: mvm: fix aux station leak
Date:   Fri, 19 Jun 2020 16:32:36 +0200
Message-Id: <20200619141656.825052015@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sharon <sara.sharon@intel.com>

[ Upstream commit f327236df2afc8c3c711e7e070f122c26974f4da ]

When mvm is initialized we alloc aux station with aux queue.
We later free the station memory when driver is stopped, but we
never free the queue's memory, which casues a leak.

Add a proper de-initialization of the station.

Signed-off-by: Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200529092401.0121c5be55e9.Id7516fbb3482131d0c9dfb51ff20b226617ddb49@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c  |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c   | 18 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h   |  6 +++---
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6ca087ffd163..ed92a8e8cd51 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1193,14 +1193,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	 */
 	flush_work(&mvm->roc_done_wk);
 
+	iwl_mvm_rm_aux_sta(mvm);
+
 	iwl_mvm_stop_device(mvm);
 
 	iwl_mvm_async_handlers_purge(mvm);
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
 
-	/* the fw is stopped, the aux sta is dead: clean up driver state */
-	iwl_mvm_del_aux_sta(mvm);
-
 	/*
 	 * Clear IN_HW_RESTART and HW_RESTART_REQUESTED flag when stopping the
 	 * hw (as restart_complete() won't be called in this case) and mac80211
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 71d339e90a9e..41f62793a57c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2080,16 +2080,24 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return ret;
 }
 
-void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm)
+int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 {
-	iwl_mvm_dealloc_int_sta(mvm, &mvm->snif_sta);
-}
+	int ret;
 
-void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm)
-{
 	lockdep_assert_held(&mvm->mutex);
 
+	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
+	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
+	if (ret)
+		IWL_WARN(mvm, "Failed sending remove station\n");
 	iwl_mvm_dealloc_int_sta(mvm, &mvm->aux_sta);
+
+	return ret;
+}
+
+void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm)
+{
+	iwl_mvm_dealloc_int_sta(mvm, &mvm->snif_sta);
 }
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 8d70093847cb..da2d1ac01229 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -541,7 +541,7 @@ int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u8 queue, bool start);
 
 int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm);
-void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm);
+int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm);
 
 int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
2.25.1



