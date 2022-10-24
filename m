Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCAE360A437
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiJXMGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbiJXMFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:05:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A00B7CE24;
        Mon, 24 Oct 2022 04:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC68612D6;
        Mon, 24 Oct 2022 11:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279C3C4347C;
        Mon, 24 Oct 2022 11:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612276;
        bh=8qIvuZtQBIn+XzpoaTxZT9Xx9bczzWsukg2GyFCA1/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAg7tOYVjaEZqY8LOD1/8ne7NWQI9+q2mSO7PjlAvGisTEMsYiPAo9iAkRqMBkxBB
         mXworgjbbsuriasqwgmfRabXAh2YYAEYthaWKOso3YB2qpT+T48sEecfc66rmHC23p
         SY+EAKbYKtTMCorJmDgKAoEAH002Y1Nz/sqhj2/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/210] mmc: wmt-sdmmc: Fix an error handling path in wmt_mci_probe()
Date:   Mon, 24 Oct 2022 13:30:22 +0200
Message-Id: <20221024113000.422320989@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit cb58188ad90a61784a56a64f5107faaf2ad323e7 ]

A dma_free_coherent() call is missing in the error handling path of the
probe, as already done in the remove function.

Fixes: 3a96dff0f828 ("mmc: SD/MMC Host Controller for Wondermedia WM8505/WM8650")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/53fc6ffa5d1c428fefeae7d313cf4a669c3a1e98.1663873255.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/wmt-sdmmc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index fd30ac7da5e5..85cad20b2ae8 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -853,7 +853,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->clk_sdmmc)) {
 		dev_err(&pdev->dev, "Error getting clock\n");
 		ret = PTR_ERR(priv->clk_sdmmc);
-		goto fail5;
+		goto fail5_and_a_half;
 	}
 
 	ret = clk_prepare_enable(priv->clk_sdmmc);
@@ -870,6 +870,9 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	return 0;
 fail6:
 	clk_put(priv->clk_sdmmc);
+fail5_and_a_half:
+	dma_free_coherent(&pdev->dev, mmc->max_blk_count * 16,
+			  priv->dma_desc_buffer, priv->dma_desc_device_addr);
 fail5:
 	free_irq(dma_irq, priv);
 fail4:
-- 
2.35.1



