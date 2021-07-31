Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA24F3DC4A4
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 09:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGaHxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 03:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230503AbhGaHxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 03:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3529C60F46;
        Sat, 31 Jul 2021 07:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627718023;
        bh=1KJVYCEuJ5jV6qNfQDq5kolD2QvDiKAsaWJLINb42vk=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=KTmL4svsIHOnIZK42fAMAfvm0IXfzS3/1ujkK42dwR7TSFBuzdsgZeeR72OOAnwl1
         yt2Jqn759Qni/JoQv8jUSAkdOqNLMzcqHtTAHQxLWm8DB6mBLcxrjV/d8ySCt20mqS
         arIVOI9OSRIulhNLeHbouD7NTxXz37Cv2eCI8UKBcDM9E29DfvPz4xGr3xG/pBsQ2C
         Ukyu1v3ERT0VcFSLhIgIjEle3DxUFjlIXKWwDc7yRMwF5uIotZ2ibMJ9Ht8DW2428y
         +CkEqTdKVp2smYz5XbqOHm82hklDrLsGZVPVIcFBik3Fwur2l4T8eqxSiiTEqQScc2
         cTcWRfPUA5A7Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210731025950.2238582-1-briannorris@chromium.org>
References: <20210731025950.2238582-1-briannorris@chromium.org>
Subject: Re: [PATCH] clk: fix leak on devm_clk_bulk_get_all() unwind
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Dong Aisheng <aisheng.dong@nxp.com>, stable@vger.kernel.org
To:     Brian Norris <briannorris@chromium.org>,
        Michael Turquette <mturquette@baylibre.com>
Date:   Sat, 31 Jul 2021 00:53:41 -0700
Message-ID: <162771802186.714452.5743429710136064714@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Brian Norris (2021-07-30 19:59:50)
> clk_bulk_get_all() allocates an array of struct clk_bulk data for us
> (unlike clk_bulk_get()), so we need to free it. Let's use the
> clk_bulk_put_all() helper.
>=20
> kmemleak complains, on an RK3399 Gru/Kevin system:
>=20
> unreferenced object 0xffffff80045def00 (size 128):
>   comm "swapper/0", pid 1, jiffies 4294667682 (age 86.394s)
>   hex dump (first 32 bytes):
>     44 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  D2`.............
>     48 32 60 fe fe ff ff ff 00 00 00 00 00 00 00 00  H2`.............
>   backtrace:
>     [<00000000742860d6>] __kmalloc+0x22c/0x39c
>     [<00000000b0493f2c>] clk_bulk_get_all+0x64/0x188
>     [<00000000325f5900>] devm_clk_bulk_get_all+0x58/0xa8
>     [<00000000175b9bc5>] dwc3_probe+0x8ac/0xb5c
>     [<000000009169e2f9>] platform_drv_probe+0x9c/0xbc
>     [<000000005c51e2ee>] really_probe+0x13c/0x378
>     [<00000000c47b1f24>] driver_probe_device+0x84/0xc0
>     [<00000000f870fcfb>] __device_attach_driver+0x94/0xb0
>     [<000000004d1b92ae>] bus_for_each_drv+0x8c/0xd8
>     [<00000000481d60c3>] __device_attach+0xc4/0x150
>     [<00000000a163bd36>] device_initial_probe+0x1c/0x28
>     [<00000000accb6bad>] bus_probe_device+0x3c/0x9c
>     [<000000001a199f89>] device_add+0x218/0x3cc
>     [<000000001bd84952>] of_device_add+0x40/0x50
>     [<000000009c658c29>] of_platform_device_create_pdata+0xac/0x100
>     [<0000000021c69ba4>] of_platform_bus_create+0x190/0x224
>=20
> Fixes: f08c2e2865f6 ("clk: add managed version of clk_bulk_get_all")
> Cc: Dong Aisheng <aisheng.dong@nxp.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---

Applied to clk-fixes
