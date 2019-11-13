Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E5AFA255
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfKMCDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731074AbfKMCCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:02:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 746BD222CA;
        Wed, 13 Nov 2019 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610568;
        bh=laoqNmJBfeOHo+/xTivya8pe9YZR3Jiai/QAOQi7MCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5V/oAr+pOk2kfyTBD11dGJafpJ8ugxZmAXt7/lvVkIP75ndji8ZuAXrPoDf7Lcko
         oML9g9QSaWTVp5ngsR0rTsScGPb6NbJB4wPPK3eh2izaYBUMKaj/AYiDoatCIlhazu
         H6DXB7LXETpMtrr7qd+kU5QcOlzhnWkPTXqO7ndY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 45/48] hwmon: (pwm-fan) Silence error on probe deferral
Date:   Tue, 12 Nov 2019 21:01:28 -0500
Message-Id: <20191113020131.13356-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3e23003f78b01..993c61e95d30c 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -227,8 +227,12 @@ static int pwm_fan_probe(struct platform_device *pdev)
 
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

