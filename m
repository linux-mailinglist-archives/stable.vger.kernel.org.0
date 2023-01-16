Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B01266CA52
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbjAPRCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjAPRBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:01:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246433E62A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E0C61086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C815DC433D2;
        Mon, 16 Jan 2023 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887418;
        bh=ZN8ONw36rZJDZ7az9/HXLyKvW4dttB0PaWD1aB0rCIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSqBSBF29/ecusVtWaYlwRmeoSVYOeZFQ+6W0aekonwGuoqaeS+v2sw9VGK6bUUQ5
         BqVXwvl+PnxiYWjSJ7fY5IkfGVAk0Oz6auDzR0hFNil2dggyEJUtlkgFXggW70Ceca
         JyeOpmHnA2NBwrT7kTQpOjFXkclhRZqrER6V2imI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 142/521] mmc: atmel-mci: fix return value check of mmc_add_host()
Date:   Mon, 16 Jan 2023 16:46:44 +0100
Message-Id: <20230116154853.617378861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index fbc56ee99682..d40bab3d9f4a 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2262,6 +2262,7 @@ static int atmci_init_slot(struct atmel_mci *host,
 {
 	struct mmc_host			*mmc;
 	struct atmel_mci_slot		*slot;
+	int ret;
 
 	mmc = mmc_alloc_host(sizeof(struct atmel_mci_slot), &host->pdev->dev);
 	if (!mmc)
@@ -2342,11 +2343,13 @@ static int atmci_init_slot(struct atmel_mci *host,
 
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



