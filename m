Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41D0650146
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiLRQ0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiLRQZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:25:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664B713F16;
        Sun, 18 Dec 2022 08:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDCF860DD4;
        Sun, 18 Dec 2022 16:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3B8C433D2;
        Sun, 18 Dec 2022 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379792;
        bh=1C/btrXoj9FohJvdTnZDUNcU45dnEn6H8iX9b6YHpx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfZ/Je4YwpILVsyZSBsFMGZGidCJoqlaGRXC44yuDhgeytrfxaFpoHL5EvR/SY2gZ
         vRQ0rr6e6NkiLv6uI2CpohNlYRKNUs7yNafFFcgDVhXck6flJY+HhHidNMDn8lJSTH
         y19q0bYuKI0ve9NJHOuZaurN/HMw2bRJLFiSZURngB94sdLMXNlG6GmRrHPEQfj8B2
         N91L/RojJQoWHpXFww8n+NPjBVaEBCGW0Y8GH9OqA0n88lKglO1FRlHp8U7vsGA+Ro
         1ywi0s/a8/H2LuV9mV4SGWyOD5mgLtJM8SxbfvD080eTbYswp5QOYNvrDgD80ARDqu
         qxoNC6VjK9wMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Zhong <floridsleeves@gmail.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 36/73] drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()
Date:   Sun, 18 Dec 2022 11:07:04 -0500
Message-Id: <20221218160741.927862-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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
index bf6dffadbe6f..63ece30114e5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2195,20 +2195,23 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
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

