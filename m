Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815AA6676BD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbjALOfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238350AbjALOd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B52C4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C6095CE1E59
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D55C433D2;
        Thu, 12 Jan 2023 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533556;
        bh=mbBWrIjHzKroHYOwbAY006ELV3qq1HryJgsTCwVIxyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIoec7Qlz83/axNzgIPRl6Vn1hJQ/XtSNLbaMS/0ApXjpxqhmDeUJRwcRE0yoALKK
         YunVvcHsODQysqqGzi9qJu2dCMnBJxT2QSJRduJ3+R1V7MZGil2Fkloq00ThOmUuJ2
         iYIc7ugZiudBy8jcT3Ur3MyUFwG1zYENCk+jEFco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zhong <floridsleeves@gmail.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 517/783] drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()
Date:   Thu, 12 Jan 2023 14:53:53 +0100
Message-Id: <20230112135548.168084113@linuxfoundation.org>
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



