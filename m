Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85929488BE0
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 19:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiAIS71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 13:59:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53270 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiAIS71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 13:59:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 050BEB80DBE
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 18:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F569C36AE5;
        Sun,  9 Jan 2022 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641754764;
        bh=DppBm8cZ2h+K8X5C3GMCsiY4vJDR355qvRjzdEba1Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRw7jCtoE649jxkqgKnYZcP3mSbUWOwRLDnaH8C9kB+x5rNS4NfDpv+/rd6AaD0zl
         Jeu2jggGL69DRsBK8PT5gvHKmRkaxQM/vDBvHEqil+AYHHHySptDhctL1HG7HJH29d
         rqXWuDRcfajjzkHKKRNKLK7SBUoUwwU+3potFWw1rj9KyJ8YbnXrLrJ2RudqYNTQdW
         EPy9MLkzdfUJ4jakvYSkLBMMPg8U7ELf0agnjt8a4elNzKB1KrJPKVv+EpXOTQY3/I
         UBcBobLdy51YlPUEYV9yyFCMtVg3xWHLHNUWKhoLPlNWp3m7eaELpgscdY9AtXV4Sm
         S4LibK+ohB+GQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ndesaulniers@google.com, sebastian.reichel@collabora.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.4,4.9] power: reset: ltc2952: Fix use of floating point literals
Date:   Sun,  9 Jan 2022 11:59:02 -0700
Message-Id: <20220109185902.1097931-1-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <164173270519248@kroah.com>
References: <164173270519248@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 644106cdb89844be2496b21175b7c0c2e0fab381 upstream.

A new commit in LLVM causes an error on the use of 'long double' when
'-mno-x87' is used, which the kernel does through an alias,
'-mno-80387' (see the LLVM commit below for more details around why it
does this).

drivers/power/reset/ltc2952-poweroff.c:162:28: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
        data->wde_interval = 300L * 1E6L;
                                  ^
drivers/power/reset/ltc2952-poweroff.c:162:21: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
        data->wde_interval = 300L * 1E6L;
                           ^
drivers/power/reset/ltc2952-poweroff.c:163:41: error: expression requires  'long double' type support, but target 'x86_64-unknown-linux-gnu' does not support it
        data->trigger_delay = ktime_set(2, 500L*1E6L);
                                               ^
3 errors generated.

This happens due to the use of a 'long double' literal. The 'E6' part of
'1E6L' causes the literal to be a 'double' then the 'L' suffix promotes
it to 'long double'.

There is no visible reason for floating point values in this driver, as
the values are only assigned to integer types. Use NSEC_PER_MSEC, which
is the same integer value as '1E6L', to avoid changing functionality but
fix the error.

Fixes: 6647156c00cc ("power: reset: add LTC2952 poweroff driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1497
Link: https://github.com/llvm/llvm-project/commit/a8083d42b1c346e21623a1d36d1f0cadd7801d83
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[nathan: Resolve conflict due to lack of 8b0e195314fab]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/power/reset/ltc2952-poweroff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 15fed9d8f871..ec54cff108b3 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -169,8 +169,8 @@ static void ltc2952_poweroff_kill(void)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
-	data->wde_interval = ktime_set(0, 300L*1E6L);
-	data->trigger_delay = ktime_set(2, 500L*1E6L);
+	data->wde_interval = ktime_set(0, 300L * NSEC_PER_MSEC);
+	data->trigger_delay = ktime_set(2, 500L * NSEC_PER_MSEC);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;

base-commit: 710bf39c7aec32641ea63f6593db1df8c3e4a4d7
-- 
2.34.1

