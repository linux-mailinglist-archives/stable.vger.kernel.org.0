Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF4C65018E
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiLRQdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiLRQdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:33:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9D9B1F3;
        Sun, 18 Dec 2022 08:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBDF760DB4;
        Sun, 18 Dec 2022 16:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9022BC433F1;
        Sun, 18 Dec 2022 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379924;
        bh=ehp/vQ7s2pFTf6up7AJNJReKn9wV8wttCXg5xI0OzjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1mbNAtkOriQpg5JBvI5zqcAA7dKO305osMQ4BHK3Gq48KLtucTl5hkQ9FejfURh9
         t1QntgMGjzO3GfIHfAoqYbkCRZrPZW4nfJaGgV5V8WFqyedG8FywBncqnoxM6Qu6+D
         dkZQSw+nJSBO4agr3BDnNnQs572U8bnv/EABTL9dCAu+ShFHLtPvYGZkPFM+6ADiAf
         NpSJ8/WKZgnTmK/JaXa3bJpPfnFBeLPnAXFWR/X1sYdXpZd4u9aV3dOQ0T6tqFN9tP
         NkZDqiW4PzGYcP/ASrNTQkbg5uI5SblBUG3aVfAXaDZ97JsRGTpGfF8emVZNPUzLWZ
         0EtsWpr7IaV/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Zhang <zr.zhang@vivo.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 6.0 59/73] regulator: core: fix use_count leakage when handling boot-on
Date:   Sun, 18 Dec 2022 11:07:27 -0500
Message-Id: <20221218160741.927862-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rui Zhang <zr.zhang@vivo.com>

[ Upstream commit 0591b14ce0398125439c759f889647369aa616a0 ]

I found a use_count leakage towards supply regulator of rdev with
boot-on option.

┌───────────────────┐           ┌───────────────────┐
│  regulator_dev A  │           │  regulator_dev B  │
│     (boot-on)     │           │     (boot-on)     │
│    use_count=0    │◀──supply──│    use_count=1    │
│                   │           │                   │
└───────────────────┘           └───────────────────┘

In case of rdev(A) configured with `regulator-boot-on', the use_count
of supplying regulator(B) will increment inside
regulator_enable(rdev->supply).

Thus, B will acts like always-on, and further balanced
regulator_enable/disable cannot actually disable it anymore.

However, B was also configured with `regulator-boot-on', we wish it
could be disabled afterwards.

Signed-off-by: Rui Zhang <zr.zhang@vivo.com>
Link: https://lore.kernel.org/r/20221201033806.2567812-1-zr.zhang@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c0f368f1b49f..02ea917c7fd1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1578,7 +1578,13 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		if (rdev->supply_name && !rdev->supply)
 			return -EPROBE_DEFER;
 
-		if (rdev->supply) {
+		/* If supplying regulator has already been enabled,
+		 * it's not intended to have use_count increment
+		 * when rdev is only boot-on.
+		 */
+		if (rdev->supply &&
+		    (rdev->constraints->always_on ||
+		     !regulator_is_enabled(rdev->supply))) {
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0) {
 				_regulator_put(rdev->supply);
-- 
2.35.1

