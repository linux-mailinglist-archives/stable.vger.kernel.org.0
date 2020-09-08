Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECE8261E88
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgIHTwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730707AbgIHPtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD87F24835;
        Tue,  8 Sep 2020 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579885;
        bh=aPvRp2GFGXKWnxLSh/2v5G+RNreiEk74ofFsmRYx6yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtoN4sLipymub9CwWq/7u8m6CLWFP5C7JvgdX1p/jq82ARqNnv44+aAnWHxo8UI4/
         OYM04a0KXKYOrtN3EXd0Yd5OoUN9DegQsiwSW6FRgzZizJ+VGLoQNr2hZJGh42iJ3o
         JGwCMtxF7B4m9rK/xMM8TppvOoyFPtpBu+ZMnqow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/129] bnxt_en: Fix possible crash in bnxt_fw_reset_task().
Date:   Tue,  8 Sep 2020 17:24:46 +0200
Message-Id: <20200908152231.953636248@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit b148bb238c02f0c7797efed026e9bba5892d2172 ]

bnxt_fw_reset_task() is run from a delayed workqueue.  The current
code is not cancelling the workqueue in the driver's .remove()
method and it can potentially crash if the device is removed with
the workqueue still pending.

The fix is to clear the BNXT_STATE_IN_FW_RESET flag and then cancel
the delayed workqueue in bnxt_remove_one().  bnxt_queue_fw_reset_work()
also needs to check that this flag is set before scheduling.  This
will guarantee that no rescheduling will be done after it is cancelled.

Fixes: 230d1f0de754 ("bnxt_en: Handle firmware reset.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7cb74d7a78e3c..16462d21fea38 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1143,6 +1143,9 @@ static int bnxt_discard_rx(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 static void bnxt_queue_fw_reset_work(struct bnxt *bp, unsigned long delay)
 {
+	if (!(test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)))
+		return;
+
 	if (BNXT_PF(bp))
 		queue_delayed_work(bnxt_pf_wq, &bp->fw_reset_task, delay);
 	else
@@ -1159,10 +1162,12 @@ static void bnxt_queue_sp_work(struct bnxt *bp)
 
 static void bnxt_cancel_sp_work(struct bnxt *bp)
 {
-	if (BNXT_PF(bp))
+	if (BNXT_PF(bp)) {
 		flush_workqueue(bnxt_pf_wq);
-	else
+	} else {
 		cancel_work_sync(&bp->sp_task);
+		cancel_delayed_work_sync(&bp->fw_reset_task);
+	}
 }
 
 static void bnxt_sched_reset(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
@@ -11386,6 +11391,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
 
-- 
2.25.1



