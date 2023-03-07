Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65E56AF39F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjCGTHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjCGTGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:06:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C1968EC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87756CE1C93
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AE8C433D2;
        Tue,  7 Mar 2023 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215118;
        bh=5DtMWVM4qDPQkMFhXfVmoicW6kz261Ojjkqf2j5bULM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGwRxwp2qP09GhJSgUmi75GvznSeZOvcVkt7TuWBpoAnu2D1OEif5JH6wTMUEFUnb
         VvZhGJLuABW/bomIMq7ffD0L8snDSk8wHAOr0mGobtf7VpWC+mF99h+npikdOkjzGR
         0cUqmUubX72CEMjd9F1Ktu/fL1j7hV0d0Soq8poM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eran Ben Elisha <eranbe@nvidia.com>,
        Majd Dibbiny <majd@nvidia.com>,
        Jack Morgenstein <jackm@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/567] net/mlx5: Enhance debug print in page allocation failure
Date:   Tue,  7 Mar 2023 17:57:42 +0100
Message-Id: <20230307165911.345361262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@nvidia.com>

[ Upstream commit 7eef93003e5d20e1a6a6e59e12d914b5431cbda2 ]

Provide more details to aid debugging.

Fixes: bf0bf77f6519 ("mlx5: Support communicating arbitrary host page size to firmware")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Majd Dibbiny <majd@nvidia.com>
Signed-off-by: Jack Morgenstein <jackm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 110c0837f95b9..ae6ac51b8ab03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -216,7 +216,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u32 function)
 
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
-- 
2.39.2



