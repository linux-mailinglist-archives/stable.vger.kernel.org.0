Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276931D2CD5
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 12:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgENKaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 06:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbgENKaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 06:30:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C4B2073E;
        Thu, 14 May 2020 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589452220;
        bh=A3IjjYicFx2sDdwHaUV1m4nmlpmmCiXI+c8C5UnaoGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wOzQJkFRV88ZCynkOK8TiPIsiUIoLdn/9TOODYbwvoiLxy1soZt18uHPKbAXPSujK
         Xc67oZSVvNDmrLfEgg1cUc6custplSvTpN3juUhWPLL2B3uSmt9gEKWxZnMkqZE1wd
         iP0K5f9PRxU+98vDdmYDX0O9kTf+OKq8ZNXnPOIE=
Date:   Thu, 14 May 2020 12:30:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, stable@vger.kernel.org,
        lkp@lists.01.org, bpf@vger.kernel.org,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
Message-ID: <20200514103017.GA1829391@kroah.com>
References: <20200513074418.GE17565@shao2-debian>
 <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
 <20200513102634.GC871114@kroah.com>
 <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200514031420.GE102436@dhcp-12-153.nay.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 11:14:20AM +0800, Hangbin Liu wrote:
> On Wed, May 13, 2020 at 12:26:34PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
> > > 
> > > Thanks test bot catch the issue.
> > > On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
> > > > Greeting,
> > > > 
> > > > FYI, we noticed the following commit (built with gcc-7):
> > > > 
> > > > commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs")
> > > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > 
> > > The author for this commit is Andrii(cc'd).
> > > 
> > > Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the setup disabled it")
> > > > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
> > > >    goto cleanup;
> > > >    ^~~~
> > > 
> > > Hi Greg, we are missing a depend commit
> > > dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> > > 
> > > So either we need backport this patch, or if you like, we can also fix it by
> > > changing 'goto cleanup;' to 'goto close_prog;'. So which one do you prefer?
> > 
> > I don't know, I have no context here at all, sorry.
> > 
> > What stable kernel tree is failing, what patch needs to be changed, what
> > patch caused this, and so on...
> > 
> > confused,
> 
> Oh, sorry, I should reply the full email. I will forward the full message in
> the bellow. For your questions:
> 
> the stable kernel tree is linux-5.4.y,
> my patch is da43712a7262 ("selftests/bpf: Skip perf hw events test if the
> setup disabled it")[1].
> 
> The reason is we are lacking upstream commit
> dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> 
> This will call build warning
> prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
>    goto cleanup;
>    ^~~~
> 
> To fix it, I think the easiest way is change the "goto cleanup" to "goto
> close_prog".

Ok, can you send a patch for this, documenting all of the above so I
know what's going on?

> For the other error:
> 
> prog_tests/perf_buffer.c: In function ‘test_perf_buffer’:
> prog_tests/perf_buffer.c:39:8: warning: implicit declaration of function ‘parse_cpu_mask_file’ [-Wimplicit-function-declaration]
>   err = parse_cpu_mask_file("/sys/devices/system/cpu/online",
>         ^~~~~~~~~~~~~~~~~~~
> ../lib.mk:138: recipe for target '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs' failed
> make: *** [/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf/test_progs] Error 1
> make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-da43712a7262891317883d4b3a909fb18dac4b1d/tools/testing/selftests/bpf'
> 
> I think Andrii may like help.

That looks like a bug, we should revert the offending patch, right?

thanks,

greg k-h
