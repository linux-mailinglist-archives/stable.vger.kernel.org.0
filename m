Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254843C5534
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355409AbhGLIJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353298AbhGLIBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591BB60698;
        Mon, 12 Jul 2021 07:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076468;
        bh=zzTE9mOH1poUGryq9U6dVffdBcfSimbZPtQfVJj3PdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qct3x//iFOVzLS1yaByZGj3Ll3Q+H7kO5FvP9whfQWARLSceCUAijo1lmx02H/slk
         zOQ8QUGbhd7AyiPnGYH+e+gUsXIik4LHlihjTsPWpgvTPsxYeU6G6/8QgBBXgj1NuW
         bgbCSXk7WUSKEZdOJ6CXpL+7qTaWYrvJUFCVL3bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 654/800] leds: class: The -ENOTSUPP should never be seen by user space
Date:   Mon, 12 Jul 2021 08:11:17 +0200
Message-Id: <20210712061036.573534936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 2e495ff67856..fa3f5f504ff7 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -285,10 +285,6 @@ struct led_classdev *__must_check devm_of_led_get(struct device *dev,
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



