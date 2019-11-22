Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FC1106CC5
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfKVKys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbfKVKyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56AE320715;
        Fri, 22 Nov 2019 10:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420085;
        bh=FJ+VnI9oZcBnhezxFHAHzk3I2B2oWQZz95RSyzMIKtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJkUzGv7O4UhOcPUkWYZ93VWnpXuKKwILSF2H6c8qafEiGml9eU+CbbSgDachtUP6
         zd4nEwJ4Vc6Q/dIw4nXdvCOpVTrr2A+KrdpF/mqgGUDeWHOkkYObZGsBqs3jyJ8Qc5
         h2R/yUaB8vUw9122SgboSSSORyKNybubUo5JoMpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 110/122] hwmon: (pwm-fan) Silence error on probe deferral
Date:   Fri, 22 Nov 2019 11:29:23 +0100
Message-Id: <20191122100833.920373569@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 9f67f7583e77fe5dc57aab3a6159c2642544eaad ]

Probe deferrals aren't actual errors, so silence the error message in
case the PWM cannot yet be acquired.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pwm-fan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 6d30bec04f2d8..f981da686d7eb 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -221,8 +221,12 @@ static int pwm_fan_probe(struct platform_device *pdev)
 
 	ctx->pwm = devm_of_pwm_get(&pdev->dev, pdev->dev.of_node, NULL);
 	if (IS_ERR(ctx->pwm)) {
-		dev_err(&pdev->dev, "Could not get PWM\n");
-		return PTR_ERR(ctx->pwm);
+		ret = PTR_ERR(ctx->pwm);
+
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Could not get PWM: %d\n", ret);
+
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, ctx);
-- 
2.20.1



