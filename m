Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1263DE6A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiK3Sgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiK3Sgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:36:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF492084
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:36:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83C561D76
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0046CC433C1;
        Wed, 30 Nov 2022 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833393;
        bh=wHcGvUCSpjeJeQFPgmrrggzyUMZP1fqxj8+p1iXfZPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGNSezVh+JZvdSjw9YeSClrComN2eTxvCHIt6FGV0Z0fCqb5msNXLJSZKTK3XUrAR
         OgtFCv1hSPw8D+uQRAqY/VWZRJo1Aj1rjMdz32kDUcjGTC7Lf1NC1iUUtxymJOMMLe
         PB+Q0CfjEGPRYqBH1JrhGA93jqojA5diznN6T3s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>,
        Peter Kosyh <pkosyh@yandex.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/206] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Wed, 30 Nov 2022 19:22:22 +0100
Message-Id: <20221130180535.306498134@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Peter Kosyh <pkosyh@yandex.ru>

[ Upstream commit 594c61ffc77de0a197934aa0f1df9285c68801c6 ]

If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
the NULL pointer (bitmap->table).

Make sure, that mlx4_bitmap_alloc_range called in no error case.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d57febe1a478 ("net/mlx4: Add A0 hybrid steering")
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
Link: https://lore.kernel.org/r/20221117152806.278072-1-pkosyh@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index b149e601f673..48cfaa7eaf50 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -697,7 +697,8 @@ static int mlx4_create_zones(struct mlx4_dev *dev,
 			err = mlx4_bitmap_init(*bitmap + k, 1,
 					       MLX4_QP_TABLE_RAW_ETH_SIZE - 1, 0,
 					       0);
-			mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
+			if (!err)
+				mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
 		}
 
 		if (err)
-- 
2.35.1



