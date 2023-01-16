Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE466C753
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjAPQ3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbjAPQ3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892412DE62
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C15BB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA26C433F0;
        Mon, 16 Jan 2023 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885871;
        bh=PMDO9hUbwriCNY3n7r/6S8oszdRH27p/kgm2I35DTOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C3a6ppyZeaKDL46dCCajAALIeJDAREM+Vzo69tYB90FGn82GLFXthC869XmpFj/Rb
         Kx3pXV2W7IKq490T83e4VDAyI+z7gy6eCThTlA0JcqZY8U9cEffk2CoPgTiJmGTy2u
         hEmcct8SHxTAyTqrEDHYxTuQ3ARAs2XMHseBX2zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/658] mmc: alcor: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:44:36 +0100
Message-Id: <20230116154918.059135519@linuxfoundation.org>
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

[ Upstream commit e93d1468f429475a753d6baa79b853b7ee5ef8c0 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and calling mmc_free_host() in the
error path.

Fixes: c5413ad815a6 ("mmc: add new Alcor Micro Cardreader SD/MMC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-2-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/alcor.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/alcor.c b/drivers/mmc/host/alcor.c
index 026ca9194ce5..a8ec2e6fefa8 100644
--- a/drivers/mmc/host/alcor.c
+++ b/drivers/mmc/host/alcor.c
@@ -1114,7 +1114,10 @@ static int alcor_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	alcor_hw_init(host);
 
 	dev_set_drvdata(&pdev->dev, host);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto free_host;
+
 	return 0;
 
 free_host:
-- 
2.35.1



