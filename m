Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25891C8864
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEGLfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 07:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgEGLfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 07:35:09 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60D3C05BD43;
        Thu,  7 May 2020 04:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S7/JCtjp/SFUzAPa+/rhOyd9q2ucCeuwYbzZwtk3H3w=; b=ZRgcchoyg6EsthP9pkro1DG0Nd
        f7Gtmf+9Shucas54O6gS/KuQTS8EQrU7opCy8i9yZDOyQ5up59Z3yP3cPxL6RA/IAtfmMlWfEFoZd
        B1jCZIJeAvtsrjFuujNO7MnhzQk8K32l+XVvRyYTm/Nq3YEAdxn3P9831zP5Eh/2Zaoq+4QS5fbNJ
        gKlxe5KsI/vJkstVx81c0RwvkLGjSeHAfwuGDRYCTwD5NfR0LRuNtOHrogJO9c/UG/s4MHI4GZaqc
        zc8wy5g95ZFNJUWneDKJdBKq6FLcGr5Uyl8OkwCcJ+5zuVdLlMrbl+v+9Ma0xZabnob/hU6+VHHzU
        8CBkhYTQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWenK-0007kR-AC; Thu, 07 May 2020 11:34:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 22976303DA8;
        Thu,  7 May 2020 13:34:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 00BCA2B51366A; Thu,  7 May 2020 13:34:22 +0200 (CEST)
Date:   Thu, 7 May 2020 13:34:22 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     hpa@zytor.com
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Ilie Halip <ilie.halip@gmail.com>, x86@kernel.org,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Daniel Axtens <dja@axtens.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86: bitops: fix build regression
Message-ID: <20200507113422.GA3762@hirez.programming.kicks-ass.net>
References: <20200505174423.199985-1-ndesaulniers@google.com>
 <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A776DBC-03AF-485B-9AA6-5920E3C4ACB2@zytor.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 11:07:24AM -0700, hpa@zytor.com wrote:
> On May 5, 2020 10:44:22 AM PDT, Nick Desaulniers <ndesaulniers@google.com> wrote:

> >@@ -54,7 +54,7 @@ arch_set_bit(long nr, volatile unsigned long *addr)
> > 	if (__builtin_constant_p(nr)) {
> > 		asm volatile(LOCK_PREFIX "orb %1,%0"
> > 			: CONST_MASK_ADDR(nr, addr)
> >-			: "iq" (CONST_MASK(nr) & 0xff)
> >+			: "iq" ((u8)(CONST_MASK(nr) & 0xff))
> > 			: "memory");
> > 	} else {
> > 		asm volatile(LOCK_PREFIX __ASM_SIZE(bts) " %1,%0"
> >@@ -74,7 +74,7 @@ arch_clear_bit(long nr, volatile unsigned long *addr)
> > 	if (__builtin_constant_p(nr)) {
> > 		asm volatile(LOCK_PREFIX "andb %1,%0"
> > 			: CONST_MASK_ADDR(nr, addr)
> >-			: "iq" (CONST_MASK(nr) ^ 0xff));
> >+			: "iq" ((u8)(CONST_MASK(nr) ^ 0xff)));
> > 	} else {
> > 		asm volatile(LOCK_PREFIX __ASM_SIZE(btr) " %1,%0"
> > 			: : RLONG_ADDR(addr), "Ir" (nr) : "memory");
> 
> Drop & 0xff and change ^ 0xff to ~.

But then we're back to sparse being unhappy, no? The thing with ~ is
that it will set high bits which will be truncated, which makes sparse
sad.
