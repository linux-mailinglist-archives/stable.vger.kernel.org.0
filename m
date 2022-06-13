Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6303F54890F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354400AbiFMLca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354644AbiFML3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834B029CBF;
        Mon, 13 Jun 2022 03:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 341D3B80D3C;
        Mon, 13 Jun 2022 10:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952A5C34114;
        Mon, 13 Jun 2022 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117115;
        bh=whWcgIcAKow3MItdKC2ltqT2clk6qkQ3/wx3WuEen0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8oNyXh8GbvuODC5kkcuybNrMeZ75WLFXAPhxrGcJXDcs/P0Ru1bklNkLD95K0u/9
         Eqhuer5eqyJryqRyyA7FW5RsWuqb6/lgis1QnGp4Cjlr563BZeCGJs7yNLtTCmCMnZ
         Iqduovo4KlL56gvCYTXv45SM8y5RhUtK83f7VwlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/411] pwm: lp3943: Fix duty calculation in case period was clamped
Date:   Mon, 13 Jun 2022 12:09:25 +0200
Message-Id: <20220613094937.514737141@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index bf3f14fb5f24..05e4120fd702 100644
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



