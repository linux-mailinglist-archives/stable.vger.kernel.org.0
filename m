Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74373288A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbhCARn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238117AbhCARhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:37:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFBAA650B3;
        Mon,  1 Mar 2021 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617700;
        bh=FpanO7C0mrIFT2jmYK3UwIvReDW+XfIKy/WsOE71cIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si+56gnK3A6LgBDFKUS14aYo917Ab3RUCKyvKYzR1sYcRY4cgx+ZibaZLnlQBLXwy
         aAmbAStyER0frFo4i5HdqMxW+YcD194TXl2zbf2v93znrIKhDV5YjydhY8qfL7rkKU
         4Vy7Etv8ubnkwlw8R0ukeAHgrJDFCrST0KVWhXuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Andre Przywara <andre.przywara@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/340] clk: sunxi-ng: h6: Fix CEC clock
Date:   Mon,  1 Mar 2021 17:11:20 +0100
Message-Id: <20210301161055.007960334@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 756650820abd4770c4200763505b634a3c04e05e ]

The CEC clock on the H6 SoC is a bit special, since it uses a fixed
pre-dividier for one source clock (the PLL), but conveys the other clock
(32K OSC) directly.
We are using a fixed predivider array for that, but fail to use the right
flag to actually activate that.

Fixes: 524353ea480b ("clk: sunxi-ng: add support for the Allwinner H6 CCU")
Reported-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210106143246.11255-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
index d89353a3cdec7..183dd350cce95 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
@@ -673,7 +673,7 @@ static struct ccu_mux hdmi_cec_clk = {
 
 	.common		= {
 		.reg		= 0xb10,
-		.features	= CCU_FEATURE_VARIABLE_PREDIV,
+		.features	= CCU_FEATURE_FIXED_PREDIV,
 		.hw.init	= CLK_HW_INIT_PARENTS("hdmi-cec",
 						      hdmi_cec_parents,
 						      &ccu_mux_ops,
-- 
2.27.0



