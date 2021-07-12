Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963E43C5387
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347978AbhGLHzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350432AbhGLHvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E0261494;
        Mon, 12 Jul 2021 07:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075909;
        bh=WgAJkEzJBA/ZNQA3RagROpQc1bXfIAe+thXdWXACNfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woWSY+VExMOvkCVKjGqBhyIMKU/CzruSI5/RzOEjOaeajWxsHCwLZTz9LhJmkLchY
         NeDdVgiM4b77plPWQTyyQQzwgXLyXqFNbfQLIIESeAX0tCMjBICDmZqkftUMaCDNh/
         87FpR3uz9WMDdUrZK4j/z1zJ6JHU9bwMnkdhNF7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Schramm <t.schramm@manjaro.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 415/800] clk: sunxi-ng: v3s: fix incorrect postdivider on pll-audio
Date:   Mon, 12 Jul 2021 08:07:18 +0200
Message-Id: <20210712061011.345342465@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit 47e4dc4e63e1dcb8eec01c4214bcefc248eb72ed ]

Commit 46060be6d840 ("clk: sunxi-ng: v3s: use sigma-delta modulation for audio-pll")
changed the audio pll on the Allwinner V3s and V3 SoCs to use
sigma-delta modulation. In the process the declaration of fixed postdivider
providing "pll-audio" was adjusted to provide the desired clock rates from
the now sigma-delta modulated pll.
However, while the divider used for calculations by the clock framework
was adjusted the actual divider programmed into the hardware in
sun8i_v3_v3s_ccu_init was left at "divide by four". This broke the
"pll-audio" clock, now only providing quater the expected clock rate.
It would in general be desirable to program the postdivider for
"pll-audio" to four, such that a broader range of frequencies were
available on the pll outputs. But the clock for the integrated codec
"ac-dig" does not feature a mux that allows to select from all pll outputs
as it is just a simple clock gate connected to "pll-audio". Thus we need
to set the postdivider to one to be able to provide the 22.5792MHz and
24.576MHz rates required by the internal sun4i codec.

This patches fixes the incorrect clock rate by forcing the postdivider to
one in sun8i_v3_v3s_ccu_init.

Fixes: 46060be6d840 ("clk: sunxi-ng: v3s: use sigma-delta modulation for audio-pll")
Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210513131315.2059451-1-t.schramm@manjaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index a774942cb153..f49724a22540 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -817,10 +817,10 @@ static void __init sun8i_v3_v3s_ccu_init(struct device_node *node,
 		return;
 	}
 
-	/* Force the PLL-Audio-1x divider to 4 */
+	/* Force the PLL-Audio-1x divider to 1 */
 	val = readl(reg + SUN8I_V3S_PLL_AUDIO_REG);
 	val &= ~GENMASK(19, 16);
-	writel(val | (3 << 16), reg + SUN8I_V3S_PLL_AUDIO_REG);
+	writel(val, reg + SUN8I_V3S_PLL_AUDIO_REG);
 
 	sunxi_ccu_probe(node, reg, ccu_desc);
 }
-- 
2.30.2



