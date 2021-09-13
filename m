Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7574094D6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbhIMOgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346308AbhIMOco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C9F6139D;
        Mon, 13 Sep 2021 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541145;
        bh=Sxi/se9EVPuxKSeY/8Y3cudE0YD0GxpE12T3muyp4kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsx3OPSq/U/vwwLBKe0NFBhg/x+WfC3ZyaYDVwANuFqtdLuk9GQy/lnpXbuAvBXHk
         hXizGvks1HLN3RFixzbBDRG1pQ03zSQ+87lQ22pBN6+/xaBXdB9EtN7cUMXfpMeHLT
         Em+da4LJ+kel9JThGTeZKTY9PvFE4dlVGbS9ekwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 182/334] leds: lgm-sso: Propagate error codes from callee to caller
Date:   Mon, 13 Sep 2021 15:13:56 +0200
Message-Id: <20210913131119.499354820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index ca9f88996819..aa14f0ebe7a0 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -644,7 +644,7 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 							      fwnode_child,
 							      GPIOD_ASIS, NULL);
 		if (IS_ERR(led->gpiod)) {
-			dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
+			ret = dev_err_probe(dev, PTR_ERR(led->gpiod), "led: get gpio fail!\n");
 			goto __dt_err;
 		}
 
@@ -664,8 +664,11 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
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
@@ -701,7 +704,8 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 				desc->brightness = LED_FULL;
 		}
 
-		if (sso_create_led(priv, led, fwnode_child))
+		ret = sso_create_led(priv, led, fwnode_child);
+		if (ret)
 			goto __dt_err;
 	}
 
@@ -715,7 +719,7 @@ __dt_err:
 		sso_led_shutdown(led);
 	}
 
-	return -EINVAL;
+	return ret;
 }
 
 static int sso_led_dt_parse(struct sso_led_priv *priv)
-- 
2.30.2



