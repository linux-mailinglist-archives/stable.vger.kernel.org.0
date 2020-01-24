Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF92148169
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390638AbgAXLTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390815AbgAXLTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:19:49 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6264F20704;
        Fri, 24 Jan 2020 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864789;
        bh=d1Y6AofPruRXrSv/a9jGNOQlif0Iswy0LImDpSb7NOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfShe4oqGdQ2Qw0g6OxKHMWTdS/8jN8GfIoWGvu3Kc5jm+NtEM+RVqeZtJ4MrNIhJ
         EmrlKtyJ2jbCEOdKk2kG6H701s3TwjieOAomulT96bZRUNXHwmlOEUus7Le8Td7ctX
         0YYo14qRaC5rde3OmssVd8EOYBD7Str9/hrMvAc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bichao Zheng <bichao.zheng@amlogic.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 366/639] pwm: meson: Dont disable PWM when setting duty repeatedly
Date:   Fri, 24 Jan 2020 10:28:56 +0100
Message-Id: <20200124093132.940603398@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bichao Zheng <bichao.zheng@amlogic.com>

[ Upstream commit a279345807e1e0ae79567a52cfdd9d30c9174a3c ]

There is an abnormally low about 20ms,when setting duty repeatedly.
Because setting the duty will disable PWM and then enable. Delete
this operation now.

Fixes: 211ed630753d2f ("pwm: Add support for Meson PWM Controller")
Signed-off-by: Bichao Zheng <bichao.zheng@amlogic.com>
[ Dropped code instead of hiding it behind a comment ]
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 4b708c1fcb1d2..e247ab632530b 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -325,11 +325,6 @@ static int meson_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (state->period != channel->state.period ||
 	    state->duty_cycle != channel->state.duty_cycle ||
 	    state->polarity != channel->state.polarity) {
-		if (channel->state.enabled) {
-			meson_pwm_disable(meson, pwm->hwpwm);
-			channel->state.enabled = false;
-		}
-
 		if (state->polarity != channel->state.polarity) {
 			if (state->polarity == PWM_POLARITY_NORMAL)
 				meson->inverter_mask |= BIT(pwm->hwpwm);
-- 
2.20.1



