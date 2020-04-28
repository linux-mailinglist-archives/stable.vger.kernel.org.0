Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF911BCA1C
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgD1Sq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbgD1SnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 810D720730;
        Tue, 28 Apr 2020 18:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099391;
        bh=fO5FI66FHgg+VlGZoyzKaqaj94B5cozUzaWJZwEdd3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aN8qEc8eN3D2bIlzI+TfBauBsPzDg28LvVffApfda6OpXCuRwaUJsEJymyG3GJ4mQ
         rclRT//hXmU9CDo1tSHc33SLjJdOfq3ytEibPtRsN2lQGRHQrH1dro6MmwiN+4jY2J
         jo7ypb1BoagKuvf/Q3kdWYskVAEorUUN8XTBk++0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 130/168] iwlwifi: mvm: limit maximum queue appropriately
Date:   Tue, 28 Apr 2020 20:25:04 +0200
Message-Id: <20200428182248.533282460@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit e5b72e3bc4763152e24bf4b8333bae21cc526c56 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h |    6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c    |    5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

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
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -722,6 +722,11 @@ static int iwl_mvm_find_free_queue(struc
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN(maxq >= mvm->trans->trans_cfg->base_params->num_of_queues,
+		 "max queue %d >= num_of_queues (%d)", maxq,
+		 mvm->trans->trans_cfg->base_params->num_of_queues))
+		maxq = mvm->trans->trans_cfg->base_params->num_of_queues - 1;
+
 	/* This should not be hit with new TX path */
 	if (WARN_ON(iwl_mvm_has_new_tx_api(mvm)))
 		return -ENOSPC;


