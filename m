Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88248153A0D
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 22:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgBEVVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 16:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgBEVVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 16:21:33 -0500
Received: from localhost (unknown [193.117.204.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE562082E;
        Wed,  5 Feb 2020 21:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580937692;
        bh=HZPos4rVk7aXuEQAlz+FmnYnm93VWpVbO/dAG4GSfM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HKH4g//cfQ6S5jaqc/c7WFe/kXaldCe314/4mmcb1fyA4rbMwK32fpG6fyeXI8q7j
         VPup/+nTDbgRkufOqmcRVp1fGQPMkvpnyvi1m3X9ssY+CI5MwbjyDmiHGtDrPYflbc
         Ucj/D+9B/mkr5H5DwmTkQ1ak5Tc2JYeOgrfXhE3Y=
Date:   Wed, 5 Feb 2020 21:21:29 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205212129.GA1452440@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
 <20200205151357.GB1236691@kroah.com>
 <20200205162429.GB25403@roeck-us.net>
 <20200205193008.GC1327971@kroah.com>
 <20200205210150.GA18483@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205210150.GA18483@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 01:01:50PM -0800, Guenter Roeck wrote:
> On Wed, Feb 05, 2020 at 07:30:08PM +0000, Greg Kroah-Hartman wrote:
> > On Wed, Feb 05, 2020 at 08:24:29AM -0800, Guenter Roeck wrote:
> > > On Wed, Feb 05, 2020 at 03:13:57PM +0000, Greg Kroah-Hartman wrote:
> > > > On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> > > > > On 2/3/20 8:19 AM, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 5.4.18 release.
> > > > > > There are 90 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > 
> > > > > Building i386:allyesconfig ... failed
> > > > > Building i386:allmodconfig ... failed
> > > > > --------------
> > > > > Error log:
> > > > > In file included from arch/x86/kernel/pci-dma.c:2:
> > > > > include/linux/dma-direct.h:29:20: error: conflicting types for 'dma_capable'
> > > > >    29 | static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
> > > > >       |                    ^~~~~~~~~~~
> > > > > In file included from include/linux/dma-direct.h:12,
> > > > >                  from arch/x86/kernel/pci-dma.c:2:
> > > > > arch/x86/include/asm/dma-direct.h:5:6: note: previous declaration of 'dma_capable' was here
> > > > >     5 | bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
> > > > 
> > > > Ok, I think this is now resolved with a patch that Sasha added.
> > > > 
> > > > I have pushed out a -rc4 that _should_ build and boot properly.
> > > > 
> > > The i386 build still fails with v5.4.17-99-gbd0c6624a110 (-rc4).
> > 
> > Crap.
> > 
> > Ok, let me get some food and then try to figure this out...
> > 
> 
> # bad: [bd0c6624a110d0f667cd2f3636f88e8de9b75851] Linux 5.4.18-rc4
> # good: [313c8460cf0290fb1b9f71a20573fc32ac6c9cee] Linux 5.4.17
> git bisect start 'HEAD' 'v5.4.17'
> # good: [7c8bd91288c71011d793de1926a30182382141a0] parisc: Use proper printk format for resource_size_t
> git bisect good 7c8bd91288c71011d793de1926a30182382141a0
> # good: [67040c483ee8137adb12e20bb6448786455f4de6] r8152: Disable PLA MCU clock speed down
> git bisect good 67040c483ee8137adb12e20bb6448786455f4de6
> # good: [b3f55c9d709e6dcf96af5230295e631f0cbc3a8f] netfilter: nf_tables_offload: fix check the chain offload flag
> git bisect good b3f55c9d709e6dcf96af5230295e631f0cbc3a8f
> # good: [87bd4bf79429566adf306b8b133625604460b7c2] perf report: Fix no libunwind compiled warning break s390 issue
> git bisect good 87bd4bf79429566adf306b8b133625604460b7c2
> # good: [f831fda5fe86918fcb049721fba779ba2300c022] ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initialization order
> git bisect good f831fda5fe86918fcb049721fba779ba2300c022
> # good: [cc47538aebee48bb7626c84607116e43f57118d5] tracing/uprobe: Fix to make trace_uprobe_filter alignment safe
> git bisect good cc47538aebee48bb7626c84607116e43f57118d5
> # bad: [26f444bf728054ad23e5888bdd4ffa899e364b45] dma-direct: unify the dma_capable definitions
> git bisect bad 26f444bf728054ad23e5888bdd4ffa899e364b45
> # first bad commit: [26f444bf728054ad23e5888bdd4ffa899e364b45] dma-direct: unify the dma_capable definitions
> 
> Reverting 26f444bf728054ad23e5888bdd4ffa899e364b45 fixes that problem, but
> results in other build failures. After dropping this commit, another bisect yields:
> 
> # bad: [56ea21e523a5ebf53e4ce88bc743c60c480d42ff] Linux 5.4.18-rc4
> # good: [313c8460cf0290fb1b9f71a20573fc32ac6c9cee] Linux 5.4.17
> git bisect start 'HEAD' 'v5.4.17'
> # good: [7c8bd91288c71011d793de1926a30182382141a0] parisc: Use proper printk format for resource_size_t
> git bisect good 7c8bd91288c71011d793de1926a30182382141a0
> # good: [afbfe89dc11d19769477c5378a7164837baf75be] r8152: disable U2P3 for RTL8153B
> git bisect good afbfe89dc11d19769477c5378a7164837baf75be
> # good: [8403906c74753734338665be315175ddd1e03f5e] netfilter: conntrack: sctp: use distinct states for new SCTP connections
> git bisect good 8403906c74753734338665be315175ddd1e03f5e
> # good: [6b1562623df22cd81bf2138d880915029bbd414c] dm thin: fix use-after-free in metadata_pre_commit_callback
> git bisect good 6b1562623df22cd81bf2138d880915029bbd414c
> # bad: [705430d0039088973d204feea9eb0b7740509194] mm/migrate.c: also overwrite error when it is bigger than zero
> git bisect bad 705430d0039088973d204feea9eb0b7740509194
> # bad: [180dafcb1d1c0ee38f935810fe18d02eb7658c9f] dma-direct: exclude dma_direct_map_resource from the min_low_pfn check
> git bisect bad 180dafcb1d1c0ee38f935810fe18d02eb7658c9f
> # good: [87bd4bf79429566adf306b8b133625604460b7c2] perf report: Fix no libunwind compiled warning break s390 issue
> git bisect good 87bd4bf79429566adf306b8b133625604460b7c2
> # first bad commit: [180dafcb1d1c0ee38f935810fe18d02eb7658c9f] dma-direct: exclude dma_direct_map_resource from the min_low_pfn check
> 
> Dropping that patch as well fixes the problem for me.

Ah, now I got my i386 build working, yeah, this works for me too.

Sasha, I think I tried to backport these dma patches earlier in the
5.4.y series, but it was just too hard to unwind, so I figured it wasn't
worth it.  I've dropped these two patches now and will go do a
release...

thanks for the testing and help here, much appreciated.

greg k-h
