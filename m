Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD5531B01
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242247AbiEWRxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245138AbiEWRwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:52:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940FEA006B;
        Mon, 23 May 2022 10:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 175CECE1724;
        Mon, 23 May 2022 17:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059E7C385A9;
        Mon, 23 May 2022 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327014;
        bh=/n+vh8yEh7Z64KXc6mBpDpamZt1/u0NHLVORrNngQx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zhg2L0FOdDUvjdyZcHXEAsMsBSYKLAP4EV7xFI+tmBxxOdMlSYZkdoxj8kQJhiFrl
         WCj5PlpVH7/5SwOI0u0KcfmBWtuiXue1EGeMp1h36scXOo6DMofz4agmlj6yvSoHpz
         mNV1+ytKFWIBZdwspooxU5C/1UkjRM1vJTZdbsyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 128/158] gpio: mvebu/pwm: Refuse requests with inverted polarity
Date:   Mon, 23 May 2022 19:04:45 +0200
Message-Id: <20220523165851.783518015@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3ecb10175b1f776f076553c24e2689e42953fef5 ]

The driver doesn't take struct pwm_state::polarity into account when
configuring the hardware, so refuse requests for inverted polarity.

Fixes: 757642f9a584 ("gpio: mvebu: Add limited PWM support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index a2c8dd329b31..2db19cd640a4 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -707,6 +707,9 @@ static int mvebu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long flags;
 	unsigned int on, off;
 
+	if (state->polarity != PWM_POLARITY_NORMAL)
+		return -EINVAL;
+
 	val = (unsigned long long) mvpwm->clk_rate * state->duty_cycle;
 	do_div(val, NSEC_PER_SEC);
 	if (val > UINT_MAX + 1ULL)
-- 
2.35.1



