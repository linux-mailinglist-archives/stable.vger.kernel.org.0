Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF7D66C736
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjAPQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjAPQ2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:28:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661B02D171
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 052A86102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6DAC433EF;
        Mon, 16 Jan 2023 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885816;
        bh=z2BiFwyVN7/HrQny4egfmwKGt8y2xWYlSwBb/JISuoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JI7Gkx667ltSQvA0or3Oe2LrDmTN5+sZEMPm1wSmljk3E9CEaIaY+UIF7fRjmGfQt
         0Wk+yWbQDevkjU67Qpf/+LeGr0nherez2ThEMDsW3GfRtCIiVdi8rRteDHGi64zIyu
         i4md/m3GQl4XdOBJnmqgOyNHE8aM5yC88Y0QFNh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/658] mmc: wmt-sdmmc: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:44:43 +0100
Message-Id: <20230116154918.360505896@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 29276d56f6ed138db0f38cd31aedc0b725c8c76c ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, clk_disable_unprepare() also needs be called.

Fixes: 3a96dff0f828 ("mmc: SD/MMC Host Controller for Wondermedia WM8505/WM8650")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-10-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/wmt-sdmmc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index d774068dba30..b1e4199f8292 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -859,11 +859,15 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	/* configure the controller to a known 'ready' state */
 	wmt_reset_hardware(mmc);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto fail7;
 
 	dev_info(&pdev->dev, "WMT SDHC Controller initialized\n");
 
 	return 0;
+fail7:
+	clk_disable_unprepare(priv->clk_sdmmc);
 fail6:
 	clk_put(priv->clk_sdmmc);
 fail5_and_a_half:
-- 
2.35.1



