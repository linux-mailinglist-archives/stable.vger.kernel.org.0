Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D20627E8C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbiKNMtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbiKNMtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A01F0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AE861154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A5C433C1;
        Mon, 14 Nov 2022 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430138;
        bh=tkch0EhrJno+mY3kL6Z+zZ628NBupKGqdyhdNDUcAmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gan/VpyXAVu+joObcvJ/UgA/Nc2IkFYANe1DNzj63PK9Dn8p5H1ED3F4UwPN3IlEf
         xB0WCHVWLT1fTwF3RC1TvyUu2RiyyzxkuweRFbdmMrv4Q82b2QH4V5FomTxPaEz93i
         RWHqXDVJijnxWo6nO3vkHdNUhW3doKdIKC3xbMXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/95] net: nixge: disable napi when enable interrupts failed in nixge_open()
Date:   Mon, 14 Nov 2022 13:45:32 +0100
Message-Id: <20221114124444.151643292@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit b06334919c7a068d54ba5b219c05e919d89943f7 ]

When failed to enable interrupts in nixge_open() for opening device,
napi isn't disabled. When open nixge device next time, it will reports
a invalid opcode issue. Fix it. Only be compiled, not be tested.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221107101443.120205-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ni/nixge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index a6861df9904f..9c48fd85c418 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -899,6 +899,7 @@ static int nixge_open(struct net_device *ndev)
 err_rx_irq:
 	free_irq(priv->tx_irq, ndev);
 err_tx_irq:
+	napi_disable(&priv->napi);
 	phy_stop(phy);
 	phy_disconnect(phy);
 	tasklet_kill(&priv->dma_err_tasklet);
-- 
2.35.1



