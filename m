Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAD66753F
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbjALOTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjALOTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:19:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA72E193D6
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4820C61F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE9EC433D2;
        Thu, 12 Jan 2023 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532652;
        bh=TYgwTPZnNK4p14U9fiR5xkW4mH7K0Yh6kSasJt+OELo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcm3X2v+B1SCZeyqv6cPsQgk8pQAZbC5TyKDDLdA2RTE0/xNnKnTMRGZsHGVQuMBe
         z1TytP8WBeVO6k6R3fxVpR2cDO0aCOw6NsMyx/deK4hkpzDepL0in9iE+85at4/Xvm
         bx9ujyc3hNaF454X5il8q7K5BbzwdDxhoCgROsV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/783] mmc: atmel-mci: fix return value check of mmc_add_host()
Date:   Thu, 12 Jan 2023 14:49:07 +0100
Message-Id: <20230112135535.073565249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 444bd3a0a922..af85b32c6c1c 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2223,6 +2223,7 @@ static int atmci_init_slot(struct atmel_mci *host,
 {
 	struct mmc_host			*mmc;
 	struct atmel_mci_slot		*slot;
+	int ret;
 
 	mmc = mmc_alloc_host(sizeof(struct atmel_mci_slot), &host->pdev->dev);
 	if (!mmc)
@@ -2306,11 +2307,13 @@ static int atmci_init_slot(struct atmel_mci *host,
 
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



