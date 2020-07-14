Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A196221FC03
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgGNSx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730628AbgGNSxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:53:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B54C207F5;
        Tue, 14 Jul 2020 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752803;
        bh=Y0ZL7fYwpv1P8Ccuhgv3GoEXJWVonj3eDP4lzZJ/Lk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXiT6Y0zNF1KYTGxw/r538+S1SsiJB8MPJho3KrB6uNDYkpPHfLe77W4p0/oW3rwm
         xpMpEgk1hFpHVOwhjKKkCM2mp8v92D/wUZWJm7ppFZrocLw9ihV9ezEW1V8Guz9mnT
         JySeO/QF7kHbLnTzz5PgU4Vejwfm+jkT7QuTPVEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 5.4 109/109] pwm: jz4740: Fix build failure
Date:   Tue, 14 Jul 2020 20:44:52 +0200
Message-Id: <20200714184110.775627425@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>

When commit 9017dc4fbd59 ("pwm: jz4740: Enhance precision in calculation
of duty cycle") from v5.8-rc1 was backported to v5.4.x its dependency on
commit ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver") was not
noticed which made the pwm-jz4740 driver fail to build.

As ce1f9cece057 depends on still more rework, just backport a small part
of this commit to make the driver build again. (There is no dependency
on the functionality introduced in ce1f9cece057, just the rate variable
is needed.)

Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/pwm-jz4740.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -92,11 +92,12 @@ static int jz4740_pwm_apply(struct pwm_c
 {
 	struct jz4740_pwm_chip *jz4740 = to_jz4740(pwm->chip);
 	unsigned long long tmp;
-	unsigned long period, duty;
+	unsigned long rate, period, duty;
 	unsigned int prescaler = 0;
 	uint16_t ctrl;
 
-	tmp = (unsigned long long)clk_get_rate(jz4740->clk) * state->period;
+	rate = clk_get_rate(jz4740->clk);
+	tmp = rate * state->period;
 	do_div(tmp, 1000000000);
 	period = tmp;
 


