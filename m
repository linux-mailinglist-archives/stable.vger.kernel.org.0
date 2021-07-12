Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE593C4570
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhGLGZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235244AbhGLGYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B55E6112D;
        Mon, 12 Jul 2021 06:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070903;
        bh=FhnN1XQCTvm1+21zvR3i9hSTgDVOL8eTTguF8dgaDtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE/esfjpkf2KvhIWFxPg4JqaWarCji40nv68CGpcyqfbQ1FMHCC6qRjh+cZDPbO60
         yq5lTm6iejRqdWhvvIBlUHAi1W/NCmECmYXPxqt3QjecUPloA5Eo+eurn3t9C0mHXk
         4fWGsg+vwT9Y2adEFJkM5LbFUE4FfMfpvcrnuzWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/348] clk: meson: g12a: fix gp0 and hifi ranges
Date:   Mon, 12 Jul 2021 08:09:34 +0200
Message-Id: <20210712060726.230277110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit bc794f8c56abddf709f1f84fcb2a3c9e7d9cc9b4 ]

While some SoC samples are able to lock with a PLL factor of 55, others
samples can't. ATM, a minimum of 60 appears to work on all the samples
I have tried.

Even with 60, it sometimes takes a long time for the PLL to eventually
lock. The documentation says that the minimum rate of these PLLs DCO
should be 3GHz, a factor of 125. Let's use that to be on the safe side.

With factor range changed, the PLL seems to lock quickly (enough) so far.
It is still unclear if the range was the only reason for the delay.

Fixes: 085a4ea93d54 ("clk: meson: g12a: add peripheral clock controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210429090325.60970-1-jbrunet@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/g12a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/meson/g12a.c b/drivers/clk/meson/g12a.c
index 3143e16065de..a55b22ebf103 100644
--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -1602,7 +1602,7 @@ static struct clk_regmap g12b_cpub_clk_trace = {
 };
 
 static const struct pll_mult_range g12a_gp0_pll_mult_range = {
-	.min = 55,
+	.min = 125,
 	.max = 255,
 };
 
-- 
2.30.2



