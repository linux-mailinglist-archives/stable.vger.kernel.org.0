Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302E759D848
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiHWJv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352022AbiHWJvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5226E2C6;
        Tue, 23 Aug 2022 01:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0997E6155E;
        Tue, 23 Aug 2022 08:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08768C433C1;
        Tue, 23 Aug 2022 08:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244305;
        bh=5UpOLZ6OrQwDiORlh4EtbzwciMIiSRov6coIlyhCNLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFoFR4qx7waNUY9JY67luN7MvvvVBzvMXxKO/YWTZahYIwNY2EKi4Wnrqih3QnUAu
         qX9yp9mCTv0rHSNe874LSoIS5MYJI+eYhILSZ+1FiakV03egZQHHIdfmuzfefB9UOc
         dAxAlH549WvkovNc2xUYrSYwBftTE8eTFdz6duCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 070/244] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration
Date:   Tue, 23 Aug 2022 10:23:49 +0200
Message-Id: <20220823080101.407966747@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

commit 13c9f4dc102f2856e80b92486c41841e25e23772 upstream.

For packets scheduled to RPM and LBK, NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
selects the TL3 or TL2 scheduling level as the one used for link/channel
selection and backpressure. For each scheduling queue at the selected
level: Setting NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG[ENA] = 1 allows
the TL3/TL2 queue to schedule packets to a specified RPM or LBK link
and channel.

There is an issue in the code where NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
is set to TL3 where as the NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG is
configured for TL2 queue in some cases. As a result packets will not
transmit on that link/channel. This patch fixes the issue by configuring
the NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG register depending on the
NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL] value.

Fixes: caa2da34fd25a ("octeontx2-pf: Initialize and config queues")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Link: https://lore.kernel.org/r/20220802142813.25031-1-naveenm@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |   19 +++++++++++----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h |    1 
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -631,6 +631,12 @@ int otx2_txschq_config(struct otx2_nic *
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
 		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
@@ -640,11 +646,12 @@ int otx2_txschq_config(struct otx2_nic *
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
-		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-		/* Enable this queue and backpressure */
-		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
-
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL1) {
 		/* Default config for TL1.
 		 * For VF this is always ignored.
@@ -1563,6 +1570,8 @@ void mbox_handler_nix_txsch_alloc(struct
 		for (schq = 0; schq < rsp->schq[lvl]; schq++)
 			pf->hw.txschq_list[lvl][schq] =
 				rsp->schq_list[lvl][schq];
+
+	pf->hw.txschq_link_cfg_lvl = rsp->link_cfg_lvl;
 }
 EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
 
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -182,6 +182,7 @@ struct otx2_hw {
 	u16			sqb_size;
 
 	/* NIX */
+	u8			txschq_link_cfg_lvl;
 	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;


