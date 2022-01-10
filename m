Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C344892CF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbiAJHvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241344AbiAJHlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEC3C033278;
        Sun,  9 Jan 2022 23:34:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D55EB81201;
        Mon, 10 Jan 2022 07:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD9EC36AED;
        Mon, 10 Jan 2022 07:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800086;
        bh=8wjOwa4D01rmIjZQtarB7Bx2PnNYdpk5SUwRRUGxoMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLuVgkGfI1mmczosuCrsnMBIomJ0vYhNhoMyObFEOHWaclMg532kkJW2aiVh6mkFF
         WEA4aqzimIpEKqWBDHnIsBpNaROEHy8t2QSX6Y5GJt3DFXq6p8XgJu0dnZZhbnfTXf
         dC4B7p9ABli9QCU6jPDlVOqYV3b+Z4pIBYSqCE2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 42/72] power: reset: ltc2952: Fix use of floating point literals
Date:   Mon, 10 Jan 2022 08:23:19 +0100
Message-Id: <20220110071822.983678521@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
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
@@ -161,8 +161,8 @@ static void ltc2952_poweroff_kill(void)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
-	data->wde_interval = 300L * 1E6L;
-	data->trigger_delay = ktime_set(2, 500L*1E6L);
+	data->wde_interval = 300L * NSEC_PER_MSEC;
+	data->trigger_delay = ktime_set(2, 500L * NSEC_PER_MSEC);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;


