Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758E825A6E5
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIBHh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIBHhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:37:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6708F207EA;
        Wed,  2 Sep 2020 07:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032274;
        bh=iFXnCVDajhd3aJwTuotc3NIfBYK03nWNbME76hRIE3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0/Zk8paGaiM5UeB3wJSU1hsl18hyQeIrV/ftf9d6Dsr6ykra+hgdgrZFMBHAOnJWd
         awzTp+UnOZ/6juadAoZeExjuTqhw4Gz8i+WoO9MOLPn2IrmPBqBbbBo9yUT/lz5Oty
         9LXMB8I5Ox+0u8nVUf/QIfeyQJePscTWvZo4A1B4=
Date:   Wed, 2 Sep 2020 09:38:20 +0200
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
        linux-mm <linux-mm@kvack.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 5.8 000/255] 5.8.6-rc1 review
Message-ID: <20200902073820.GE1610179@kroah.com>
References: <20200901151000.800754757@linuxfoundation.org>
 <CA+G9fYt+NW7w_NSmqhgQYEmWR_Yo0XDGj1skSoCSqUeLfDPu_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt+NW7w_NSmqhgQYEmWR_Yo0XDGj1skSoCSqUeLfDPu_A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 02, 2020 at 11:14:54AM +0530, Naresh Kamboju wrote:
> On Tue, 1 Sep 2020 at 21:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.6 release.
> > There are 255 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.6-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> While running LTP CVE test suite on i386 this BUG triggered
> after the known warning. Please find below full test log link [1].
> This was reported on the mailing list on next-20200811 but
> did not get any reply [2].
> 
> [  138.177043] ------------[ cut here ]------------
> [  138.181675] WARNING: CPU: 1 PID: 8301 at mm/mremap.c:230
> move_page_tables+0x6ef/0x720
> [  138.189515] Modules linked in: x86_pkg_temp_thermal
> [  138.194436] CPU: 1 PID: 8301 Comm: true Not tainted 5.8.6-rc1 #1
> [  138.194437] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [  138.194439] EIP: move_page_tables+0x6ef/0x720
> 
> <>
> 
> [  802.156512] BUG: unable to handle page fault for address: fe402000
> [  802.162703] #PF: supervisor write access in kernel mode
> [  802.167927] #PF: error_code(0x0002) - not-present page
> [  802.173064] *pde = 23e61067 *pte = 64b32163
> [  802.177329] Oops: 0002 [#1] SMP
> [  802.180469] CPU: 1 PID: 13118 Comm: cve-2017-17053 Tainted: G
>  W         5.8.6-rc1 #1
> [  802.188811] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [  802.196199] EIP: memcpy+0x14/0x30
> [  802.199517] Code: e8 a1 72 c5 ff 0f 31 31 c3 59 58 eb 85 cc cc cc
> cc cc cc cc cc cc 3e 8d 74 26 00 55 89 e5 57 89 c7 56 89 d6 53 89 cb
> c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 8d b4 26 00
> 00 00
> [  802.218259] EAX: fe402000 EBX: 00010000 ECX: 00004000 EDX: fb3dd000
> [  802.224518] ESI: fb3dd000 EDI: fe402000 EBP: ea799ddc ESP: ea799dd0
> [  802.230773] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010206
> [  802.237551] CR0: 80050033 CR2: fe402000 CR3: 1eee9000 CR4: 003406d0
> [  802.243809] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  802.250065] DR6: fffe0ff0 DR7: 00000400
> [  802.253897] Call Trace:
> [  802.256345]  ldt_dup_context+0x6b/0x90
> [  802.260093]  dup_mm+0x2b3/0x480
> [  802.263230]  copy_process+0x13d6/0x1650
> [  802.267062]  _do_fork+0x7b/0x3b0
> [  802.270284]  ? set_next_entity+0xa9/0x250
> [  802.274290]  __ia32_sys_clone+0x77/0xa0
> [  802.278119]  do_syscall_32_irqs_on+0x3d/0x250
> [  802.282472]  ? do_fast_syscall_32+0x2d/0xc0
> [  802.286656]  ? trace_hardirqs_on+0x30/0xf0
> [  802.290746]  ? trace_hardirqs_off_finish+0x32/0xa0
> [  802.295533]  ? do_SYSENTER_32+0x15/0x20
> [  802.299371]  do_fast_syscall_32+0x49/0xc0
> [  802.303374]  do_SYSENTER_32+0x15/0x20
> [  802.307032]  entry_SYSENTER_32+0x9f/0xf2
> [  802.310956] EIP: 0xb7fbb549
> [  802.313747] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
> 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
> 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
> 8d 76
> [  802.332483] EAX: ffffffda EBX: 01200011 ECX: 00000000 EDX: 00000000
> [  802.338742] ESI: 00000000 EDI: b7dbdba8 EBP: b7dbd348 ESP: b7dbd2f0
> [  802.344998] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000246
> [  802.351776] Modules linked in: algif_hash x86_pkg_temp_thermal
> [  802.357608] CR2: 00000000fe402000
> [  802.360920] ---[ end trace ea48459ba50c2a87 ]---
> [  802.365542] EIP: memcpy+0x14/0x30
> [  802.368858] Code: e8 a1 72 c5 ff 0f 31 31 c3 59 58 eb 85 cc cc cc
> cc cc cc cc cc cc 3e 8d 74 26 00 55 89 e5 57 89 c7 56 89 d6 53 89 cb
> c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 8d b4 26 00
> 00 00
> [  802.387593] EAX: fe402000 EBX: 00010000 ECX: 00004000 EDX: fb3dd000
> [  802.393852] ESI: fb3dd000 EDI: fe402000 EBP: ea799ddc ESP: ea799dd0
> [  802.400107] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010206
> [  802.406887] CR0: 80050033 CR2: fe402000 CR3: 1eee9000 CR4: 003406d0
> [  802.413143] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  802.419400] DR6: fffe0ff0 DR7: 00000400
> 
> full test log,
> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-5.8-oe/build/v5.8.5-256-gad57c5b5e64d/testrun/3148295/suite/linux-log-parser/test/check-kernel-bug-1727425/log
> 
> [2] https://lore.kernel.org/linux-mm/CA+G9fYsiNgoh09h0paf1+UTKhPnn490QCoLB2dRFhMT+Cjh9RA@mail.gmail.com/

As this also triggers on mainline/Linus's tree, I'll just let it be for
now, thanks!

greg k-h
