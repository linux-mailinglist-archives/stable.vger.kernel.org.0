Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68B5EA4D7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIZL4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiIZLxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC44B1F9;
        Mon, 26 Sep 2022 03:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9388B80977;
        Mon, 26 Sep 2022 10:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412AAC433D6;
        Mon, 26 Sep 2022 10:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189349;
        bh=pWaRJyjXJ4O6BGgYMnwLbJO+Jhs/QYK2pFYO54lvYUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQqHEjS+X1Mp1R9XePRsK9NjjkvZv5b/c/o+fSO/QlA2fdw15QrlYybR9F093FatP
         UTheemVFZwxYN7mRyVelx8i2PnGKH0t8iJX4+9tnYbmY2e+ME/wEwGgOXvaw/27Cfi
         j+CEow4ERj3pvECurPyKJ3lyuACRcp5M/9N6t6yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 157/207] bnxt: prevent skb UAF after handing over to PTP worker
Date:   Mon, 26 Sep 2022 12:12:26 +0200
Message-Id: <20220926100813.673579991@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c31f26c8f69f776759cbbdfb38e40ea91aa0dd65 ]

When reading the timestamp is required bnxt_tx_int() hands
over the ownership of the completed skb to the PTP worker.
The skb should not be used afterwards, as the worker may
run before the rest of our code and free the skb, leading
to a use-after-free.

Since dev_kfree_skb_any() accepts NULL make the loss of
ownership more obvious and set skb to NULL.

Fixes: 83bb623c968e ("bnxt_en: Transmit and retrieve packet timestamps")
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220921201005.335390-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 964354536f9c..111a952f880e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -662,7 +662,6 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 
 	for (i = 0; i < nr_pkts; i++) {
 		struct bnxt_sw_tx_bd *tx_buf;
-		bool compl_deferred = false;
 		struct sk_buff *skb;
 		int j, last;
 
@@ -671,6 +670,8 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		skb = tx_buf->skb;
 		tx_buf->skb = NULL;
 
+		tx_bytes += skb->len;
+
 		if (tx_buf->is_push) {
 			tx_buf->is_push = 0;
 			goto next_tx_int;
@@ -691,8 +692,9 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 		}
 		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)) {
 			if (bp->flags & BNXT_FLAG_CHIP_P5) {
+				/* PTP worker takes ownership of the skb */
 				if (!bnxt_get_tx_ts_p5(bp, skb))
-					compl_deferred = true;
+					skb = NULL;
 				else
 					atomic_inc(&bp->ptp_cfg->tx_avail);
 			}
@@ -701,9 +703,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 next_tx_int:
 		cons = NEXT_TX(cons);
 
-		tx_bytes += skb->len;
-		if (!compl_deferred)
-			dev_kfree_skb_any(skb);
+		dev_kfree_skb_any(skb);
 	}
 
 	netdev_tx_completed_queue(txq, nr_pkts, tx_bytes);
-- 
2.35.1



