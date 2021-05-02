Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9A0370AF3
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhEBJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhEBJwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A55E2611F1;
        Sun,  2 May 2021 09:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949074;
        bh=oxYCjfRqAiF7c2wI6Xee55m1LSAzlh0hYCWNVdhFkhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tt8iVWbw6ThZNWfkat7q3QqpJJrAJByyWoG+W6GKrZ50y2AT5NjlpvC3gwXC7nTR
         T+Y2QsCznMPdagqp3eZebFcPzBdd49pY/AUNqbtoT5KmfFdm7hbP9+1hxtI8rTecP7
         h6pXfJr4BUe4KSdUKuOD6GACQZHfPADpNRvdRgnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.34
Date:   Sun,  2 May 2021 11:51:06 +0200
Message-Id: <16199490669250@kroah.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <161994906655242@kroah.com>
References: <161994906655242@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index fd5c8b5c013b..ac2f14a067d3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 33
+SUBLEVEL = 34
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 14be76d4c2e6..cb34925e10f1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -105,6 +105,7 @@
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a7e179626b63..c3393b383e59 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 8c7138247869..833fd133d15b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -87,6 +87,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd;
+	unsigned long flags;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -155,14 +156,14 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
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
@@ -297,7 +298,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	spin_unlock(&trans_pcie->reg_lock);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);
