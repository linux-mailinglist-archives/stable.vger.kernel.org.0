Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D0A59212A
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240730AbiHNPek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiHNPeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:34:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EBDDEA4;
        Sun, 14 Aug 2022 08:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C16F60C94;
        Sun, 14 Aug 2022 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30774C433D7;
        Sun, 14 Aug 2022 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491020;
        bh=LKYTZ8t1r7PSDOsdZvV9qIXBrHrd4WElWZNqWkPgLvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcqSMF4xMJmMORL/T1tAEOTJgV6NHGVfh3p+K1h3pqfDT20p3eRLx1xHg+x4UdcA3
         qTv4voMgpzuxDTZjLd54nGt3/W82U/VhO8DbLgGgVI3b0e0rJhUxbiX8hDiv0p4kLC
         QPbNXLWKC8H4dj0dfTs//7jb5mpXD2NgjM9k/PlZI59zbrFZZlnCQbn0+SsJv5n7hX
         dC0l6hn4GRPUMvl0EwFIhLVGIly4O+xityX20+t8eZmryKv6yO7pyiWs7arcJuR3RF
         YRBFGloXwpNPBcpE9p618jjpXUtoBl0rbi2+s62xhuR31VBDK6TmgguWY9TzrqfjsD
         96vopDRutepAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>, Song Liu <song@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 61/64] drivers:md:fix a potential use-after-free bug
Date:   Sun, 14 Aug 2022 11:24:34 -0400
Message-Id: <20220814152437.2374207-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
index 45482cebacdb..1c1310d539f2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2881,10 +2881,10 @@ static void raid5_end_write_request(struct bio *bi)
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

