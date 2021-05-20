Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289A938A57A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbhETKQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236387AbhETKPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601CC6198E;
        Thu, 20 May 2021 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503916;
        bh=CjIgtZRmdyllaX4pshZt3ieneih3tP4FyJZg3/hMOC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUCQBtxkTWF3b6IPQDeIm7CEJ6NVvuABWgN+g9r4BEeeMdDPjS5UIXPktIfZlPMrX
         n3ncq37fFAh8o1h7+w2Otea0/PpoELOiXUr19QNbaM28aCy54YLmNoBKYm5YgYH8lZ
         LUV4Vdz5q0JpM9acDnv+JfWSfEIClvmv0sIBpr/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jari Ruusu <jariruusu@protonmail.com>
Subject: [PATCH 4.14 012/323] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Date:   Thu, 20 May 2021 11:18:24 +0200
Message-Id: <20210520092120.536055880@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit e7020bb068d8be50a92f48e36b236a1a1ef9282e upstream.

Analogically to what we did in 2800aadc18a6 ("iwlwifi: Fix softirq/hardirq
disabling in iwl_pcie_enqueue_hcmd()"), we must apply the same fix to
iwl_pcie_gen2_enqueue_hcmd(), as it's being called from exactly the same
contexts.

Reported-by: Heiner Kallweit <hkallweit1@gmail.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2104171112390.18270@cbobk.fhfr.pm
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -559,6 +559,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans, txq, txq->write_ptr);
+	unsigned long flags2;
 
 	memset(tfd, 0, sizeof(*tfd));
 
@@ -629,10 +630,10 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 		goto free_dup_buf;
 	}
 
-	spin_lock_bh(&txq->lock);
+	spin_lock_irqsave(&txq->lock, flags2);
 
 	if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_bh(&txq->lock);
+		spin_unlock_irqrestore(&txq->lock, flags2);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -773,7 +774,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags2);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);


