Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C77133C4A5D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240746AbhGLGwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236878AbhGLGsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C79661106;
        Mon, 12 Jul 2021 06:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072259;
        bh=2ew9wTCj0SV6KOtEPridqdekKVUmxJTm74fuKIxFFJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0yawUl30Wjwpewq3UWvC1CFdiIiviU6xPEAg80QXvY7RoB56Jrp9d1qucFvHaNjcX
         7k/98V85zUdhoLtFgbYCVmpeOI/oLSA9WKbyZiovdL2PcC7LIy38A9MLaHFZ9RrLz2
         DlIvOmz51+prFW1BFJwVVNKLrVfLtEVhZn1bQaDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 421/593] clk: qcom: clk-alpha-pll: fix CAL_L write in alpha_pll_fabia_prepare
Date:   Mon, 12 Jul 2021 08:09:41 +0200
Message-Id: <20210712060934.525951776@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 7f54bf2640e877c8a9b4cc7e2b29f82e3ca1a284 ]

Caught this when looking at alpha-pll code. Untested but it is clear that
this was intended to write to PLL_CAL_L_VAL and not PLL_ALPHA_VAL.

Fixes: 691865bad627 ("clk: qcom: clk-alpha-pll: Add support for Fabia PLL calibration")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20210609022852.4151-1-jonathan@marek.ca
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index 564431130a76..1a571c04a76c 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -1214,7 +1214,7 @@ static int alpha_pll_fabia_prepare(struct clk_hw *hw)
 		return -EINVAL;
 
 	/* Setup PLL for calibration frequency */
-	regmap_write(pll->clkr.regmap, PLL_ALPHA_VAL(pll), cal_l);
+	regmap_write(pll->clkr.regmap, PLL_CAL_L_VAL(pll), cal_l);
 
 	/* Bringup the PLL at calibration frequency */
 	ret = clk_alpha_pll_enable(hw);
-- 
2.30.2



