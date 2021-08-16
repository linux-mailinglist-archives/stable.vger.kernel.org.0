Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA543ED668
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbhHPNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238299AbhHPNSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:18:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29962632FC;
        Mon, 16 Aug 2021 13:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119637;
        bh=IMh7Dmq8MIpX0F+ZNZlos+dTf2PKE1HJ2IDJikYHEbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sr7EVZPTCOkTFdS78MVKGYy+jERtcWH6323Ju2c0hfOSOoavXgYIFZrMvnXP175/B
         Rb5iOf44V965RuUP2MZafYgMy6Xr+rAjFOx8Zg1B5r6tdJhLw24Ii2CAF0k3+F8M5o
         YN4F9UhMLBBJwC2V61XhPuyUMg/pnXmsOBamC4v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 104/151] pinctrl: sunxi: Dont underestimate number of functions
Date:   Mon, 16 Aug 2021 15:02:14 +0200
Message-Id: <20210816125447.502952777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit d1dee814168538eba166ae4150b37f0d88257884 ]

When we are building all the various pinctrl structures for the
Allwinner pinctrl devices, we do some estimation about the maximum
number of distinct function (names) that we will need.

So far we take the number of pins as an upper bound, even though we
can actually have up to four special functions per pin. This wasn't a
problem until now, since we indeed have typically far more pins than
functions, and most pins share common functions.

However the H616 "-r" pin controller has only two pins, but four
functions, so we run over the end of the array when we are looking for
a matching function name in sunxi_pinctrl_add_function - there is no
NULL sentinel left that would terminate the loop:

[    8.200648] Unable to handle kernel paging request at virtual address fffdff7efbefaff5
[    8.209179] Mem abort info:
....
[    8.368456] Call trace:
[    8.370925]  __pi_strcmp+0x90/0xf0
[    8.374559]  sun50i_h616_r_pinctrl_probe+0x1c/0x28
[    8.379557]  platform_probe+0x68/0xd8

Do an actual worst case allocation (4 functions per pin, three common
functions and the sentinel) for the initial array allocation. This is
now heavily overestimating the number of functions in the common case,
but we will reallocate this array later with the actual number of
functions, so it's only temporarily.

Fixes: 561c1cf17c46 ("pinctrl: sunxi: Add support for the Allwinner H616-R pin controller")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210722132548.22121-1-andre.przywara@arm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index dc8d39ae045b..9c7679c06dca 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1219,10 +1219,12 @@ static int sunxi_pinctrl_build_state(struct platform_device *pdev)
 	}
 
 	/*
-	 * We suppose that we won't have any more functions than pins,
-	 * we'll reallocate that later anyway
+	 * Find an upper bound for the maximum number of functions: in
+	 * the worst case we have gpio_in, gpio_out, irq and up to four
+	 * special functions per pin, plus one entry for the sentinel.
+	 * We'll reallocate that later anyway.
 	 */
-	pctl->functions = kcalloc(pctl->ngroups,
+	pctl->functions = kcalloc(4 * pctl->ngroups + 4,
 				  sizeof(*pctl->functions),
 				  GFP_KERNEL);
 	if (!pctl->functions)
-- 
2.30.2



