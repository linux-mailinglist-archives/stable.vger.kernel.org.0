Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5CB40E0C1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbhIPQXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240632AbhIPQVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A9B8613A9;
        Thu, 16 Sep 2021 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808891;
        bh=BZrkluB2099K/J1qS8KSKoiffuQQBK2F02rugxMspQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzuBYgf5al87MWapcPX97wtEuPNpclgoTyrSUBZ6E2ZjHRYsML2YLDc7MhmaSKvvS
         Fjs/sM4onvBtYb9MZ2oMKd9vbPiuDpIXsOqTVk3Kb2Y8VP3ik2rF/IO7eBRggBpNmY
         S7IhY7M7+Md+xOLP3idikl0SpR3mQdlSwhBV1GHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/306] iwlwifi: pcie: free RBs during configure
Date:   Thu, 16 Sep 2021 18:00:06 +0200
Message-Id: <20210916155802.970532519@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index 94299f259518..2c13fa8f2820 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -544,6 +544,9 @@ void iwl_pcie_free_rbs_pool(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int i;
 
+	if (!trans_pcie->rx_pool)
+		return;
+
 	for (i = 0; i < RX_POOL_SIZE(trans_pcie->num_rx_bufs); i++) {
 		if (!trans_pcie->rx_pool[i].page)
 			continue;
@@ -1094,7 +1097,7 @@ static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 	INIT_LIST_HEAD(&rba->rbd_empty);
 	spin_unlock(&rba->lock);
 
-	/* free all first - we might be reconfigured for a different size */
+	/* free all first - we overwrite everything here */
 	iwl_pcie_free_rbs_pool(trans);
 
 	for (i = 0; i < RX_QUEUE_SIZE; i++)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bb990be7c870..082768ec8aa8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1909,6 +1909,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
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



