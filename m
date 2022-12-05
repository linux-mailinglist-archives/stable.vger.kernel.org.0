Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A788B64312A
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiLETMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiLETLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:11:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEA9DF4D
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 258626130E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39196C433D7;
        Mon,  5 Dec 2022 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267508;
        bh=AbukNit9jrGYedSRVJ73HZEQC0VkQCOluTF7P4Lp7TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvTiIZu14Fe3jKclWbO6tCtr6+oozKWIBqtSWj0V0uGySpdTM5J7hFB96r8fQClSq
         c9c2eMsnW2uEnF3FDq097ROyLVKmDF9r7wNIhqVFwncyE5eDTFmMSXtCV2+INmk6yf
         MUcRW7GufQVO86lDRz2yktIbPlgvScl//p7y8NxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>,
        Peter Kosyh <pkosyh@yandex.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/62] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Mon,  5 Dec 2022 20:09:09 +0100
Message-Id: <20221205190758.555662803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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
index 71578d48efbc..54026043b5e2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -696,7 +696,8 @@ static int mlx4_create_zones(struct mlx4_dev *dev,
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



