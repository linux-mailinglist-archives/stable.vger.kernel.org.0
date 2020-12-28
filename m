Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4332E68BB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgL1Qkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgL1M7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA6EB22AAD;
        Mon, 28 Dec 2020 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160330;
        bh=mCKcn42ai5yLIkB4E8U89XJ4qeRFev5q3sycr5NWsGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dx1gK22/VaFjxCcC5D4TK3WVT3yCNbyMrhKRtc778DstpiVKrwxG68ryKAPDQVQgN
         m/T+v0Rh1oFWEewXHNBZfjbL9VACp1LXMrXvZbStxO7Pve7PwKeKaSweX1NH1q5Ide
         lHJN5abHCeWo4eySIvT9Ojzzdlz2p0qXEQJiFQUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 015/175] net: stmmac: dwmac-meson8b: fix mask definition of the m250_sel mux
Date:   Mon, 28 Dec 2020 13:47:48 +0100
Message-Id: <20201228124853.997472795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 82ca4c922b8992013a238d65cf4e60cc33e12f36 ]

The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
struct clk_mux expects the mask relative to the "shift" field in the
same struct.

While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
__ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
macro.

Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201205213207.519341-1-martin.blumenstingl@googlemail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -30,7 +30,6 @@
 #define PRG_ETH0_RGMII_MODE		BIT(0)
 
 /* mux to choose between fclk_div2 (bit unset) and mpll2 (bit set) */
-#define PRG_ETH0_CLK_M250_SEL_SHIFT	4
 #define PRG_ETH0_CLK_M250_SEL_MASK	GENMASK(4, 4)
 
 #define PRG_ETH0_TXDLY_SHIFT		5
@@ -123,8 +122,9 @@ static int meson8b_init_clk(struct meson
 	init.num_parents = MUX_CLK_NUM_PARENTS;
 
 	dwmac->m250_mux.reg = dwmac->regs + PRG_ETH0;
-	dwmac->m250_mux.shift = PRG_ETH0_CLK_M250_SEL_SHIFT;
-	dwmac->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK;
+	dwmac->m250_mux.shift = __ffs(PRG_ETH0_CLK_M250_SEL_MASK);
+	dwmac->m250_mux.mask = PRG_ETH0_CLK_M250_SEL_MASK >>
+			       dwmac->m250_mux.shift;
 	dwmac->m250_mux.flags = 0;
 	dwmac->m250_mux.table = NULL;
 	dwmac->m250_mux.hw.init = &init;


