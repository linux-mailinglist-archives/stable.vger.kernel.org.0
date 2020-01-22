Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A421C14504B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbgAVJow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388119AbgAVJov (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:44:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCE32467B;
        Wed, 22 Jan 2020 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686291;
        bh=9+mnxnuZEYGkaKqyXGgAnXLvIhgTl5a9+54r4yxYcqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phpyYDa7JPGBe4WATlx4PVB61V9wERVqOLJ4GPh6vTXW3w+2FC7I/lerBX/3SENCL
         4xefYe2+LAMpqaORr8pzGNzy2BQVOQPncpRsWE4OJeVKtURGadU1nRf544xt2mLsmx
         pkr3xiyK3Q4wWN6iDWkjcCnrDmUnbklPcQokcyPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 018/222] ARM: OMAP2+: Fix ti_sysc_find_one_clockdomain to check for to_clk_hw_omap
Date:   Wed, 22 Jan 2020 10:26:44 +0100
Message-Id: <20200122092834.698926029@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

commit 90bdfa0b05e3cc809a7c1aa3b1f162b46ea1b330 upstream.

We must bail out early if the clock is not hw_omap. Otherwise we will
try to access invalid address with hwclk->clkdm_name:

Unable to handle kernel paging request at virtual address ffffffff
Internal error: Oops: 27 [#1] ARM
...
(strcmp) from [<c011b348>] (clkdm_lookup+0x40/0x60)
[<c011b348>] (clkdm_lookup) from [<c011cb84>] (ti_sysc_clkdm_init+0x5c/0x64)
[<c011cb84>] (ti_sysc_clkdm_init) from [<c03680a8>] (sysc_probe+0x948/0x117c)
[<c03680a8>] (sysc_probe) from [<c03d0af4>] (platform_drv_probe+0x48/0x98)
...

Fixes: 2b2f7def058a ("bus: ti-sysc: Add support for missing clockdomain handling")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/pdata-quirks.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -368,10 +368,14 @@ static void __init dra7x_evm_mmc_quirk(v
 
 static struct clockdomain *ti_sysc_find_one_clockdomain(struct clk *clk)
 {
+	struct clk_hw *hw = __clk_get_hw(clk);
 	struct clockdomain *clkdm = NULL;
 	struct clk_hw_omap *hwclk;
 
-	hwclk = to_clk_hw_omap(__clk_get_hw(clk));
+	hwclk = to_clk_hw_omap(hw);
+	if (!omap2_clk_is_hw_omap(hw))
+		return NULL;
+
 	if (hwclk && hwclk->clkdm_name)
 		clkdm = clkdm_lookup(hwclk->clkdm_name);
 


