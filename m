Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB1B6A001B
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 01:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjBWAdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 19:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjBWAdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 19:33:39 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781FFCC3D
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 16:33:33 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id i4so2817912ils.1
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 16:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qiIzKPUUv1iOBvt89lezv2ZkxW0me3bA2w+4a4Beaic=;
        b=GWyY4rZFZfGpPzhK85+Z+BwjVqx0BpQlR+0EWmWrNvYWB8wBv2bbTCIS0hGnMZddnK
         iYoMAChm4bOGN4vrjGzZOjRlmncGITBJYIYHqanYnwSXTCkaQaTscCbs3fBUDlYxDXZy
         Zvck5NfCqSZA823aFXCvFrsza9T31uScMlyeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qiIzKPUUv1iOBvt89lezv2ZkxW0me3bA2w+4a4Beaic=;
        b=JGWubuG9xI9fzVHr0mULlAf+Dc19k8Wuz/w654gBkvSmvNGWtiRA/3KMcMseD1q6ri
         wJ+yg2WYBo13F7oy+S2fz1Co2F1ALAcPH2vBc5I+tm6OmffB2DKeuKyyYUhgxBtvYLBk
         JIEGRWCHAYcO+QSE1mFIogfAMNfCIepbKx8E22zvZDjmSIjuaO7MUrQtCjMHKxlMOaPv
         RFFYEMEqbwsVfNpQoU8sXwmphlvXF5GcGBr+YWUbbPlWWRoonXTn4la69nO7HZZl+yDn
         jaELZ6+yYcgkSOryp7jb7oWlRz4CFlfcdjtkO9acqQ6bZlVIYRtyFF91+X4A32bS8l2B
         AplQ==
X-Gm-Message-State: AO0yUKVhcRMCUuOlSxxw7nfWw9b47rwKjCpudDdHPImIwOURg24mAFls
        SdQ7Ock6s/cj9I9ODT7kKOBwWQ==
X-Google-Smtp-Source: AK7set/rmH/TlXj8qh9JFNfXaNQWInM2+f4FvMLa/adCywpEj3qZrR3M4gGYv5Nj6JRYXZzzxDnYiw==
X-Received: by 2002:a05:6e02:16ce:b0:315:4f52:213e with SMTP id 14-20020a056e0216ce00b003154f52213emr11753440ilx.12.1677112412865;
        Wed, 22 Feb 2023 16:33:32 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id z25-20020a02ceb9000000b003c5170ddcedsm1152044jaq.110.2023.02.22.16.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 16:33:32 -0800 (PST)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Stephen Boyd <swboyd@chromium.org>,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] regulator: core: Use ktime_get_boottime() to determine how long a regulator was off
Date:   Thu, 23 Feb 2023 00:33:30 +0000
Message-Id: <20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For regulators with 'off-on-delay-us' the regulator framework currently
uses ktime_get() to determine how long the regulator has been off
before re-enabling it (after a delay if needed). A problem with using
ktime_get() is that it doesn't account for the time the system is
suspended. As a result a regulator with a longer 'off-on-delay' (e.g.
500ms) that was switched off during suspend might still incurr in a
delay on resume before it is re-enabled, even though the regulator
might have been off for hours. ktime_get_boottime() accounts for
suspend time, use it instead of ktime_get().

Fixes: a8ce7bd89689 ("regulator: core: Fix off_on_delay handling")
Cc: stable@vger.kernel.org    # 5.13+
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
---
The issue already existed before the commit in the 'Fixes' tag, but
it's probably not worth backporting this to older kernels that
use jiffies instead of ktime.

Changes in v2:
- added 'Fixes' and Cc: stable tags
- added 'Reviewed-by' tag from Stephen

 drivers/regulator/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ae69e493913d..4fcd36055b02 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1584,7 +1584,7 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
@@ -2673,7 +2673,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 		 * this regulator was disabled.
 		 */
 		ktime_t end = ktime_add_us(rdev->last_off, rdev->desc->off_on_delay);
-		s64 remaining = ktime_us_delta(end, ktime_get());
+		s64 remaining = ktime_us_delta(end, ktime_get_boottime());
 
 		if (remaining > 0)
 			_regulator_delay_helper(remaining);
@@ -2912,7 +2912,7 @@ static int _regulator_do_disable(struct regulator_dev *rdev)
 	}
 
 	if (rdev->desc->off_on_delay)
-		rdev->last_off = ktime_get();
+		rdev->last_off = ktime_get_boottime();
 
 	trace_regulator_disable_complete(rdev_get_name(rdev));
 
-- 
2.39.2.722.g9855ee24e9-goog

