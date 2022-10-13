Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C602B5FD0DE
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiJMAaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiJMA3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFC511E47C;
        Wed, 12 Oct 2022 17:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AC1361646;
        Thu, 13 Oct 2022 00:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5DAC43142;
        Thu, 13 Oct 2022 00:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620651;
        bh=p6GiSY8fKFEwVLEYaOs1ega9J3UWlailRKtYivPY8dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ralkKVeHDCFg1GzFTTPBFCW/lnC/sQw4/tbmuAuLziiHeCg18QFyjuqgAi6rKzRsI
         9wGuznO3f88WlF1zMeQ/BGatOANV0iHmlwOZz0nlo97iy6GXeguz595aSAmyaSP5Yo
         Nt7XB/jW2MpCQeXZTTLM5TWk/jNmw+SG2FSDsZYemdZz4pOaPc0oqnTV+QhEQ1ffUy
         N6GsNd1r35kBVapSXUjYnpcpKoh4klskB9TuS+qD1zQl4QMdg6rRSHTd9IqN7UDgNr
         29F6uvnQvClPULo2C57XYJuY+yUR/t7x4cmNyO0qWI10svancil/kaHzKAouMSW7oe
         wKXHqJT4LxaTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/33] blk-throttle: prevent overflow while calculating wait time
Date:   Wed, 12 Oct 2022 20:23:12 -0400
Message-Id: <20221013002334.1894749-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8d6bbaada2e0a65f9012ac4c2506460160e7237a ]

There is a problem found by code review in tg_with_in_bps_limit() that
'bps_limit * jiffy_elapsed_rnd' might overflow. Fix the problem by
calling mul_u64_u64_div_u64() instead.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220829022240.3348319-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c53a254171a2..c526fdd0a7b9 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -944,7 +944,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -961,10 +961,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-
-	tmp = bps_limit * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
-	bytes_allowed = tmp;
+	bytes_allowed = mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd,
+					    (u64)HZ);
 
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
-- 
2.35.1

