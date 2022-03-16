Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDDA4DB2E4
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348404AbiCPOV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356705AbiCPOU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:20:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10BE25C7B;
        Wed, 16 Mar 2022 07:18:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53570B81B7C;
        Wed, 16 Mar 2022 14:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055E7C340F1;
        Wed, 16 Mar 2022 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440324;
        bh=fZ0NMhp8ITe263nvjodv6Z57zmXNL/LGHoSpLaRSkNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfaQWrQAzvnP7II+ybcpwpdOJutI2ULyOeWurSbWd4/nYFHms1n1vdXDc+T4duktZ
         vu+d6fNKIhWZmc9uItdBx56bH1LeIl32oYXj1ZOBcSJezdaW4PNfdAGcTsjxjdbv6+
         kBn9uEw+BISmGEGms+K1Q6Zb4oaVsnFU0+h6kwBkd/2XftsSkx4roovuEDsZJQ7jlm
         OHuswtNpB9UVM9bb9/8G+++xqXBCEPiMgFwPn6MPUAaYdqpThimHNbHb4RsqMsZTDD
         QF4GIX2jQeO0oVoTA+ZLjeRpeX93JeCFgqxSZHJ6Swm64mgbBVXLcQx6K2XAIXZMBi
         7dl1/mBx0iONw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/6] spi: Fix invalid sgs value
Date:   Wed, 16 Mar 2022 10:18:16 -0400
Message-Id: <20220316141817.248621-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141817.248621-1-sashal@kernel.org>
References: <20220316141817.248621-1-sashal@kernel.org>
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
index 49f592e433a8..518c8e0eef7f 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -779,10 +779,10 @@ int spi_map_buf(struct spi_controller *ctlr, struct device *dev,
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

