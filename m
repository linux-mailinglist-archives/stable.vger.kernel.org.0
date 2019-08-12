Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF898A568
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 20:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfHLSKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 14:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfHLSKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 14:10:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594E52067D;
        Mon, 12 Aug 2019 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565633400;
        bh=ILnj6kPDUnzY5ixHdPSfrLLMfvvQssQWfSVFfuwlzUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAVxM2ecyVaX+A6MtdaBhEdeQQe2vjUUJkK9TI9nC/gYf91poc4RLf7DKFZcpn2lb
         m6CgfqFUXSjzunGSs1kA0POztOgvfbM/37aTtEa7C58UyGIzUSE7F5mTISMW5SCYYf
         +6IeuofZ6/Cnal3oMGkD6I7gD8NdU1wcYK+3VhFE=
Date:   Mon, 12 Aug 2019 20:09:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, kbuild@01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: Re: [stable:linux-4.14.y 8386/9999]
 drivers/gpu/drm/i915/gvt/opregion.o: warning: objtool:
 intel_vgpu_emulate_opregion_request()+0xbe: can't find jump dest instruction
 at .text+0x6dd
Message-ID: <20190812180958.GA14905@kroah.com>
References: <201908120108.9KdVOsTD%lkp@intel.com>
 <CAKwvOd=JpUsD1XDSBzgwDWcAO+1VuGOLjbGNCTFne-WAqjGzXQ@mail.gmail.com>
 <20190812175828.GA13040@kroah.com>
 <CAKwvOd=ORE==PVaXdyUc44CsNp7bShapjaQ00Ej-UA7_r4CWSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=ORE==PVaXdyUc44CsNp7bShapjaQ00Ej-UA7_r4CWSQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 11:00:38AM -0700, Nick Desaulniers wrote:
> On Mon, Aug 12, 2019 at 10:58 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Aug 12, 2019 at 10:49:47AM -0700, Nick Desaulniers wrote:
> > > On Sun, Aug 11, 2019 at 10:08 AM kbuild test robot <lkp@intel.com> wrote:
> > > >
> > > > CC: kbuild-all@01.org
> > > > TO: Daniel Borkmann <daniel@iogearbox.net>
> > > > CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > > > CC: Thomas Gleixner <tglx@linutronix.de>
> > > >
> > > > tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> > > > head:   3ffe1e79c174b2093f7ee3df589a7705572c9620
> > > > commit: e28951100515c9fd8f8d4b06ed96576e3527ad82 [8386/9999] x86/retpolines: Disable switch jump tables when retpolines are enabled
> > > > config: x86_64-rhel-7.6 (attached as .config)
> > > > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
> > > > reproduce:
> > > >         git checkout e28951100515c9fd8f8d4b06ed96576e3527ad82
> > > >         # save the attached .config to linux build tree
> > > >         make ARCH=x86_64
> > > >
> > > > If you fix the issue, kindly add following tag
> > > > Reported-by: kbuild test robot <lkp@intel.com>
> > > >
> > > > All warnings (new ones prefixed by >>):
> > > >
> > > >    In file included from drivers/gpu/drm/i915/gvt/opregion.c:25:
> > > >    In file included from drivers/gpu/drm/i915/i915_drv.h:61:
> > > >    In file included from drivers/gpu/drm/i915/intel_uc.h:31:
> > > >    In file included from drivers/gpu/drm/i915/i915_vma.h:34:
> > > >    drivers/gpu/drm/i915/i915_gem_object.h:290:1: warning: attribute declaration must precede definition [-Wignored-attributes]
> > > >    __deprecated
> > > >    ^
> > >
> > > Was there another patch that fixes this that should have been
> > > backported to stable (4.14) along with this?
> >
> > If this is an issue on the latest 4.14.y tree, please let me know.  Look
> > at how far back this commit is before getting worried :)
> 
> patch 8386/9999 ???!!!  Were there exactly 9999 patches backported, or
> does git stop reporting after 4 digits? "4 digits ought to be enough
> for anyone!" (except GKH, it would seem ;) ).

I blame kbuild, every once in a while when it adds something new to its
system it goes off and does crazy things like this...

