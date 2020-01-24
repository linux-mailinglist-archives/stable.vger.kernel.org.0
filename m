Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91BD1483B4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391231AbgAXLWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390997AbgAXLWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:32 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89B421569;
        Fri, 24 Jan 2020 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864951;
        bh=9+gfxXomcigT80VZmmhAS6uCU+w5O0zAbnaeaSPCv/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEaE1eIEeEHsuKy+8jBwKZp/XitSpVVKoC/29RVAAM5HMxknRLQbFunU+VRdA2yZa
         gJYRTscl1CQVmuMZ10TSLTDJB/+7PmeSOPaNZVjmoeLMOep9C1IblycaQ6oD3XzWku
         ci6ENN2sd/W0fzL01n17zv3brNerN2A7HgUPQyuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 411/639] clk: sunxi-ng: sun50i-h6-r: Fix incorrect W1 clock gate register
Date:   Fri, 24 Jan 2020 10:29:41 +0100
Message-Id: <20200124093138.523524508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 27554eaf69298..8d05d4f1f8a1e 100644
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



