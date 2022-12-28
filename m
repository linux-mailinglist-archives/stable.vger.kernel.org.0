Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75DA657ED5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiL1P6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbiL1P6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DACD183B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCAE1B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287EEC433D2;
        Wed, 28 Dec 2022 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243083;
        bh=KsNsRnhHCmEaauer6ON5uqFqhQpEjYpmwUIzIoIbukM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARS+kAnhOjL1//f1Z3U8R7Zo97uvf42Tm/9UILVf4YQyeKfT9/DdkswE+qVXWA7Gh
         f7jk9lS11lY2ytTcHjcVGuQeY6UMLbVp5LI5aWaf0CUZOQdP054SuRtkjFAmJfizPb
         f1luj5u0oAr0swEE+pNS8Mv4Zlxcv452RWQvGvK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0488/1073] mmc: atmel-mci: fix return value check of mmc_add_host()
Date:   Wed, 28 Dec 2022 15:34:36 +0100
Message-Id: <20221228144341.290873714@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 9e6e8c43726673ca2abcaac87640b9215fd72f4c ]

mmc_add_host() may return error, if we ignore its return value,
it will lead two issues:
1. The memory that allocated in mmc_alloc_host() is leaked.
2. In the remove() path, mmc_remove_host() will be called to
   delete device, but it's not added yet, it will lead a kernel
   crash because of null-ptr-deref in device_del().

So fix this by checking the return value and calling mmc_free_host()
in the error path.

Fixes: 7d2be0749a59 ("atmel-mci: Driver for Atmel on-chip MMC controllers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221108122819.429975-1-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/atmel-mci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 91d52ba7a39f..bb9bbf1c927b 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2222,6 +2222,7 @@ static int atmci_init_slot(struct atmel_mci *host,
 {
 	struct mmc_host			*mmc;
 	struct atmel_mci_slot		*slot;
+	int ret;
 
 	mmc = mmc_alloc_host(sizeof(struct atmel_mci_slot), &host->pdev->dev);
 	if (!mmc)
@@ -2305,11 +2306,13 @@ static int atmci_init_slot(struct atmel_mci *host,
 
 	host->slot[id] = slot;
 	mmc_regulator_get_supply(mmc);
-	mmc_add_host(mmc);
+	ret = mmc_add_host(mmc);
+	if (ret) {
+		mmc_free_host(mmc);
+		return ret;
+	}
 
 	if (gpio_is_valid(slot->detect_pin)) {
-		int ret;
-
 		timer_setup(&slot->detect_timer, atmci_detect_change, 0);
 
 		ret = request_irq(gpio_to_irq(slot->detect_pin),
-- 
2.35.1



