Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2DD6ADAC0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCGJpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCGJpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE029747
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A36A612AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D29C433EF;
        Tue,  7 Mar 2023 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182332;
        bh=o0OL3pZ3+27EbfJDovnjg/y6BVisdMf6/o43eA5H/zY=;
        h=Subject:To:Cc:From:Date:From;
        b=d9OsS31p++sd+5IlHT926X2Z8CEthN9pXeISYJPYdGLirNJgu+nXN6Iw7ij3UQs8J
         k6hm2WbaBrV2+M93wCJTT8ZsYY9vjNT7t2DIWvGrtB5kPf6gJdQlh0JiEJkne1jS1g
         Hn+fgaLhmli+tiCKpNTWyE6vaIGuSjjxFT26UUSQ=
Subject: FAILED: patch "[PATCH] regulator: core: Use ktime_get_boottime() to determine how" failed to apply to 5.15-stable tree
To:     mka@chromium.org, broonie@kernel.org, swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:45:29 +0100
Message-ID: <1678182329223204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 80d2c29e09e663761c2778167a625b25ffe01b6f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678182329223204@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

80d2c29e09e6 ("regulator: core: Use ktime_get_boottime() to determine how long a regulator was off")
218320fec294 ("regulator: core: Fix off-on-delay-us for always-on/boot-on regulators")
261f06315cf7 ("regulator: Flag uncontrollable regulators as always_on")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 80d2c29e09e663761c2778167a625b25ffe01b6f Mon Sep 17 00:00:00 2001
From: Matthias Kaehlcke <mka@chromium.org>
Date: Thu, 23 Feb 2023 00:33:30 +0000
Subject: [PATCH] regulator: core: Use ktime_get_boottime() to determine how
 long a regulator was off

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
Link: https://lore.kernel.org/r/20230223003301.v2.1.I9719661b8eb0a73b8c416f9c26cf5bd8c0563f99@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>

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
 

