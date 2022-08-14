Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1845922C9
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbiHNPwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241936AbiHNPul (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831151CFD4;
        Sun, 14 Aug 2022 08:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E252460DDA;
        Sun, 14 Aug 2022 15:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5B1C433B5;
        Sun, 14 Aug 2022 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491367;
        bh=aNmfpcaxTpFNfqz2CgXLsqoeLB3uweq9V9AqqFqHcRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDo2TslTnyfH3BYMgR2+5xyYa2UkbOuR1AN8tNT/gt+eMzFNBJZEda+K/v9zeqpHC
         DaPNy3Zoft1BT756KJT1uZxzeyhyxf3YFaalBTwygNcZHPnuLGeoZ8R7k/ilRHGS04
         bfByuQvXoInGnoJu6CqzIr+vbobtC9v1betkHK20ohBMQ3Jt2DPFgLvJoZ2fzqgr2g
         cT/aZ/KhX4/ikdD0MjbtmpkhgZ9oJd+gE/PNsNwN/peeKhwtSblv2AqsMHUEuLBBHF
         j4D7pAkXNN+kMh5NLOuLrY9XzI05VrUCOdCVxiE5O6le2GpGkbp/gi1UmBEJo+mNxL
         C3SQ6LmzgQW7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/21] drivers:md:fix a potential use-after-free bug
Date:   Sun, 14 Aug 2022 11:35:29 -0400
Message-Id: <20220814153531.2379705-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
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
index 474cf6abefea..fe99e8cdc026 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2666,10 +2666,10 @@ static void raid5_end_write_request(struct bio *bi)
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

