Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B6C159D9
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfEGFka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbfEGFk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F12FB20675;
        Tue,  7 May 2019 05:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207628;
        bh=VRtGhhfvENSk8MY3OOpOVHVA92UpWAu95L5vA/T4aGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfCLMjBfimSrl+6hRlsICl8+sTs8uGacnlQdSRvhKdM+kULeMJPYCeSKk9B/mrneO
         58eD0ZUs6jH6A1HILb2cd0797yM9+lNvWmyQzGmdMusVQSMUtD2TcxREZWKy2WgWVB
         fwbeSCFremyK7eijYM+Y4RbYeOLLhoocs8CAcMA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-leds@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 66/95] leds: pwm: silently error out on EPROBE_DEFER
Date:   Tue,  7 May 2019 01:37:55 -0400
Message-Id: <20190507053826.31622-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 9aec30371fb095a0c9415f3f0146ae269c3713d8 ]

When probing, if we fail to get the pwm due to probe deferal, we shouldn't
print an error message. Just be silent in this case.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/leds/leds-pwm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 8d456dc6c5bf..83f9bbe57e02 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -101,8 +101,9 @@ static int led_pwm_add(struct device *dev, struct led_pwm_priv *priv,
 		led_data->pwm = devm_pwm_get(dev, led->name);
 	if (IS_ERR(led_data->pwm)) {
 		ret = PTR_ERR(led_data->pwm);
-		dev_err(dev, "unable to request PWM for %s: %d\n",
-			led->name, ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "unable to request PWM for %s: %d\n",
+				led->name, ret);
 		return ret;
 	}
 
-- 
2.20.1

