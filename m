Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43672409496
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345462AbhIMOce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:32:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347233AbhIMOae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98CCC61BA1;
        Mon, 13 Sep 2021 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541080;
        bh=2ITj5GJ9ow0IEEL/OtqutD4LH+DrjnmA/o6l3zoPD6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ek28GUhiRcDusNc+RgI4vrYCmqadaS2/klph9RDkbcF2Bs7mCQiETAX2uIfiqZSf
         bEwGNJyrMTdMzzVndvVgh9bqN1Q1LvDG2sKBDPKujYTItY2XqjLFj87KHs+Dw8Y4/r
         /ibV0VVO7QhGYk1LpMGBb3kNild28GrH675dYniI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 154/334] leds: lgm-sso: Put fwnode in any case during ->probe()
Date:   Mon, 13 Sep 2021 15:13:28 +0200
Message-Id: <20210913131118.557999148@linuxfoundation.org>
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
index 7eb2f44f16be..62ce83cea553 100644
--- a/drivers/leds/blink/leds-lgm-sso.c
+++ b/drivers/leds/blink/leds-lgm-sso.c
@@ -631,8 +631,10 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
 
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
@@ -702,11 +704,11 @@ __sso_led_dt_parse(struct sso_led_priv *priv, struct fwnode_handle *fw_ssoled)
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
@@ -731,6 +733,7 @@ static int sso_led_dt_parse(struct sso_led_priv *priv)
 	fw_ssoled = fwnode_get_named_child_node(fwnode, "ssoled");
 	if (fw_ssoled) {
 		ret = __sso_led_dt_parse(priv, fw_ssoled);
+		fwnode_handle_put(fw_ssoled);
 		if (ret)
 			return ret;
 	}
-- 
2.30.2



