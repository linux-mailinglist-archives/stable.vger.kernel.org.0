Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848D064A240
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiLLNvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiLLNvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:51:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16631140F1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8DAD61068
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A3AC433EF;
        Mon, 12 Dec 2022 13:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853036;
        bh=AuOUX6Q8A6O4fglwPRxv5J01FYk//ZB99Zo1bht5BD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWcReicUnwEpweHWHWM2rfzMJS5Teegnn2O+IyzM07C22Pkj0wni5PM+7yYujisUb
         sMEkx8d/ZE44YXLdy+4BxceSl0mUO/16NeZnfc2GKbBHY/Wc/ZWFa6v1bGOTpt8+TY
         /i/igQfD/BZZ6/pLbbliBozfiLW2GDy7UfaK2WkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/49] ethernet: aeroflex: fix potential skb leak in greth_init_rings()
Date:   Mon, 12 Dec 2022 14:19:22 +0100
Message-Id: <20221212130915.868655107@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 063a932b64db3317ec020c94466fe52923a15f60 ]

The greth_init_rings() function won't free the newly allocated skb when
dma_mapping_error() returns error, so add dev_kfree_skb() to fix it.

Compile tested only.

Fixes: d4c41139df6e ("net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/1670134149-29516-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aeroflex/greth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index a20e95b39cf7..4df8da8f5e7e 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -262,6 +262,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
-- 
2.35.1



