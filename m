Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076C06D46EF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjDCOPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjDCOPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:15:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404472BEEE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 987DAB81B57
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECABBC433EF;
        Mon,  3 Apr 2023 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531326;
        bh=o12PI8OsdkCqHAmIV3lwp6EOMpuA1XMdDDKv1GPRw8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/6Yzh4zuTrqu5g8Voy86DENegSNr68eZTzror87Q/i3mr+FosXpNYvHtIqUp0soz
         U27Jrv1PNwy9ugJkaB3ZvvyDjRBYji/5xRC82KsCoyw948IP5u3jzx2KhdDYFwMo/I
         CYYv6Fa0BR6ptoYfWOh+TCkh+6y906ptErUCV9l8=
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
Subject: [PATCH 4.19 20/84] net/sonic: use dma_mapping_error() for error check
Date:   Mon,  3 Apr 2023 16:08:21 +0200
Message-Id: <20230403140354.064129586@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 69282f31d519e..fe54bcab705f8 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -255,7 +255,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -473,7 +473,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
-- 
2.39.2



