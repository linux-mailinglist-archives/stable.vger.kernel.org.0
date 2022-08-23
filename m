Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8112459D516
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343711AbiHWIfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbiHWIdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285707549E;
        Tue, 23 Aug 2022 01:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E56F1B81C35;
        Tue, 23 Aug 2022 08:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A38C433C1;
        Tue, 23 Aug 2022 08:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242556;
        bh=WmoV+L1N+fDk24WcvLpFK8jLFwah7J6ezwwEFkIDOR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIrHQ1NhuIZzPdrbb3CPJ/U71bMMeLaE6bavDRutZEsXYnmqwvjSOSFzFRhG6YGbQ
         XH/0WatCncPSG0MYd8MBPp5+OiShCcOIoBE5VDWgECITYo3aOL+nROdPrDLB1gTUg9
         tNch3g37FHfUDLN02bdE88Y4DEhAVk4WHEsq8+lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wentao_Liang <Wentao_Liang_g@163.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 091/101] drivers:md:fix a potential use-after-free bug
Date:   Tue, 23 Aug 2022 10:04:04 +0200
Message-Id: <20220823080038.031410756@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b396e78b1b6d..bea171a5e663 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2513,10 +2513,10 @@ static void raid5_end_write_request(struct bio *bi)
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
 		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
-	raid5_release_stripe(sh);
 
 	if (sh->batch_head && sh != sh->batch_head)
 		raid5_release_stripe(sh->batch_head);
+	raid5_release_stripe(sh);
 }
 
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
-- 
2.35.1



