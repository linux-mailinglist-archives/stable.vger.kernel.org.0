Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F06E876409
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 13:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfGZLBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 07:01:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53124 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfGZLBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 07:01:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gW1Md4ZhXK3S0fvI55c/3Y5ClOV0sc1UfTNxtBj16RU=; b=s2c+GrUo/qdQvXNS9uOpLjrgt
        ELnrxfhUFo9I7SgXEHySGOFk4SkuYJ/Bvomv//hsGI2fSSrHI+l0e59J/Id+/3XfiCmVfqH1VgWHU
        8tp7h5gu5ux/QdL8map2mMsuUbQXMw/Ug0z03ho1xA1yMWgOr8AKckgDx1r7fIefGyXTyOJSVn3D+
        YW/Aivd7mFpY/plRfr9DeMSVvJBfBMN5DbSLvwkuzhU019DCmxknDSnGdkOUzp8aJ9PqjmNOKqSVu
        jwyJfW+Trf+39rLBomy4hvrqdZflDgpPU+PW1MxqSm4ucAIUD8CDkLF6zSIrdltytu7rff7T+AVnD
        QAeQXRy2A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqxyk-0001YW-Be; Fri, 26 Jul 2019 11:01:38 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 99614203B6360; Fri, 26 Jul 2019 13:01:35 +0200 (CEST)
Date:   Fri, 26 Jul 2019 13:01:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 079/271] x86/atomic: Fix
 smp_mb__{before,after}_atomic()
Message-ID: <20190726110135.GO31381@hirez.programming.kicks-ass.net>
References: <20190724191655.268628197@linuxfoundation.org>
 <20190724191701.954991110@linuxfoundation.org>
 <5D3AD35E.FB77B44F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D3AD35E.FB77B44F@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 01:18:06PM +0300, Jari Ruusu wrote:
> Greg Kroah-Hartman wrote:
> > [ Upstream commit 69d927bba39517d0980462efc051875b7f4db185 ]
> > 
> > Recent probing at the Linux Kernel Memory Model uncovered a
> > 'surprise'. Strongly ordered architectures where the atomic RmW
> > primitive implies full memory ordering and
> > smp_mb__{before,after}_atomic() are a simple barrier() (such as x86)
> > fail for:
> > 
> >         *x = 1;
> >         atomic_inc(u);
> >         smp_mb__after_atomic();
> >         r0 = *y;
> 
> [snip]
> 
> > --- a/arch/x86/include/asm/atomic.h
> > +++ b/arch/x86/include/asm/atomic.h
> > @@ -54,7 +54,7 @@ static __always_inline void arch_atomic_add(int i, atomic_t *v)
> >  {
> >         asm volatile(LOCK_PREFIX "addl %1,%0"
> >                      : "+m" (v->counter)
> > -                    : "ir" (i));
> > +                    : "ir" (i) : "memory");
> >  }
> > 
> >  /**
> 
> Shouldn't those clobber contraints actually be:  "memory","cc"
> That is because addl subl (and other) machine instructions
> actually modify the flags register too.
> 
> gcc docs say: The "cc" clobber indicates that the assembler
> code modifies the flags register.

GCC x86 assumes any asm() will clobber "cc".
