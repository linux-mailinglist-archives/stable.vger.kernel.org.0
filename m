Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2360A627EC2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiKNMvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiKNMvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:51:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880CA24BE4
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:51:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2456A61175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F7CC433C1;
        Mon, 14 Nov 2022 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430279;
        bh=CQgavLIwFqKEKn3j5JuLJmUwnhhzMiTuUuT6kwrxD1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QjyNo2sglneMzKWnav1E+CCQuBQev7kUlRf8+meSfF47lxXOx9g6RBeoB0LRSMACT
         Nn8t2d4BcNAabl6C2AlsGQoYH/mCllIFLGkla6JtaMUFkh2AqkM2wG3G2egY4Y0B7G
         g6vOKIwwjdBCn5phgQI+tGd94CAdE134E8mWKIIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/95] net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
Date:   Mon, 14 Nov 2022 13:45:41 +0100
Message-Id: <20221114124444.477912460@linuxfoundation.org>
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

[ Upstream commit f111606b63ff2282428ffbac0447c871eb957b6c ]

When failed to init rxq or txq in mv643xx_eth_open() for opening device,
napi isn't disabled. When open mv643xx_eth device next time, it will
trigger a BUG_ON() in napi_enable(). Compile tested only.

Fixes: 2257e05c1705 ("mv643xx_eth: get rid of receive-side locking")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109025432.80900-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 90e6111ce534..735b76effc49 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2471,6 +2471,7 @@ static int mv643xx_eth_open(struct net_device *dev)
 	for (i = 0; i < mp->rxq_count; i++)
 		rxq_deinit(mp->rxq + i);
 out:
+	napi_disable(&mp->napi);
 	free_irq(dev->irq, dev);
 
 	return err;
-- 
2.35.1



