Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7561A1F0AF1
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgFGLU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 07:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgFGLU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 07:20:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CCE2064C;
        Sun,  7 Jun 2020 11:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591528828;
        bh=DS7INHu5YrxLt5/jgduSlfYglRwT3c3Y2w1WlfAoBWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y7e+hW/VfYFTPRqS6tXp8Aa72aVjaAkfXPCIMwx8vBrMQtJde0iXzvuaTxxnDuHuM
         uhY6hcUfxNYCHcpHp03cLhQ2v99j9iMoAbscs0hKUVh82AGzBW8dJ+EXa8nRiaY3G6
         XsZY62p/y3OCJrhtmpJefaoBsZi2UybqhD2SHups=
Date:   Sun, 7 Jun 2020 13:20:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.7 00/14] 5.7.1-rc1 review
Message-ID: <20200607112026.GD47740@kroah.com>
References: <20200605135951.018731965@linuxfoundation.org>
 <CA+G9fYsuzQ1BiAx74K2VGK4enUoNLe=jzpT-+AX2NB=wd4PHPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsuzQ1BiAx74K2VGK4enUoNLe=jzpT-+AX2NB=wd4PHPw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 06, 2020 at 09:19:53PM +0530, Naresh Kamboju wrote:
> On Fri, 5 Jun 2020 at 19:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.1 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> 
> While running kselftest memfd_test case the kernel panic noticed on i386
> which started with kernel BUG and followed by kernel panic.
> 
> steps to reproduce: (Not always reproducible)
>           - cd /opt/kselftests/mainline/memfd/
>           - ./run_fuse_test.sh || true
>           - ./run_hugetlbfs_test.sh || true
> 
> [  417.473220] run_hugetlbfs_t (10826): drop_caches: 3
> [  417.491120] audit: type=1701 audit(1591388532.357:87503):
> auid=4294967295 uid=0 gid=0 ses=4294967295 subj=kernel pid=10829
> comm=\"memfd_test\" exe=\"/opt/kselftests/mainline/memfd/memfd_test\"
> sig=6 res=1
> [  417.511294] BUG: kernel NULL pointer dereference, address: 00000043
> [  417.517569] #PF: supervisor read access in kernel mode
> [  417.522699] #PF: error_code(0x0000) - not-present page
> [  417.527830] *pde = 00000000
> [  417.530707] Oops: 0000 [#2] SMP
> [  417.533846] CPU: 3 PID: 10829 Comm: memfd_test Tainted: G      D W
>        5.7.1-rc1 #1
> [  417.541845] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  417.549327] EIP: kmem_cache_alloc_trace+0x81/0x2b0
> <>
> [  931.776242] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x00000009
> [  931.783933] Kernel Offset: 0x1ce00000 from 0xc1000000 (relocation
> range: 0xc0000000-0xf77fdfff)
> [  931.792627] ---[ end Kernel panic - not syncing: Attempted to kill
> init! exitcode=0x00000009 ]---

Did you see this on Linus's tree too?

Is it a regression from 5.7.0?

> software_node_release bug on stable-rc 5.7 noticed which is a known
> issue on Linus's tree.
> [  400.320910] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  400.328959] #PF: supervisor read access in kernel mode
> [  400.334097] #PF: error_code(0x0000) - not-present page
> [  400.339226] PGD 800000022880d067 P4D 800000022880d067 PUD 21f410067 PMD 0
> [  400.346093] Oops: 0000 [#1] SMP PTI
> [  400.349586] CPU: 2 PID: 8865 Comm: modprobe Tainted: G        W
>     5.7.1-rc1 #1
> [  400.357322] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [  400.364711] RIP: 0010:ida_free+0x76/0x140
> 
> Full test log link,
> https://lkft.validation.linaro.org/scheduler/job/1477323#L11575
> 
> 
> Kernel BUG on arm64 dragonboard 410c which is reported upstream but
> did not get reply.
> BUG: spinlock bad magic on CPU#1, swapper/0/1
> lock: msm_uart_ports
> Upstream issue reported link,
> https://lore.kernel.org/lkml/CA+G9fYsDgghO+4zMY-AF2RgUmAfjZyA+tjeg5m5F1rEgEtw5fg@mail.gmail.com/


Thanks for testing all of these.

greg k-h
