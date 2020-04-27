Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6516E1BA959
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 17:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgD0Pzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 11:55:54 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58913 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbgD0Pzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 11:55:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 916B9194060C;
        Mon, 27 Apr 2020 11:55:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 11:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nCOIc7
        KjKRVwdu7DZuWg7YLzg3JvOCVIY8MP1DBnjak=; b=0OKP0xjjQptBm9NJ4tGRQa
        BDKPdyVmQiKS8q87UVE54zLaB/r3yDydhGhiHNFd7X0oIPV2e4MyI9dHfKAwOYuM
        jFwqE3DsS7oUVMnVccSCg/6eYBzYr0G3b4Fn/HdBCP7WDaxsXwF2owxA+DuArqNp
        G/ikxJuteAS8NmMgAnDpjfPo5duw9ZLppQUH+C8vZ7k4M3E8RuwyWOTlmN6tZjh+
        qvsEhe4AHE7bzHIbmwRQs7viS0eBqMm5iec4bsk8PdPiNY1c3Y855v2/S3q+zfqS
        Z6o0jegRCdM5drqyQnd4TIQBhpbw58u3+IObOTE3j5qpRDbyL5I0O2/uSf9sBiCw
        ==
X-ME-Sender: <xms:iQCnXsDQTdd5VIE4TwCmOm0nqlPaeLwfvlGPhssgTLBqbVlWpbKJsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iQCnXgwO84NCGkZW_HHjejkPkwpyIY7f0TE1JK7V0KIx0ikPBt_Lww>
    <xmx:iQCnXvrhagapugVdBdfBCRjARpr047pTrUbLRko7SecSoFR3wx3nZQ>
    <xmx:iQCnXrvZsQ3jSeGU2m4PnapsLccqDZvr60WqRlqJlMJeRelgREV_LA>
    <xmx:iQCnXsqwY5iXRaKVMgEYsioj8INYZxEODW6j1C6sVmp-OsgCvP8-Mw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D931F3280064;
        Mon, 27 Apr 2020 11:55:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: mvm: limit maximum queue appropriately" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com, kvalo@codeaurora.org,
        luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 17:55:49 +0200
Message-ID: <158800294920399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5b72e3bc4763152e24bf4b8333bae21cc526c56 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 17 Apr 2020 10:08:12 +0300
Subject: [PATCH] iwlwifi: mvm: limit maximum queue appropriately

Due to some hardware issues, queue 31 isn't usable on devices that have
32 queues (7000, 8000, 9000 families), which is correctly reflected in
the configuration and TX queue initialization.

However, the firmware API and queue allocation code assumes that there
are 32 queues, and if something actually attempts to use #31 this leads
to a NULL-pointer dereference since it's not allocated.

Fix this by limiting to 31 in the IWL_MVM_DQA_MAX_DATA_QUEUE, and also
add some code to catch this earlier in the future, if the configuration
changes perhaps.

Cc: stable@vger.kernel.org # v4.9+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.98a79be2db6a.I3a4af6b03b87a6bc18db9b1ff9a812f397bee1fc@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
index 73196cbc7fbe..75d958bab0e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/txq.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2019 Intel Corporation
+ * Copyright(c) 2019 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2019 Intel Corporation
+ * Copyright(c) 2019 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -99,7 +99,7 @@ enum iwl_mvm_dqa_txq {
 	IWL_MVM_DQA_MAX_MGMT_QUEUE = 8,
 	IWL_MVM_DQA_AP_PROBE_RESP_QUEUE = 9,
 	IWL_MVM_DQA_MIN_DATA_QUEUE = 10,
-	IWL_MVM_DQA_MAX_DATA_QUEUE = 31,
+	IWL_MVM_DQA_MAX_DATA_QUEUE = 30,
 };
 
 enum iwl_mvm_tx_fifo {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 64ef3f3ba23b..251d6fbb1da5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -722,6 +722,11 @@ static int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id,
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN(maxq >= mvm->trans->trans_cfg->base_params->num_of_queues,
+		 "max queue %d >= num_of_queues (%d)", maxq,
+		 mvm->trans->trans_cfg->base_params->num_of_queues))
+		maxq = mvm->trans->trans_cfg->base_params->num_of_queues - 1;
+
 	/* This should not be hit with new TX path */
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -ENOSPC;

