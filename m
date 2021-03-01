Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F41F328571
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236182AbhCAQxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234795AbhCAQrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6658664F96;
        Mon,  1 Mar 2021 16:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616284;
        bh=jSK36YXfI3ibonePXke76vCetrsnv9SDA/VOnw0VIMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrPPBxh55A1cUyfi8KoCigPL0OgR3R7JwUiYdo5XgnF43v0hHk/BDIgG56weEGFJG
         SVvseWhvWOpu1ErraXgE0lurFN3msPpcYeWqwB5JwcbDaCIQT60vJETVtTSL48ElL5
         CzN1pAAVPkkIg0XlpiFxkB9AOxfkzfrLzADLbz9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 068/176] clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL
Date:   Mon,  1 Mar 2021 17:12:21 +0100
Message-Id: <20210301161024.340235318@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 01341553f50b7..80ce8ea1ff16a 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -178,7 +178,7 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (parent_rate == 0 || rate == 0)
 		return -EINVAL;
 
-	old_rate = rate;
+	old_rate = clk_hw_get_rate(hw);
 
 	rate_set = meson_clk_get_pll_settings(pll, rate);
 	if (!rate_set)
-- 
2.27.0



