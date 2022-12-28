Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D6A657D4F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbiL1PmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiL1Pl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:41:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C11758D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B38561542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E70C433D2;
        Wed, 28 Dec 2022 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242102;
        bh=8gypTo4tBvMCAZOXNMPC20/u583//DgZMWMdaTCx5xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zk58csRRTrfAU2uZPnu+sHa5XZPShGS3NKUpt+Eq+kG3E84KVMVuqJLXCkp+myQQM
         5jaA8h7WE9FLM+xpB6tWFaNcRPxeaUUeFpctbEJvJWIdZIkWFJ/V1T63mR6lunWASy
         IEyEDK/e93amiPkrUfTrRm8mRjfBPSNyAVXc35BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/731] pwm: sifive: Call pwm_sifive_update_clock() while mutex is held
Date:   Wed, 28 Dec 2022 15:41:10 +0100
Message-Id: <20221228144312.882144587@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 45558b3abb87eeb2cedb8a59cb2699c120b5102a ]

As was documented in commit 0f02f491b786 ("pwm: sifive: Reduce time the
controller lock is held") a caller of pwm_sifive_update_clock() must
hold the mutex. So fix pwm_sifive_clock_notifier() to grab the lock.

While this necessity was only documented later, the race exists since
the driver was introduced.

Fixes: 9e37a53eb051 ("pwm: sifive: Add a driver for SiFive SoC PWM")
Reported-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Link: https://lore.kernel.org/r/20221018061656.1428111-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-sifive.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 58347fcd4812..07e9fc58354f 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -217,8 +217,11 @@ static int pwm_sifive_clock_notifier(struct notifier_block *nb,
 	struct pwm_sifive_ddata *ddata =
 		container_of(nb, struct pwm_sifive_ddata, notifier);
 
-	if (event == POST_RATE_CHANGE)
+	if (event == POST_RATE_CHANGE) {
+		mutex_lock(&ddata->lock);
 		pwm_sifive_update_clock(ddata, ndata->new_rate);
+		mutex_unlock(&ddata->lock);
+	}
 
 	return NOTIFY_OK;
 }
-- 
2.35.1



