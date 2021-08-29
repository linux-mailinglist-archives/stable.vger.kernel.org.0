Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568E43FA89A
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 06:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhH2EMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 00:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhH2EMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 00:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E117160E94;
        Sun, 29 Aug 2021 04:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630210303;
        bh=QLosJFKLxCjUmRbuQiHnZosizIxS9SJGkcBKO3FBan8=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=MZQeCsp7RrZDu2m24AZ/MdSdA2v/jLtm1HAt+l7D0sdq57ERxcA9lXqoqXHznp/Xw
         /Rr3oHcuXRoJemEBsf9qI0kbAqgWKPJmqX8b5euugfX8a1S5bscqifB3A8ZqrGbtmX
         IuF9GWJ3xEPlo8rZDv6VUxm2OJQ2Yn2bXwg9YG1attLbCv36x1SqvbpjUATaON9Rz9
         rP1ePj7igogn/hv5SbTOYw1Hyst3QZWr0qu4LlrA2Mf59LBStGKL1ZhsRcTg6hwgl3
         YtM0BmACTbQlY9gLS97yncCRR2VPbbu9YQwXSfz08U7ua6ODJ3WVdQNkNiGvXaOLMm
         tJrz6PIvcCtFw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210814235514.403426-1-linus.walleij@linaro.org>
References: <20210814235514.403426-1-linus.walleij@linaro.org>
Subject: Re: [PATCH] clk: kirkwood: Fix a clocking boot regression
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>
Date:   Sat, 28 Aug 2021 21:11:41 -0700
Message-ID: <163021030161.2676726.8456868938456366040@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Linus Walleij (2021-08-14 16:55:14)
> Since a few kernel releases the Pogoplug 4 has crashed like this
> during boot:
>=20
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
002
> (...)
> [<c04116ec>] (strlen) from [<c00ead80>] (kstrdup+0x1c/0x4c)
> [<c00ead80>] (kstrdup) from [<c04591d8>] (__clk_register+0x44/0x37c)
> [<c04591d8>] (__clk_register) from [<c04595ec>] (clk_hw_register+0x20/0x4=
4)
> [<c04595ec>] (clk_hw_register) from [<c045bfa8>] (__clk_hw_register_mux+0=
x198/0x1e4)
> [<c045bfa8>] (__clk_hw_register_mux) from [<c045c050>] (clk_register_mux_=
table+0x5c/0x6c)
> [<c045c050>] (clk_register_mux_table) from [<c0acf3e0>] (kirkwood_clk_mux=
ing_setup.constprop.0+0x13c/0x1ac)
> [<c0acf3e0>] (kirkwood_clk_muxing_setup.constprop.0) from [<c0aceae0>] (o=
f_clk_init+0x12c/0x214)
> [<c0aceae0>] (of_clk_init) from [<c0ab576c>] (time_init+0x20/0x2c)
> [<c0ab576c>] (time_init) from [<c0ab3d18>] (start_kernel+0x3dc/0x56c)
> [<c0ab3d18>] (start_kernel) from [<00000000>] (0x0)
> Code: e3130020 1afffffb e12fff1e c08a1078 (e5d03000)
>=20
> This is because the "powersave" mux clock 0 was provided in an unterminat=
ed
> array, which is required by the loop in the driver:
>=20
>         /* Count, allocate, and register clock muxes */
>         for (n =3D 0; desc[n].name;)
>                 n++;
>=20
> Here n will go out of bounds and then call clk_register_mux() on random
> memory contents after the mux clock.
>=20
> Fix this by terminating the array with a blank entry.
>=20
> Fixes: 105299381d87 ("cpufreq: kirkwood: use the powersave multiplexer")
> Cc: stable@vger.kernel.org
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to clk-next
