Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6897559B26A
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiHUHAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiHUHAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7578226130;
        Sun, 21 Aug 2022 00:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104A860CF5;
        Sun, 21 Aug 2022 07:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16178C433D6;
        Sun, 21 Aug 2022 07:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065211;
        bh=Jk+w6RRPYKSTK9pnvnj/GWadQ00NplT6eFMPA3t59qE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wlDPPkfgHLjTZlMv+CIpu39kdkGOM5+vtYAVv+wmOyD+5/WDzDYO9BajZ3o3vRoum
         utIZOFZVlXbkFNBQ3vz9t6t2qKs4LfvQbG3t4mHAeHe/Mvt0nATCl2aQibA36JaLVd
         9gkqFZHw+wdv33316NLq7+1dQ6RMzf4CuKkxxw+0=
Date:   Sat, 20 Aug 2022 20:09:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fangrui Song <maskray@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 001/545] Makefile: link with -z noexecstack
 --no-warn-rwx-segments
Message-ID: <YwEjcKBOd8t/3JFw@kroah.com>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153829.220984987@linuxfoundation.org>
 <CAKwvOdmu72iN8NE3dbCaoWNf9mbr9UcRAzmRgezRsKsWmT5xJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmu72iN8NE3dbCaoWNf9mbr9UcRAzmRgezRsKsWmT5xJg@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 10:14:51AM -0700, Nick Desaulniers wrote:
> On Fri, Aug 19, 2022 at 8:46 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Nick Desaulniers <ndesaulniers@google.com>
> >
> > commit 0d362be5b14200b77ecc2127936a5ff82fbffe41 upstream.
> >
> > Users of GNU ld (BFD) from binutils 2.39+ will observe multiple
> > instances of a new warning when linking kernels in the form:
> >
> >   ld: warning: vmlinux: missing .note.GNU-stack section implies executable stack
> >   ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> >   ld: warning: vmlinux has a LOAD segment with RWX permissions
> >
> > Generally, we would like to avoid the stack being executable.  Because
> > there could be a need for the stack to be executable, assembler sources
> > have to opt-in to this security feature via explicit creation of the
> > .note.GNU-stack feature (which compilers create by default) or command
> > line flag --noexecstack.  Or we can simply tell the linker the
> > production of such sections is irrelevant and to link the stack as
> > --noexecstack.
> >
> > LLVM's LLD linker defaults to -z noexecstack, so this flag isn't
> > strictly necessary when linking with LLD, only BFD, but it doesn't hurt
> > to be explicit here for all linkers IMO.  --no-warn-rwx-segments is
> > currently BFD specific and only available in the current latest release,
> > so it's wrapped in an ld-option check.
> >
> > While the kernel makes extensive usage of ELF sections, it doesn't use
> > permissions from ELF segments.
> >
> > Link: https://lore.kernel.org/linux-block/3af4127a-f453-4cf7-f133-a181cce06f73@kernel.dk/
> > Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ba951afb99912da01a6e8434126b8fac7aa75107
> > Link: https://github.com/llvm/llvm-project/issues/57009
> > Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
> > Suggested-by: Fangrui Song <maskray@google.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  Makefile |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -983,6 +983,11 @@ KBUILD_CFLAGS   += $(KCFLAGS)
> >  KBUILD_LDFLAGS_MODULE += --build-id=sha1
> >  LDFLAGS_vmlinux += --build-id=sha1
> >
> > +KBUILD_LDFLAGS += -z noexecstack
> > +ifeq ($(CONFIG_LD_IS_BFD),y)
> > +KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
> > +endif
> 
> 5.10.y is missing CONFIG_LD_IS_BFD. Specifically
> 
> commit 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
> which first landed in v5.12-rc1.  I'd recommend simply dropping the
> `ifeq` guards; the ld-option guard will still work.  Otherwise GNU BFD
> 2.39 users will observe linker warnings related to rwx-segments.
> 
> Greg, do you mind dropping this patch and I'll supply a v2, or is it
> too late and I should send a patch on top?

I've fixed it up, thanks!

greg k-h
