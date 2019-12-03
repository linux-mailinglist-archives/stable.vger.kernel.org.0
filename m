Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AED111D0D
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfLCWts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfLCWtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000AB2080F;
        Tue,  3 Dec 2019 22:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413386;
        bh=XTkHmEKwNPvTyg4Z81m7qtUb9jgX3QA/cApRICAg6+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5/LJ0vU2NmhhEz0/j7S+TIBIDmTCUNndD9dm3nLg4vbhbYG+Qij6OWfoC5H899oA
         fYKFK+Ixlj/jAWnFcG8lfMHawKRtTvXMXiRkp51e+4zbQ5hnLB00B51bS7W9c3Kd9u
         CLhzFqVwC8eCDiioF+9eZByblFPzmL25fKGs5dzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/321] iwlwifi: pcie: set cmd_len in the correct place
Date:   Tue,  3 Dec 2019 23:32:54 +0100
Message-Id: <20191203223432.770349057@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 956343a61226e1af3d146386f70a059feb567d0c ]

command len is set too early in the code, since when building
AMSDU, the size changes. This causes the byte count table to
have the wrong size.

Fixes: a0ec0169b7a9 ("iwlwifi: support new tx api")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 61ffa1d1a00d7..316e2ba0c34d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -560,18 +560,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	spin_lock(&txq->lock);
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
-	} else {
-		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
-	}
-
 	if (iwl_queue_space(trans, txq) < txq->high_mark) {
 		iwl_stop_queue(trans, txq);
 
@@ -609,6 +597,18 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		return -1;
 	}
 
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
+	} else {
+		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
+	}
+
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_gen2_update_byte_tbl(trans_pcie, txq, cmd_len,
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
-- 
2.20.1



