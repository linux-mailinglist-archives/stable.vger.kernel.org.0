Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745C05FA980
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJKAzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 20:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiJKAzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 20:55:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7420D3CBC1;
        Mon, 10 Oct 2022 17:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EDEE61058;
        Tue, 11 Oct 2022 00:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D85C433D6;
        Tue, 11 Oct 2022 00:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665449752;
        bh=5f6V6CKsr2XoEaA7bspk2kMXZ9atRoFGUx2n3DSngN8=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=kwwA6ucBgQvHTTg1vCtiVJZY38+ZKv5iHwF7PLs1ugM6ixWv7tznO8nX9nVsfWXHF
         4Lptgf8zQLkWbNqbaYo6s7DfTASU12wrmFTlNLxV+RM/sSf7Zz5r+Qtem94ibjL+hc
         pfuj/gOUJyj1EoGhBVevpMisejyZ8lfUJ3iSWCvf2x2h7l8N8vwvI/75egO3Oaxw6o
         vw25/yNul+mR+/Md6XVsPq6ep+zDQ1yjGtpZpLVd4kUjMKwniVNYm27yH8RFvuJktY
         M9UItjofxaIF7j1EmNBBDi8WvdznzLtiEcwiGmIC9MChtZ8B9eE0v1Kp+kAOF/m4MZ
         ohaZt8ydl7UPQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y0QB/9dmTwd1tx11@sirena.org.uk>
References: <6341c30d.170a0220.2bfa7.6117@mx.google.com> <Y0QB/9dmTwd1tx11@sirena.org.uk>
Subject: Re: stable-rc/linux-5.10.y bisection: baseline.login on panda
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Date:   Mon, 10 Oct 2022 17:55:50 -0700
User-Agent: alot/0.10
Message-Id: <20221011005552.62D85C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mark Brown (2022-10-10 04:29:03)
> The KernelCI bisection bot bisected a boot failure on the 5.10-rc stable
> tree on Panda to d86c6447ee250 ("clk: ti: Stop using legacy clkctrl names
> for omap4") in the v5.10 stable tree.  There's a lot of clock related
> warnings/errors including:
>=20
> <4>[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/clk/clk.c:3778 __clk_=
register+0x464/0x868
> <4>[    0.000000] ti_dt_clocks_register: failed to lookup clock node abe-=
clkctrl:0008:24, ret=3D-517
> <4>[    0.416076] omap_hwmod: debugss: cannot _init_clocks
> <4>[    0.421447] ------------[ cut here ]------------
> <4>[    0.426513] WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmo=
d.c:2371 _init+0x428/0x488
>=20
> (there's a *lot* of probe deferrals and hwmods that fail to init). The
> last output from the kernel is:
>=20
> <3>[   10.523590] twl6030_uv_to_vsel:OUT OF RANGE! non mapped vsel for 14=
10000 Vs max 1316660
> <6>[   10.531890] Power Management for TI OMAP4+ devices.
> <4>[   10.537048] OMAP4 PM: u-boot >=3D v2012.07 is required for full PM =
support
> <5>[   10.544555] Loading compiled-in X.509 certificates
>=20
> I've left the full report from the bot with more information including
> full logs and a reported-by tag below:

I don't think we want that commit on stable. It depends on a DT change
that may not be present. Tony?
