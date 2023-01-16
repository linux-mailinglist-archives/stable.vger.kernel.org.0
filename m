Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511B166CCAA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbjAPR2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbjAPR17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:27:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF51CACE
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D4FA61089
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DF6C433D2;
        Mon, 16 Jan 2023 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888697;
        bh=84njc3sqCdLGwLZ7ZSkJPQbr6wpRGSvbQGjie9P9Ehw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI65u3gmdZf+245A2rOpo4T4K9/00vxGvZK3M/w7F3aGhYYeUzshWF5H6ZGyzB6CK
         nKAGwJprqhuXRuz6tPX4u5XIJjhZ4hmvhE+kAKVYiU1nQqKQFTYB0cYF46OLpCi6sh
         ULf/zADwKpATIDZ1Uc9+m/HxkbHpq8M65MNInu/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 104/338] mmc: mxcmmc: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:49:37 +0100
Message-Id: <20230116154825.416092741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit cde600af7b413c9fe03e85c58c4279df90e91d13 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host().

Fixes: d96be879ff46 ("mmc: Add a MX2/MX3 specific SDHC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-4-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxcmmc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 1d5418e4efae..05aca0372ab2 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1169,7 +1169,9 @@ static int mxcmci_probe(struct platform_device *pdev)
 	host->watchdog.function = &mxcmci_watchdog;
 	host->watchdog.data = (unsigned long)mmc;
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out_free_dma;
 
 	return 0;
 
-- 
2.35.1



