Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AED65037C
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiLRRFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiLRREa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 12:04:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4B11DDC9;
        Sun, 18 Dec 2022 08:21:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8CF660DC9;
        Sun, 18 Dec 2022 16:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70438C433EF;
        Sun, 18 Dec 2022 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380500;
        bh=TnOZ58i0JaKCaCF55ezilnREsj7O6EnUUDHmR71/QiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vb+qYzUcl3u5Q8+JyQ/V3h/Hg4VRFbk2fUMVikVrJKXrQgC+MNdzHYSywshK72Bz8
         QNpB3Y5OZnzdMAU2klxdrUptzfezscRTOpKdkBOMh73fPMasf05e1jHeCmnOPL6fG/
         /VyGeqG7LsfKYYzKywa0tbPI/ln7u+DpyewMgfwkR5Z6xp0zlSjyLjewIXz9BiNhng
         3Kq65Yjq9DNS6PvxJzub/UcqYw2PAfwX71I6Y1zKKNOf6EF5jzLs5bK7KifgV73Fr/
         8ryinaQFnjknqyODq8k4Bf+Shsk6wRiqpRyjdEuhBIrfOOJEK62GPf1KUeRGT2ewCt
         AR9xGclo71RqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rui Zhang <zr.zhang@vivo.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 4.19 23/26] regulator: core: fix use_count leakage when handling boot-on
Date:   Sun, 18 Dec 2022 11:20:13 -0500
Message-Id: <20221218162016.934280-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
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
index 045075cd256c..368d95578b31 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1197,7 +1197,13 @@ static int set_machine_constraints(struct regulator_dev *rdev)
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

