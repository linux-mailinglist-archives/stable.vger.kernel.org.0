Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852806431FF
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiLETXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiLETWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE8275CB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:18:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D482161307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66FAC433C1;
        Mon,  5 Dec 2022 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267905;
        bh=ELfAWij46Wt02A5ynXbjy8/nvc20JrIwgveo3uDJNNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJ6Ltdq2BJrmq44vGgBn2B3W0xkbBDbvon6UWMB1Pg/uKFYC9qPtLR8QMPUGDsaJ1
         IMU6TdWH7ZZj/I+LSd4cKM2vFOvRMnB4nnvbvcxCFRsIbPzpUw8S4T2zqdtDrPMqoB
         F8J7ORylsgBClKWZJknlz+zUI23p9gl0EFsiYLAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>,
        Peter Kosyh <pkosyh@yandex.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/105] net/mlx4: Check retval of mlx4_bitmap_init
Date:   Mon,  5 Dec 2022 20:08:49 +0100
Message-Id: <20221205190803.718976606@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index 427e7a31862c..d7f2890c254f 100644
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



