Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB33F1BC9DD
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgD1SnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgD1SnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F28720730;
        Tue, 28 Apr 2020 18:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099388;
        bh=cT5SIXL+iVDu/hb72oYjuRoUfLvME/5P/O+c1CUUBH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSJ7XJX0yxoFSdOIfgOhTsgCjYKeRQFG3w+fa/fiNE02XclcE6vdDjzdY4T9q/QI+
         a6JbD+X1u02ig8DKQHZ0F+0hNbZtLRJMAAUqp/jEi58/LYjUef0mR8JLgH/j3dvI4X
         8wX3INqmZm4NbaMezBcgYth0r+wmKMQCa56LE+Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 129/168] iwlwifi: mvm: beacon statistics shouldnt go backwards
Date:   Tue, 28 Apr 2020 20:25:03 +0200
Message-Id: <20200428182248.453105003@linuxfoundation.org>
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

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

commit 290d5e4951832e39d10f4184610dbf09038f8483 upstream.

We reset statistics also in case that we didn't reassoc so in
this cases keep last beacon counter.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.1f9142751fbc.Ifbfd0f928a0a761110b8f4f2ca5483a61fb21131@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -566,6 +566,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *
 
 struct iwl_mvm_stat_data {
 	struct iwl_mvm *mvm;
+	__le32 flags;
 	__le32 mac_id;
 	u8 beacon_filter_average_energy;
 	void *general;
@@ -606,6 +607,13 @@ static void iwl_mvm_stat_iterator(void *
 			-general->beacon_average_energy[vif_id];
 	}
 
+	/* make sure that beacon statistics don't go backwards with TCM
+	 * request to clear statistics
+	 */
+	if (le32_to_cpu(data->flags) & IWL_STATISTICS_REPLY_FLG_CLEAR)
+		mvmvif->beacon_stats.accu_num_beacons +=
+			mvmvif->beacon_stats.num_beacons;
+
 	if (mvmvif->id != id)
 		return;
 
@@ -763,6 +771,7 @@ void iwl_mvm_handle_rx_statistics(struct
 
 		flags = stats->flag;
 	}
+	data.flags = flags;
 
 	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
 


