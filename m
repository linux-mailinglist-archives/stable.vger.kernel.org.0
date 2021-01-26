Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D423044EA
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 18:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390317AbhAZRSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390312AbhAZIoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 03:44:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA172065C;
        Tue, 26 Jan 2021 08:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611650611;
        bh=RGOC6SXuU+lbMn+ZX7UyoYXvwogc/UEwlnkWFIn9f4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kSaoX74K2eXtrwg/yJ3X5QKORA14j5cvZVrspdE6ewg1AztLk/aKSJObGLezpIOZ9
         YlVsAUHn4DWkubCNTFePyiKQDPKYpjh2qvBkkB91KoEQ8I2TEkBbLTr4CnOjfgYH1V
         Bq2Z/q9wxKQVVJh9cz3L4i1y7HFuOcIZP90q8mE4=
Date:   Tue, 26 Jan 2021 09:43:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5.10 000/199] 5.10.11-rc1 review
Message-ID: <YA/WMSIMjeclLv+Y@kroah.com>
References: <20210125183216.245315437@linuxfoundation.org>
 <ef5b0670-83ea-e754-033c-2f3f56a8c822@linaro.org>
 <20210125201806.GA78651@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125201806.GA78651@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 12:18:06PM -0800, Guenter Roeck wrote:
> On Mon, Jan 25, 2021 at 01:36:03PM -0600, Daniel Díaz wrote:
> > Hello!
> > 
> > 
> > On 1/25/21 12:37 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.11 release.
> > > There are 199 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Sanity results from Linaro’s test farm.
> > Regressions detected.
> > 
> [ ... ]
> > 
> > Errors look like the following:
> > 
> >   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc' 'HOSTCC=sccache gcc'
> >   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c: In function 'bsp_init_amd':
> >   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c:572:3: error: '__max_die_per_package' undeclared (first use in this function); did you mean 'topology_max_die_per_package'?
> >     572 |   __max_die_per_package = nodes_per_socket = ((ecx >> 8) & 7) + 1;
> >         |   ^~~~~~~~~~~~~~~~~~~~~
> >         |   topology_max_die_per_package
> > 
> > Will find out more soon.
> > 
> 
> This may be due to commit 76e2fc63ca40 ("x86/cpu/amd: Set __max_die_per_package
> on AMD").
> 
> Our patches robot tells me:
> 
> SHA 76e2fc63ca40 recursively fixed by: 1eb8f690bcb5
> 
> I don't see commit 1eb8f690bcb5 ("x86/topology: Make __max_die_per_package
> available unconditionally") in the commit log. I have not checked,
> but it is at least possible that applying it fixes the problem.

Argh, the one time I don't run my "are there any fixes for the patches
in the queue" script, and this pops up...

Thanks for this, turns out there's another patch missing as well.  I'll
be doing a -rc2 soon for two queues...

thanks,

greg k-h
