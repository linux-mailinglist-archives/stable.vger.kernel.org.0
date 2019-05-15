Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD061EFA1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfEOLdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733176AbfEOLdU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2965D2084A;
        Wed, 15 May 2019 11:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919999;
        bh=U+bVO08RSkFhXJCb1d6WIQYF9KG8SlPWxmTuRrDvIx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0tYWMNXAOBKku63FGGQxvK3vopt2wbyvIghiU6enAzbCoW5Tcn3/teUYCFXwErWz
         PYsoFVb381RaK+I2HNt+ddz38AJv4GUHcE78IdfLJIK/bhrWijnILpol7KRmpwh92p
         pxt/2zkcmvFEkUoQhcnzpL+cGPwdblVe7zaufnf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Rock <linux@roeck-us.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.1 04/46] hwmon: (pwm-fan) Disable PWM if fetching cooling data fails
Date:   Wed, 15 May 2019 12:56:28 +0200
Message-Id: <20190515090619.129811625@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit 53f1647da3e8fb3e89066798f0fdc045064d353d upstream.

In case pwm_fan_of_get_cooling_data() fails we should disable the PWM
just like in the other error cases.

Fixes: 2e5219c77183 ("hwmon: (pwm-fan) Read PWM FAN configuration from device tree")
Cc: <stable@vger.kernel.org> # 4.14+
Reported-by: Guenter Rock <linux@roeck-us.net>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/pwm-fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -271,7 +271,7 @@ static int pwm_fan_probe(struct platform
 
 	ret = pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
 	if (ret)
-		return ret;
+		goto err_pwm_disable;
 
 	ctx->pwm_fan_state = ctx->pwm_fan_max_state;
 	if (IS_ENABLED(CONFIG_THERMAL)) {


