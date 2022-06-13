Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4DC549787
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377294AbiFMNcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377870AbiFMNaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEA66E8FF;
        Mon, 13 Jun 2022 04:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E26A36114A;
        Mon, 13 Jun 2022 11:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF36DC34114;
        Mon, 13 Jun 2022 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119512;
        bh=EO27XRrZvZM3OEMGUga+8QfaUgSMH/01Y5OujwF83w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LvSD2U71Rw5/tj/JgcNtr+3cmz3ROuRoeteHSQRpHzQyZIjl2QNgg8xRQfZRVLiA
         J88ELMCOtJXck7X8Os1O2dGNXGh1zoHyNSNLXh1195OZ1jp3cLLwMNjAUpTlHoTGft
         ulWcI/81Xw5JttKbNw3B/5jhjIWqVGnF/UQxSHTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 022/339] pwm: lp3943: Fix duty calculation in case period was clamped
Date:   Mon, 13 Jun 2022 12:07:27 +0200
Message-Id: <20220613094927.181585995@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5e3b07ca5cc78cd4a987e78446849e41288d87cb ]

The hardware only supports periods <= 1.6 ms and if a bigger period is
requested it is clamped to 1.6 ms. In this case duty_cycle might be bigger
than 1.6 ms and then the duty cycle register is written with a value
bigger than LP3943_MAX_DUTY. So clamp duty_cycle accordingly.

Fixes: af66b3c0934e ("pwm: Add LP3943 PWM driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-lp3943.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index ea17d446a627..2bd04ecb508c 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -125,6 +125,7 @@ static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (err)
 		return err;
 
+	duty_ns = min(duty_ns, period_ns);
 	val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
 
 	return lp3943_write_byte(lp3943, reg_duty, val);
-- 
2.35.1



