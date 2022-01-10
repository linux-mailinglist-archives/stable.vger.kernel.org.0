Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6213D4891AC
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiAJHe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239401AbiAJHc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D86EC03325A;
        Sun,  9 Jan 2022 23:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF0A611B7;
        Mon, 10 Jan 2022 07:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E948BC36AE9;
        Mon, 10 Jan 2022 07:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799715;
        bh=lqWkFxXzeHiiWiphwCk/OALmbWCz2eduk0uhpTPGqAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHhf3Q1OIhlFYXFVFL8O2/j8cAmOXb8aVVakr/63it7CAscLS6BlMln8DVeNXRNwM
         vLg7WbD6oBPdaKUjdz6PpauvNIUDJDccuClYWXwXunhSD6jX8gkKvnXcAetVjSZxZx
         q2qf5GMEzK6m5TykWmsnrbLrhhMXwVYBuqU/Pm10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.4 24/34] power: reset: ltc2952: Fix use of floating point literals
Date:   Mon, 10 Jan 2022 08:23:19 +0100
Message-Id: <20220110071816.473962166@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/reset/ltc2952-poweroff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -160,8 +160,8 @@ static void ltc2952_poweroff_kill(void)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
-	data->wde_interval = 300L * 1E6L;
-	data->trigger_delay = ktime_set(2, 500L*1E6L);
+	data->wde_interval = 300L * NSEC_PER_MSEC;
+	data->trigger_delay = ktime_set(2, 500L * NSEC_PER_MSEC);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;


