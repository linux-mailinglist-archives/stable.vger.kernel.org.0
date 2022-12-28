Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D679657F4B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiL1QDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiL1QDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:03:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED641928C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E48436156E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6E6C433F0;
        Wed, 28 Dec 2022 16:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243389;
        bh=yoj//D37v82aTDnUCc2h2XHFMHJuk2hrvtsKDHa7EKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzEYSjsa0SVTK7MWEfzZhfnOmwde/fsX1iqJERLS4RrOJV9/wYw0q6+traDwVX+ku
         /2L8UqA5fLJyuT7JeLuvCWdRhL9WZxZbKA+YMLC+kqHyPgptyiB3s9555ZY0znWU8k
         Oa9lvYDRVxgOii0Fw+I+5yPCXAkVrqB5zoC46Jl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0524/1073] net: ethernet: dnet: dont call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:35:12 +0100
Message-Id: <20221228144342.277188811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f07fadcbee2a5e84caa67c7c445424200bffb60b ]

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

In this case, the lock is used to protected 'bp', so we can move
dev_kfree_skb() after the spin_unlock_irqrestore().

Fixes: 4796417417a6 ("dnet: Dave DNET ethernet controller driver (updated)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 92462ed87bc4..d9f0c297ae2a 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -550,11 +550,11 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	skb_tx_timestamp(skb);
 
+	spin_unlock_irqrestore(&bp->lock, flags);
+
 	/* free the buffer */
 	dev_kfree_skb(skb);
 
-	spin_unlock_irqrestore(&bp->lock, flags);
-
 	return NETDEV_TX_OK;
 }
 
-- 
2.35.1



