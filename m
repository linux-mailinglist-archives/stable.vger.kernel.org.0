Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B95FA131
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfKMBzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbfKMBzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634CE22467;
        Wed, 13 Nov 2019 01:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610144;
        bh=42AfC1JAgQnwGHw73JvEkXmD6v+DlYzI2SFaT4NhMX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOKwxobf8gDiT56cErABRFY/qCyuwsPb6WvxO/9gqKEi3sSo0zee1hPYRJiQjQE6B
         FREzTEr7TdJH2YijYk6X9QgSHfcxgJEDzlRrc9IvPa9kWnrYVTjftgWfvNOpAgIc93
         j/XNYFGAi837xjQdJVNDCH71kLvDKPGYE7CjHpoI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 190/209] hwmon: (pwm-fan) Silence error on probe deferral
Date:   Tue, 12 Nov 2019 20:50:06 -0500
Message-Id: <20191113015025.9685-190-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
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
index 7f01fad0d3e34..65de80bd63d8c 100644
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

