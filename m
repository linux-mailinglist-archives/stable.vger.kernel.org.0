Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3CF36FC29
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhD3OVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233140AbhD3OVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABD7613A9;
        Fri, 30 Apr 2021 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792457;
        bh=nukcF0K5pT5pJU2XcsMB7CrDYkl8SOkfiE5b7L4GNBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5H0muAEVHsDF5W6GfFGYbd3oYDJW3GXDrubnnnKVdXcQTWyBydGBMKhMQjflyjvo
         Pj2XAXkHrUn+9CXhym6pTo9d7lmmlICKVH7LsKq1EyVS1HGwuvA3KP5Ib/3yCJGU3/
         uiBo9ixfcCxWuaZDZ4N4hiM0G9eBVzTIa+QXKjpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.11 1/3] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Date:   Fri, 30 Apr 2021 16:20:50 +0200
Message-Id: <20210430141910.740742420@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141910.693887691@linuxfoundation.org>
References: <20210430141910.693887691@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -40,6 +40,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd;
+	unsigned long flags;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -108,14 +109,14 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
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
@@ -250,7 +251,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(st
 	spin_unlock(&trans_pcie->reg_lock);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);


