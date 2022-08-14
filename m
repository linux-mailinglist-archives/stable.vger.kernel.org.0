Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E1F5922A8
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiHNPuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241719AbiHNPst (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:48:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E076B101C6;
        Sun, 14 Aug 2022 08:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 496D7B80B79;
        Sun, 14 Aug 2022 15:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509E5C433B5;
        Sun, 14 Aug 2022 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491328;
        bh=5al+6LErGki/bhO/CqhGcnv4fL+cBKxwlRvMI/DCKE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qm1qWqkgGjCIgzvvvklFbGGmRyoG+NOeQ1H86MsqiTenYd1DPagtn7cXIsuqlKab0
         wpFa/c4tD3G6JEAniYulYbRojdpmtyUR5jrvopavbYomMxixIUHSceVrWfqRe5pzh2
         tFOoHrHQI5PqQkoMzDeA0frecXzE1tLp0SQ69T9JKuicTlPqmET6Gm/p+Hs4YCgAeC
         XPD6b3a7VXYj+NbnYCaFPLDwwP9wuGdjKVY4J4MCCVYmRlZpx0SycEkHvL5YWCPSqc
         Sri0XmuKeIivaHN0lDGEk3i9mzuBkz4ZT+9Q5rBd0FkEUKdzNC02F+0l+I18YhyZwH
         iQIIa22/RPK5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/31] drivers:md:fix a potential use-after-free bug
Date:   Sun, 14 Aug 2022 11:34:29 -0400
Message-Id: <20220814153431.2379231-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153431.2379231-1-sashal@kernel.org>
References: <20220814153431.2379231-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wentao_Liang <Wentao_Liang_g@163.com>

[ Upstream commit 104212471b1c1817b311771d817fb692af983173 ]

In line 2884, "raid5_release_stripe(sh);" drops the reference to sh and
may cause sh to be released. However, sh is subsequently used in lines
2886 "if (sh->batch_head && sh != sh->batch_head)". This may result in an
use-after-free bug.

It can be fixed by moving "raid5_release_stripe(sh);" to the bottom of
the function.

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c8cafdb094aa..01c7edf32936 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2864,10 +2864,10 @@ static void raid5_end_write_request(struct bio *bi)
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	raid5_release_stripe(sh);
 
 	if (sh->batch_head && sh != sh->batch_head)
 		raid5_release_stripe(sh->batch_head);
+	raid5_release_stripe(sh);
 }
 
 static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
-- 
2.35.1

