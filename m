Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A30681308
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbjA3O1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbjA3O1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:27:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD742BF6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B88AB80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64189C4339B;
        Mon, 30 Jan 2023 14:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088745;
        bh=0Bv6vF6sdxPMc4hXnPyUAGmxZuAmKITuj/ilcO9wjUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvYOysnurQ22pvT+TiiOz/6Hnyn17XMJQIJorc5fTjgKeQoh75Hh7pLhjMBgoptUG
         +Mj6aXL5d1LDYa3dv+r9G2Y6wKRizoGvINDHBmZjw399eI/c4nXm6cHqZI68F+Ec15
         pR3j3Ix6JGIjV5KO5arIWqM8rAtdm6/URXBbk2K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/143] i2c: designware: Use DIV_ROUND_CLOSEST() macro
Date:   Mon, 30 Jan 2023 14:52:51 +0100
Message-Id: <20230130134311.552546765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit c045214a0f31dd5d6be716ed2f119b57b6c5d3a2 ]

Instead of open-coding DIV_ROUND_CLOSEST() and similar use the macros directly.
While at it, replace numbers with predefined SI metric prefixes.

No functional change intended.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: c8c37bc51451 ("i2c: designware: use casting of u64 in clock multiplication to avoid overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c  | 8 ++++----
 drivers/i2c/busses/i2c-designware-platdrv.c | 5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 9468c6c89b3f..73a4ef8130e6 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -24,6 +24,7 @@
 #include <linux/regmap.h>
 #include <linux/swab.h>
 #include <linux/types.h>
+#include <linux/units.h>
 
 #include "i2c-designware-core.h"
 
@@ -347,7 +348,7 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 *
 		 * If your hardware is free from tHD;STA issue, try this one.
 		 */
-		return (ic_clk * tSYMBOL + 500000) / 1000000 - 8 + offset;
+		return DIV_ROUND_CLOSEST(ic_clk * tSYMBOL, MICRO) - 8 + offset;
 	else
 		/*
 		 * Conditional expression:
@@ -363,8 +364,7 @@ u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 * The reason why we need to take into account "tf" here,
 		 * is the same as described in i2c_dw_scl_lcnt().
 		 */
-		return (ic_clk * (tSYMBOL + tf) + 500000) / 1000000
-			- 3 + offset;
+		return DIV_ROUND_CLOSEST(ic_clk * (tSYMBOL + tf), MICRO) - 3 + offset;
 }
 
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
@@ -380,7 +380,7 @@ u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	 * account the fall time of SCL signal (tf).  Default tf value
 	 * should be 0.3 us, for safety.
 	 */
-	return ((ic_clk * (tLOW + tf) + 500000) / 1000000) - 1 + offset;
+	return DIV_ROUND_CLOSEST(ic_clk * (tLOW + tf), MICRO) - 1 + offset;
 }
 
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev)
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index ad91c7c0faa5..474754151725 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -32,12 +32,13 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/units.h>
 
 #include "i2c-designware-core.h"
 
 static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 {
-	return clk_get_rate(dev->clk)/1000;
+	return clk_get_rate(dev->clk) / KILO;
 }
 
 #ifdef CONFIG_ACPI
@@ -284,7 +285,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 		if (!dev->sda_hold_time && t->sda_hold_ns)
 			dev->sda_hold_time =
-				div_u64(clk_khz * t->sda_hold_ns + 500000, 1000000);
+				DIV_S64_ROUND_CLOSEST(clk_khz * t->sda_hold_ns, MICRO);
 	}
 
 	adap = &dev->adapter;
-- 
2.39.0



