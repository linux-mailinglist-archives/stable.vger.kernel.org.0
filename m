Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82461489E9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbgAXOie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389267AbgAXOSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0413C208C4;
        Fri, 24 Jan 2020 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875523;
        bh=vQ+VRUWqZvHfu70GmDAAlI1wZqRONm9x3XytVHCr2A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/C2jBPsTzKbWMqVEyktoIBy60KaO24eiClo8U/EE/RW7MKSzUP0j1LATGcWLss+w
         D6sR+b4D35iNJ4Kz79/0X+jnrW9R+U3PyHNrYeP4gYSaGzPxpk2c0/3HtOuHHZox4+
         hERPDqzKMs4dfqAAooeSttHRdwPUB5GmTx0uLBPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 022/107] clk: Don't try to enable critical clocks if prepare failed
Date:   Fri, 24 Jan 2020 09:16:52 -0500
Message-Id: <20200124141817.28793-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 12ead77432f2ce32dea797742316d15c5800cb32 ]

The following traceback is seen if a critical clock fails to prepare.

bcm2835-clk 3f101000.cprman: plld: couldn't lock PLL
------------[ cut here ]------------
Enabling unprepared plld_per
WARNING: CPU: 1 PID: 1 at drivers/clk/clk.c:1014 clk_core_enable+0xcc/0x2c0
...
Call trace:
 clk_core_enable+0xcc/0x2c0
 __clk_register+0x5c4/0x788
 devm_clk_hw_register+0x4c/0xb0
 bcm2835_register_pll_divider+0xc0/0x150
 bcm2835_clk_probe+0x134/0x1e8
 platform_drv_probe+0x50/0xa0
 really_probe+0xd4/0x308
 driver_probe_device+0x54/0xe8
 device_driver_attach+0x6c/0x78
 __driver_attach+0x54/0xd8
...

Check return values from clk_core_prepare() and clk_core_enable() and
bail out if any of those functions returns an error.

Cc: Jerome Brunet <jbrunet@baylibre.com>
Fixes: 99652a469df1 ("clk: migrate the count of orphaned clocks at init")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20191225163429.29694-1-linux@roeck-us.net
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4fc294c2f9e8f..67f592fa083ab 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3408,11 +3408,17 @@ static int __clk_core_init(struct clk_core *core)
 	if (core->flags & CLK_IS_CRITICAL) {
 		unsigned long flags;
 
-		clk_core_prepare(core);
+		ret = clk_core_prepare(core);
+		if (ret)
+			goto out;
 
 		flags = clk_enable_lock();
-		clk_core_enable(core);
+		ret = clk_core_enable(core);
 		clk_enable_unlock(flags);
+		if (ret) {
+			clk_core_unprepare(core);
+			goto out;
+		}
 	}
 
 	clk_core_reparent_orphans_nolock();
-- 
2.20.1

