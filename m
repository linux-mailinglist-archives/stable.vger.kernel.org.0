Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05574DB2DA
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356808AbiCPOUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356728AbiCPOUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21F71EEC8;
        Wed, 16 Mar 2022 07:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9ADD61387;
        Wed, 16 Mar 2022 14:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9281C340EC;
        Wed, 16 Mar 2022 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440291;
        bh=cVDdsbpYFuHyz0xlac1F0bWymJbKHPQtOUNFav6KMT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnoHw7jvHtBqxfU0Lq/J4k7YHfRiIPvoJc/RAK9oRkLSK1mAhqIPkatXl4hXOObtZ
         1FNRYIv2Kx3cD4kHV/MYIEN+wqWuYVVP0XtI22PDfXUhGeHjBgsEwzPeoS3ac3gduO
         +FBhMSlYGjA4c4457qEEVeM0ozrnRaSJwjb277/yBUNFeB7ISdt4L1tQtuLGDnAkbM
         JFx2SsAzUlhJU9vw2NaXEZGTjuaTllXD8mZ/gywNyEq6IDnsr4LJks4kzAc7014o5I
         6JUV0BTIF1WWeU9ymY0+XVZw5IMk2zyG90wkqJyRuKJ4xC5geqp+FWWONvKUw4UFz5
         ECmDHvrdBIXiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/7] spi: Fix invalid sgs value
Date:   Wed, 16 Mar 2022 10:17:37 -0400
Message-Id: <20220316141738.248513-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141738.248513-1-sashal@kernel.org>
References: <20220316141738.248513-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 1a4e53d2fc4f68aa654ad96d13ad042e1a8e8a7d ]

max_seg_size is unsigned int and it can have a value up to 2^32
(for eg:-RZ_DMAC driver sets dma_set_max_seg_size as U32_MAX)
When this value is used in min_t() as an integer type, it becomes
-1 and the value of sgs becomes 0.

Fix this issue by replacing the 'int' data type with 'unsigned int'
in min_t().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220307184843.9994-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index ac05c9c86488..837fa947dec7 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -844,10 +844,10 @@ int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
 	int i, ret;
 
 	if (vmalloced_buf || kmap_buf) {
-		desc_len = min_t(int, max_seg_size, PAGE_SIZE);
+		desc_len = min_t(unsigned int, max_seg_size, PAGE_SIZE);
 		sgs = DIV_ROUND_UP(len + offset_in_page(buf), desc_len);
 	} else if (virt_addr_valid(buf)) {
-		desc_len = min_t(int, max_seg_size, ctlr->max_dma_len);
+		desc_len = min_t(unsigned int, max_seg_size, ctlr->max_dma_len);
 		sgs = DIV_ROUND_UP(len, desc_len);
 	} else {
 		return -EINVAL;
-- 
2.34.1

