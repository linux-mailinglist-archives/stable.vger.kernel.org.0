Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCD6593806
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343762AbiHOTSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344337AbiHOTQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:16:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EE252E52;
        Mon, 15 Aug 2022 11:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 678B961024;
        Mon, 15 Aug 2022 18:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58657C433C1;
        Mon, 15 Aug 2022 18:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588675;
        bh=4Y9obJ3d9SzWV7e3qd/6vTgE2ysm+GKbDTXk7kI8D4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gU+awE9MwapkVU0fJUiGdlf+m0e6faptFX3YLpwCwQ640DHO59BteMe3zyZlDQFCC
         BCrOYhzlO9zhHxLY6SdOpuRxPIMN6CcCHwH0wTs2v/kfYbf3zNhbUFW0GD6Dd5Alrf
         GNdd+tUahAOS0laR74LTBYPgP1h5vapJHIXgH7VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/779] memstick/ms_block: Fix some incorrect memory allocation
Date:   Mon, 15 Aug 2022 20:02:03 +0200
Message-Id: <20220815180357.742528393@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2e531bc3e0d86362fcd8a577b3278d9ef3cc2ba0 ]

Some functions of the bitmap API take advantage of the fact that a bitmap
is an array of long.

So, to make sure this assertion is correct, allocate bitmaps with
bitmap_zalloc() instead of kzalloc()+hand-computed number of bytes.

While at it, also use bitmap_free() instead of kfree() to keep the
semantic.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/dbf633c48c24ae6d95f852557e8d8b3bbdef65fe.1656155715.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/core/ms_block.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 487e4cc2951e..7275217e485e 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1341,17 +1341,17 @@ static int msb_ftl_initialize(struct msb_data *msb)
 	msb->zone_count = msb->block_count / MS_BLOCKS_IN_ZONE;
 	msb->logical_block_count = msb->zone_count * 496 - 2;
 
-	msb->used_blocks_bitmap = kzalloc(msb->block_count / 8, GFP_KERNEL);
-	msb->erased_blocks_bitmap = kzalloc(msb->block_count / 8, GFP_KERNEL);
+	msb->used_blocks_bitmap = bitmap_zalloc(msb->block_count, GFP_KERNEL);
+	msb->erased_blocks_bitmap = bitmap_zalloc(msb->block_count, GFP_KERNEL);
 	msb->lba_to_pba_table =
 		kmalloc_array(msb->logical_block_count, sizeof(u16),
 			      GFP_KERNEL);
 
 	if (!msb->used_blocks_bitmap || !msb->lba_to_pba_table ||
 						!msb->erased_blocks_bitmap) {
-		kfree(msb->used_blocks_bitmap);
+		bitmap_free(msb->used_blocks_bitmap);
+		bitmap_free(msb->erased_blocks_bitmap);
 		kfree(msb->lba_to_pba_table);
-		kfree(msb->erased_blocks_bitmap);
 		return -ENOMEM;
 	}
 
@@ -1962,7 +1962,7 @@ static int msb_bd_open(struct block_device *bdev, fmode_t mode)
 static void msb_data_clear(struct msb_data *msb)
 {
 	kfree(msb->boot_page);
-	kfree(msb->used_blocks_bitmap);
+	bitmap_free(msb->used_blocks_bitmap);
 	kfree(msb->lba_to_pba_table);
 	kfree(msb->cache);
 	msb->card = NULL;
-- 
2.35.1



