Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4164A005
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiLLNTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiLLNSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:18:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1FE1038
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:17:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50CFB61045
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D12EC433EF;
        Mon, 12 Dec 2022 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851059;
        bh=2xTj+0tcNnhijVA1AA51x6sX8lcq7GmodvgnfoWEeAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fwcdx7GNqNiCfkrMoiB/huImkXffKRQoCB7FahfYndo/iD5o22UPUBm80Xgyqg4yV
         KSBMmLTGTaM8vutvsw04jJsq0PKAANcR1KNhqypnuc2C8hOlPCnp9D/ZAVMsoFZJcc
         xxaz6FkkkKYpkXTsUqCb2//ZcBPjSTiNTBkR4tH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/106] ethernet: aeroflex: fix potential skb leak in greth_init_rings()
Date:   Mon, 12 Dec 2022 14:10:43 +0100
Message-Id: <20221212130929.217277928@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
index f4f50b3a472e..0d56cb4f5dd9 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -258,6 +258,7 @@ static int greth_init_rings(struct greth_private *greth)
 			if (dma_mapping_error(greth->dev, dma_addr)) {
 				if (netif_msg_ifup(greth))
 					dev_err(greth->dev, "Could not create initial DMA mapping\n");
+				dev_kfree_skb(skb);
 				goto cleanup;
 			}
 			greth->rx_skbuff[i] = skb;
-- 
2.35.1



