Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE2B64A0FE
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiLLNd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiLLNdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:33:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC2B13E31
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98AF2B80D2B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F45EC433EF;
        Mon, 12 Dec 2022 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851999;
        bh=LLxbFhc+0EZOfRypz7nDS1zUjU1o3N3D5fMbR39MIMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OuWafchfYYOKu/HsoSTsaOC9V1fEiWuLvnVeD8qqh1KI+f1O0bG+xSioU1rQea7rC
         BzgB368DYsXitc1vQHwaORyugk15KkVI8o+lRmzqrTb/M0DfV6euX7V+uKt/U9dK0H
         kGtHnfrgKJZv3m0Fd0HXAEeBqbN2x8HlLYvHVkJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/123] net: plip: dont call kfree_skb/dev_kfree_skb() under spin_lock_irq()
Date:   Mon, 12 Dec 2022 14:17:59 +0100
Message-Id: <20221212130932.103254959@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

[ Upstream commit 7d8c19bfc8ff3f78e5337107ca9246327fcb6b45 ]

It is not allowed to call kfree_skb() or consume_skb() from
hardware interrupt context or with interrupts being disabled.
So replace kfree_skb/dev_kfree_skb() with dev_kfree_skb_irq()
and dev_consume_skb_irq() under spin_lock_irq().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20221207015310.2984909-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/plip/plip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 2a2cb9d453e8..b1776116f9f7 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -446,12 +446,12 @@ plip_bh_timeout_error(struct net_device *dev, struct net_local *nl,
 	}
 	rcv->state = PLIP_PK_DONE;
 	if (rcv->skb) {
-		kfree_skb(rcv->skb);
+		dev_kfree_skb_irq(rcv->skb);
 		rcv->skb = NULL;
 	}
 	snd->state = PLIP_PK_DONE;
 	if (snd->skb) {
-		dev_kfree_skb(snd->skb);
+		dev_consume_skb_irq(snd->skb);
 		snd->skb = NULL;
 	}
 	spin_unlock_irq(&nl->lock);
-- 
2.35.1



