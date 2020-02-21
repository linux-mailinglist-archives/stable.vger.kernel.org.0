Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18A1167709
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgBUIBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:01:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbgBUIBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:01:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C4502073A;
        Fri, 21 Feb 2020 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272106;
        bh=dxyccyigJhbpHPCQ2eWhVt7tV6C/oCPf9Cj4BDUW/vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ez8vyWWe+Zd3oCB0mCJi97G3wCIMiFESA08lgg7geBIoo8KJxMyKAGFts18QeHYYK
         2YYT1mTvMZTaIDEwE4DAvgFP8asJE0lXF0Rny8dadOCqXULXqMONs7Bhq4ZxFTJhnZ
         5vTMpReaQd0O4i+UgMYyRiLLnw6xZ+sIsAKS+mGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Remi Pommarel <repk@triplefau.lt>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/344] clk: meson: pll: Fix by 0 division in __pll_params_to_rate()
Date:   Fri, 21 Feb 2020 08:36:58 +0100
Message-Id: <20200221072350.959486973@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit d8488a41800d9f5c80bc0d17b9cc2c91b4841464 ]

Some meson pll registers can be initialized with 0 as N value, introducing
the following division by 0 when computing rate :

  UBSAN: Undefined behaviour in drivers/clk/meson/clk-pll.c:75:9
  division by zero
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc3-608075-g86c9af8630e1-dirty #400
  Call trace:
   dump_backtrace+0x0/0x1c0
   show_stack+0x14/0x20
   dump_stack+0xc4/0x100
   ubsan_epilogue+0x14/0x68
   __ubsan_handle_divrem_overflow+0x98/0xb8
   __pll_params_to_rate+0xdc/0x140
   meson_clk_pll_recalc_rate+0x278/0x3a0
   __clk_register+0x7c8/0xbb0
   devm_clk_hw_register+0x54/0xc0
   meson_eeclkc_probe+0xf4/0x1a0
   platform_drv_probe+0x54/0xd8
   really_probe+0x16c/0x438
   driver_probe_device+0xb0/0xf0
   device_driver_attach+0x94/0xa0
   __driver_attach+0x70/0x108
   bus_for_each_dev+0xd8/0x128
   driver_attach+0x30/0x40
   bus_add_driver+0x1b0/0x2d8
   driver_register+0xbc/0x1d0
   __platform_driver_register+0x78/0x88
   axg_driver_init+0x18/0x20
   do_one_initcall+0xc8/0x24c
   kernel_init_freeable+0x2b0/0x344
   kernel_init+0x10/0x128
   ret_from_fork+0x10/0x18

This checks if N is null before doing the division.

Fixes: 7a29a869434e ("clk: meson: Add support for Meson clock controller")
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
[jbrunet@baylibre.com: update the comment in above the fix]
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/clk-pll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/meson/clk-pll.c b/drivers/clk/meson/clk-pll.c
index ddb1e56347395..3a5853ca98c6c 100644
--- a/drivers/clk/meson/clk-pll.c
+++ b/drivers/clk/meson/clk-pll.c
@@ -77,6 +77,15 @@ static unsigned long meson_clk_pll_recalc_rate(struct clk_hw *hw,
 	unsigned int m, n, frac;
 
 	n = meson_parm_read(clk->map, &pll->n);
+
+	/*
+	 * On some HW, N is set to zero on init. This value is invalid as
+	 * it would result in a division by zero. The rate can't be
+	 * calculated in this case
+	 */
+	if (n == 0)
+		return 0;
+
 	m = meson_parm_read(clk->map, &pll->m);
 
 	frac = MESON_PARM_APPLICABLE(&pll->frac) ?
-- 
2.20.1



