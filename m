Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7926ECD47
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjDXNWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjDXNVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85545526C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6543162232
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DA6C4339C;
        Mon, 24 Apr 2023 13:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342499;
        bh=tBkSnrIt2m+7p4Ir4G2Vb3DYBKgIS58O0gdBptIAb1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOqRFZIicFvodb2pWBJot1AYjGomUJWNRqJipnEIbKbXwDqv4DadfEVqlCjfmnFby
         hVvQ1ABXaqn4mfjbTlnalewvKE7SNX4uFkuKCFYxi5aPS+34ZJIavNNj47PEEGwuqv
         czHoLHrPXNywINvkZ6gtNIr1djrd1IjtDhFIWjNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Munehisa Kamata <kamatam@amazon.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.15 63/73] pwm: meson: Explicitly set .polarity in .get_state()
Date:   Mon, 24 Apr 2023 15:17:17 +0200
Message-Id: <20230424131131.404088824@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 8caa81eb950cb2e9d2d6959b37d853162d197f57 upstream.

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
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-meson.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -168,6 +168,12 @@ static int meson_pwm_calc(struct meson_p
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
 
@@ -366,6 +372,7 @@ static void meson_pwm_get_state(struct p
 		state->period = 0;
 		state->duty_cycle = 0;
 	}
+	state->polarity = PWM_POLARITY_NORMAL;
 }
 
 static const struct pwm_ops meson_pwm_ops = {


