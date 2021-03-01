Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D3F328BB2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhCASi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239943AbhCASbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 807F364E4B;
        Mon,  1 Mar 2021 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620870;
        bh=cSYEfSkUIJk7GDTyxPxp3qO1KZlUoagDxjgJeoVmZsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgKA7kK+rI9kdnMdgvVvk/dA6iUGfruIDZTcyah/WoSjkLQJy9OunlgSk6B3B3sKL
         qOsPqfWIrT/G21vPxthno16D6AhnV5hoMKLKHZi6LMdGcZ4Y87twyEOUWtrXLaHDCg
         /ZcYM3NCAqZA0vrVNmDytWszxmFqApACON51L51U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 310/775] clk: meson: clk-pll: propagate the error from meson_clk_pll_set_rate()
Date:   Mon,  1 Mar 2021 17:07:58 +0100
Message-Id: <20210301161216.937332729@linuxfoundation.org>
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

[ Upstream commit ccdc1f0836f8e37b558a424f1e491f929b2e7ede ]

Popagate the error code from meson_clk_pll_set_rate() when the PLL does
not lock with the new settings.

Fixes: 722825dcd54b2e ("clk: meson: migrate plls clocks to clk_regmap")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201226121556.975418-4-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/clk-pll.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index 5b932976483fd..49f27fe532139 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -394,7 +394,8 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (!enabled)
 		return 0;
 
-	if (meson_clk_pll_enable(hw)) {
+	ret = meson_clk_pll_enable(hw);
+	if (ret) {
 		pr_warn("%s: pll did not lock, trying to restore old rate %lu\n",
 			__func__, old_rate);
 		/*
@@ -406,7 +407,7 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 		meson_clk_pll_set_rate(hw, old_rate, parent_rate);
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.27.0



