Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B31F4B47
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfKHMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbfKHLh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:37:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D6D21924;
        Fri,  8 Nov 2019 11:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213078;
        bh=BPACXaFVQTm9exWl0MhTgT5qlYmiPd+LkRsxeBV1D1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUPoGTdUxvL47YUQFNQrMK3YIv+syYW9n+f3cgytlTNVsrBefMPIIFxZgC+k73GLl
         hH3BIfjV38ZwFN3hAwTxIwdv/4YTWB8IqsaZbTW9nsmdgQbfINEinal0xzPdHbh5G9
         r5SB7/nA75f8LJCT64p5+BoHcL8/lqQdxsYuP0Mk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rongyi Chen <chenyi@tt-cool.com>, Icenowy Zheng <icenowy@aosc.io>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 005/205] clk: sunxi-ng: h6: fix PWM gate/reset offset
Date:   Fri,  8 Nov 2019 06:34:32 -0500
Message-Id: <20191108113752.12502-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rongyi Chen <chenyi@tt-cool.com>

[ Upstream commit 58c0f79887d5e425fe6a9fd542778e50df69e9c6 ]

Currently the register offset of the PWM bus gate in Allwinner H6 clock
driver is wrong.

Fix this issue.

Fixes: 542353ea ("clk: sunxi-ng: add support for the Allwinner H6 CCU")
Signed-off-by: Rongyi Chen <chenyi@tt-cool.com>
[Icenowy: refactor commit message]
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
index 0f7a0ffd3f706..d425b47cef179 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
@@ -352,7 +352,7 @@ static SUNXI_CCU_GATE(bus_dbg_clk, "bus-dbg", "psi-ahb1-ahb2",
 static SUNXI_CCU_GATE(bus_psi_clk, "bus-psi", "psi-ahb1-ahb2",
 		      0x79c, BIT(0), 0);
 
-static SUNXI_CCU_GATE(bus_pwm_clk, "bus-pwm", "apb1", 0x79c, BIT(0), 0);
+static SUNXI_CCU_GATE(bus_pwm_clk, "bus-pwm", "apb1", 0x7ac, BIT(0), 0);
 
 static SUNXI_CCU_GATE(bus_iommu_clk, "bus-iommu", "apb1", 0x7bc, BIT(0), 0);
 
-- 
2.20.1

