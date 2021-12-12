Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B77471AA0
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhLLOUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 09:20:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39588 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhLLOUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 09:20:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5469CE0B66
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476B7C341C5;
        Sun, 12 Dec 2021 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639318842;
        bh=5UiP4tp8Vny+0QpUOyFE/OwkwRzFxEeQN6SUKjeAbMQ=;
        h=Subject:To:Cc:From:Date:From;
        b=zR2AdA5I6Dx13dpRsKSIieNRphLbPGDHGoFftZQ7QqgFIj4kMS2138r9wn2JSCtfj
         Q7mUxLQ2CO9hgb2y703hMtaz1XN1ZxVhKEhQ3ybkdk0kNWtSgZ5E0YofZxKmzBfqj4
         gHDnY28eDqOIx+V1PHUn8GzEUEC9aOCMA34/o6/Y=
Subject: FAILED: patch "[PATCH] qede: validate non LSO skb length" failed to apply to 4.4-stable tree
To:     manishc@marvell.com, aelior@marvell.com, kuba@kernel.org,
        palok@marvell.com, pkushwaha@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 15:20:39 +0100
Message-ID: <1639318839165209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e227b198a55859bf790dc7f4b1e30c0859c6756 Mon Sep 17 00:00:00 2001
From: Manish Chopra <manishc@marvell.com>
Date: Fri, 3 Dec 2021 09:44:13 -0800
Subject: [PATCH] qede: validate non LSO skb length

Although it is unlikely that stack could transmit a non LSO
skb with length > MTU, however in some cases or environment such
occurrences actually resulted into firmware asserts due to packet
length being greater than the max supported by the device (~9700B).

This patch adds the safeguard for such odd cases to avoid firmware
asserts.

v2: Added "Fixes" tag with one of the initial driver commit
    which enabled the TX traffic actually (as this was probably
    day1 issue which was discovered recently by some customer
    environment)

Fixes: a2ec6172d29c ("qede: Add support for link")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Link: https://lore.kernel.org/r/20211203174413.13090-1-manishc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 065e9004598e..999abcfe3310 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1643,6 +1643,13 @@ netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			data_split = true;
 		}
 	} else {
+		if (unlikely(skb->len > ETH_TX_MAX_NON_LSO_PKT_LEN)) {
+			DP_ERR(edev, "Unexpected non LSO skb length = 0x%x\n", skb->len);
+			qede_free_failed_tx_pkt(txq, first_bd, 0, false);
+			qede_update_tx_producer(txq);
+			return NETDEV_TX_OK;
+		}
+
 		val |= ((skb->len & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
 			 ETH_TX_DATA_1ST_BD_PKT_LEN_SHIFT);
 	}

