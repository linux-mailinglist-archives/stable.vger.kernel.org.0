Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54B3EC9A4
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 16:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhHOOlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 10:41:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhHOOlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 10:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=woQgBcJycESx1AeAnSauAxUXWqkWpB7nFh0pfKfcZmY=; b=m3+FpD8ujfk5GHSg7Vrz55uqww
        4s14rKulOZvFjfWPA4JWlENJ0L5Fs+LFDMZ7rUq3qbiY983/75FiTGU7bfg/cG/gb1eJXuLxp5x0E
        D/82H+apjLHtbJMHeE3CAw2OE5RNmGn5HTxHGWN9kXKx9RqUGFJo6D1x7LM/eOP5wcn4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFHJX-000FJa-3P; Sun, 15 Aug 2021 16:40:39 +0200
Date:   Sun, 15 Aug 2021 16:40:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: kirkwood: Fix a clocking boot regression
Message-ID: <YRknZ0G6e7HfPZ0d@lunn.ch>
References: <20210814235514.403426-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814235514.403426-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 15, 2021 at 01:55:14AM +0200, Linus Walleij wrote:
> Since a few kernel releases the Pogoplug 4 has crashed like this
> during boot:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000002
> (...)
> [<c04116ec>] (strlen) from [<c00ead80>] (kstrdup+0x1c/0x4c)
> [<c00ead80>] (kstrdup) from [<c04591d8>] (__clk_register+0x44/0x37c)
> [<c04591d8>] (__clk_register) from [<c04595ec>] (clk_hw_register+0x20/0x44)
> [<c04595ec>] (clk_hw_register) from [<c045bfa8>] (__clk_hw_register_mux+0x198/0x1e4)
> [<c045bfa8>] (__clk_hw_register_mux) from [<c045c050>] (clk_register_mux_table+0x5c/0x6c)
> [<c045c050>] (clk_register_mux_table) from [<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0+0x13c/0x1ac)
> [<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0) from [<c0aceae0>] (of_clk_init+0x12c/0x214)
> [<c0aceae0>] (of_clk_init) from [<c0ab576c>] (time_init+0x20/0x2c)
> [<c0ab576c>] (time_init) from [<c0ab3d18>] (start_kernel+0x3dc/0x56c)
> [<c0ab3d18>] (start_kernel) from [<00000000>] (0x0)
> Code: e3130020 1afffffb e12fff1e c08a1078 (e5d03000)
> 
> This is because the "powersave" mux clock 0 was provided in an unterminated
> array, which is required by the loop in the driver:
> 
>         /* Count, allocate, and register clock muxes */
>         for (n = 0; desc[n].name;)
>                 n++;
> 
> Here n will go out of bounds and then call clk_register_mux() on random
> memory contents after the mux clock.
> 
> Fix this by terminating the array with a blank entry.
> 
> Fixes: 105299381d87 ("cpufreq: kirkwood: use the powersave multiplexer")
> Cc: stable@vger.kernel.org
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Linus

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
