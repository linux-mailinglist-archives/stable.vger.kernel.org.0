Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B94664869
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbjAJSLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbjAJSKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AC62BED
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 797D6B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C395AC433EF;
        Tue, 10 Jan 2023 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374123;
        bh=0sWyWXZjvmFbjGYs3WwcKgwVVnnct+7QuQl1g+2dcek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCpymw7L67FdsjpoCKo6qhVaGwQxCf9wM6ZUr1gFwifaAVImiRp51/1m5YPyXVxZ1
         wx+6xJktvowFNWrKWM0Ec9YwGgMxveFYniedBpihZ5PJa/2+Zfw2Wb36ZRb6l7/6n0
         7Z0G50rg3yGe7CkR3zOt/JwWVmuS70udCtqD15CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/148] bnxt_en: Fix XDP RX path
Date:   Tue, 10 Jan 2023 19:02:20 +0100
Message-Id: <20230110180018.364599449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 9b3e607871ea5ee90f10f5be3965fc07f2aa3ef7 ]

The XDP program can change the starting address of the RX data buffer and
this information needs to be passed back from bnxt_rx_xdp() to
bnxt_rx_pkt() for the XDP_PASS case so that the SKB can point correctly
to the modified buffer address.  Add back the data_ptr parameter to
bnxt_rx_xdp() to make this work.

Fixes: b231c3f3414c ("bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 7 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2c83bc890839..31c427d53b90 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1937,7 +1937,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (xdp_active) {
-		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &len, event)) {
+		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &data_ptr, &len, event)) {
 			rc = 1;
 			goto next_rx;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 1847f191577d..2ceeaa818c1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -222,7 +222,8 @@ void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
  * false   - packet should be passed to the stack.
  */
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff xdp, struct page *page, unsigned int *len, u8 *event)
+		 struct xdp_buff xdp, struct page *page, u8 **data_ptr,
+		 unsigned int *len, u8 *event)
 {
 	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
 	struct bnxt_tx_ring_info *txr;
@@ -255,8 +256,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		*event &= ~BNXT_RX_EVENT;
 
 	*len = xdp.data_end - xdp.data;
-	if (orig_data != xdp.data)
+	if (orig_data != xdp.data) {
 		offset = xdp.data - xdp.data_hard_start;
+		*data_ptr = xdp.data_hard_start + offset;
+	}
 
 	switch (act) {
 	case XDP_PASS:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 2bbdb8e7c506..ea430d6961df 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -18,8 +18,8 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct xdp_buff *xdp);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct xdp_buff xdp, struct page *page, unsigned int *len,
-		 u8 *event);
+		 struct xdp_buff xdp, struct page *page, u8 **data_ptr,
+		 unsigned int *len, u8 *event);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		  struct xdp_frame **frames, u32 flags);
-- 
2.35.1



