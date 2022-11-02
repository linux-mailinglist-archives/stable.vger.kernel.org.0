Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2005561589A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiKBCyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiKBCyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89A1B7F8
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75365617C8
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49ECC433D6;
        Wed,  2 Nov 2022 02:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357689;
        bh=ey7cjboHJUSIHdTG0xLTebWBaq682f1bBRCattXoFAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cECt9qTctxHhiSY+ZNMHUMJlCOKOH1osNXT6Cwn7NrgjKQpYdv2gor1KZ3W5yatJE
         XuUuPAnsreK8k/5onyfWWnYmuhe/FVR6imWdjMnMosxw1mSpgpnTjhtR5ap7/HBY8Z
         Q/ud+cvvvYHgC/uCHkFy6v5p9THIff096rzybtoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 186/240] net: lantiq_etop: dont free skb when returning NETDEV_TX_BUSY
Date:   Wed,  2 Nov 2022 03:32:41 +0100
Message-Id: <20221102022115.596871196@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 9c1eaa27ec599fcc25ed4970c0b73c247d147a2b ]

The ndo_start_xmit() method must not free skb when returning
NETDEV_TX_BUSY, since caller is going to requeue freed skb.

Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 7cedbe1fdfd7..bd04d9f33349 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -485,7 +485,6 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
-		dev_kfree_skb_any(skb);
 		netdev_err(dev, "tx ring full\n");
 		netif_tx_stop_queue(txq);
 		return NETDEV_TX_BUSY;
-- 
2.35.1



