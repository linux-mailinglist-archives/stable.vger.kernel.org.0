Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26584411F9E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349010AbhITRnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352700AbhITRlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F98261B4B;
        Mon, 20 Sep 2021 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157711;
        bh=2+69YOaFMQV3IeG+2xp7JYf6jg/oriN58muh/MO/R1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW+S/wvymrnGJGKxbQaYE/L8ZCRQdXq6LA5lM0fsjPMoWWHD0YSjbLYiqNifyjvIa
         Jl62ExOHacUdaWTIdj9zzVDRaNGf7o9wQFAFKlVs7/FYMHzcYq/9oW5wpvqmJN7I0A
         Z9+7H79AxsdMAqMCpFS89mutG4XrlGcFRPjDQlH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 117/293] clk: kirkwood: Fix a clocking boot regression
Date:   Mon, 20 Sep 2021 18:41:19 +0200
Message-Id: <20210920163937.267418935@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
 
 static struct clk *clk_muxing_get_src(


