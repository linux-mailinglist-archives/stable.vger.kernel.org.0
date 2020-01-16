Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822C613F4F0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbgAPSxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387649AbgAPRIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F15AC22464;
        Thu, 16 Jan 2020 17:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194499;
        bh=RYTJX7tjMAYi3e6sBx82WM3OZ5dIvSFuCjkiIXsioGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gK5Z0M1LBr9/3wLb/01Boidggv5NZapEvXYAcGc1L2zB60FQjUt9an2SaxhGdqer6
         2ozTaGzJ6yvs52SbuupcuEGGmVY0heD3cqdEoG3w+kuSGTdb4LGUTI56tbeCdrMxhA
         gw0O43Znoab9EydzjosDO25MF/OZwTG+WXIre6Jk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ondrej Jirman <megous@megous.com>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 396/671] clk: sunxi-ng: sun50i-h6-r: Fix incorrect W1 clock gate register
Date:   Thu, 16 Jan 2020 12:00:34 -0500
Message-Id: <20200116170509.12787-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

[ Upstream commit f167675486c37b88620d344fbb12d06e34f11d47 ]

The current code defines W1 clock gate to be at 0x1cc, overlaying it
with the IR gate.

Clock gate for r-apb1-w1 is at 0x1ec. This fixes issues with IR receiver
causing interrupt floods on H6 (because interrupt flags can't be cleared,
due to IR module's bus being disabled).

Fixes: b7c7b05065aa77ae ("clk: sunxi-ng: add support for H6 PRCM CCU")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Acked-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
index 27554eaf6929..8d05d4f1f8a1 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c
@@ -104,7 +104,7 @@ static SUNXI_CCU_GATE(r_apb2_i2c_clk,	"r-apb2-i2c",	"r-apb2",
 static SUNXI_CCU_GATE(r_apb1_ir_clk,	"r-apb1-ir",	"r-apb1",
 		      0x1cc, BIT(0), 0);
 static SUNXI_CCU_GATE(r_apb1_w1_clk,	"r-apb1-w1",	"r-apb1",
-		      0x1cc, BIT(0), 0);
+		      0x1ec, BIT(0), 0);
 
 /* Information of IR(RX) mod clock is gathered from BSP source code */
 static const char * const r_mod0_default_parents[] = { "osc32k", "osc24M" };
-- 
2.20.1

