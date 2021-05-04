Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918A037272E
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 10:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhEDI05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 04:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhEDI05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 04:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A0E06023C;
        Tue,  4 May 2021 08:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620116762;
        bh=94XzKzc+hp6yHkT0RPZQKGsi3EMY3XkGe6WVNcpCIHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yxz+v7dZfQJcDbkVKGLt50iXaCkWfjeY8CbbDidn4HFIKh7EwYDZyGwPVpIAexzGs
         HZE1D1kfL7m0TtdZkHoV5Wme2tNjk25peulUflIhnytPCVj76CjFypwIBOp5NFK2WU
         Msi095wXqGM9u0+K+0zMdmNeXEFtzRYJi2tA2mI0=
Date:   Tue, 4 May 2021 10:25:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Sasha Levin <sashal@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable:linux-5.4.y 5541/6083] ERROR: "__memcat_p"
 [drivers/hwtracing/stm/stm_core.ko] undefined!
Message-ID: <YJEFF1iHZ4o7LUgV@kroah.com>
References: <202105030311.xWwkyV9z-lkp@intel.com>
 <CAK8P3a0ZdZY94KVwF-C_t+7rx=iHC60ty52AQAmc1VDZwsn9Rw@mail.gmail.com>
 <CAKwvOdmCmvHNpyjNtNU1OeSzK_E_9n9T4CPiFGD7K_JuJDOj-w@mail.gmail.com>
 <CAK8P3a3KLasm-CdcM3HCP6EZO1Vr0ay17jw7zSy0btqPr32WRg@mail.gmail.com>
 <YJDQ0ePGHxmcB7dX@kroah.com>
 <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a30xJ1+zrCC4fk+q9xzLspHuE4VM0UHSWiU3-iFeNN+6g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 09:41:14AM +0200, Arnd Bergmann wrote:
> On Tue, May 4, 2021 at 6:43 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, May 03, 2021 at 09:16:42PM +0200, Arnd Bergmann wrote:
> > > On Mon, May 3, 2021 at 7:00 PM 'Nick Desaulniers' via Clang Built
> > > Linux <clang-built-linux@googlegroups.com> wrote:
> > > > > > >> ERROR: "__memcat_p" [drivers/hwtracing/stm/stm_core.ko] undefined!
> > > > >
> > > > > I'm fairly sure this is unrelated to my patch, but I don't see what
> > > > > happened here.
> > > >
> > > > It's unrelated to your patch. It was fixed in 5.7 by
> > > > 7273ad2b08f8ac9563579d16a3cf528857b26f49 and a few other dependencies
> > > > according to https://github.com/ClangBuiltLinux/linux/issues/515.
> > > >
> > >
> > > Ah right, the big hammer.
> > >
> > > Greg, not sure what we want to do here. Backporting
> > >
> > > 7273ad2b08f8 ("kbuild: link lib-y objects to vmlinux forcibly when
> > > CONFIG_MODULES=y")
> > >
> > > to v5.4 and earlier would be an easy workaround, but it has the potential
> > > of adding extra bloat to the kernel image since it links in all other
> > > library objects as well.
> >
> > I've lost the thread here, but what _real_ problem is happening here
> > that doing the above is required?
> 
> Randconfig builds fail if drivers/hwtracing/stm/stm_core.ko is a loadable
> modules and nothing inside vmlinux forces lib/memcat_p.o to be
> linked in. A simpler workaround for v5.4 would be:
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index a5c5f342ade0..745d1207e9e2 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -33,7 +33,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>          flex_proportions.o ratelimit.o show_mem.o \
>          is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>          earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
> -        nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o \
> +        nmi_backtrace.o nodemask.o win_minmax.o \
>          buildid.o
> 
>  lib-$(CONFIG_PRINTK) += dump_stack.o
> @@ -48,7 +48,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
>          bsearch.o find_bit.o llist.o memweight.o kfifo.o \
>          percpu-refcount.o rhashtable.o \
>          once.o refcount.o usercopy.o errseq.o bucket_locks.o \
> -        generic-radix-tree.o
> +        generic-radix-tree.o memcat_p.o
>  obj-$(CONFIG_STRING_SELFTEST) += test_string.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
> 
> which is the same as what 7273ad2b08f8 does, but only for this one file
> instead of all of lib/*.o.

I think a "one off" change would be best here.  Can you submit it?

thanks,

greg k-h
