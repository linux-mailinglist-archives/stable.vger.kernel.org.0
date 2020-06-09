Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992F31F473F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgFITlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 15:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389353AbgFITla (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 15:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EF6206C3;
        Tue,  9 Jun 2020 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591731684;
        bh=tTi9AQ6cMecxxSEDxc0I7E4Qrl8xBrI7Q7ahhrNrv5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lE8qdtPMZ+tZtusscQJyQDE5j8vqeNJ9x+lvXe7X/It7f3pa36bNvLiY6IslvYqZ5
         mmVs5eWlCExwYsI9jzmqEXCasMh2kDQ/vrb5BRWsSxvP5IoKEuFehChFU533iuCMoM
         +UePtzNhtNBNfHzb02nc/FYxVva6Hj8Rt07fFTBA=
Date:   Tue, 9 Jun 2020 21:41:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/25] 4.19.128-rc1 review
Message-ID: <20200609194122.GA1095933@kroah.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <CA+G9fYsxjJpM-bw_VamAH0Beri66aC+-kqZ-RiCWVqm4N=t4gA@mail.gmail.com>
 <f5429b08-e3d8-f6fb-79bc-3868bf8a2816@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5429b08-e3d8-f6fb-79bc-3868bf8a2816@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 01:20:42PM -0600, Shuah Khan wrote:
> On 6/9/20 1:01 PM, Naresh Kamboju wrote:
> > On Tue, 9 Jun 2020 at 23:21, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 4.19.128 release.
> > > There are 25 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 11 Jun 2020 17:40:24 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.128-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >      Linux 4.19.128-rc1
> > > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >      Revert "net/mlx5: Annotate mutex destroy for root ns"
> > > 
> > > Oleg Nesterov <oleg@redhat.com>
> > >      uprobes: ensure that uprobe->offset and ->ref_ctr_offset are properly aligned
> > 
> > stable-rc 4.19 build failure for x86_64, i386 and arm.
> > 
> >   make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=x86 HOSTCC=gcc
> > CC="sccache gcc" O=build
> > 75 #
> > 76 In file included from ../kernel/events/uprobes.c:25:
> > 77 ../kernel/events/uprobes.c: In function ‘__uprobe_register’:
> > 78 ../kernel/events/uprobes.c:916:18: error: ‘ref_ctr_offset’
> > undeclared (first use in this function); did you mean
> > ‘per_cpu_offset’?
> > 79  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > 80  | ^~~~~~~~~~~~~~
> > 81 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > 82  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > 83  | ^
> > 84 ../kernel/events/uprobes.c:916:18: note: each undeclared identifier
> > is reported only once for each function it appears in
> > 85  916 | if (!IS_ALIGNED(ref_ctr_offset, sizeof(short)))
> > 86  | ^~~~~~~~~~~~~~
> > 87 ../include/linux/kernel.h:62:30: note: in definition of macro ‘IS_ALIGNED’
> > 88  62 | #define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
> > 89  | ^
> > 90 make[3]: *** [../scripts/Makefile.build:304: kernel/events/uprobes.o] Error 1
> > 
> > kernel config:
> > https://builds.tuxbuild.com/I3PT6_HS4PTt7EFgJUIPxA/kernel.config
> > 
> 
> I am seeing the same problem on x86_64
> 
> CONFIG_UPROBES is enabled in my config.

Should be fixed in the -rc2 release, sorry about that.

greg k-h
