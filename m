Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80F05FABD5
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 07:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJKFQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 01:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJKFQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 01:16:02 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B051B58DE4;
        Mon, 10 Oct 2022 22:16:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 75A0480FE;
        Tue, 11 Oct 2022 05:07:12 +0000 (UTC)
Date:   Tue, 11 Oct 2022 08:15:58 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Tero Kristo <kristo@kernel.org>, kernelci-results@groups.io,
        bot@kernelci.org, gtucker@collabora.com, stable@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: stable-rc/linux-5.10.y bisection: baseline.login on panda
Message-ID: <Y0T8DhAawSA3GYw7@atomide.com>
References: <6341c30d.170a0220.2bfa7.6117@mx.google.com>
 <Y0QB/9dmTwd1tx11@sirena.org.uk>
 <20221011005552.62D85C433D6@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011005552.62D85C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Stephen Boyd <sboyd@kernel.org> [221011 00:47]:
> Quoting Mark Brown (2022-10-10 04:29:03)
> > The KernelCI bisection bot bisected a boot failure on the 5.10-rc stable
> > tree on Panda to d86c6447ee250 ("clk: ti: Stop using legacy clkctrl names
> > for omap4") in the v5.10 stable tree.  There's a lot of clock related
> > warnings/errors including:
> > 
> > <4>[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/clk/clk.c:3778 __clk_register+0x464/0x868
> > <4>[    0.000000] ti_dt_clocks_register: failed to lookup clock node abe-clkctrl:0008:24, ret=-517
> > <4>[    0.416076] omap_hwmod: debugss: cannot _init_clocks
> > <4>[    0.421447] ------------[ cut here ]------------
> > <4>[    0.426513] WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2371 _init+0x428/0x488
> > 
> > (there's a *lot* of probe deferrals and hwmods that fail to init). The
> > last output from the kernel is:
> > 
> > <3>[   10.523590] twl6030_uv_to_vsel:OUT OF RANGE! non mapped vsel for 1410000 Vs max 1316660
> > <6>[   10.531890] Power Management for TI OMAP4+ devices.
> > <4>[   10.537048] OMAP4 PM: u-boot >= v2012.07 is required for full PM support
> > <5>[   10.544555] Loading compiled-in X.509 certificates
> > 
> > I've left the full report from the bot with more information including
> > full logs and a reported-by tag below:
> 
> I don't think we want that commit on stable. It depends on a DT change
> that may not be present. Tony?

Correct, that commit depends on devicetree data being available.

Regards,

Tony
