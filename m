Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273CD1133BA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfLDSKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731191AbfLDSKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:10:04 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B610420862;
        Wed,  4 Dec 2019 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483004;
        bh=0i8+MroQvcCp4W7iTdzxkMdymi9RZSRFAFVF573fmOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufmD8gjFGFpoAyWlwo8ed4fQk8BqZSWWdjgSl/VS0Blgb4pzLi0VP3PjNlBW1ANFA
         lqSrbkB6qZviq146LLK+Zp671j88pjjNOmsCPMKUJyI3akGwoWctBIQrMb9g0DB/OM
         Hu5MapLsCJGSkvyHpRWgNpEJ6n8AmkoMjmQo3LTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/125] pwm: bcm-iproc: Prevent unloading the driver module while in use
Date:   Wed,  4 Dec 2019 18:55:18 +0100
Message-Id: <20191204175315.380871425@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 24906a41eecb73d51974ade0847c21e429beec60 ]

The owner member of struct pwm_ops must be set to THIS_MODULE to
increase the reference count of the module such that the module cannot
be removed while its code is in use.

Fixes: daa5abc41c80 ("pwm: Add support for Broadcom iProc PWM controller")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-bcm-iproc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-bcm-iproc.c b/drivers/pwm/pwm-bcm-iproc.c
index d961a8207b1cb..31b01035d0ab3 100644
--- a/drivers/pwm/pwm-bcm-iproc.c
+++ b/drivers/pwm/pwm-bcm-iproc.c
@@ -187,6 +187,7 @@ static int iproc_pwmc_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 static const struct pwm_ops iproc_pwm_ops = {
 	.apply = iproc_pwmc_apply,
 	.get_state = iproc_pwmc_get_state,
+	.owner = THIS_MODULE,
 };
 
 static int iproc_pwmc_probe(struct platform_device *pdev)
-- 
2.20.1



