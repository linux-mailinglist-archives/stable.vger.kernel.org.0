Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C0C6D4752
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjDCOTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbjDCOTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0782952D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940D961D01
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A28C433EF;
        Mon,  3 Apr 2023 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531549;
        bh=PJ7dg7p2r4pOd8lbHOnL51IrXooaZsr6jQK8mphGK2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDVn9HmyfcNHU1UWzbngneyM8cj24XAGwubYgDQa5DPq9L6ncgT0Z+1FWY+1DUJoq
         QipZkDlNuNvkRsEALErTLTJx3AMZriVdJB67YP/VV8srqJAzkp+n7MleIej8Cg/ojz
         IZvn19+JvODeRH0qWrfSaTnombEtbmv+qL0lgD3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/104] net/sonic: use dma_mapping_error() for error check
Date:   Mon,  3 Apr 2023 16:08:12 +0200
Message-Id: <20230403140405.016688592@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 4107b8746d93ace135b8c4da4f19bbae81db785f ]

The DMA address returned by dma_map_single() should be checked with
dma_mapping_error(). Fix it accordingly.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/sonic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 05e760444a92c..953708e2ab4b4 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -256,7 +256,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -474,7 +474,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
-- 
2.39.2



