Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4C6604007
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiJSJme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiJSJjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:39:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC51DED22;
        Wed, 19 Oct 2022 02:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8400617D4;
        Wed, 19 Oct 2022 09:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B671FC433D7;
        Wed, 19 Oct 2022 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170843;
        bh=FExqy90cvvKeQwgBS3G6vEsaIKxkIk3GIJCelzs91+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftzSWO+eC6HulXbNI8UJ63pYwCK6i+VcXgU2h9VAyJgIlpg69EXnQps8JKP9WZkZv
         mk5SRnj9GBHz0wVcKWIUs5KysclTyApt21i7O68V0R3VLWyCG+XTuRr82q6RhLwR36
         wcKVQZjZW3oQqYkH1F7bU4g85UG5agWgO5yVr3Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 807/862] blk-throttle: prevent overflow while calculating wait time
Date:   Wed, 19 Oct 2022 10:34:54 +0200
Message-Id: <20221019083325.560259314@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3c02a9b3275a..35cf744ea9d1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -806,7 +806,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -824,10 +824,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
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



