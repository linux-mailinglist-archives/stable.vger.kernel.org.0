Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BEB31EBC
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfFANUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfFANUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:20:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B72EE272E0;
        Sat,  1 Jun 2019 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395251;
        bh=FqTSBe2EtMLANJyq2W3Rh4WKsrc9+fooGilgER43Ulc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMhOUBQAiX4ZtMdBr5WYqKmIVUE94uOOMPKC3foU+ztUOhjGbMnVCYbUZ5qXpfCyC
         n+mSzYvKviHUS7d92FNf9L/gTxo7muWYHuMzMFvgawRqtU6CJs9A6nARuEMXXXhOO+
         u9VBnSsf89sMwAj5xT0qVEfx4imcfLRmz/JjzdlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 027/173] mfd: twl6040: Fix device init errors for ACCCTL register
Date:   Sat,  1 Jun 2019 09:16:59 -0400
Message-Id: <20190601131934.25053-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

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
index 7c3c5fd5fcd04..86052c5c60696 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -322,8 +322,19 @@ int twl6040_power(struct twl6040 *twl6040, int on)
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

