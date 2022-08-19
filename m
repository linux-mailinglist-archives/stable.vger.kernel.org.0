Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A629D59A0A1
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351304AbiHSQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351091AbiHSQDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA9E10B529;
        Fri, 19 Aug 2022 08:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8522C61746;
        Fri, 19 Aug 2022 15:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F1EC4347C;
        Fri, 19 Aug 2022 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924475;
        bh=0ibeVoMhvWjiXTa33v0eEbyr8ffsBjbSPN74AUThmvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/C9CFk2l4uXVB0wHdDqN7TDKFwmKLCC8IKwAsh1zgondeTYOfTaZp/w0AgtquND7
         YBHcjCgr7n0YMKBlRQ83qY5LG68+xPokwWuR+scAr3eE6DR7SdBEhogel6RU/Ukki4
         hCOW/oJBrbbw9HTrKrBkt6wmqerSHN3Inz6DpI4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/545] pwm: sifive: Dont check the return code of pwmchip_remove()
Date:   Fri, 19 Aug 2022 17:38:42 +0200
Message-Id: <20220819153836.132954723@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ceb2c2842f3664dcc4e6d8cb317e1e83bb81b1e5 ]

pwmchip_remove() returns always 0. Don't use the value to make it
possible to eventually change the function to return void. Also the
driver core ignores the return value of pwm_sifive_remove().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 2485fbaaead2..8c6de4f41076 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -296,7 +296,7 @@ static int pwm_sifive_remove(struct platform_device *dev)
 	struct pwm_sifive_ddata *ddata = platform_get_drvdata(dev);
 	bool is_enabled = false;
 	struct pwm_device *pwm;
-	int ret, ch;
+	int ch;
 
 	for (ch = 0; ch < ddata->chip.npwm; ch++) {
 		pwm = &ddata->chip.pwms[ch];
@@ -309,10 +309,10 @@ static int pwm_sifive_remove(struct platform_device *dev)
 		clk_disable(ddata->clk);
 
 	clk_disable_unprepare(ddata->clk);
-	ret = pwmchip_remove(&ddata->chip);
+	pwmchip_remove(&ddata->chip);
 	clk_notifier_unregister(ddata->clk, &ddata->notifier);
 
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id pwm_sifive_of_match[] = {
-- 
2.35.1



