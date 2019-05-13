Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113E51AF09
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 05:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfEMDBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 May 2019 23:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfEMDBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 May 2019 23:01:37 -0400
Received: from dragon (98.142.130.235.16clouds.com [98.142.130.235])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E95E920989;
        Mon, 13 May 2019 03:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557716497;
        bh=Vf3S4y6D2Q7ocm8jNWZb50W9bK/aBU2qQFrwVceRIGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yTcnpyJsSX9vo49LjtqtriKMqO88BQS9lKyV/PCWwLKqYhHKNUO6tc0lj+o1q1zIj
         vnRT2Vgippve56ayQtRLmNpHVIpINBctso7Icn5878eKgBpKJhxD7DRjvVFhks6sYx
         03DXUAsZWrCkhrwKovW03UROjPQkJIc0+bK2ZiTk=
Date:   Mon, 13 May 2019 11:01:06 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase
 to i.MX6SX
Message-ID: <20190513030105.GR15856@dragon>
References: <20190502113020.8642-1-festevam@gmail.com>
 <20190502122645.C5FD52081C@mail.kernel.org>
 <CAOMZO5B6GJ_OCX_22M+RQ6HQG=_kxEcM7x1X8+VL9fRc+jHx2w@mail.gmail.com>
 <CAOMZO5BMpwqQUYQ==MRowu62SboL7ikFztUVA2ODkRtONU6gsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BMpwqQUYQ==MRowu62SboL7ikFztUVA2ODkRtONU6gsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 09:54:16AM -0300, Fabio Estevam wrote:
> On Thu, May 2, 2019 at 9:33 AM Fabio Estevam <festevam@gmail.com> wrote:
> >
> > On Thu, May 2, 2019 at 9:26 AM Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > Hi,
> > >
> > > [This is an automated email]
> > >
> > > This commit has been processed because it contains a "Fixes:" tag,
> > > fixing commit: 1e434b703248 ARM: imx: update the cpu power up timing setting on i.mx6sx.
> > >
> > > The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114, v4.9.171, v4.4.179.
> > >
> > > v5.0.10: Build OK!
> > > v4.19.37: Build OK!
> > > v4.14.114: Build OK!
> > > v4.9.171: Build OK!
> > > v4.4.179: Failed to apply! Possible dependencies:
> > >     6ae44aa651d0 ("ARM: imx: enable WAIT mode hardware workaround for imx6sx")
> > >
> > >
> > > How should we proceed with this patch?
> >
> > I can submit a version for 4.4 stable tree once this hits mainline.
> > The conflict resolution is very simple.
> 
> Or maybe I can send a simpler version that applies all the way to 4.4:
> 
> --- a/arch/arm/mach-imx/cpuidle-imx6sx.c
> +++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
> @@ -15,6 +15,7 @@
> 
>  #include "common.h"
>  #include "cpuidle.h"
> +#include "hardware.h"
> 
>  static int imx6sx_idle_finish(unsigned long val)
>  {
> @@ -110,7 +111,7 @@ int __init imx6sx_cpuidle_init(void)
>   * except for power up sw2iso which need to be
>   * larger than LDO ramp up time.
>   */
> - imx_gpc_set_arm_power_up_timing(0xf, 1);
> + imx_gpc_set_arm_power_up_timing(cpu_is_imx6sx() ? 0xf: 0x2, 1);
                                                         ^ missing space

>   imx_gpc_set_arm_power_down_timing(1, 1);
> 
>   return cpuidle_register(&imx6sx_cpuidle_driver, NULL);
> 
> Would this be preferred?

Yes, please.

Shawn
