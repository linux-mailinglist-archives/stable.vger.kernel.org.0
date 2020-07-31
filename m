Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EEE2349FE
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732988AbgGaRQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 13:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732973AbgGaRQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jul 2020 13:16:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDB62074B;
        Fri, 31 Jul 2020 17:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215761;
        bh=9bNhpovPSTGi6X3LF9twzY/MMA9zySnTVDjOd55Ntxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2dlBa5GvxepmB1bZWS6B4sDbxrGegsTyQ4h4AQ1rmaWhT1WYYuPVBcjLzEYBROrYs
         eI8bf1euA96BCgOWN+O8i/1WbCxMhrQb/d5IwLpc+PWlibzAt7QRE5yyqaBRBahQpf
         HKwa1SAokQSMNQqWrUcwplngTMoq0no3Ux2vRfxc=
Date:   Fri, 31 Jul 2020 19:15:47 +0200
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
        Arnd Bergmann <arnd@arndb.de>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Shakeel Butt <shakeelb@google.com>,
        Hugh Dickins <hughd@google.com>,
        Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-mm <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <songmuchun@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 5.4 00/19] 5.4.55-rc1 review
Message-ID: <20200731171547.GC2012979@kroah.com>
References: <20200730074420.502923740@linuxfoundation.org>
 <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvCPwwmF-k=Z9Z6P2KYrOMHurcORwa3RW2H1j6pq1QEDg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 04:02:16PM +0530, Naresh Kamboju wrote:
> On Thu, 30 Jul 2020 at 13:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.55 release.
> > There are 19 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.55-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions on arm64 Juno-r2 device running LTP controllers-tests
> 
> CONFIG_ARM64_64K_PAGES=y
> 
> Unable to handle kernel paging request at virtual address dead000000000108
> [dead000000000108] address between user and kernel address ranges
> Internal error: Oops: 96000044 [#1] PREEMPT SMP
> 
> pc : get_page_from_freelist+0xa64/0x1030
> lr : get_page_from_freelist+0x9c4/0x1030
> 
> We are trying to reproduce this kernel panic and trying to narrow down to
> specific test cases.

If you come up with something that needs to be reverted, please let me
know.

Otherwise, thanks for testing all of these.

greg k-h
