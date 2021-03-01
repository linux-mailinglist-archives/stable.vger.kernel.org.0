Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4D1328A87
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbhCASSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239393AbhCASMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:12:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3307651C8;
        Mon,  1 Mar 2021 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619020;
        bh=7YVtzAOdpccMPBGAKnB8fOc8EPwe9L4sRW1khEaKJnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Awf2Au2PWLtWcwYf0EPAnDGQrd10GixuF2S5EkjxVUYtcoBp449DION4RygKlT579
         mckOjwu2X4D+a5r5EyFi8aZLGfCCB088wleq2wv1MOFBu12xwPR9MjzTzlPvcwQ+qf
         QlivfIHpXc4eJ7zcvF6P5TtjWo97J5QNG1ofoFRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/663] clk: sunxi-ng: h6: Fix clock divider range on some clocks
Date:   Mon,  1 Mar 2021 17:09:11 +0100
Message-Id: <20210301161156.826208741@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 04ef679591c76571a9e7d5ca48316cc86fa0ef12 ]

While comparing clocks between the H6 and H616, some of the M factor
ranges were found to be wrong: the manual says they are only covering
two bits [1:0], but our code had "5" in the number-of-bits field.

By writing 0xff into that register in U-Boot and via FEL, it could be
confirmed that bits [4:2] are indeed masked off, so the manual is right.

Change to number of bits in the affected clock's description.

Fixes: 524353ea480b ("clk: sunxi-ng: add support for the Allwinner H6 CCU")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210118000912.28116-1-andre.przywara@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
index a26dbbdff80d1..bff446b782907 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h6.c
@@ -237,7 +237,7 @@ static const char * const psi_ahb1_ahb2_parents[] = { "osc24M", "osc32k",
 static SUNXI_CCU_MP_WITH_MUX(psi_ahb1_ahb2_clk, "psi-ahb1-ahb2",
 			     psi_ahb1_ahb2_parents,
 			     0x510,
-			     0, 5,	/* M */
+			     0, 2,	/* M */
 			     8, 2,	/* P */
 			     24, 2,	/* mux */
 			     0);
@@ -246,19 +246,19 @@ static const char * const ahb3_apb1_apb2_parents[] = { "osc24M", "osc32k",
 						       "psi-ahb1-ahb2",
 						       "pll-periph0" };
 static SUNXI_CCU_MP_WITH_MUX(ahb3_clk, "ahb3", ahb3_apb1_apb2_parents, 0x51c,
-			     0, 5,	/* M */
+			     0, 2,	/* M */
 			     8, 2,	/* P */
 			     24, 2,	/* mux */
 			     0);
 
 static SUNXI_CCU_MP_WITH_MUX(apb1_clk, "apb1", ahb3_apb1_apb2_parents, 0x520,
-			     0, 5,	/* M */
+			     0, 2,	/* M */
 			     8, 2,	/* P */
 			     24, 2,	/* mux */
 			     0);
 
 static SUNXI_CCU_MP_WITH_MUX(apb2_clk, "apb2", ahb3_apb1_apb2_parents, 0x524,
-			     0, 5,	/* M */
+			     0, 2,	/* M */
 			     8, 2,	/* P */
 			     24, 2,	/* mux */
 			     0);
-- 
2.27.0



