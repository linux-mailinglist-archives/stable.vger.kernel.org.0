Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E083C198C
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 21:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGHTFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 15:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHTFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 15:05:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2187F61879;
        Thu,  8 Jul 2021 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625770938;
        bh=YWKy4W4SxAg5wfYnEiyQ/Un7SdESpTm6i4mxrhAJBDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gAmcZDC6Y4w0Zw5xY2rDQ0JaeDJkTPu/JbOyGVlooU+7f31JGYfhoGvwGrMy40mJo
         9YRjnezGBDFkUQT3/hr4WOu1z08GtgGSEva9lBQwNR38y7TpeXzh8ZmOO1j6DB1rMZ
         JdrP/+RuaraR1jut4Ikl9QH0Wl51kXbac3up5L0I=
Date:   Thu, 8 Jul 2021 21:02:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     kernel test robot <lkp@intel.com>,
        Andy Lutomirski <luto@kernel.org>, kbuild-all@lists.01.org,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/entry: Fix noinstr violation
Message-ID: <YOdLuAL6rRDzMPDX@kroah.com>
References: <202106291306.0c9aeGFw-lkp@intel.com>
 <87a6mxorjp.ffs@nanos.tec.linutronix.de>
 <87y2agodn9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2agodn9.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 08, 2021 at 08:37:30PM +0200, Thomas Gleixner wrote:
> On Thu, Jul 08 2021 at 15:37, Thomas Gleixner wrote:
> > The recent commit which fixed the entry/exit mismatch on failed 32-bit
> > syscalls got the ordering vs. instrumentation_end() wrong, which makes
> > objtool complain about tracer invocation in an instrumentation disabled
> > region.
> >
> > Stick the offending local_irq_disable() into the instrumentation enabled
> > region so objtool stops complaining.
> >
> > Fixes: 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls")
> 
> Bah. I looked at the wrong branch. It's fixed already in Linus tree:
> 
> commit 240001d4e3041832e8a2654adc3ccf1683132b92
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Mon Jun 21 13:12:34 2021 +0200
> 
>     x86/entry: Fix noinstr fail in __do_fast_syscall_32()
> 
> Though that lacks a CC: stable tag, which would have been appropriate
> because 5d5675df792f ("x86/entry: Fix entry/exit mismatch on failed fast
> 32-bit syscalls") has been backported.
> 
> Can the stable folks pick this up please?

It's already in 5.10.47 and 5.12.14.  Does it need to go further back to
older kernels?

thanks,

greg k-h
