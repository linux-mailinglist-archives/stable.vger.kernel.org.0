Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC132D845
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 18:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhCDRDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 12:03:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238880AbhCDRDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 12:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D375864F5F;
        Thu,  4 Mar 2021 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614877346;
        bh=olDcRtJ+t+lJRyUWeLlACC10m/jXX6cmy5ZSvP7+fMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1c8dYmxPme5nDJ5jJBax+akaxmeavwP2zwTlE9GI8aR60FlohQKfh7hHPgKbGI97
         gSBQ4zE2Vyo0AGD4FO+YIpL9l+apuq5uVhx2ieIXVz12G13RtPlR0tuBF++VUR/WOT
         CWIPlRNQoh+x24S8XNiUzDB5Icai1lA69GAocw7Y=
Date:   Thu, 4 Mar 2021 18:02:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 5.11 000/773] 5.11.3-rc3 review
Message-ID: <YEESn1JboVRjfJGN@kroah.com>
References: <20210302192719.741064351@linuxfoundation.org>
 <CA+G9fYvkW+84U9e0Cjft_pq9bGnBBqCXST7Hg+gx4pKNyuGPFQ@mail.gmail.com>
 <YEDDIzz32JqSvi1S@kroah.com>
 <20210304165247.GA131220@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210304165247.GA131220@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 04, 2021 at 08:52:47AM -0800, Guenter Roeck wrote:
> On Thu, Mar 04, 2021 at 12:23:15PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Mar 03, 2021 at 02:02:20PM +0530, Naresh Kamboju wrote:
> > > On Wed, 3 Mar 2021 at 00:59, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.11.3 release.
> > > > There are 773 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.3-rc3.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > 
> > > Results from Linaro’s test farm.
> > > All our builds are getting PASS now.
> > > But,
> > > Regressions detected on all devices (arm64, arm, x86_64 and i386).
> > > LTP pty test case hangup01 failed on all devices
> > > 
> > > hangup01    1  TFAIL  :  hangup01.c:133: unexpected message 3
> > > 
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > 
> > > This failure is specific to stable-rc v5.10.20-rc4 and v5.11.3-rc3
> > > Test PASS on the v5.12-rc1 mainline and Linux next kernel.
> > > 
> > > Following two commits caused this test failure,
> > > 
> > >    Linus Torvalds <torvalds@linux-foundation.org>
> > >        tty: implement read_iter
> > > 
> > >    Linus Torvalds <torvalds@linux-foundation.org>
> > >        tty: convert tty_ldisc_ops 'read()' function to take a kernel pointer
> > > 
> > > Test case failed link,
> > > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11.2-774-g6ca52dbc58df/testrun/4070143/suite/ltp-pty-tests/test/hangup01/log
> > > 
> > 
> > Thanks for testing them all, I'll try to debug this later today...
> > 
> 
> Did you see my response to v5.10.y ? It looks like two related patches
> may be missing from v5.10.y and v5.11.y.

I did, thank you, I need to get through some other tasks first before
trying the reproducer and see if the patches you list fix it or not...

thanks,

greg k-h
