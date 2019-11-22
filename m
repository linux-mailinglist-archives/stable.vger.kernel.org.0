Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C37B106550
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKVGXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:23:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfKVFvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3D22084B;
        Fri, 22 Nov 2019 05:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401906;
        bh=wLBO30qA8tZlK3OT5pGv0t3ty/ImslmbiEW2j4YjAG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whG7Unw2khm4vsQGruMSNnnN9ip2QKc2bDjZIDciYvnUH9I/GUhys5MmkEYbuNU7W
         Jj2u1AmMPEF2K86kDHj5104ENFtXWcEZBOW4I85qSMkM0QphBY4L10HRHwnUs/jgT/
         ZT6qjJihRQPq2VU/UnSvwjrXiA6maa66LqBCiDQE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shiyan <shc_work@mail.ru>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 137/219] pwm: clps711x: Fix period calculation
Date:   Fri, 22 Nov 2019 00:47:49 -0500
Message-Id: <20191122054911.1750-130-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

[ Upstream commit b0f17570b8203c22f139459c86cfbaa0311313ed ]

Commit e39c0df1be5a ("pwm: Introduce the pwm_args concept") has
changed the variable for the period for clps711x-pwm driver, so now
pwm_get/set_period() works with pwm->state.period variable instead
of pwm->args.period.
This patch changes the period variable in other places where it is used.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-clps711x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-clps711x.c b/drivers/pwm/pwm-clps711x.c
index 26ec24e457b12..7e16b7def0dcb 100644
--- a/drivers/pwm/pwm-clps711x.c
+++ b/drivers/pwm/pwm-clps711x.c
@@ -48,7 +48,7 @@ static void clps711x_pwm_update_val(struct clps711x_chip *priv, u32 n, u32 v)
 static unsigned int clps711x_get_duty(struct pwm_device *pwm, unsigned int v)
 {
 	/* Duty cycle 0..15 max */
-	return DIV_ROUND_CLOSEST(v * 0xf, pwm_get_period(pwm));
+	return DIV_ROUND_CLOSEST(v * 0xf, pwm->args.period);
 }
 
 static int clps711x_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
@@ -71,7 +71,7 @@ static int clps711x_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct clps711x_chip *priv = to_clps711x_chip(chip);
 	unsigned int duty;
 
-	if (period_ns != pwm_get_period(pwm))
+	if (period_ns != pwm->args.period)
 		return -EINVAL;
 
 	duty = clps711x_get_duty(pwm, duty_ns);
-- 
2.20.1

