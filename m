Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DB31D9E
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfFANaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbfFAN0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410E1273B8;
        Sat,  1 Jun 2019 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395581;
        bh=iKFhaIr8rPvFeRFwneCZtFEEkt+6qqK4mTCTtwCb0eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBVDrJbm5dJfs3zy4iFRHeItpW8Jl62qKSyWVjFEh+4yEs4Rfg2qQgN1Li9npDebm
         wEBrwELOiX2j9GprzrTPKHtwelTE1hFfXRJ0ZLJPTDRFsaM+NoI/+jvcXoM+DB2rsv
         6b2yyDWxDxaXl+XRp8K5IQXDC13/HmSQ9gOQ/SLQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/56] mfd: twl6040: Fix device init errors for ACCCTL register
Date:   Sat,  1 Jun 2019 09:25:13 -0400
Message-Id: <20190601132600.27427-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
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
index 72aab60ae8466..db8684430f02c 100644
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

