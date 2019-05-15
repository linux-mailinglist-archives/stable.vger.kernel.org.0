Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0341F1C5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbfEOLSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfEOLSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0EE20818;
        Wed, 15 May 2019 11:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919103;
        bh=9pxoIVvjNsBDldV32JMr5wQ/d626a0NhDAPvv9DCx4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCm4xC2Il3XEYaR3dyUCjyszwzI+gYtovbAVwLh4PKropZgdAlkhrbKVRyWXrm7GC
         eFOuhKacbhWIU9bOC4Y3/HUn3xL2v/NaL6f3BwK8QIptf+sQfUhZm2n1ECc3m0wbp7
         h9gIuZR+X+Nd4NwMIJj0kU+rbfaS6SkvFYq6sNFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 069/115] leds: pwm: silently error out on EPROBE_DEFER
Date:   Wed, 15 May 2019 12:55:49 +0200
Message-Id: <20190515090704.494207874@linuxfoundation.org>
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
index 8d456dc6c5bfe..83f9bbe57e02b 100644
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



