Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6676328389
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhCAQVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237784AbhCAQTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FB3E64EC4;
        Mon,  1 Mar 2021 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615449;
        bh=achybmWqggPsIEp4S9TA73cspTASuxLJc3rLOcSkiyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4qdW6Lb1Nf1S+H8JmJv4o93qt5Evxy8t3+4C4snGK2ikTRQ+7WxOG0WfDqnJcTw7
         A++eKU3fpDHSiTx0m6fk0zZQY8SbCzR8wECVRH2VVW5nXY8RQ6XzLeiDIGKCtZLMuw
         NlMtK2n4NtW7fmcVub3ZZciEP9t0CzlGD8Iz1Bdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 34/93] clk: meson: clk-pll: fix initializing the old rate (fallback) for a PLL
Date:   Mon,  1 Mar 2021 17:12:46 +0100
Message-Id: <20210301161008.592174223@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 664edf0708ea7..50b1138aaad71 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -138,7 +138,7 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (parent_rate == 0 || rate == 0)
 		return -EINVAL;
 
-	old_rate = rate;
+	old_rate = clk_hw_get_rate(hw);
 
 	rate_set = meson_clk_get_pll_settings(pll, rate);
 	if (!rate_set)
-- 
2.27.0



