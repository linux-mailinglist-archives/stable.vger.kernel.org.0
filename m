Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A1E36F245
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 23:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhD2Vrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 17:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237299AbhD2Vrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 17:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F176141C;
        Thu, 29 Apr 2021 21:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619732819;
        bh=8PtlIrBanIqXwvNenAuZ3u0lscN/gyUib+DlVYNSed0=;
        h=Date:From:To:cc:Subject:From;
        b=Py9yHG26xOaAkXX2D5b2EGXTc3nPCK3uDOm9RIxGP+rc3lU8Da9t63h4YQOk2HxBt
         AOtCEeFotCVrgFZIuZ2e1b3EQxypw8nuXROPexI7PUuilWQ3Re2nUHU5XB54z7Q0d6
         UPascaZ9UG+NI7VtAwWLYj2ttXsfdYfb1zHuxwCFi8fq5CUIf1u0Y/fCV1G9gcUapV
         zMNYRNPk/5+WLs48rgB3pIgHNm6dAxgsgn+vMjxo6QgfYV6VhgiQmfluhFSrLo2iTx
         8IlSEkKpWT77aUFggT5e/HIUiR8RkoAui2eDlIKSWhEZxMlWDeeCGsjF50o+wCr9W3
         56TCUieUk0z7Q==
Date:   Thu, 29 Apr 2021 23:46:56 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     stable@vger.kernel.org
cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5.12 -stable] iwlwifi: Fix softirq/hardirq disabling in
 iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <nycvar.YFH.7.76.2104292345080.18270@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


[ commit e7020bb068d8be50a92f48e36b236a1a1ef9282e upstream ]

From: Jiri Kosina <jkosina@suse.cz>

Analogically to what we did in 2800aadc18a6 ("iwlwifi: Fix softirq/hardirq 
disabling in iwl_pcie_enqueue_hcmd()"), we must apply the same fix to 
iwl_pcie_gen2_enqueue_hcmd(), as it's being called from exactly the same 
contexts.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2104171112390.18270@cbobk.fhfr.pm
---

This fix unfortunately didn't make it upstream in time.

 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 4456abb9a074..34bde8c87324 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -40,6 +40,7 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd;
+	unsigned long flags;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -108,14 +109,14 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 		goto free_dup_buf;
 	}
 
-	spin_lock_bh(&txq->lock);
+	spin_lock_irqsave(&txq->lock, flags);
 
 	idx = iwl_txq_get_cmd_index(txq, txq->write_ptr);
 	tfd = iwl_txq_get_tfd(trans, txq, txq->write_ptr);
 	memset(tfd, 0, sizeof(*tfd));
 
 	if (iwl_txq_space(trans, txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_bh(&txq->lock);
+		spin_unlock_irqrestore(&txq->lock, flags);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -250,7 +251,7 @@ int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	spin_unlock(&trans_pcie->reg_lock);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);
-- 
2.12.3


-- 
Jiri Kosina
SUSE Labs

