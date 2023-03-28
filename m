Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB76CC3F8
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjC1O6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbjC1O6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07145E079
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D8D6183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D445C433D2;
        Tue, 28 Mar 2023 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015506;
        bh=6ZIG/AaYFRe4Ziajz/NcQxFcvyNcXM3LuH1cO7y+XfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRcAmCxfZayNdD0vlYwW5kFxGEl/M4zS52xE0gznb+ezctqBEHMwhfHopQJ8mDHtU
         LmyTZ9LCeYlx2QuUVoFg4cD++22ST9LkXBjk0zCc4vsU/zUubrowV3acd63rODlLE+
         A7IV+7rIyDT4Zo0nFOLGo8+wH4QvnqB+vPcnxNCY=
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
Subject: [PATCH 6.1 073/224] net/sonic: use dma_mapping_error() for error check
Date:   Tue, 28 Mar 2023 16:41:09 +0200
Message-Id: <20230328142620.395432622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index d17d1b4f2585f..825356ee3492e 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -292,7 +292,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -509,7 +509,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
-- 
2.39.2



