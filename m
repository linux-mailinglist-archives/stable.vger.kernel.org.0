Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C534C0814
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiBWCas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiBWCaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2220357B02;
        Tue, 22 Feb 2022 18:29:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC718B81E0F;
        Wed, 23 Feb 2022 02:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B25C340F0;
        Wed, 23 Feb 2022 02:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583368;
        bh=Y0ydCJdLcvb/muRQhxCjXoK2Jvm2kqf39/xsowfr3bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgBf9pPdj8QtBLHi1sUKas7k/fodj/UflX3qMTVdwbD5qC1eCgx7dh4knX58qDMSF
         oNonO52BH6KZDFB2nsw1k54y+qqr21Q+aqADvDDHfNtHeF7w99hdBKSZTjo4ZEIojQ
         Za96nJzWfl+1Stv+8+xXyCY422CRL2UfOS34EBQyIf5epItB0J4hcszRQXxSkrQSF5
         Oi/c2K9ksIIeTDK0NUO2kzXSD6/Rr6y/MH/gZVQboYeG02NTSWDrJn3Ig0Lk/JVOrv
         SqwHHtKZysnpIcIMUOklefHbFWPZH1ljP8ugv60MtrIMnKNzDaXIh8YgPa/BJW+MlH
         Ww5g+O7qQQnXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 30/30] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
Date:   Tue, 22 Feb 2022 21:28:19 -0500
Message-Id: <20220223022820.240649-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022820.240649-1-sashal@kernel.org>
References: <20220223022820.240649-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit cc8f7fe1f5eab010191aa4570f27641876fa1267 ]

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde01564..c7f71d83eff18 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -446,7 +446,7 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(GFP_NOIO | gfp_mask);
+		page = alloc_page(GFP_NOIO | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
-- 
2.34.1

