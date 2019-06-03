Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B9D32C01
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfFCJNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbfFCJNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:13:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3457527EB0;
        Mon,  3 Jun 2019 09:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553220;
        bh=ljkVMiDGnIyN+HweEiPscSIRcNH9hnQsnvTHND46q1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF6kmIRqHajwsl1N7bGk/zue5JhZ1MXxUK8XUUAVO36pwQGrx7wt8xzWa6I/yPryX
         aoXqoG2Mq9V0bzgulLClKTwuFhSDGYukahItai+vwateDXjIv861fDKxRp6yQm15qV
         VUXnUZEFQ+dCrTIujwAPHufICYYSsjHgC9f1gFOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 28/40] bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
Date:   Mon,  3 Jun 2019 11:09:21 +0200
Message-Id: <20190603090524.318771107@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
References: <20190603090522.617635820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1b3f0b75c39f534278a895c117282014e9d0ae1f ]

When making configuration changes, the driver calls bnxt_close_nic()
and then bnxt_open_nic() for the changes to take effect.  A parameter
irq_re_init is passed to the call sequence to indicate if IRQ
should be re-initialized.  This irq_re_init parameter needs to
be included in the bnxt_reserve_rings() call.  bnxt_reserve_rings()
can only call pci_disable_msix() if the irq_re_init parameter is
true, otherwise it may hit BUG() because some IRQs may not have been
freed yet.

Fixes: 41e8d7983752 ("bnxt_en: Modify the ring reservation functions for 57500 series chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   13 +++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |    2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7514,22 +7514,23 @@ static void bnxt_clear_int_mode(struct b
 	bp->flags &= ~BNXT_FLAG_USING_MSIX;
 }
 
-int bnxt_reserve_rings(struct bnxt *bp)
+int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 {
 	int tcs = netdev_get_num_tc(bp->dev);
-	bool reinit_irq = false;
+	bool irq_cleared = false;
 	int rc;
 
 	if (!bnxt_need_reserve_rings(bp))
 		return 0;
 
-	if (BNXT_NEW_RM(bp) && (bnxt_get_num_msix(bp) != bp->total_irqs)) {
+	if (irq_re_init && BNXT_NEW_RM(bp) &&
+	    bnxt_get_num_msix(bp) != bp->total_irqs) {
 		bnxt_ulp_irq_stop(bp);
 		bnxt_clear_int_mode(bp);
-		reinit_irq = true;
+		irq_cleared = true;
 	}
 	rc = __bnxt_reserve_rings(bp);
-	if (reinit_irq) {
+	if (irq_cleared) {
 		if (!rc)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
@@ -8428,7 +8429,7 @@ static int __bnxt_open_nic(struct bnxt *
 			return rc;
 		}
 	}
-	rc = bnxt_reserve_rings(bp);
+	rc = bnxt_reserve_rings(bp, irq_re_init);
 	if (rc)
 		return rc;
 	if ((bp->flags & BNXT_FLAG_RFS) &&
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1778,7 +1778,7 @@ unsigned int bnxt_get_avail_stat_ctxs_fo
 unsigned int bnxt_get_max_func_cp_rings(struct bnxt *bp);
 unsigned int bnxt_get_avail_cp_rings_for_en(struct bnxt *bp);
 int bnxt_get_avail_msix(struct bnxt *bp, int num);
-int bnxt_reserve_rings(struct bnxt *bp);
+int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init);
 void bnxt_tx_disable(struct bnxt *bp);
 void bnxt_tx_enable(struct bnxt *bp);
 int bnxt_hwrm_set_pause(struct bnxt *);
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -788,7 +788,7 @@ static int bnxt_set_channels(struct net_
 			 */
 		}
 	} else {
-		rc = bnxt_reserve_rings(bp);
+		rc = bnxt_reserve_rings(bp, true);
 	}
 
 	return rc;
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -147,7 +147,7 @@ static int bnxt_req_msix_vecs(struct bnx
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
 		} else {
-			rc = bnxt_reserve_rings(bp);
+			rc = bnxt_reserve_rings(bp, true);
 		}
 	}
 	if (rc) {


