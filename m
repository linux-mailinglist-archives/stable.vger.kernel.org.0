Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FEF73E1D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388585AbfGXUWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390703AbfGXTnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:43:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFBA229F4;
        Wed, 24 Jul 2019 19:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997418;
        bh=pR6AqmoBKD+kONQ4csh2ylFS7g8FUgOnFWlvLdSUJ38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SyWuFBAJ4r8FpFbZqwGK23+lmllUI2CGiKoKAnb6ztoPpshaV+Bbch4kgUU40uDaP
         TPwzjR76b79nbW5Ua6BeQAQdaiL3eJg/qe87fRBIhcjGh1g7EySTSUgslaJOGdDx4g
         PDuixgLE16/yQeY93Rk74qrTW91tsk4bTYrd7DwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 017/371] ath10k: add peer id check in ath10k_peer_find_by_id
Date:   Wed, 24 Jul 2019 21:16:09 +0200
Message-Id: <20190724191725.803202524@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 49ed34b835e231aa941257394716bc689bc98d9f ]

For some SDIO chip, the peer id is 65535 for MPDU with error status,
then test_bit will trigger buffer overflow for peer's memory, if kasan
enabled, it will report error.

Reason is when station is in disconnecting status, firmware do not delete
the peer info since it not disconnected completely, meanwhile some AP will
still send data packet to station, then hardware will receive the packet
and send to firmware, firmware's logic will report peer id of 65535 for
MPDU with error status.

Add check for overflow the size of peer's peer_ids will avoid the buffer
overflow access.

Call trace of kasan:
dump_backtrace+0x0/0x2ec
show_stack+0x20/0x2c
__dump_stack+0x20/0x28
dump_stack+0xc8/0xec
print_address_description+0x74/0x240
kasan_report+0x250/0x26c
__asan_report_load8_noabort+0x20/0x2c
ath10k_peer_find_by_id+0x180/0x1e4 [ath10k_core]
ath10k_htt_t2h_msg_handler+0x100c/0x2fd4 [ath10k_core]
ath10k_htt_htc_t2h_msg_handler+0x20/0x34 [ath10k_core]
ath10k_sdio_irq_handler+0xcc8/0x1678 [ath10k_sdio]
process_sdio_pending_irqs+0xec/0x370
sdio_run_irqs+0x68/0xe4
sdio_irq_work+0x1c/0x28
process_one_work+0x3d8/0x8b0
worker_thread+0x508/0x7cc
kthread+0x24c/0x264
ret_from_fork+0x10/0x18

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index c5818d28f55a..4102df016931 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -150,6 +150,9 @@ struct ath10k_peer *ath10k_peer_find_by_id(struct ath10k *ar, int peer_id)
 {
 	struct ath10k_peer *peer;
 
+	if (peer_id >= BITS_PER_TYPE(peer->peer_ids))
+		return NULL;
+
 	lockdep_assert_held(&ar->data_lock);
 
 	list_for_each_entry(peer, &ar->peers, list)
-- 
2.20.1



