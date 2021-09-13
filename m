Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF73409256
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245737AbhIMOKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244723AbhIMOIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9085861A88;
        Mon, 13 Sep 2021 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540443;
        bh=vQZ8aBcpON6jrIgp7vnwWUJaWfuLDh0abPyi8fIbhs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6lZ+Bs6zG2+tLYqz7Id6HmL4rq4RdxXX/4+QFZmX4pZGDtHg3SFfbwjlhqvBjnga
         yiqNoISXp5IXZJJmZ2BLnMofr1FzCgPfjnppoq5Jed16HZmRF3hlpZALmazuUu5Rnf
         P7Qz4b4wTVf+yRxpzAbgFi4I+9vMD3piD0msxBZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 163/300] leds: lgm-sso: Propagate error codes from callee to caller
Date:   Mon, 13 Sep 2021 15:13:44 +0200
Message-Id: <20210913131114.919165374@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9cbc861095375793a69858f91f3ac4e817f320f0 ]

The one of the latest change to the driver reveals the problem that
the error codes from callee aren't propagated to the caller of
__sso_led_dt_parse(). Fix this accordingly.

Fixes: 9999908ca1ab ("leds: lgm-sso: Put fwnode in any case during ->probe()")
Fixes: c3987cd2bca3 ("leds: lgm: Add LED controller driver for LGM SoC")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 6c0ffcaa6b5c..24736f29d363 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -643,7 +643,7 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 							      fwnode_child,
 							      GPIOD_ASIS, NULL);
 		if (IS_ERR(led->gpiod)) {
-			dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
+			ret = dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
 			goto __dt_err;
 		}
 
@@ -663,8 +663,11 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 			desc->panic_indicator = 1;
 
 		ret = fwnode_property_read_u32(fwnode_child, "reg", &prop);
-		if (ret != 0 || prop >= SSO_LED_MAX_NUM) {
+		if (ret)
+			goto __dt_err;
+		if (prop >= SSO_LED_MAX_NUM) {
 			dev_err(dev, "invalid LED pin:%u\n", prop);
+			ret = -EINVAL;
 			goto __dt_err;
 		}
 		desc->pin = prop;
@@ -700,7 +703,8 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 				desc->brightness = LED_FULL;
 		}
 
-		if (sso_create_led(priv, led, fwnode_child))
+		ret = sso_create_led(priv, led, fwnode_child);
+		if (ret)
 			goto __dt_err;
 	}
 
@@ -714,7 +718,7 @@ __dt_err:
 		sso_led_shutdown(led);
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 static int sso_led_dt_parse(struct sso_led_priv *priv)
-- 
2.30.2



