Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86BF18C803
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 08:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgCTHNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 03:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgCTHNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 03:13:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C7820767;
        Fri, 20 Mar 2020 07:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584688379;
        bh=TfWmM3Ai4YdmyWibZDbTrgYUu0dg8O37hYbqBbaKOZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wf+VDkWtXVOonaNXQlQCefnxMa9QnAyJMtTgjHglMuQc67YzSRQwKwrB56TtM4jcg
         2E/P0ZH2cFpU4lg5K9pOna+W46o8IZKhhuCG1duGZQo1bwAwsEQjuLWsZL4yg8Kh1c
         pfkpT65tGyRXSMbpclpxblPf1n8Vge5sBxDAna4Q=
Date:   Fri, 20 Mar 2020 08:12:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Jann Horn <jannh@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.4 00/60] 5.4.27-rc1 review
Message-ID: <20200320071256.GA308547@kroah.com>
References: <20200319123919.441695203@linuxfoundation.org>
 <CA+G9fYvLC7xBuULxhG9yRi+EbUqmQjnS0X+0j-vGpX6XPVskOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvLC7xBuULxhG9yRi+EbUqmQjnS0X+0j-vGpX6XPVskOg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 03:29:47AM +0530, Naresh Kamboju wrote:
> On Thu, 19 Mar 2020 at 18:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.27 release.
> > There are 60 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.27-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> This regression is platform specific.
> 
> On arm64 dragonboard 410c-QC410E* the LT hugemmap05 and
> hackbench test cases started failing on this build and easy to reproduce.
> Where as on other arm64 platforms (juno-r2, nxp-ls2088) these test PASS.
> 
> These two test case scenario run on independent execution.
> 
> Steps to reproduce,
> cd /opt/ltp
> ./runltp -s hugemmap05
> 
> cd /opt/ltp/testcases/bin
> ./hackbench 50 process 1000
> ./hackbench 20 thread 1000
> 
> Test output log:
> --------------------
> hugemmap05.c:89: BROK: mmap((nil),402653184,3,1,6,0) failed: ENOMEM (12)
> tst_safe_sysv_ipc.c:99: BROK: hugemmap05.c:85: shmget(218431587,
> 402653184, b80) failed: ENOMEM (12)
> 
> Running with 50*40 (== 2000) tasks.
> fork() (error: Resource temporarily unavailable)
> Running with 20*40 (== 800) tasks.
> pthread_create failed: Resource temporarily unavailable (11)
> 
> 
> *
> RAM: 1GB LPDDR3 SDRAM @ 533MHz
> CPU: ARM Cortex-A53 Quad-core up to 1.2 GHz per core
> 
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-hugetlb-tests/hugemmap05
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-sched-tests/hackbench01
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-sched-tests/hackbench02

Any chance you can run 'git bisect' to find the issue here?

thanks,

greg k-h
