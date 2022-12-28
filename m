Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D921657E7C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiL1PyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiL1PyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:54:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1D3186B7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51B0BB8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5018C433EF;
        Wed, 28 Dec 2022 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242845;
        bh=nXG3WuK/QywGgb0xAZGZZ6Y/nrBzkOPYXdvXg8/rwkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSWaWpSfLVsJ/A416XSLdUm3DgMP4yQOPdlM6+lmWyarZZxT8YjkIoZkJpdwUTgnH
         Uy7sjAQRyG6d5g2t4ihP46HC9nNyGZQpt3+uIhDLmSD4fLH2eH16HDPrRBN1mo+04l
         0GYpBpE18eVtt0C4Fju7pUd0jsg0+CKFaIRXJiwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zhong <floridsleeves@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 653/731] drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()
Date:   Wed, 28 Dec 2022 15:42:40 +0100
Message-Id: <20221228144315.430319329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 8cc11b1987ec..650bfccd066f 100644
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



