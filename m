Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10951328BA9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhCASiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239929AbhCASbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2F0D64E4E;
        Mon,  1 Mar 2021 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620867;
        bh=4VMJuXLZYF6F6IUFnR/0lFgQ5BVHVgFfI5Mo/jnu8nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4j0fbRmld75NJGsYhAtAmzJn/fYwBPidgAVuShtViZRM5MvaBwhghqx+oA6gPO5p
         mG7lurmeYFytdj3AOJNZpugCEY/j35iH2QOIsn2aaPRLu21RggYMWO0xC/7PS59vBh
         A/MIcmqI7rn3ZLxrLYx3pQvbDVIC6mISPEeXamQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 309/775] clk: meson: clk-pll: make "ret" a signed integer
Date:   Mon,  1 Mar 2021 17:07:57 +0100
Message-Id: <20210301161216.891583926@linuxfoundation.org>
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

[ Upstream commit 9e717285f0bd591d716fa0e7418f2cdaf756dd25 ]

The error codes returned by meson_clk_get_pll_settings() are all
negative. Make "ret" a signed integer in meson_clk_pll_set_rate() to
make it match with the clk_ops.set_rate API as well as the data type
returned by meson_clk_get_pll_settings().

Fixes: 8eed1db1adec6a ("clk: meson: pll: update driver for the g12a")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20201226121556.975418-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/clk-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index 9404609b5ebfa..5b932976483fd 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -365,8 +365,9 @@ static int meson_clk_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 {
 	struct clk_regmap *clk = to_clk_regmap(hw);
 	struct meson_clk_pll_data *pll = meson_clk_pll_data(clk);
-	unsigned int enabled, m, n, frac = 0, ret;
+	unsigned int enabled, m, n, frac = 0;
 	unsigned long old_rate;
+	int ret;
 
 	if (parent_rate == 0 || rate == 0)
 		return -EINVAL;
-- 
2.27.0



