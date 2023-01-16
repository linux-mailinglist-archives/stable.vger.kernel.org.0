Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5466C741
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbjAPQ3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbjAPQ3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:29:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C03736FD4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F288CE127F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61344C433D2;
        Mon, 16 Jan 2023 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885829;
        bh=YPgO4DaKOjIkBA4cvB5WFeNsSZOamXi002wzuVCCepY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MssMk7FOeovc/FQZqOOd3PQ0uD4RLxgfcWeeGfWtEwuVHmGRBnSBXQ3flMFR/g5cj
         bHurVoiLvzB2MM8PqyTBDSHjfVDPILm3vPS5zufWmOjr5hhmHmxhYurmuDvk4radPe
         84pXkuRDiBB4eLKBqUO487MixiXFx/CmmxruDWYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/658] mmc: wbsd: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:44:48 +0100
Message-Id: <20230116154918.587072749@linuxfoundation.org>
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

[ Upstream commit dc5b9b50fc9d1334407e316e6e29a5097ef833bd ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

So fix this by checking the return value and goto error path which
will call mmc_free_host(), besides, other resources also need be
released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109133237.3273558-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/wbsd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 740179f42cf2..639f87ba1606 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1701,7 +1701,17 @@ static int wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	wbsd_init_device(host);
 
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		if (!pnp)
+			wbsd_chip_poweroff(host);
+
+		wbsd_release_resources(host);
+		wbsd_free_mmc(dev);
+
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	pr_info("%s: W83L51xD", mmc_hostname(mmc));
 	if (host->chip_id != 0)
-- 
2.35.1



