Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2618A411A6D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243908AbhITQtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244104AbhITQtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E07A61242;
        Mon, 20 Sep 2021 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156460;
        bh=wWYN6TOqooXpSHMj8jRxU3SF8EFAxjzBm2Q4EXJ5fXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEUcsaXP+S/9pEi1ShbFuoXWzbkWVZTJDLL7cvI/6TVi3Jqn1PMuLnXEToQmDBOgT
         bkoMM+g2rZuplL62MBkK5rljB8wC5ta8hESQpMU0LivM7slj9pPyrZRoBSdLPoikFX
         e8dmkdkNILBXubz3yZlzs+ze/mVyI2ee83Zx+MbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.4 070/133] clk: kirkwood: Fix a clocking boot regression
Date:   Mon, 20 Sep 2021 18:42:28 +0200
Message-Id: <20210920163914.938701750@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit aaedb9e00e5400220a8871180d23a83e67f29f63 upstream.

Since a few kernel releases the Pogoplug 4 has crashed like this
during boot:

Unable to handle kernel NULL pointer dereference at virtual address 00000002
(...)
[<c04116ec>] (strlen) from [<c00ead80>] (kstrdup+0x1c/0x4c)
[<c00ead80>] (kstrdup) from [<c04591d8>] (__clk_register+0x44/0x37c)
[<c04591d8>] (__clk_register) from [<c04595ec>] (clk_hw_register+0x20/0x44)
[<c04595ec>] (clk_hw_register) from [<c045bfa8>] (__clk_hw_register_mux+0x198/0x1e4)
[<c045bfa8>] (__clk_hw_register_mux) from [<c045c050>] (clk_register_mux_table+0x5c/0x6c)
[<c045c050>] (clk_register_mux_table) from [<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0+0x13c/0x1ac)
[<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0) from [<c0aceae0>] (of_clk_init+0x12c/0x214)
[<c0aceae0>] (of_clk_init) from [<c0ab576c>] (time_init+0x20/0x2c)
[<c0ab576c>] (time_init) from [<c0ab3d18>] (start_kernel+0x3dc/0x56c)
[<c0ab3d18>] (start_kernel) from [<00000000>] (0x0)
Code: e3130020 1afffffb e12fff1e c08a1078 (e5d03000)

This is because the "powersave" mux clock 0 was provided in an unterminated
array, which is required by the loop in the driver:

        /* Count, allocate, and register clock muxes */
        for (n = 0; desc[n].name;)
                n++;

Here n will go out of bounds and then call clk_register_mux() on random
memory contents after the mux clock.

Fix this by terminating the array with a blank entry.

Fixes: 105299381d87 ("cpufreq: kirkwood: use the powersave multiplexer")
Cc: stable@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210814235514.403426-1-linus.walleij@linaro.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mvebu/kirkwood.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -254,6 +254,7 @@ static const char *powersave_parents[] =
 static const struct clk_muxing_soc_desc kirkwood_mux_desc[] __initconst = {
 	{ "powersave", powersave_parents, ARRAY_SIZE(powersave_parents),
 		11, 1, 0 },
+	{ }
 };
 
 #define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)


