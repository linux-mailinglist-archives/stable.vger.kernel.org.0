Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6404B4627
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243403AbiBNJbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:31:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243441AbiBNJbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB56BF53;
        Mon, 14 Feb 2022 01:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF069B80D83;
        Mon, 14 Feb 2022 09:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F07C340EF;
        Mon, 14 Feb 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831012;
        bh=nYslgeNak5ILpjm8/69W2TdwvNNOr5bMUskwb787vUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPrmCe+6e9qBXrhwXJXjroaF8hksaNszvrcrUindG88A0bpLxcD7feIEM+6uz8IVL
         AYTzzLvr/p7XxYXLCla7QhxUypSZNYgQrxrtoYG1yyUR0cPjHIuGQGqeCcbMKk4QH7
         1rrPNs/aTt0/zG6l0Yt1WW1lCNh6SuB6Zk9otaLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/44] Revert "net: axienet: Wait for PhyRstCmplt after core reset"
Date:   Mon, 14 Feb 2022 10:25:39 +0100
Message-Id: <20220214092448.434681680@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit ff594e1b6f39f07f050759de2d27c36b7739c0c9.

Breaks the build on 4.14 and 4.9.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d2ba466613c0a..7876e56a5b5db 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -279,16 +279,6 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
 
-	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
-	ret = read_poll_timeout(axienet_ior, value,
-				value & XAE_INT_PHYRSTCMPLT_MASK,
-				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
-				XAE_IS_OFFSET);
-	if (ret) {
-		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
-		return ret;
-	}
-
 	return 0;
 out:
 	axienet_dma_bd_release(ndev);
-- 
2.34.1



