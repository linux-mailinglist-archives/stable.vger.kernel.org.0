Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD1E72F6
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 14:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfJ1N57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 09:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfJ1N57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 09:57:59 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03919208C0;
        Mon, 28 Oct 2019 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572271078;
        bh=sFq6WLRbsDHn3Meg4K3ag08QcEsXHR9zXySA4lIlSnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E0wyGZ4Ow60kJlx6divewxBfdGys5c9bRLh9qWtlvfn9NqJ9uiBcPVzuHxp/KmknJ
         JdFjyuMjMENQnpYBewFxLHn4Zyf6uOuo4j6qtakvh9fux29qD76HYlaggOwHkqnD0w
         wHSmoPuILDaZ/iL9cewx4rRgr9/p31LgHLnUZxsE=
Date:   Mon, 28 Oct 2019 14:57:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
Message-ID: <20191028135756.GA97772@kroah.com>
References: <20191027203056.220821342@linuxfoundation.org>
 <3961082b-17bc-cef7-f0e5-7bf029b2de2a@roeck-us.net>
 <20191028134905.GA53500@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028134905.GA53500@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 02:49:05PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Oct 28, 2019 at 06:32:14AM -0700, Guenter Roeck wrote:
> > On 10/27/19 2:00 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.4.198 release.
> > > There are 41 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > > Anything received after that time might be too late.
> > > 
> > 
> > 
> > Building mips:defconfig ... failed
> > --------------
> > Error log:
> > In file included from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/bitops.h:21,
> >                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/bitops.h:17,
> >                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/kernel.h:10,
> >                  from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:15:
> > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c: In function 'cpu_probe':
> > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaration of function '__ase' [-Werror=implicit-function-declaration]
> >   349 | #define cpu_has_loongson_mmi  __ase(MIPS_ASE_LOONGSON_MMI)
> >       |                               ^~~~~
> > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2079:6: note: in expansion of macro 'cpu_has_loongson_mmi'
> >  2079 |  if (cpu_has_loongson_mmi)
> >       |      ^~~~~~~~~~~~~~~~~~~~
> > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?
> >  2083 |   elf_hwcap |= HWCAP_LOONGSON_CAM;
> >       |                ^~~~~~~~~~~~~~~~~~
> >       |                HWCAP_LOONGSON_EXT
> > /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > 
> > Affects all mips builds in v{4.4, 4.9, 4.14}.
> 
> Ugh, let me see what happened...

Ok, two MIPS patches dropped from 4.4, 4.9, and 4.14 queues, and -rc2
are now pushed out for all 3 of those trees.  It "should" be clean now.

thanks,

greg k-h
