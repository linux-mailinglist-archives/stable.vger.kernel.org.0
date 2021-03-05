Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FCD32EB61
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhCEMnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:43:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233382AbhCEMna (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:43:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4BE65026;
        Fri,  5 Mar 2021 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948209;
        bh=N14Qc9jfN2xuPVXoiMUJk/bJHPTJ7/tNd3xsGH09Pus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wa/VUeMvx4wswWfAtmJ7eDmaMgaoIW1RimRG1iGUa+m0pr8sV4MCSTo1/5VBhHM1Z
         OD6xN6lTnLaSpJ3BWp7U22ZeVKnuyrPI0NdkzLYCmLcnEg36QroEFO7mHgugT/pExy
         V0hFb6UEXU2OTIV2BrzGy0rwA6Txqq7jfnAVLwEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 03/30] iwlwifi: pcie: fix to correct null check
Date:   Fri,  5 Mar 2021 13:22:32 +0100
Message-Id: <20210305120849.563727119@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

The fixes made in commit: 4ae5798004d8 ("iwlwifi: pcie: add a NULL check in
iwl_pcie_txq_unmap") is not enough in 4.4.y tree.. This still have problems
with null references. This provides the correct fix.
Also, this is a problem only in 4.4.y. This patch has been applied to other
LTS trees, but with the correct fixes.

Fixes: 4ae5798004d8 ("iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap")
Cc: stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -583,13 +583,15 @@ static void iwl_pcie_txq_unmap(struct iw
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
+	struct iwl_queue *q;
 
 	if (!txq) {
 		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
 		return;
 	}
 
+	q = &txq->q;
+
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",


