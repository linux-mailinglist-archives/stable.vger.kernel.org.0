Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA09640E810
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350030AbhIPRnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354350AbhIPRjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74CE0615A3;
        Thu, 16 Sep 2021 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811057;
        bh=P9ZjK+o2s9regC1QoJWaKrnsuGmcJw2S4q1Z0fD9Cko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+6gd5IBmvZPDKoGsMCLH3vQfRC743ym3aLh4nNbdUqxNqhErUEBQIYRYS38oJ9zx
         VHYZ+8oITjDE9mXbJf4gvOdKzt1aoOPBSGanUCfR05FQ0gtqybVlPe1POhe4cZ/hgf
         Da+73y/bYbifIWEjmb4z20GPI0mKzUHmMtyyDUfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 366/432] iwlwifi: pcie: free RBs during configure
Date:   Thu, 16 Sep 2021 18:01:55 +0200
Message-Id: <20210916155823.206798887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6ac5720086c8b176794eb74c5cc09f8b79017f38 ]

When switching op-modes, or more generally when reconfiguring,
we might switch the RB size. In _iwl_pcie_rx_init() we have a
comment saying we must free all RBs since we might switch the
size, but this is actually too late: the switch has been done
and we'll free the buffers with the wrong size.

Fix this by always freeing the buffers, if any, at the start
of configure, instead of only after the size may have changed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802170640.42d7c93279c4.I07f74e65aab0e3d965a81206fcb289dc92d74878@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c    | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 4f6f4b2720f0..ff7ca3c57f34 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -487,6 +487,9 @@ void iwl_pcie_free_rbs_pool(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
+	if (!trans_pcie->rx_pool)
+		return;
+
 	for (i = 0; i < RX_POOL_SIZE(trans_pcie->num_rx_bufs); i++) {
 		if (!trans_pcie->rx_pool[i].page)
 			continue;
@@ -1062,7 +1065,7 @@ static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 	INIT_LIST_HEAD(&rba->rbd_empty);
 	spin_unlock_bh(&rba->lock);
 
-	/* free all first - we might be reconfigured for a different size */
+	/* free all first - we overwrite everything here */
 	iwl_pcie_free_rbs_pool(trans);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bee6b4574226..65cc25cbb9ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1866,6 +1866,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	/* free all first - we might be reconfigured for a different size */
+	iwl_pcie_free_rbs_pool(trans);
+
 	trans->txqs.cmd.q_id = trans_cfg->cmd_queue;
 	trans->txqs.cmd.fifo = trans_cfg->cmd_fifo;
 	trans->txqs.cmd.wdg_timeout = trans_cfg->cmd_q_wdg_timeout;
-- 
2.30.2



