Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9894FD87B
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352417AbiDLIAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358106AbiDLHlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187203BA5D;
        Tue, 12 Apr 2022 00:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 878516179E;
        Tue, 12 Apr 2022 07:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A95FC385A1;
        Tue, 12 Apr 2022 07:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747841;
        bh=O+IifnGMdoysyZqyVP0StvjROtzPsCC5zNF9Nr2ilEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iv7NxVtiPCVyZQaDhaB7CU/ZnIuj7M0FK0F7sptRuTj/fsTL5+r0joVyQbL5Lv78o
         wLy97tUdppMV0PqL9hoAa1FX04D8M0YoUEBP9GqS0ZyOFBB6O/kr0peSFsCWN4qZPi
         G8YqO4o3vZbyH4h4zHWoWwC/jIfqkV8Rk6E1vxSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Olovyannikov <vladimir.olovyannikov@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 224/343] bnxt_en: Prevent XDP redirect from running when stopping TX queue
Date:   Tue, 12 Apr 2022 08:30:42 +0200
Message-Id: <20220412062957.804621407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ray Jui <ray.jui@broadcom.com>

[ Upstream commit 27d4073f8d9af0340362554414f4961643a4f4de ]

Add checks in the XDP redirect callback to prevent XDP from running when
the TX ring is undergoing shutdown.

Also remove redundant checks in the XDP redirect callback to validate the
txr and the flag that indicates the ring supports XDP. The modulo
arithmetic on 'tx_nr_rings_xdp' already guarantees the derived TX
ring is an XDP ring.  txr is also guaranteed to be valid after checking
BNXT_STATE_OPEN and within RCU grace period.

Fixes: f18c2b77b2e4 ("bnxt_en: optimized XDP_REDIRECT support")
Reviewed-by: Vladimir Olovyannikov <vladimir.olovyannikov@broadcom.com>
Signed-off-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c0541ff00ac8..03b1d6c04504 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -229,14 +229,16 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 	ring = smp_processor_id() % bp->tx_nr_rings_xdp;
 	txr = &bp->tx_ring[ring];
 
+	if (READ_ONCE(txr->dev_state) == BNXT_DEV_STATE_CLOSING)
+		return -EINVAL;
+
 	if (static_branch_unlikely(&bnxt_xdp_locking_key))
 		spin_lock(&txr->xdp_tx_lock);
 
 	for (i = 0; i < num_frames; i++) {
 		struct xdp_frame *xdp = frames[i];
 
-		if (!txr || !bnxt_tx_avail(bp, txr) ||
-		    !(bp->bnapi[ring]->flags & BNXT_NAPI_FLAG_XDP))
+		if (!bnxt_tx_avail(bp, txr))
 			break;
 
 		mapping = dma_map_single(&pdev->dev, xdp->data, xdp->len,
-- 
2.35.1



