Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5301E13FD71
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbgAPX0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgAPXZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3152075B;
        Thu, 16 Jan 2020 23:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217158;
        bh=RPnjgwJitvJ9WTJhiXRj+CfScZfy+WqaNZeXHqvhueI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLRUTzX1+2xgdgmuBxhoaKoGplXW6wzklXu6l1PKnTxf8wLHRonFq33Nhq4o9cq90
         azhkuTZ3PLDuIz6bHkZ+uC8N058FpoopdBo/jgLpgAAKZsICFTnjJkqU1wap73tdxS
         za9al0sCzZFXqgoHAXoKfKdFFS6h9erGG8p8dymA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 172/203] iwlwifi: mvm: consider ieee80211 station max amsdu value
Date:   Fri, 17 Jan 2020 00:18:09 +0100
Message-Id: <20200116231759.571800150@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

commit ee4cce9b9d6421d037ffc002536b918fd7f4aff3 upstream.

debugfs amsdu_len sets only the max_amsdu_len for ieee80211 station
so take it into consideration while getting max amsdu

Fixes: af2984e9e625 ("iwlwifi: mvm: add a debugfs entry to set a fixed size AMSDU for all TX packets")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c |    8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c    |    7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -350,7 +350,13 @@ void iwl_mvm_tlc_update_notif(struct iwl
 		u16 size = le32_to_cpu(notif->amsdu_size);
 		int i;
 
-		if (WARN_ON(sta->max_amsdu_len < size))
+		/*
+		 * In debug sta->max_amsdu_len < size
+		 * so also check with orig_amsdu_len which holds the original
+		 * data before debugfs changed the value
+		 */
+		if (WARN_ON(sta->max_amsdu_len < size &&
+			    mvmsta->orig_amsdu_len < size))
 			goto out;
 
 		mvmsta->amsdu_enabled = le32_to_cpu(notif->amsdu_enabled);
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -935,7 +935,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm
 	    !(mvmsta->amsdu_enabled & BIT(tid)))
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 
-	max_amsdu_len = iwl_mvm_max_amsdu_size(mvm, sta, tid);
+	/*
+	 * Take the min of ieee80211 station and mvm station
+	 */
+	max_amsdu_len =
+		min_t(unsigned int, sta->max_amsdu_len,
+		      iwl_mvm_max_amsdu_size(mvm, sta, tid));
 
 	/*
 	 * Limit A-MSDU in A-MPDU to 4095 bytes when VHT is not


