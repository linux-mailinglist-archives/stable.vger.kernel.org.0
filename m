Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A506EBA1B
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDVP7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 11:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDVP7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 11:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF0810EA
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 08:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBD5E61044
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFFBC433D2;
        Sat, 22 Apr 2023 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682179186;
        bh=VNt1AQOI1F9iDZ8xtBkX7WdZwUlT+cc0IBZRvr0Neb0=;
        h=Subject:To:Cc:From:Date:From;
        b=gWGCBSIvriu9pY/f/hxh2UuhC/Hybv+E+77+fFmSzyXZk/LMDitJ8xMUm3FYin7OJ
         Rp5M4SVnCLlqEUhREx816ALo4ATtkUiuALur+PbICuyZaBHzYlGX6PdCUGiR9hubzV
         ySFToAkWsocZWl6U9tq9XXoinPwKNuyN22Fsr1UM=
Subject: FAILED: patch "[PATCH] pwm: meson: Explicitly set .polarity in .get_state()" failed to apply to 5.10-stable tree
To:     u.kleine-koenig@pengutronix.de, kamatam@amazon.com,
        martin.blumenstingl@googlemail.com, thierry.reding@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 17:59:42 +0200
Message-ID: <2023042242-unsaved-sanded-d4c1@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 8caa81eb950cb2e9d2d6959b37d853162d197f57
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042242-unsaved-sanded-d4c1@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

8caa81eb950c ("pwm: meson: Explicitly set .polarity in .get_state()")
6c452cff79f8 ("pwm: Make .get_state() callback return an error code")
8eca6b0a647a ("Merge tag 'pwm/for-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8caa81eb950cb2e9d2d6959b37d853162d197f57 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Date: Wed, 22 Mar 2023 22:45:44 +0100
Subject: [PATCH] pwm: meson: Explicitly set .polarity in .get_state()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The driver only supports normal polarity. Complete the implementation of
.get_state() by setting .polarity accordingly.

This fixes a regression that was possible since commit c73a3107624d
("pwm: Handle .get_state() failures") which stopped to zero-initialize
the state passed to the .get_state() callback. This was reported at
https://forum.odroid.com/viewtopic.php?f=177&t=46360 . While this was an
unintended side effect, the real issue is the driver's callback not
setting the polarity.

There is a complicating fact, that the .apply() callback fakes support
for inversed polarity. This is not (and cannot) be matched by
.get_state(). As fixing this isn't easy, only point it out in a comment
to prevent authors of other drivers from copying that approach.

Fixes: c375bcbaabdb ("pwm: meson: Read the full hardware state in meson_pwm_get_state()")
Reported-by: Munehisa Kamata <kamatam@amazon.com>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230310191405.2606296-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 16d79ca5d8f5..5cd7b90872c6 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -162,6 +162,12 @@ static int meson_pwm_calc(struct meson_pwm *meson, struct pwm_device *pwm,
 	duty = state->duty_cycle;
 	period = state->period;
 
+	/*
+	 * Note this is wrong. The result is an output wave that isn't really
+	 * inverted and so is wrongly identified by .get_state as normal.
+	 * Fixing this needs some care however as some machines might rely on
+	 * this.
+	 */
 	if (state->polarity == PWM_POLARITY_INVERSED)
 		duty = period - duty;
 
@@ -358,6 +364,8 @@ static int meson_pwm_get_state(struct pwm_chip *chip, struct pwm_device *pwm,
 		state->duty_cycle = 0;
 	}
 
+	state->polarity = PWM_POLARITY_NORMAL;
+
 	return 0;
 }
 

