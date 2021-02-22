Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E5E3216FD
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhBVMlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231431AbhBVMjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:39:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7708664F09;
        Mon, 22 Feb 2021 12:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997477;
        bh=URee8Yn0JaFrFfh24A299t9bK1e6ZhAAFklE4uFM7Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uw9fJN5b0POrr9Zyavg0lGXQusGkQYKtYq5eUr1uwFJ4fIdtLRA3IAMYjCKcOVX8D
         XjyIluNayevTrBgSYTcRczANVZ/m1D8ShCw14Oz48KWjhuwyWKiDsG6ao9jo8ENl86
         /nvWfsNZHdBFRqh35mNJcVkj5IpAn31sWPfIUI1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/57] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Mon, 22 Feb 2021 13:35:33 +0100
Message-Id: <20210222121027.749904742@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
index c3a2e6b6da65b..e1fb0258c9168 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -622,6 +622,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 
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



