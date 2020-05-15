Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B750F1D48E5
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEOIzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 04:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgEOIzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 04:55:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A23A206B6;
        Fri, 15 May 2020 08:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589532901;
        bh=oClvNX1jiA9weydwEdlbenPiHIznHQd1L5EBZhCxx3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpt+mp4LzvuJbX9ycQvw0RpWGNKF5RbZCD0kYOXuvsY6Itbjj25ZChFWEoFSWgyeS
         2w8CH90vuzfAcTG4bYJuviqa2BGLKMD0ysk87k5yQpFoXoqmmLwYDZXhrATqThPunL
         Ge02lOwSxj2U73XKT+Rxrzr5aIw+V31CeLBi9HGg=
Date:   Fri, 15 May 2020 10:54:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, stable@vger.kernel.org,
        lkp@lists.01.org, bpf@vger.kernel.org,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
Message-ID: <20200515085459.GH1474499@kroah.com>
References: <20200513074418.GE17565@shao2-debian>
 <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
 <20200513102634.GC871114@kroah.com>
 <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
 <20200514103017.GA1829391@kroah.com>
 <e5221ecb-04ad-bc77-d66f-b438c1a8b5c7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5221ecb-04ad-bc77-d66f-b438c1a8b5c7@fb.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 11:38:27AM -0700, Andrii Nakryiko wrote:
> On 5/14/20 3:30 AM, Greg Kroah-Hartman wrote:
> > On Thu, May 14, 2020 at 11:14:20AM +0800, Hangbin Liu wrote:
> > > On Wed, May 13, 2020 at 12:26:34PM +0200, Greg Kroah-Hartman wrote:
> > > > On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
> > > > > 
> > > > > Thanks test bot catch the issue.
> > > > > On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
> > > > > > Greeting,
> > > > > > 
> > > > > > FYI, we noticed the following commit (built with gcc-7):
> > > > > > 
> > > > > > commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs")
> > > > > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > > 
> > > > > The author for this commit is Andrii(cc'd).
> > > > > 
> > > > > Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the setup disabled it")
> > > > > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
> > > > > >     goto cleanup;
> > > > > >     ^~~~
> > > > > 
> > > > > Hi Greg, we are missing a depend commit
> > > > > dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> > > > > 
> > > > > So either we need backport this patch, or if you like, we can also fix it by
> > > > > changing 'goto cleanup;' to 'goto close_prog;'. So which one do you prefer?
> 
> Hi, sorry for late reply, missed emails earlier.
> 
> The above "selftest to skeletons" commit will need some more after that,
> it's going to be a pretty big back-port, so I think just fixing it up would
> be ok.
> 
> > > > 
> > > > I don't know, I have no context here at all, sorry.
> > > > 
> > > > What stable kernel tree is failing, what patch needs to be changed, what
> > > > patch caused this, and so on...
> > > > 
> > > > confused,
> > > 
> > > Oh, sorry, I should reply the full email. I will forward the full message in
> > > the bellow. For your questions:
> > > 
> > > the stable kernel tree is linux-5.4.y,
> > > my patch is da43712a7262 ("selftests/bpf: Skip perf hw events test if the
> > > setup disabled it")[1].
> > > 
> > > The reason is we are lacking upstream commit
> > > dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> > > 
> > > This will call build warning
> > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
> > >     goto cleanup;
> > >     ^~~~
> > > 
> > > To fix it, I think the easiest way is change the "goto cleanup" to "goto
> > > close_prog".
> > 
> > Ok, can you send a patch for this, documenting all of the above so I
> > know what's going on?
> > 
> > > For the other error:
> > > 
> > > prog_tests/perf_buffer.c: In function ‘test_perf_buffer’:
> > > prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function ‘parse_cpu_mask_file’ [-Wimplicit-function-declaration]
> > >    err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
> > >          ^~~~~~~~~~~~~~~~~~~
> > > ../lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs' failed
> > > make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
> > > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
> > > 
> > > I think Andrii may like help.
> > 
> > That looks like a bug, we should revert the offending patch, right?
> 
> 6803ee25f0ea ("libbpf: Extract and generalize CPU mask parsing logic") added
> parse_cpu_mask_file() function, so back-porting that commit should solve
> this? It should be straightforward and shouldn't bring any more dependent
> commits.

As this does not apply cleanly, can you provide a working backport so
that I can apply that?

tahnks,

greg k-h
