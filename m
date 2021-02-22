Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD92F321733
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhBVMoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhBVMmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:42:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED5E64F07;
        Mon, 22 Feb 2021 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997583;
        bh=Hz+J5UmtDXGaKbBwf4cbi2y0bPeNszPDZvo/Tzji9R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMcInGaNloVenHyLfoc6cq9XHGnwo4xLg03W/beh1989e1U8E3Mzq7HzI0CvDaXp1
         bp4byGE0D5Z2UUltlrE2D6s8SWKaUqksts0LqixzBHGixDkh+9OcD8gMYmK2XzhOIa
         eX6U95zYOfVRolHnKYMEoWnIeaPYZ+RNhg0Qv2eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/35] iwlwifi: pcie: add a NULL check in iwl_pcie_txq_unmap
Date:   Mon, 22 Feb 2021 13:36:00 +0100
Message-Id: <20210222121017.933649049@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
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
 drivers/net/wireless/iwlwifi/pcie/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8dfe6b2bc7031..cb03c2855019b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -585,6 +585,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 
+	if (!txq) {
+		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
+		return;
+	}
+
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
-- 
2.27.0



