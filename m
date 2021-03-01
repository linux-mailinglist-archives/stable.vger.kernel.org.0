Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B36328A0B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhCASKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239052AbhCASEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 178B864E4A;
        Mon,  1 Mar 2021 17:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620864;
        bh=MYRzRrpG+IHMuJfrBPvXLvD5kn+prmL5VPf+V8lkX4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2xGMuOYbAfb3DDQWzPIPCO3h/Me5BAgLhnK97wcBe3kwj9aePuKtDr08HCwZwgSy
         3BPlt65taxGqW4MQgeO686e4iqDouLXf2bfb7X+gWHWvFDwe64pHv8tMbhVB6Zr2Zy
         fhuC687sZ9JyNeThr+QDW7sJ0/H/rblonF8vzY38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 308/775] clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL
Date:   Mon,  1 Mar 2021 17:07:56 +0100
Message-Id: <20210301161216.842477054@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 2f290b7c67adf6459a17a4c978102af35cd62e4a ]

The "rate" parameter in meson_clk_pll_set_rate() contains the new rate.
Retrieve the old rate with clk_hw_get_rate() so we don't inifinitely try
to switch from the new rate to the same rate again.

Fixes: 7a29a869434e8b ("clk: meson: Add support for Meson clock controller")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201226121556.975418-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/clk-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index b17a13e9337c4..9404609b5ebfa 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -371,7 +371,7 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (parent_rate == 0 || rate == 0)
 		return -EINVAL;
 
-	old_rate = rate;
+	old_rate = clk_hw_get_rate(hw);
 
 	ret = meson_clk_get_pll_settings(rate, parent_rate, &m, &n, pll);
 	if (ret)
-- 
2.27.0



