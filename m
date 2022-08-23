Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C0559E305
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiHWMDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359352AbiHWMBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E18D83E2;
        Tue, 23 Aug 2022 02:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FCFCB81C63;
        Tue, 23 Aug 2022 09:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F149BC433C1;
        Tue, 23 Aug 2022 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247340;
        bh=aNmfpcaxTpFNfqz2CgXLsqoeLB3uweq9V9AqqFqHcRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTIIZGMm6psPTZ5VWezwUthlerepa19lR/mYkL7WLXNKkd1SdQQTgUu5VWgwKbep+
         kpEZvsDSr1SsqL5Q5rZ9oGpzeVaR6IQSlcdZxS23Wt8m7ZMiPt2mFvwbqQ4EAYvvsB
         SeZkaAoD2G2jxDOGS/v1fFHvEmBukp/bAwvPQ1/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wentao_Liang <Wentao_Liang_g@163.com>,
        Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 366/389] drivers:md:fix a potential use-after-free bug
Date:   Tue, 23 Aug 2022 10:27:24 +0200
Message-Id: <20220823080130.831174912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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



