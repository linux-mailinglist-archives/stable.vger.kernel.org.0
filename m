Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C173B4091C4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbhIMOFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244606AbhIMOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C11C61A4F;
        Mon, 13 Sep 2021 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540308;
        bh=YJ3YEJmb0vOXhvgxRo9igpiNc1A8M6GRnM1uZpGEviE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyTtAd1V8qKFPihITF3/UxOWCW6jrM8TsewiNjT4WGERdNlClhm4VahW0HPJMmtyw
         tXFyKUVM0w7/5tv08RQ6BJPFBi/5e7lEyvwOWdXZRYp2z8L2GRNjupPS2kSI8vQv1I
         XnAALPUuF3vF9jOsFTCEL8pxClQ/vKYD3N97/fLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 140/300] leds: lgm-sso: Put fwnode in any case during ->probe()
Date:   Mon, 13 Sep 2021 15:13:21 +0200
Message-Id: <20210913131114.130950470@linuxfoundation.org>
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

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 9999908ca1abee7aa518a4f6a3739517c137acbf ]

fwnode_get_next_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

All the same in fwnode_for_each_child_node() case.

Fixes: c3987cd2bca3 ("leds: lgm: Add LED controller driver for LGM SoC")
Cc: Amireddy Mallikarjuna reddy <mallikarjunax.reddy@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/blink/leds-lgm-sso.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/blink/leds-lgm-sso.c b/drivers/leds/blink/leds-lgm-sso.c
index 7d5f0bf2817a..2dd285052c6a 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -630,8 +630,10 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 
 	fwnode_for_each_child_node(fw_ssoled, fwnode_child) {
 		led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
-		if (!led)
-			return -ENOMEM;
+		if (!led) {
+			ret = -ENOMEM;
+			goto __dt_err;
+		}
 
 		INIT_LIST_HEAD(&led->list);
 		led->priv = priv;
@@ -701,11 +703,11 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 		if (sso_create_led(priv, led, fwnode_child))
 			goto __dt_err;
 	}
-	fwnode_handle_put(fw_ssoled);
 
 	return 0;
+
 __dt_err:
-	fwnode_handle_put(fw_ssoled);
+	fwnode_handle_put(fwnode_child);
 	/* unregister leds */
 	list_for_each(p, &priv->led_list) {
 		led = list_entry(p, struct sso_led, list);
@@ -730,6 +732,7 @@ static int sso_led_dt_parse(struct sso_led_priv *priv)
 	fw_ssoled = fwnode_get_named_child_node(fwnode, "ssoled");
 	if (fw_ssoled) {
 		ret = __sso_led_dt_parse(priv, fw_ssoled);
+		fwnode_handle_put(fw_ssoled);
 		if (ret)
 			return ret;
 	}
-- 
2.30.2



