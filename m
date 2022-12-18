Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7732650295
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiLRQsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiLRQrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:47:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447A711476;
        Sun, 18 Dec 2022 08:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA091B80BE7;
        Sun, 18 Dec 2022 16:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E80C4339C;
        Sun, 18 Dec 2022 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380245;
        bh=mbBWrIjHzKroHYOwbAY006ELV3qq1HryJgsTCwVIxyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+baqErKHggCVntJRl2wDuC+jTMPNEM3A7yGCMBsw3knM8ZpHYJ0lUTUFqMPtgSCS
         ZwiF+ZWEaBCSg02/HrpRCOz25Gnd4Jn3WYg966WXUdlF+VgYqxiQ9CSezwHqHOlOu2
         OmgPwxQrtQ5JnNzK0Gqc1geaiuJ2LUeEanBs8zxCwuCWETVbsKsV8XZoR9mXKoqLOy
         xDHIUXyoN8VKn2/KZuZu/5THCLgys8QnQWbR4MWco7FKHmx23hD06GJrmyayMAFLeA
         qDbanj51ulY9UQvH0mJywrschj1CPMJenv1BjIMbskPvVj65jYHBEuAtZCV7ALFXZ8
         AZhMPynqNUuaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhong <floridsleeves@gmail.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/39] drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()
Date:   Sun, 18 Dec 2022 11:15:42 -0500
Message-Id: <20221218161559.932604-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhong <floridsleeves@gmail.com>

[ Upstream commit 3bd548e5b819b8c0f2c9085de775c5c7bff9052f ]

Check the return value of md_bitmap_get_counter() in case it returns
NULL pointer, which will result in a null pointer dereference.

v2: update the check to include other dereference

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d377ea060925..4e52fcf98d59 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2196,20 +2196,23 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 		if (set) {
 			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
-			if (*bmc_new == 0) {
-				/* need to set on-disk bits too. */
-				sector_t end = block + new_blocks;
-				sector_t start = block >> chunkshift;
-				start <<= chunkshift;
-				while (start < end) {
-					md_bitmap_file_set_bit(bitmap, block);
-					start += 1 << chunkshift;
+			if (bmc_new) {
+				if (*bmc_new == 0) {
+					/* need to set on-disk bits too. */
+					sector_t end = block + new_blocks;
+					sector_t start = block >> chunkshift;
+
+					start <<= chunkshift;
+					while (start < end) {
+						md_bitmap_file_set_bit(bitmap, block);
+						start += 1 << chunkshift;
+					}
+					*bmc_new = 2;
+					md_bitmap_count_page(&bitmap->counts, block, 1);
+					md_bitmap_set_pending(&bitmap->counts, block);
 				}
-				*bmc_new = 2;
-				md_bitmap_count_page(&bitmap->counts, block, 1);
-				md_bitmap_set_pending(&bitmap->counts, block);
+				*bmc_new |= NEEDED_MASK;
 			}
-			*bmc_new |= NEEDED_MASK;
 			if (new_blocks < old_blocks)
 				old_blocks = new_blocks;
 		}
-- 
2.35.1

