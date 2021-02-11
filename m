Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC225318D67
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhBKO3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 09:29:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhBKO1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 09:27:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B9D64ECF;
        Thu, 11 Feb 2021 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613053398;
        bh=WChxGIvOv+ddcZNCBGS3FZQ5DthPIh0PppyDsv4OSwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pGbsbtF5uCfynxoTbW0yIUqgt/y2MfVu3Yj7jN7H8AocFuhkHbVt1jhvagkwXB4Rq
         Cs4FRKkJOHNxWL/whCnEIhElr6HuqJA7i7EEH7ehRLgow3ss2lHJq+++FAUyZUMHdk
         gcgtAkVGEtn2vz8M0WkqKxu3/wyMcZnTIdgMoeTQ=
Date:   Thu, 11 Feb 2021 15:23:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] lkdtm: don't move ctors to .rodata
Message-ID: <YCU9zoiw8EZktw5U@kroah.com>
References: <20201207170533.10738-1-mark.rutland@arm.com>
 <202012081319.D5827CF@keescook>
 <X9DkdTGAiAEfUvm5@kroah.com>
 <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161300376813.1254594.5196098885798133458@swboyd.mtv.corp.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 04:36:08PM -0800, Stephen Boyd wrote:
> Quoting Greg Kroah-Hartman (2020-12-09 06:51:33)
> > On Tue, Dec 08, 2020 at 01:20:56PM -0800, Kees Cook wrote:
> > > On Mon, Dec 07, 2020 at 05:05:33PM +0000, Mark Rutland wrote:
> > > > When building with KASAN and LKDTM, clang may implictly generate an
> > > > asan.module_ctor function in the LKDTM rodata object. The Makefile moves
> > > > the lkdtm_rodata_do_nothing() function into .rodata by renaming the
> > > > file's .text section to .rodata, and consequently also moves the ctor
> > > > function into .rodata, leading to a boot time crash (splat below) when
> > > > the ctor is invoked by do_ctors().
> > > > 
> > > > Let's prevent this by marking the function as noinstr rather than
> > > > notrace, and renaming the file's .noinstr.text to .rodata. Marking the
> > > > function as noinstr will prevent tracing and kprobes, and will inhibit
> > > > any undesireable compiler instrumentation.
> > > > 
> > > > The ctor function (if any) will be placed in .text and will work
> > > > correctly.
> > > > 
> > > > Example splat before this patch is applied:
> > > > 
> > > > [    0.916359] Unable to handle kernel execute from non-executable memory at virtual address ffffa0006b60f5ac
> > > > [    0.922088] Mem abort info:
> > > > [    0.922828]   ESR = 0x8600000e
> > > > [    0.923635]   EC = 0x21: IABT (current EL), IL = 32 bits
> > > > [    0.925036]   SET = 0, FnV = 0
> > > > [    0.925838]   EA = 0, S1PTW = 0
> > > > [    0.926714] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000427b3000
> > > > [    0.928489] [ffffa0006b60f5ac] pgd=000000023ffff003, p4d=000000023ffff003, pud=000000023fffe003, pmd=0068000042000f01
> > > > [    0.931330] Internal error: Oops: 8600000e [#1] PREEMPT SMP
> > > > [    0.932806] Modules linked in:
> > > > [    0.933617] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.10.0-rc7 #2
> > > > [    0.935620] Hardware name: linux,dummy-virt (DT)
> > > > [    0.936924] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> > > > [    0.938609] pc : asan.module_ctor+0x0/0x14
> > > > [    0.939759] lr : do_basic_setup+0x4c/0x70
> > > > [    0.940889] sp : ffff27b600177e30
> > > > [    0.941815] x29: ffff27b600177e30 x28: 0000000000000000
> > > > [    0.943306] x27: 0000000000000000 x26: 0000000000000000
> > > > [    0.944803] x25: 0000000000000000 x24: 0000000000000000
> > > > [    0.946289] x23: 0000000000000001 x22: 0000000000000000
> > > > [    0.947777] x21: ffffa0006bf4a890 x20: ffffa0006befb6c0
> > > > [    0.949271] x19: ffffa0006bef9358 x18: 0000000000000068
> > > > [    0.950756] x17: fffffffffffffff8 x16: 0000000000000000
> > > > [    0.952246] x15: 0000000000000000 x14: 0000000000000000
> > > > [    0.953734] x13: 00000000838a16d5 x12: 0000000000000001
> > > > [    0.955223] x11: ffff94000da74041 x10: dfffa00000000000
> > > > [    0.956715] x9 : 0000000000000000 x8 : ffffa0006b60f5ac
> > > > [    0.958199] x7 : f9f9f9f9f9f9f9f9 x6 : 000000000000003f
> > > > [    0.959683] x5 : 0000000000000040 x4 : 0000000000000000
> > > > [    0.961178] x3 : ffffa0006bdc15a0 x2 : 0000000000000005
> > > > [    0.962662] x1 : 00000000000000f9 x0 : ffffa0006bef9350
> > > > [    0.964155] Call trace:
> > > > [    0.964844]  asan.module_ctor+0x0/0x14
> > > > [    0.965895]  kernel_init_freeable+0x158/0x198
> > > > [    0.967115]  kernel_init+0x14/0x19c
> > > > [    0.968104]  ret_from_fork+0x10/0x30
> > > > [    0.969110] Code: 00000003 00000000 00000000 00000000 (00000000)
> > > > [    0.970815] ---[ end trace b5339784e20d015c ]---
> > > > 
> > > > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > > 
> > > Oh, eek. Why was a ctor generated at all? But yes, this looks good.
> > > Greg, can you pick this up please?
> > > 
> > > Acked-by: Kees Cook <keescook@chromium.org>
> > 
> > Now picked up, thanks.
> > 
> 
> Can this be backported to 5.4 and 5.10 stable trees? I just ran across
> this trying to use kasan on 5.4 with lkdtm and it blows up early. This
> patch applies on 5.4 cleanly but doesn't compile because it's missing
> noinstr. Here's a version of the patch that introduces noinstr on 5.4.97
> so this patch can be picked to 5.4 stable trees.

Why 5.10?  This showed up in 5.8, so how would it be needed there?

confused,

greg k-h
