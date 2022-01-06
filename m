Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7911D4862E1
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 11:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiAFKYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 05:24:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47302 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbiAFKYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 05:24:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D396198A;
        Thu,  6 Jan 2022 10:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE4C36AE5;
        Thu,  6 Jan 2022 10:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641464652;
        bh=kWkuPMeTHkRgtrl1DDpvo+ZOFVlzHB7oyAw8WGbIPT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9/OStszlEWaH8l6bgV+LcUoqKll3j5NjmiR5f1caKs9mc61R5BvwYya6Ue41x/fa
         advNIQrKsHpGpRzVTsKK/s0i6C2zrhJyHVKeXl1ymXI83K1Y+SOIOPBlMQpstaAtaw
         5P/vJhP/V5x3+SX2edfy+0vDxJ0LJWf6iOJX2/lc=
Date:   Thu, 6 Jan 2022 11:24:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <YdbDSR4NLGDRxisb@kroah.com>
References: <20211213092939.074326017@linuxfoundation.org>
 <20211213103536.GC17683@duo.ucw.cz>
 <YbdAE9r9GXZlnyfr@kroah.com>
 <CAEUSe794fvuFwWPDvTeK1TRZw3OizSWOdDsVzVdj+SuWZA_LxA@mail.gmail.com>
 <CAEUSe7-CD5jvro+7DgM-6N_G-Ab_ovNFLG1b_F_ZsTAYJ23D-A@mail.gmail.com>
 <20220106101618.GA13602@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106101618.GA13602@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 11:16:19AM +0100, Pavel Machek wrote:
> Hi!
> 
> > I wonder if you saw this message of mine the other day.
> 
> Seen the message.
> 
> > > > > I'm getting a lot of build failures -- missing gmp.h:
> > > > >
> > > > >   UPD     include/generated/utsrelease.h
> > > > > 1317In file included from /builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0/plugin/include/gcc-plugin.h:28:0,
> > > > > 1318                 from scripts/gcc-plugins/gcc-common.h:7,
> > > > > 1319                 from scripts/gcc-plugins/arm_ssp_per_task_plugin.c:3:
> > > > > 1320/builds/hVatwYBy/68/cip-project/cip-testing/linux-stable-rc-ci/gcc/gcc-8.1.0-nolibc/arm-linux-gnueabi/bin/../lib/gcc/arm-linux-gnueabi/8.1.0/plugin/include/system.h:687:10: fatal error: gmp.h: No such file or directory
> > > > > 1321 #include <gmp.h>
> > > > > 1322          ^~~~~~~
> > > > > 1323compilation terminated.
> > > > > 1324scripts/gcc-plugins/Makefile:47: recipe for target 'scripts/gcc-plugins/arm_ssp_per_task_plugin.so' failed
> > > > > 1325
> > > > >
> > > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> > > >
> > > > What gcc plugins are you trying to build with?
> > >
> > > We saw a similar problem with mainline/next about a year ago, after
> > > v5.10 was released. In our case it failed with gmp.h because
> > > libmpc-dev was not installed on the host; then libiberty-dev was
> > > needed too
> > [...]
> > 
> > We installed libgmp-dev, libmpc-dev and libiberty-dev. That generally
> > helps. FWIW, this is needed for 5.11+.
> 
> Yep, but I'm not the one that can do the installation, our q&a team
> does that. They are aware of the problem now, but it may take a while
> to solve due to holidays etc.
> 
> I believe -stable team should be more conservative and should not
> introduce regressions like this.

If you know a way to solve this, while still solving the original bug
report that this commit fixes, I will be glad to consider it.

thanks,

greg k-h
