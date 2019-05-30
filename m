Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65FE2EB2E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfE3DKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbfE3DKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:35 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7258A244A9;
        Thu, 30 May 2019 03:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185834;
        bh=/Z5gzOrsT4Paiv5XfMaVUi3xgeFVJYQCmqkeqLGRBls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFklSO46LxRNlRztRtg+XfAFf1mNKSt0r2CSQGjLvRDtQBWAj2a/28Ji4BfAarp/l
         I4gAyEiYoATX5sL+akESahcMr3RwCTPZVy7cQeQHFwHJwvmeVTcnCJg0s4Lmw4YInc
         Zk0OmigQFUzX/EIdUvuEi5/Ow9UORFUb6U8KS1co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 099/405] iwlwifi: pcie: dont crash on invalid RX interrupt
Date:   Wed, 29 May 2019 20:01:37 -0700
Message-Id: <20190530030546.033363175@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 30f24eabab8cd801064c5c37589d803cb4341929 ]

If for some reason the device gives us an RX interrupt before we're
ready for it, perhaps during device power-on with misconfigured IRQ
causes mapping or so, we can crash trying to access the queues.

Prevent that by checking that we actually have RXQs and that they
were properly allocated.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8d4f0628622bb..12f02aaf923ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1434,10 +1434,15 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_rxq *rxq = &trans_pcie->rxq[queue];
+	struct iwl_rxq *rxq;
 	u32 r, i, count = 0;
 	bool emergency = false;
 
+	if (WARN_ON_ONCE(!trans_pcie->rxq || !trans_pcie->rxq[queue].bd))
+		return;
+
+	rxq = &trans_pcie->rxq[queue];
+
 restart:
 	spin_lock(&rxq->lock);
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
-- 
2.20.1



