Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEA848896D
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbiAIMv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 07:51:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34428 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbiAIMv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 07:51:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05F0460EFA
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 12:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D724AC36AED;
        Sun,  9 Jan 2022 12:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641732716;
        bh=JKohEbg8NfEtEe3ccKdU5hWGLjTw/+xwej0dOFoADuE=;
        h=Subject:To:Cc:From:Date:From;
        b=x2fcnfQNGQu3p+UcrR2SDXVvcDmbQ6kw8qMYUU8MXEK+gh0dtxbzdhdhERBXm6At3
         Dfy/Wzq0adNN9mL9z+6s74Ij//ewC2ptBW0UNkHtjO0DacWTJG1TvZe1qDwv5UAE9k
         eUmy4ZaghrThprV+qT4N7WMWA6yRTzkG5YfRDwQw=
Subject: FAILED: patch "[PATCH] power: reset: ltc2952: Fix use of floating point literals" failed to apply to 4.9-stable tree
To:     nathan@kernel.org, ndesaulniers@google.com,
        sebastian.reichel@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jan 2022 13:51:45 +0100
Message-ID: <164173270519248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 644106cdb89844be2496b21175b7c0c2e0fab381 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 5 Nov 2021 08:20:50 -0700
Subject: [PATCH] power: reset: ltc2952: Fix use of floating point literals

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

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index fbb344353fe4..65d9528cc989 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -159,8 +159,8 @@ static void ltc2952_poweroff_kill(void)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
-	data->wde_interval = 300L * 1E6L;
-	data->trigger_delay = ktime_set(2, 500L*1E6L);
+	data->wde_interval = 300L * NSEC_PER_MSEC;
+	data->trigger_delay = ktime_set(2, 500L * NSEC_PER_MSEC);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;

