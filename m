Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B896582FE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiL1Qn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiL1Qn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE05D1FCED
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF2A3CE1367
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3658C433EF;
        Wed, 28 Dec 2022 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245466;
        bh=Qll6mOLQd9hFyC0J26Qi2x/DiIHIBkr6XZaVbG0YleM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QuffnIUdw1CBG5D7+ZjxQzLuVqQmivpI0Fo0pCXkvOzrekRzl9ixe23dA0qs2upo
         sg8VeF8e/IU+j8byoZzr7BYfn0Qs8Gs/BAcHk+TUzHSwwEV+ggXCRhIZz9I6dBs4Gf
         xdS3ckCa7lLi2xm4/zPib4dKEkFVGpN7cGy58HIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0866/1146] pwm: sifive: Call pwm_sifive_update_clock() while mutex is held
Date:   Wed, 28 Dec 2022 15:40:05 +0100
Message-Id: <20221228144353.686192961@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 2d4fa5e5fdd4..bb7239313401 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -204,8 +204,11 @@ static int pwm_sifive_clock_notifier(struct notifier_block *nb,
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



