Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85032BC2E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241696AbhCCNm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842908AbhCCKWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:22:24 -0500
X-Greylist: delayed 2975 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Mar 2021 01:54:21 PST
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1115.securemx.jp [IPv6:2001:240:bb81::4:1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C564C08ECA9
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 01:54:21 -0800 (PST)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 12381IYC023996; Wed, 3 Mar 2021 17:01:18 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 1237w3PQ009787; Wed, 3 Mar 2021 16:58:03 +0900
X-Iguazu-Qid: 2wGr679Rap50tdjAXo
X-Iguazu-QSIG: v=2; s=0; t=1614758283; q=2wGr679Rap50tdjAXo; m=+HB87UopndDXWzY3/iPv1MLYSW7PXFI8n+rUbTGuyU4=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1110) id 1237w24f029199
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Mar 2021 16:58:02 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id EEBF010011A;
        Wed,  3 Mar 2021 16:58:01 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 1237w1gA020753;
        Wed, 3 Mar 2021 16:58:01 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH for 4.4.y] iwlwifi: pcie: fix to correct null check
Date:   Wed,  3 Mar 2021 16:57:31 +0900
X-TSB-HOP: ON
Message-Id: <20210303075731.920687-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index cb03c2855019..7584796131fa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -583,13 +583,15 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
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
-- 
2.30.0.rc2

