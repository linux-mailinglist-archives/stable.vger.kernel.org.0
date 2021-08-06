Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6933E22A3
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 06:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhHFEew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 00:34:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhHFEei (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 00:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCAEF611C5;
        Fri,  6 Aug 2021 04:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628224459;
        bh=EolTbqTcuTIUW+jVDkYB935Z3TTEyaZ+u+VLSLIrw4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iKcNBC8pCGifMlS34e3N+o69+5grs5j3qwjvkyWi3u/WpmY2c/gB/Dg+wG9fBSS8R
         ulrU65e7Y/hN6ZOqJ6dzvRKS+DNsjCN3Uub9ljeFBZ8woiJwY8A9K8UqwudSSb8bK7
         m09yXczF2L3ZiBZL8LAuamIlu7KNKkICwmLkR+Dw=
Date:   Fri, 6 Aug 2021 06:34:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>,
        kernel test robot <lkp@intel.com>,
        clang-built-linux@googlegroups.com, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-4.19.y 1181/1498] ERROR:
 "__compiletime_assert_491" [drivers/gpu/drm/i915/i915.ko] undefined!
Message-ID: <YQy7yY+/+r4X/5v6@kroah.com>
References: <202108060412.oMqAe0rc-lkp@intel.com>
 <CAKwvOdk6PNK1unJ2Yym4WHV=AXjdYwEyfWf_fPxO013ZtJa6Yw@mail.gmail.com>
 <YQx+HjjUrzIEkG/O@Ryzen-9-3900X.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQx+HjjUrzIEkG/O@Ryzen-9-3900X.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 05, 2021 at 05:11:10PM -0700, Nathan Chancellor wrote:
> On Thu, Aug 05, 2021 at 04:23:40PM -0700, Nick Desaulniers wrote:
> > On Thu, Aug 5, 2021 at 1:24 PM kernel test robot <lkp@intel.com> wrote:
> > >
> > > Hi Nick,
> > >
> > > First bad commit (maybe != root cause):
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > head:   7457eed4b647560ae1b1800c295efc5f1db22e4b
> > > commit: 7c29fd831799d09474dfdae556207b7102647a45 [1181/1498] lib/string.c: implement stpcpy
> > > config: x86_64-randconfig-r024-20210805 (attached as .config)
> > > compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 31a71a393f65d9e07b5b0756fef9dd16690950ee)
> > > reproduce (this is a W=1 build):
> > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > >         chmod +x ~/bin/make.cross
> > >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=7c29fd831799d09474dfdae556207b7102647a45
> > >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >         git fetch --no-tags linux-stable-rc linux-4.19.y
> > >         git checkout 7c29fd831799d09474dfdae556207b7102647a45
> > >         # save the attached .config to linux build tree
> > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
> > >
> > > If you fix the issue, kindly add following tag as appropriate
> > > Reported-by: kernel test robot <lkp@intel.com>
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > > >> ERROR: "__compiletime_assert_491" [drivers/gpu/drm/i915/i915.ko] undefined!
> > 
> > ^ I'm actively trying to improve these diagnostics in LLVM at the
> > moment. Hopefully that will make this report clearer!
> > https://reviews.llvm.org/D106030
> 
> It does help :)
> 
> drivers/gpu/drm/i915/intel_engine_cs.c:466:2: error: call to '__compiletime_assert_491' declared with attribute error: BUILD_BUG_ON failed: (execlists_num_ports(execlists)) == 0 || (((execlists_num_ports(execlists)) & ((execlists_num_ports(execlists)) - 1)) != 0)
>         BUILD_BUG_ON_NOT_POWER_OF_2(execlists_num_ports(execlists));
>         ^
> include/linux/build_bug.h:21:2: note: expanded from macro 'BUILD_BUG_ON_NOT_POWER_OF_2'
>         BUILD_BUG_ON((n) == 0 || (((n) & ((n) - 1)) != 0))
>         ^
> include/linux/build_bug.h:69:2: note: expanded from macro 'BUILD_BUG_ON'
>         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>         ^
> include/linux/build_bug.h:45:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
> #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                     ^
> note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
> include/linux/compiler.h:336:2: note: expanded from macro '_compiletime_assert'
>         __compiletime_assert(condition, msg, prefix, suffix)
>         ^
> include/linux/compiler.h:329:4: note: expanded from macro '__compiletime_assert'
>                         prefix ## suffix();                             \
>                         ^
> <scratch space>:83:1: note: expanded from here
> __compiletime_assert_491
> ^
> 4 warnings and 1 error generated.
> 
> As it turns out, this has come up before and it was fixed by commit
> 410ed5731a65 ("drm/i915: Ensure intel_engine_init_execlist() builds with
> Clang").
> 
> Greg and Sasha, could this be picked up for 4.19?

Now queued up, thanks.

greg k-h
