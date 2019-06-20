Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78254D90A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfFTR7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 13:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfFTR7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 13:59:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED9D72083B;
        Thu, 20 Jun 2019 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053577;
        bh=hErqMKTtmiv9W7Mf9Z6tNQ98BFQ2PFO0Ra4pVf0xzdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npUTEBIjM9lYKViIO7PIDK1VD59ohMWO32GDNlWeoDAjb3ma/NN027oX8u/a2flPG
         X1SOf+yoRnnFzse90evuGucputuNId9NnpEG5SMiRrtd4PuRKuWZsRsxrKUn5+92i6
         F4R3n36ol0Z+c7XV+NVr/ImvCZyV4gROFF81SWPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 09/84] mfd: twl6040: Fix device init errors for ACCCTL register
Date:   Thu, 20 Jun 2019 19:56:06 +0200
Message-Id: <20190620174338.989366661@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 48171d0ea7caccf21c9ee3ae75eb370f2a756062 ]

I noticed that we can get a -EREMOTEIO errors on at least omap4 duovero:

twl6040 0-004b: Failed to write 2d = 19: -121

And then any following register access will produce errors.

There 2d offset above is register ACCCTL that gets written on twl6040
powerup. With error checking added to the related regcache_sync() call,
the -EREMOTEIO error is reproducable on twl6040 powerup at least
duovero.

To fix the error, we need to wait until twl6040 is accessible after the
powerup. Based on tests on omap4 duovero, we need to wait over 8ms after
powerup before register write will complete without failures. Let's also
make sure we warn about possible errors too.

Note that we have twl6040_patch[] reg_sequence with the ACCCTL register
configuration and regcache_sync() will write the new value to ACCCTL.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl6040.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 72aab60ae846..db8684430f02 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -316,8 +316,19 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			}
 		}
 
+		/*
+		 * Register access can produce errors after power-up unless we
+		 * wait at least 8ms based on measurements on duovero.
+		 */
+		usleep_range(10000, 12000);
+
 		/* Sync with the HW */
-		regcache_sync(twl6040->regmap);
+		ret = regcache_sync(twl6040->regmap);
+		if (ret) {
+			dev_err(twl6040->dev, "Failed to sync with the HW: %i\n",
+				ret);
+			goto out;
+		}
 
 		/* Default PLL configuration after power up */
 		twl6040->pll = TWL6040_SYSCLK_SEL_LPPLL;
-- 
2.20.1



