Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060F813EF24
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgAPSNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405202AbgAPRgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:36:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA66246B8;
        Thu, 16 Jan 2020 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196210;
        bh=ZGJmYlRjr2H0cz1pgfoxuIs7wu9sOSTq74J+NGGbjRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dgn3RykfLEIcnLGf/6LMjzLGB+c2eak+Tu3H/7mVKlCoDza3Nzos1rLMTJg0YvODD
         m1G2ZAwUaN9c5ZGb9C/JwCaJNnuxNCJVGJDrG22MumMWZ4o5CXcXDsPSSBtG0TMkdy
         McF1V50+FRNGAmPupAbZPcGJMInX15kyRVqHYRcw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 046/251] clk: sunxi-ng: sun8i-a23: Enable PLL-MIPI LDOs when ungating it
Date:   Thu, 16 Jan 2020 12:33:15 -0500
Message-Id: <20200116173641.22137-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 108a459ef4cd17a28711d81092044e597b5c7618 ]

The PLL-MIPI clock is somewhat special as it has its own LDOs which
need to be turned on for this PLL to actually work and output a clock
signal.

Add the 2 LDO enable bits to the gate bits.

Fixes: 5690879d93e8 ("clk: sunxi-ng: Add A23 CCU")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-a23.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-a23.c b/drivers/clk/sunxi-ng/ccu-sun8i-a23.c
index 5c6d37bdf247..765c6977484e 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-a23.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-a23.c
@@ -132,7 +132,7 @@ static SUNXI_CCU_NKM_WITH_GATE_LOCK(pll_mipi_clk, "pll-mipi",
 				    8, 4,		/* N */
 				    4, 2,		/* K */
 				    0, 4,		/* M */
-				    BIT(31),		/* gate */
+				    BIT(31) | BIT(23) | BIT(22), /* gate */
 				    BIT(28),		/* lock */
 				    CLK_SET_RATE_UNGATE);
 
-- 
2.20.1

