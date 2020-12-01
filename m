Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823B62C9BA9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389781AbgLAJK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:10:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389778AbgLAJK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACAAE21D46;
        Tue,  1 Dec 2020 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813817;
        bh=1N/kMEsmNUOC9sFU82OMtdArer2/NIxIU2mCVNUY8Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7p4JV0epX9QcTJ8Af/abT0YuqB2eVisynD3TpAbrpPcOXrE4D09uxqqSbjS+YG4r
         CFXQzdKjpe2PFobyYLFoV8Kcl6XIZlJnUjW2hEOOCWXVbB04iMwvu9+xdJpw/CfatZ
         4svfAde5sSIOhYzQHOV0BLvvbqhdzPYbaHwJLTC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 069/152] bus: ti-sysc: Fix reset status check for modules with quirks
Date:   Tue,  1 Dec 2020 09:53:04 +0100
Message-Id: <20201201084720.975693420@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e275d2109cdaea8b4554b9eb8a828bdb8f8ba068 ]

Commit d46f9fbec719 ("bus: ti-sysc: Use optional clocks on for enable and
wait for softreset bit") started showing a "OCP softreset timed out"
warning on enable if the interconnect target module is not out of reset.
This caused the warning to be often triggered for i2c and hdq while the
devices are working properly.

Turns out that some interconnect target modules seem to have an unusable
reset status bits unless the module specific reset quirks are activated.

Let's just skip the reset status check for those modules as we only want
to activate the reset quirks when doing a reset, and not on enable. This
way we don't see the bogus "OCP softreset timed out" warnings during boot.

Fixes: d46f9fbec719 ("bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 24 +++++++++++++++---------
 include/linux/platform_data/ti-sysc.h |  1 +
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index efb088df12766..88a751c11677b 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -970,9 +970,15 @@ static int sysc_enable_module(struct device *dev)
 			return error;
 		}
 	}
-	error = sysc_wait_softreset(ddata);
-	if (error)
-		dev_warn(ddata->dev, "OCP softreset timed out\n");
+	/*
+	 * Some modules like i2c and hdq1w have unusable reset status unless
+	 * the module reset quirk is enabled. Skip status check on enable.
+	 */
+	if (!(ddata->cfg.quirks & SYSC_MODULE_QUIRK_ENA_RESETDONE)) {
+		error = sysc_wait_softreset(ddata);
+		if (error)
+			dev_warn(ddata->dev, "OCP softreset timed out\n");
+	}
 	if (ddata->cfg.quirks & SYSC_QUIRK_OPT_CLKS_IN_RESET)
 		sysc_disable_opt_clocks(ddata);
 
@@ -1373,17 +1379,17 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("hdmi", 0, 0, 0x10, -ENODEV, 0x50030200, 0xffffffff,
 		   SYSC_QUIRK_OPT_CLKS_NEEDED),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x00000006, 0xffffffff,
-		   SYSC_MODULE_QUIRK_HDQ1W),
+		   SYSC_MODULE_QUIRK_HDQ1W | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x0000000a, 0xffffffff,
-		   SYSC_MODULE_QUIRK_HDQ1W),
+		   SYSC_MODULE_QUIRK_HDQ1W | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("i2c", 0, 0, 0x20, 0x10, 0x00000036, 0x000000ff,
-		   SYSC_MODULE_QUIRK_I2C),
+		   SYSC_MODULE_QUIRK_I2C | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("i2c", 0, 0, 0x20, 0x10, 0x0000003c, 0x000000ff,
-		   SYSC_MODULE_QUIRK_I2C),
+		   SYSC_MODULE_QUIRK_I2C | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("i2c", 0, 0, 0x20, 0x10, 0x00000040, 0x000000ff,
-		   SYSC_MODULE_QUIRK_I2C),
+		   SYSC_MODULE_QUIRK_I2C | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("i2c", 0, 0, 0x10, 0x90, 0x5040000a, 0xfffff0f0,
-		   SYSC_MODULE_QUIRK_I2C),
+		   SYSC_MODULE_QUIRK_I2C | SYSC_MODULE_QUIRK_ENA_RESETDONE),
 	SYSC_QUIRK("gpu", 0x50000000, 0x14, -ENODEV, -ENODEV, 0x00010201, 0xffffffff, 0),
 	SYSC_QUIRK("gpu", 0x50000000, 0xfe00, 0xfe10, -ENODEV, 0x40000000 , 0xffffffff,
 		   SYSC_MODULE_QUIRK_SGX),
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index c59999ce044e5..240dce553a0bd 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -50,6 +50,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_MODULE_QUIRK_ENA_RESETDONE	BIT(25)
 #define SYSC_MODULE_QUIRK_PRUSS		BIT(24)
 #define SYSC_MODULE_QUIRK_DSS_RESET	BIT(23)
 #define SYSC_MODULE_QUIRK_RTC_UNLOCK	BIT(22)
-- 
2.27.0



