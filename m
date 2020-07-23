Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEDB22AA54
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 10:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgGWIGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 04:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGWIGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 04:06:39 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4BD20888;
        Thu, 23 Jul 2020 08:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595491598;
        bh=4JGlD1TbFFWSg+P/0Pdxr7uW71kuoH7GfKoYbWbz4BU=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=lX458IbiTO0ynEufOwB3W12aiXAlmMXEuxF79prWdjzw+veZgSATz/xrQfhAarY8L
         p+kCqR4aIFWPNSyfGJfEUJAGYXa7AM26Mb7gaOsOXyW6P2Zk8XbAv0NaGBHdPdZ++M
         Fc8boQfFt44GfftAgM8IC6OYdWUQkwY0+oOpDGns=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com>
References: <CA+G9fYvGXOcsF=70FVwOxqVYOeGTUuzhUzh5od1cKV1hshsW_g@mail.gmail.com> <CAK8P3a1ReCDR8REM7AWMisiEJ_D45pC8dXaoYFFVG3aZj91e7Q@mail.gmail.com>
Subject: Re: stable-rc 4.14: arm64: Internal error: Oops: clk_reparent __clk_set_parent_before on db410c
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Clark <robdclark@chromium.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Eric Anholt <eric@anholt.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        samuel@sholland.org
To:     Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Jul 2020 01:06:37 -0700
Message-ID: <159549159798.3847286.18202724980881020289@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Arnd Bergmann (2020-07-21 02:51:32)
>                         __clk_set_parent_before(orphan, parent);
>=20
> None of the above have changed in stable kernels.
>=20
> > [    5.633668]  pll_28nm_register+0xa4/0x340 [msm]
> > [    5.637492]  msm_dsi_pll_28nm_init+0xc8/0x1d8 [msm]
> > [    5.642007]  msm_dsi_pll_init+0x34/0xe0 [msm]
> > [    5.646870]  dsi_phy_driver_probe+0x1cc/0x310 [msm]
>=20
> The only changes to the dsi driver in v4.14-stable were:
>=20
> 89e30bb46074 drm/msm/dsi: save pll state before dsi host is powered off
> 892afde0f4a1 drm: msm: Fix return type of dsi_mgr_connector_mode_valid fo=
r kCFI
> 35ff594b0da2 drm/msm/dsi: Implement reset correctly
> 5151a0c8d730 drm/msm/dsi: use correct enum in dsi_get_cmd_fmt
> e6bc3a4b0c23 clk: divider: fix incorrect usage of container_of
>=20
> None of these look suspicious to me.
>=20

It sounds like maybe you need this patch?

bdcf1dc25324 ("clk: Evict unregistered clks from parent caches")

or=20

4368a1539c6b ("drm/msm: Depopulate platform on probe failure")

I vaguelly recall that the display driver wasn't removing clks becaues
it wasn't removing devices when probe defer happened and then we had
dangling clks in the parent cache confusing things.
