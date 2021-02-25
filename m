Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B03324BF3
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhBYIWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhBYIWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 03:22:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED4064F06;
        Thu, 25 Feb 2021 08:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614241325;
        bh=bJy0KIkD4/X7cHM6wylB/CG7wpq451bD4qyVOaqPznw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EyMI0p9e7z/2Xluk9/Oz1kL9FfcuhCaOo83DGqkXX2siZAImqbboRCrHzpOkOYirH
         SHOcnEVktl2pIxi5F53j6Whjy6yF3TW8IIWaIUISEygNg7YT5d4CQysO5fO3HpigJO
         6rouTwZmedJ/pzpaTB22n0FefZoPjeBBFd5IULDg=
Date:   Thu, 25 Feb 2021 09:22:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        kernel test robot <lkp@intel.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [linux-stable-rc:linux-5.4.y 2231/4843] ERROR: "__memcat_p"
 undefined!
Message-ID: <YDdeKz8cZOyZ5q6m@kroah.com>
References: <202102151855.H817KoOF-lkp@intel.com>
 <CAKwvOdmqso8SmPeZ4tOLP-wFSbkkDAthG1vt6k045_C0JoU4Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmqso8SmPeZ4tOLP-wFSbkkDAthG1vt6k045_C0JoU4Rg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 11:56:29AM -0800, Nick Desaulniers wrote:
> On Mon, Feb 15, 2021 at 2:49 AM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Nick,
> >
> > First bad commit (maybe != root cause):
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > head:   642aa3284e09f63bf1d4832798dd787b4320ca64
> > commit: f05f667f8764f9ec834ca3e412ed7f5a20dea3bf [2231/4843] lib/string.c: implement stpcpy
> > config: x86_64-randconfig-a005-20210215 (attached as .config)
> > compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c9439ca36342fb6013187d0a69aef92736951476)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install x86_64 cross compiling tool for clang build
> >         # apt-get install binutils-x86-64-linux-gnu
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=f05f667f8764f9ec834ca3e412ed7f5a20dea3bf
> >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >         git fetch --no-tags linux-stable-rc linux-5.4.y
> >         git checkout f05f667f8764f9ec834ca3e412ed7f5a20dea3bf
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> > >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!
> 
> This error is unrelated to the referenced commit, but we did fix this
> error finally in 5.7:
> https://github.com/ClangBuiltLinux/linux/issues/515. This is not a
> regression, but something that never worked with LLD until 5.7.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7273ad2b08f8ac9563579d16a3cf528857b26f49
> looks like the commit of interest, though I seem to have left a
> comment implying there were dependencies:
> https://github.com/ClangBuiltLinux/linux/issues/515#issuecomment-612999929
> (I no longer recall what they were).
> 
> Some other commits in tree reference that bug from the issue tracker.
> https://github.com/0day-ci/linux/commit/0cf9baa2dbb8ca29f30ac8a1afb69de51f222d17
> https://github.com/0day-ci/linux/commit/565508bb949dd72638b52522fb6ac6ec04ec57fc
> https://github.com/0day-ci/linux/commit/0d0537aa772566473bd5310be3874060cbff8672
> 
> Not sure whether all 4 of the above worth backporting to 4.4.y?
> Thoughts? (Perhaps these would allow us to add x86_64 allmodconfig CI
> coverage with LLD for 4.4.y)

If someone wants to backport them to 4.4.y, please feel free to submit
it!

thanks,

greg k-h
