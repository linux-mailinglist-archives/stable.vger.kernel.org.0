Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06AD2472893
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhLMKOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbhLMJ4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 264E2B80E0E;
        Mon, 13 Dec 2021 09:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E9CC34601;
        Mon, 13 Dec 2021 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389408;
        bh=q/g2Tpqr2HD7SG3QRn90XXMDonOPjVTipNNCkFyreNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kffS3rAtlGzKIeJWLeh5hxrkMoGAQLKvGAfEkSTrZ5tyUqIULUCz3yVR0jzklVX61
         E7PClz74uq0jgDdfOd7y5kv7cPRLU7oGMVXckwTFug3tkLZ9ve2ALzKbKshtMBGNh4
         lVwvYP950xITtNmJFhoBo1qvJxKFs/eLmRAPLW6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Billy Tsai <billy_tsai@aspeedtech.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 088/171] hwmon: (pwm-fan) Ensure the fan going on in .probe()
Date:   Mon, 13 Dec 2021 10:30:03 +0100
Message-Id: <20211213092948.017032764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit a2ca752055edd39be38b887e264d3de7ca2bc1bb upstream.

Before commit 86585c61972f ("hwmon: (pwm-fan) stop using legacy
PWM functions and some cleanups") pwm_apply_state() was called
unconditionally in pwm_fan_probe(). In this commit this direct
call was replaced by a call to __set_pwm(ct, MAX_PWM) which
however is a noop if ctx->pwm_value already matches the value to
set.
After probe the fan is supposed to run at full speed, and the
internal driver state suggests it does, but this isn't asserted
and depending on bootloader and pwm low-level driver, the fan
might just be off.
So drop setting pwm_value to MAX_PWM to ensure the check in
__set_pwm doesn't make it exit early and the fan goes on as
intended.

Cc: stable@vger.kernel.org
Fixes: 86585c61972f ("hwmon: (pwm-fan) stop using legacy PWM functions and some cleanups")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211130092212.17783-1-billy_tsai@aspeedtech.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pwm-fan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -336,8 +336,6 @@ static int pwm_fan_probe(struct platform
 			return ret;
 	}
 
-	ctx->pwm_value = MAX_PWM;
-
 	pwm_init_state(ctx->pwm, &ctx->pwm_state);
 
 	/*


