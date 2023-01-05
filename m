Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0840365EB8F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjAENAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbjAEM7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:59:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE08E5B165
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:59:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5351461358
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB6AC43392;
        Thu,  5 Jan 2023 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923586;
        bh=rmUNwuHkCZK/kL94eohe6D4tak7ZalGMdhKeu+Yj4iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bjh9c9D4KIy3ZD+5gBDZeGV3dsDfFnthNUlO73PLitr2/oM+5dFl81GobKOpAi5nC
         WrFKCZSCFAaEiL8Ae//URH+FOKxwR96GHsGujmoEnMe0iKvxRLnItAtHociO4YzkME
         yX4Exc/TBbqy35ITw5ZRjCqkcX167Z8zSMMNn0Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/251] mtd: lpddr2_nvm: Fix possible null-ptr-deref
Date:   Thu,  5 Jan 2023 13:53:17 +0100
Message-Id: <20230105125337.503987047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 6bdd45d795adf9e73b38ced5e7f750cd199499ff ]

It will cause null-ptr-deref when resource_size(add_range) invoked,
if platform_get_resource() returns NULL.

Fixes: 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM PCM memories")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221114090240.244172-1-tanghui20@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/lpddr/lpddr2_nvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/lpddr/lpddr2_nvm.c b/drivers/mtd/lpddr/lpddr2_nvm.c
index 5e36366d9b36..19b00225c7ef 100644
--- a/drivers/mtd/lpddr/lpddr2_nvm.c
+++ b/drivers/mtd/lpddr/lpddr2_nvm.c
@@ -448,6 +448,8 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 
 	/* lpddr2_nvm address range */
 	add_range = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!add_range)
+		return -ENODEV;
 
 	/* Populate map_info data structure */
 	*map = (struct map_info) {
-- 
2.35.1



