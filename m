Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811F12010C9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393557AbgFSPdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404915AbgFSPdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:33:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EAE920786;
        Fri, 19 Jun 2020 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580784;
        bh=9bceEJ9pJZhQjQluZuGetqYQXAYC7KXWl/AlOJEesNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1um2GMFMKAs7kOUqHyHkyaTaDaClE/iI7jyH6sHIyvzuo0b7zMFKlOp00MZFRRky
         PH5iTi5dX6NFwloMt+pWM81/xf+c0HqgRHgdKLB1durV1kar4r/2hbGv3Zf+uhBzyu
         GoC/hp2nw4mZxgQwheOYoA6NmH4PNP9qEs+jncqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.7 351/376] pwm: jz4740: Enhance precision in calculation of duty cycle
Date:   Fri, 19 Jun 2020 16:34:29 +0200
Message-Id: <20200619141726.940210748@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9017dc4fbd59c09463019ce494cfe36d654495a8 upstream.

Calculating the hardware value for the duty from the hardware value of
the period resulted in a precision loss versus calculating it from the
clock rate directly.

(Also remove a cast that doesn't really need to be here)

Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
Cc: <stable@vger.kernel.org>
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/pwm-jz4740.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -158,11 +158,11 @@ static int jz4740_pwm_apply(struct pwm_c
 	/* Calculate period value */
 	tmp = (unsigned long long)rate * state->period;
 	do_div(tmp, NSEC_PER_SEC);
-	period = (unsigned long)tmp;
+	period = tmp;
 
 	/* Calculate duty value */
-	tmp = (unsigned long long)period * state->duty_cycle;
-	do_div(tmp, state->period);
+	tmp = (unsigned long long)rate * state->duty_cycle;
+	do_div(tmp, NSEC_PER_SEC);
 	duty = period - tmp;
 
 	if (duty >= period)


