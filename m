Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832DB3C4A8C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbhGLGwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240418AbhGLGvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62B4F6101E;
        Mon, 12 Jul 2021 06:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072513;
        bh=d5bkbVdHx/ooL3Ak9tPp8dI1TFEGE/j/dFpXQNbY4GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN1mk6aVZno9nh6hARr4Q0O12Fc/zR6OcoVkG624VsrVpVLYwwCO1b4YKm8Twna2P
         yesQDZ4GYU7CT5nayr0BhBn3Raz+Lk6t+QkO/oK0u7b2CeZebbZp9lnhlS7yfW5n1N
         0ZlKVvtwz4fG6ezKZiQjaM4jX8Waw/V93hOSUVfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/593] leds: class: The -ENOTSUPP should never be seen by user space
Date:   Mon, 12 Jul 2021 08:10:39 +0200
Message-Id: <20210712060943.223327461@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 0ac40af86077982a5346dbc9655172d2775d6b08 ]

Drop the bogus error code and let of_led_get() to take care about absent
of_node.

Fixes: e389240ad992 ("leds: Add managed API to get a LED from a device driver")
Cc: Jean-Jacques Hiblot <jjhiblot@ti.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 131ca83f5fb3..4365c1cc4505 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -286,10 +286,6 @@ struct led_classdev *__must_check devm_of_led_get(struct device *dev,
 	if (!dev)
 		return ERR_PTR(-EINVAL);
 
-	/* Not using device tree? */
-	if (!IS_ENABLED(CONFIG_OF) || !dev->of_node)
-		return ERR_PTR(-ENOTSUPP);
-
 	led = of_led_get(dev->of_node, index);
 	if (IS_ERR(led))
 		return led;
-- 
2.30.2



