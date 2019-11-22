Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65912106AC8
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfKVKiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:38:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbfKVKiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:38:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC99420715;
        Fri, 22 Nov 2019 10:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419097;
        bh=laoqNmJBfeOHo+/xTivya8pe9YZR3Jiai/QAOQi7MCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjfNy5CCo6FPhwWERYRmQ+32QSAHuLQcP+PFYrh+bY3TqIh4M/zuCWRpQWW6Rkjc1
         7RxAyJGF0s9MYecVLUND7+A6uL4Lc+c8niG3J9ypZJx2IYoV37XLss5+9L0ZS9vK4G
         RrzBA03oE8VyFQDPNX8c66H869V2VGMI/mkQ+dzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 155/159] hwmon: (pwm-fan) Silence error on probe deferral
Date:   Fri, 22 Nov 2019 11:29:06 +0100
Message-Id: <20191122100848.393906397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
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



