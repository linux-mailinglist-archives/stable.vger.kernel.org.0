Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6EA1F194
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfEOLPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbfEOLPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805102084E;
        Wed, 15 May 2019 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918954;
        bh=bm66xKRLhd7zHtRL+0BEHuLQckw6arjnAi9uTkJzrAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDgesOMj3O+H4leA8YDYwYUsSFPOXIt6q3fzvAC7A9qp62S1N2i+ieA9k7tlk3dj7
         AoUjAbpO4byuKkRDc4I/PsKTBL/8KdKCGDAzXchW119AffS6UbU41nzE7j41y8bLqQ
         4ZQIkK9BLjlmT613oz+neRnYIX+f2/NhshOmDEr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Rock <linux@roeck-us.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 4.14 004/115] hwmon: (pwm-fan) Disable PWM if fetching cooling data fails
Date:   Wed, 15 May 2019 12:54:44 +0200
Message-Id: <20190515090659.522849691@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
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
@@ -250,7 +250,7 @@ static int pwm_fan_probe(struct platform
 
 	ret = pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
 	if (ret)
-		return ret;
+		goto err_pwm_disable;
 
 	ctx->pwm_fan_state = ctx->pwm_fan_max_state;
 	if (IS_ENABLED(CONFIG_THERMAL)) {


