Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176F918C0F2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 21:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSUAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 16:00:45 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:45002 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgCSUAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 16:00:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1jF1LG-0000uU-Rl; Thu, 19 Mar 2020 20:00:35 +0000
Message-ID: <7a8c6a752793f0907662c3e9c197c284fc461550.camel@codethink.co.uk>
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Faiz Abbas <faiz_abbas@ti.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 19 Mar 2020 20:00:32 +0000
In-Reply-To: <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
References: <20200319123902.941451241@linuxfoundation.org>
         <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-03-20 at 01:12 +0530, Naresh Kamboju wrote:
> On Thu, 19 Mar 2020 at 18:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 4.19.112 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > Faiz Abbas <faiz_abbas@ti.com>
> >     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
> > 
> > Faiz Abbas <faiz_abbas@ti.com>
> >     mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> NOTE:
> The arm beagleboard x15 device running stable rc 4.19.112-rc1, 5.4.27-rc1
> and 5.5.11-rc2 kernel pops up the following messages on console log,
> Is this a problem ?
>
> [   15.737765] mmc1: unspecified timeout for CMD6 - use generic
> [   16.754248] mmc1: unspecified timeout for CMD6 - use generic
> [   16.842071] mmc1: unspecified timeout for CMD6 - use generic
> ...
> [  977.126652] mmc1: unspecified timeout for CMD6 - use generic
> [  985.449798] mmc1: unspecified timeout for CMD6 - use generic
[...]

This warning was introduced by commit 533a6cfe08f9 "mmc: core: Default
to generic_cmd6_time as timeout in __mmc_switch()".  That should not be
applied to stable branches; it is not valid without (at least) these
preparatory changes:

0c204979c691 mmc: core: Cleanup BKOPS support
24ed3bd01d6a mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
ad91619aa9d7 mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

