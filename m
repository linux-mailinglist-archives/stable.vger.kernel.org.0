Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AEA66C75C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbjAPQaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbjAPQ3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8619F2ED74
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:18:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48F0AB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A917AC433EF;
        Mon, 16 Jan 2023 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885885;
        bh=MFwwQ0+CD6m1Wliu3kYzukNk13q2qCGVka/zcKdXhIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tmTN8qzpvyW0IpMoo63PvLI98fszaWsWuinkvQJ4hr3Fy2Ruu23Q5JgN+emc4gov
         w3Ak0N+YThlgqPOlbUOcDFDJjJnesrfkYImatlD94tgRm+/B/Qm5V628VHKbCSjyuX
         2+WiZeh9s6OlMtiRXjVNuCWzKjn2yEaVHxyR8pgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/658] mmc: pxamci: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:44:39 +0100
Message-Id: <20230116154918.182392471@linuxfoundation.org>
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

[ Upstream commit 80e1ef3afb8bfbe768380b70ffe1b6cab87d1a3b ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, ->exit() need be called to uninit the pdata.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-5-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/pxamci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 99f3958a037c..7f96df4d2a87 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -761,7 +761,12 @@ static int pxamci_probe(struct platform_device *pdev)
 			dev_warn(dev, "gpio_ro and get_ro() both defined\n");
 	}
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		if (host->pdata && host->pdata->exit)
+			host->pdata->exit(dev, mmc);
+		goto out;
+	}
 
 	return 0;
 
-- 
2.35.1



