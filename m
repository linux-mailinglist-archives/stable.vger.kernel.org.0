Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568A810BCA9
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfK0VWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732274AbfK0VFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:05:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5AFD2166E;
        Wed, 27 Nov 2019 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888722;
        bh=TSfcfKMerSp3xOiFklG5ABCAq1n+d8pMG/0OHuwn+yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDXfgidZJD8oIO/JnWTtZlaXRwYvWdHr9Ulvxz1e3yh/+Tg70GQsXwFL8z7M5SlTm
         00gVqHUp9simhk8zuMq54M+I55PzVXAQXiMlDHFumU9h8+9xHdUerE7UMIRuvOmBbB
         Aj4gBHor5nLkcYoup72j8xqyICzlfmdA7GOHeDhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/306] pinctrl: bcm2835: Use define directive for BCM2835_PINCONF_PARAM_PULL
Date:   Wed, 27 Nov 2019 21:31:35 +0100
Message-Id: <20191127203132.838482192@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b40ac08ff886302a6aa457fd72e94a969f50e245 ]

Clang warns when one enumerated type is implicitly converted to another:

drivers/pinctrl/bcm/pinctrl-bcm2835.c:707:40: warning: implicit
conversion from enumeration type 'enum bcm2835_pinconf_param' to
different enumeration type 'enum pin_config_param' [-Wenum-conversion]
        configs[0] = pinconf_to_config_packed(BCM2835_PINCONF_PARAM_PULL, pull);
                     ~~~~~~~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.

It is expected that pinctrl drivers can extend pin_config_param because
of the gap between PIN_CONFIG_END and PIN_CONFIG_MAX so this conversion
isn't an issue. Most drivers that take advantage of this define the
PIN_CONFIG variables as constants, rather than enumerated values. Do the
same thing here so that Clang no longer warns.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 08925d24180b0..1bd3c10ce1893 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -72,10 +72,8 @@
 #define GPIO_REG_OFFSET(p)	((p) / 32)
 #define GPIO_REG_SHIFT(p)	((p) % 32)
 
-enum bcm2835_pinconf_param {
-	/* argument: bcm2835_pinconf_pull */
-	BCM2835_PINCONF_PARAM_PULL = (PIN_CONFIG_END + 1),
-};
+/* argument: bcm2835_pinconf_pull */
+#define BCM2835_PINCONF_PARAM_PULL	(PIN_CONFIG_END + 1)
 
 struct bcm2835_pinctrl {
 	struct device *dev;
-- 
2.20.1



