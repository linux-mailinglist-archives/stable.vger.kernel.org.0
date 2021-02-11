Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7338318E32
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBKPWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhBKPRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 864BD64EFD;
        Thu, 11 Feb 2021 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055911;
        bh=Mntyyw9pDo73Mx8hzXtsDcqsj83PlObc6cNFP+pQy/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djsmI0ybpiUD0wnt8J/nZT9C0YfnFxIuyCFe2EW6WEb3OIEbtZndyqVKVQP7hxuxf
         Wjm3vsWg/OGUwoeoi/dL4fDaMi8HzDfQFr/EHIpfap44eZg/7RYzuwBeCdUgMFD+T0
         dCHEFkXKs0v6UtnrVpLLY+J4AyaaRos/0fOfBBAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/54] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Thu, 11 Feb 2021 16:02:17 +0100
Message-Id: <20210211150154.329490410@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 98c7d21f957b10d9c07a3a60a3a5a8f326a197e5 ]

I hit a NULL pointer exception in this function when the
init flow went really bad.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.2e8da9f2c132.I0234d4b8ddaf70aaa5028a20c863255e05bc1f84@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 966be5689d63a..ed54d04e43964 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -299,6 +299,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
 
+	if (!txq) {
+		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
+		return;
+	}
+
 	spin_lock_bh(&txq->lock);
 	while (txq->write_ptr != txq->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
-- 
2.27.0



