Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1015E657A2F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiL1PIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiL1PIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5505713DC5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C9DB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFC6C433D2;
        Wed, 28 Dec 2022 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240115;
        bh=l6cXAvTD5xBYkwinVMf3KSkDyng3QPUJvJg7BzLk4Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwKuv2xxDfR6g1+nU6u5z4vceDzhhUjL0B9rwEINMlf9tb4Qvmq3yWk7LxYH6c+5n
         QDpfzhDfnMmkB7hn/oWaE1bHSvh4NuiWgir+VYsmnp9ykkMZIvK8JnL9VnTCrJZONQ
         0JGKkkkbi+42PY5oiETvCBY9TU8COJl5FhYpE2yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/731] mmc: mxcmmc: fix return value check of mmc_add_host()
Date:   Wed, 28 Dec 2022 15:36:40 +0100
Message-Id: <20221228144305.066143036@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 9bf95ba217fa..97227ad71715 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1143,7 +1143,9 @@ static int mxcmci_probe(struct platform_device *pdev)
 
 	timer_setup(&host->watchdog, mxcmci_watchdog, 0);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret)
+		goto out_free_dma;
 
 	return 0;
 
-- 
2.35.1



