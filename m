Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81251121266
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfLPRwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfLPRwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4919220726;
        Mon, 16 Dec 2019 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518738;
        bh=C4lYRJukxV0+4PsZc7aDgH0OXVnlRSEUuOMr8jSSS1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPofYxLcrHRNu7iavXjhi71Kg/jO3C824VdfKa0UopQ4/VL30kPW+2cg17nZyqnPu
         rqqgqJTbZhEHwcPKUQ2r+/GsxqSBNnyTfMYca7XAq079g70x4xq4vJONLKNwsID4C6
         Lg63WWjDj1hb+TiaQAqBIo4vlHJX/5B18Go585rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/267] clk: rockchip: fix I2S1 clock gate register for rk3328
Date:   Mon, 16 Dec 2019 18:46:12 +0100
Message-Id: <20191216174853.726718823@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <katsuhiro@katsuster.net>

[ Upstream commit 5c73ac2f8b70834a603eb2d92eb0bb464634420b ]

This patch fixes definition of I2S1 clock gate register for rk3328.
Current setting is not related I2S clocks.
  - bit6 of CRU_CLKGATE_CON0 means clk_ddrmon_en
  - bit6 of CRU_CLKGATE_CON1 means clk_i2s1_en

Signed-off-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3328.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3328.c b/drivers/clk/rockchip/clk-rk3328.c
index 33d1cf4e6d803..0e5222d1944b5 100644
--- a/drivers/clk/rockchip/clk-rk3328.c
+++ b/drivers/clk/rockchip/clk-rk3328.c
@@ -392,7 +392,7 @@ static struct rockchip_clk_branch rk3328_clk_branches[] __initdata = {
 			RK3328_CLKGATE_CON(1), 5, GFLAGS,
 			&rk3328_i2s1_fracmux),
 	GATE(SCLK_I2S1, "clk_i2s1", "i2s1_pre", CLK_SET_RATE_PARENT,
-			RK3328_CLKGATE_CON(0), 6, GFLAGS),
+			RK3328_CLKGATE_CON(1), 6, GFLAGS),
 	COMPOSITE_NODIV(SCLK_I2S1_OUT, "i2s1_out", mux_i2s1out_p, 0,
 			RK3328_CLKSEL_CON(8), 12, 1, MFLAGS,
 			RK3328_CLKGATE_CON(1), 7, GFLAGS),
-- 
2.20.1



