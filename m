Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8955F91A6
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiJIWgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiJIWe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:34:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85682286E1;
        Sun,  9 Oct 2022 15:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B45CB80DDE;
        Sun,  9 Oct 2022 22:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29184C433D6;
        Sun,  9 Oct 2022 22:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354014;
        bh=zTri6CPQ9P0Lzgr20EKzelmjLoo2TzdJMIC0eulf4NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5hDLhPDNrNsaOu39bpjVRCXaL3HcdFFAXSTkEmeJKItyRpggIMKA1wEva76PFU0S
         uIywv8dSENN4b0jIaJSC0X7RNVgGbkBZ2y6zCu+vgzSbXKogl7HfOo8ix6brIsTBDE
         u0StdeYOOflhCu2NrE8wQZeHzu/OIEN29EKibSNizCPQSOWAeESzcYp7Xh5Z9Ero9/
         FtQ0SqSNYUqPSgehqEZ8j9xQon1BmO7S9ypmbkEeGu4D3kpS4Dit3chs2Fb/ynDjV3
         wkpld/9BQPDtaCHRoUIgiaJwCZqBpZK1VsMXZoA7aRFC/X/lIb+CPwatn5Ag8oKzCg
         JiPe0+mzGmSAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.15 22/46] regulator: core: Prevent integer underflow
Date:   Sun,  9 Oct 2022 18:18:47 -0400
Message-Id: <20221009221912.1217372-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 8d8e16592022c9650df8aedfe6552ed478d7135b ]

By using a ratio of delay to poll_enabled_time that is not integer
time_remaining underflows and does not exit the loop as expected.
As delay could be derived from DT and poll_enabled_time is defined
in the driver this can easily happen.

Use a signed iterator to make sure that the loop exits once
the remaining time is negative.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20220909125954.577669-1-patrick.rudolph@9elements.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 43613db7af75..aa4d78b02483 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2636,7 +2636,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * expired, return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_enable_delay(rdev->desc->poll_enabled_time);
-- 
2.35.1

