Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B041CD6B9
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbfJFRlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbfJFRlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0085C2053B;
        Sun,  6 Oct 2019 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383679;
        bh=ghPfPE3Dv9KM5BihfJgp2aHVM6ja4supiXXbg586G2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbkwNFJKwUhyfg/syVNfTZgJX7zEc49Ci62Aj7RfadKBjwIhPyIlVkHcE3ABGpuFG
         avhH3Oowg/uYtfzI896hDWu7aZUhP8fVOtq9bCrdlHt97SbGN21xErAkh9yTtk0ZAR
         hE7hvKnLWwp4W6UIDtn2K1zxfV/KEpiLLD44+0Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 038/166] clk: sunxi: Dont call clk_hw_get_name() on a hw that isnt registered
Date:   Sun,  6 Oct 2019 19:20:04 +0200
Message-Id: <20191006171216.122051307@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit a7b85ad25a97cf897b4819a121655c483d86156f ]

The implementation of clk_hw_get_name() relies on the clk_core
associated with the clk_hw pointer existing. If of_clk_hw_register()
fails, there isn't a clk_core created yet, so calling clk_hw_get_name()
here fails. Extract the name first so we can print it later.

Fixes: 1d80c14248d6 ("clk: sunxi-ng: Add common infrastructure")
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index 7fe3ac980e5f9..2e20e650b6c01 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -97,14 +97,15 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 
 	for (i = 0; i < desc->hw_clks->num ; i++) {
 		struct clk_hw *hw = desc->hw_clks->hws[i];
+		const char *name;
 
 		if (!hw)
 			continue;
 
+		name = hw->init->name;
 		ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n",
-			       i, clk_hw_get_name(hw));
+			pr_err("Couldn't register clock %d - %s\n", i, name);
 			goto err_clk_unreg;
 		}
 	}
-- 
2.20.1



