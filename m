Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CA21F065
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfEOL06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbfEOL06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29355206BF;
        Wed, 15 May 2019 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919617;
        bh=axUyy+CxM87Y+wbA2jQUgiogIniTnUIy1IaZLqSjRfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PixXZy7KS7/FM3Hcv4btt4vtGx+HIfF+8XK+oTHKxd22OM+yQgW/WKTUYvIJ+t20x
         KO6wYDEhMlxcECiZbJY9Nr4h8j73+DBzPcrCDpFl5eO5nBTw7Sub82OJEDDnY1ECIb
         80rPwmqJF3+3C1saWFCu+f78ahDf3jaiZFFY/fLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Rock <linux@roeck-us.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.0 005/137] hwmon: (pwm-fan) Disable PWM if fetching cooling data fails
Date:   Wed, 15 May 2019 12:54:46 +0200
Message-Id: <20190515090652.767781171@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
@@ -254,7 +254,7 @@ static int pwm_fan_probe(struct platform
 
 	ret = pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
 	if (ret)
-		return ret;
+		goto err_pwm_disable;
 
 	ctx->pwm_fan_state = ctx->pwm_fan_max_state;
 	if (IS_ENABLED(CONFIG_THERMAL)) {


