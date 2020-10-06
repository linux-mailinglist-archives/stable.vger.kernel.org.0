Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1641284EB9
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 17:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgJFPSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 11:18:46 -0400
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:59606 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgJFPSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 11:18:43 -0400
X-Greylist: delayed 1758 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 11:18:43 EDT
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1kPoHH-0004bn-TJ; Tue, 06 Oct 2020 15:49:19 +0100
Message-ID: <9f395cf46fc5edef55ac1d053d0203c5d39a44cf.camel@codethink.co.uk>
Subject: Re: [PATCH 5.4 00/57] 5.4.70-rc1 review
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 06 Oct 2020 15:49:19 +0100
In-Reply-To: <CA+G9fYu5zw8=Dbm79TW6qhbu-BPYbnxTh976Kv1riUQCkv7ZNg@mail.gmail.com>
References: <20201005142109.796046410@linuxfoundation.org>
         <CA+G9fYvHOu8kJhRKV5GPJmnaE_x2mrnN6myb4G4YHHW-oiKD7A@mail.gmail.com>
         <CA+G9fYu5zw8=Dbm79TW6qhbu-BPYbnxTh976Kv1riUQCkv7ZNg@mail.gmail.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-10-06 at 13:55 +0530, Naresh Kamboju wrote:
[...]
> NOTE:
> While running LTP containers test suite,
> I noticed this kernel panic on arm64 Juno-r2 devices.
> Not easily reproducible and not seen on any other arm64 devices.
> 
> steps to reproduce:
> ---------------------------
> # boot stable rc 5.4.70 kernel on juno-r2 machine
> # cd /opt/ltp
> # ./runltp -f containers
> 
> Crash log,
> ---------------
> pidns13     0  TINFO  :  cinit2: writing some data in pipe
> pidns13     0  TINFO  :  cinit1: setup handler for async I/O on pipe
> pidns13     1  TPASS  :  cinit1: si_fd is 6, si_code is 1
> [  122.275627] Internal error: synchronous external abort: 96000210
> [#1] PREEMPT SMP
[...]
> [  122.399545] Call trace:
> [  122.401995]  sil24_interrupt+0x28/0x5f0
[...]
> [  122.467321] Code: d503201f f9400ac0 f9400014 91011294 (b9400294)
[...]

This corresponds to the statement:

        status = readl(host_base + HOST_IRQ_STAT);

So it looks like the PCI device stopped responding to MMIO for some
reason.  It could be faulty hardware.  I don't see any sign of run-time 
power management in that driver that might explain it.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

