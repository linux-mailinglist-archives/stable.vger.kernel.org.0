Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC8E2F1522
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbhAKNNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731965AbhAKNNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4157822CA1;
        Mon, 11 Jan 2021 13:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370804;
        bh=HOfmmsNDwLOfN7qKJIMJttvvQjlx4KepTPwiRGShhy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahr3TkMUMEqOly4zsyQWii95uypRuDDWue9WTi6++jCE0z3e2bx4VTIBWSVcMF0Mj
         awq167m6TcmkelVoqTuoVjcHdpFMwsKRjOJDqwnpirQ+s7AyDs7NZGE46E58lM/kT3
         NhZT6sLf3/QniYg2XiJXuImq2iSTilAYtgzXML8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Graichen <thomas.graichen@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 012/145] net: stmmac: dwmac-meson8b: ignore the second clock input
Date:   Mon, 11 Jan 2021 14:00:36 +0100
Message-Id: <20210111130049.104722338@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit f87777a3c30cf50c66a20e1d153f0e003bb30774 ]

The dwmac glue registers on Amlogic Meson8b and newer SoCs has two clock
inputs:
- Meson8b and Meson8m2: MPLL2 and MPLL2 (the same parent is wired to
  both inputs)
- GXBB, GXL, GXM, AXG, G12A, G12B, SM1: FCLK_DIV2 and MPLL2

All known vendor kernels and u-boots are using the first input only. We
let the common clock framework automatically choose the "right" parent.
For some boards this causes a problem though, specificially with G12A and
newer SoCs. The clock input is used for generating the 125MHz RGMII TX
clock. For the two input clocks this means on G12A:
- FCLK_DIV2: 999999985Hz / 8 = 124999998.125Hz
- MPLL2: 499999993Hz / 4 = 124999998.25Hz

In theory MPLL2 is the "better" clock input because it's gets us 0.125Hz
closer to the requested frequency than FCLK_DIV2. In reality however
there is a resource conflict because MPLL2 is needed to generate some of
the audio clocks. dwmac-meson8b probes first and sets up the clock tree
with MPLL2. This works fine until the audio driver comes and "steals"
the MPLL2 clocks and configures it with it's own rate (294909637Hz). The
common clock framework happily changes the MPLL2 rate but does not
reconfigure our RGMII TX clock tree, which then ends up at 73727409Hz,
which is more than 40% off the requested 125MHz.

Don't use the second clock input for now to force the common clock
framework to always select the first parent. This mimics the behavior
from the vendor driver and fixes the clock resource conflict with the
audio driver on G12A boards. Once the common clock framework can handle
this situation this change can be reverted again.

Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Reported-by: Thomas Graichen <thomas.graichen@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: thomas graichen <thomas.graichen@gmail.com>
Link: https://lore.kernel.org/r/20201219135036.3216017-1-martin.blumenstingl@googlemail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -135,7 +135,7 @@ static int meson8b_init_rgmii_tx_clk(str
 	struct device *dev = dwmac->dev;
 	static const struct clk_parent_data mux_parents[] = {
 		{ .fw_name = "clkin0", },
-		{ .fw_name = "clkin1", },
+		{ .index = -1, },
 	};
 	static const struct clk_div_table div_table[] = {
 		{ .div = 2, .val = 2, },


