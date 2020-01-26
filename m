Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29E91499C2
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 10:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgAZJNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 04:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgAZJNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 04:13:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2154E2071E;
        Sun, 26 Jan 2020 09:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580030001;
        bh=7O4rZrabfwe2Yk8BfYvwgH+qJH1yicMOq6Gs92zQMhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoG/pm1slnQ7cTk4cUOGZtlTS1D/KfZaqBVgjYP38n7Le/JePC429D1AiQ64at6Xw
         RxY0orqoBRGglLa81silLd8APNaeSo4qwEhs+J5NeQT5Be5U17OUHHDhshGn9UmDCH
         gRyQE0oHM/CnMrQZrNTfysRner/8j+HZStnj1erY=
Date:   Sun, 26 Jan 2020 10:13:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jon Hunter <jonathanh@nvidia.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
Message-ID: <20200126091319.GA3549630@kroah.com>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
 <20200124173659.GD3166016@kroah.com>
 <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
 <87fcb1f0-b1b8-a6e2-b8f6-b95a07f67919@nvidia.com>
 <eadee1dd-fb6d-855d-935a-4bf93a9ad505@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eadee1dd-fb6d-855d-935a-4bf93a9ad505@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 25, 2020 at 07:46:47AM -0800, Guenter Roeck wrote:
> On 1/25/20 3:32 AM, Jon Hunter wrote:
> > 
> > On 24/01/2020 18:07, Jon Hunter wrote:
> > > 
> > > On 24/01/2020 17:36, Greg Kroah-Hartman wrote:
> > > > On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 4.19.99 release.
> > > > > > There are 639 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > The whole patch series can be found in one patch at:
> > > > > > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
> > > > > > or in the git tree and branch at:
> > > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > > > > and the diffstat can be found below.
> > > > > > 
> > > > > > thanks,
> > > > > > 
> > > > > > greg k-h
> > > > > > 
> > > > > > -------------
> > > > > > Pseudo-Shortlog of commits:
> > > > > 
> > > > > ...
> > > > > 
> > > > > > Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > >      PCI: PM: Skip devices in D0 for suspend-to-idle
> > > > > 
> > > > > The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
> > > > > Reverting this on top of v4.19.99-rc1 fixes the issue.
> > > > 
> > > > This is also in the 4.14 queue, so should I drop it there too?
> > > 
> > > I did not see any failures with the same board on that branch, so I
> > > would say no, but odd that it only fails here. It was failing for me
> > > 100% so I would have expected to see if there too if it was a problem.
> > 
> > Hmmm, rc2 still not working for me ...
> > 
> > Test results for stable-v4.19:
> >      11 builds:	11 pass, 0 fail
> >      22 boots:	22 pass, 0 fail
> >      32 tests:	30 pass, 2 fail
> > 
> > Linux version:	4.19.99-rc2-g24832ad2c623
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra30-cardhu-a04
> > 
> > I still see the following commit in rc2 ...
> > 
> > commit bb52152abe85f971278a7a4f033b29483f64bfdb
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Thu Jun 13 23:59:45 2019 +0200
> > 
> >      PCI: PM: Skip devices in D0 for suspend-to-idle

Yes, I did not change anything in -rc2 for you, sorry.

> > BTW, I checked the 4.14. queue and I do not see the above change in
> > there, however, there is similar change ...
> > 
> > Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >      PCI: PM: Avoid possible suspend-to-idle issue
> > 
> bb52152abe85 fixes this one, which in turn fixes 33e4f80ee69b.
> The above in 4.14 but not its fixes is spelling a bit of trouble.
> 
> Maybe commit 471a739a47aa7 ("PCI: PM: Avoid skipping bus-level
> PM on platforms without ACPI") was added to -rc2, since it is
> supposed to fix bb52152abe85.

I have added that fix to 4.14 now, and will go push out a -rc3 for both
4.19.y and 4.14.y to try to sync up on this and figure it out.

Jon, if you could retest 4.14.y, that would be great, to see if it has
the same issue that 4.19.y has.  And if so, that means I should probably
just drop both patches from both trees, right?

thanks,

greg k-h
