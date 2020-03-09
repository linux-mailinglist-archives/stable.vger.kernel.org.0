Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F8D17E9E3
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgCIUWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:22:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCIUWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1IPYKY5i0WcOP6+Mj4yJxK/haVfh2zKAl1BsGlfBYoo=; b=nI31IECVSTE8x6hUOJdpZRMUn8
        PMBZ94A1ZJeMRVcmZcKK1/D7DCQn+99kHR7UoTYlAQQInp/PWot3vgF/mIBFNR8sBOZtyp/hzOqfh
        uRlbmZpJL9fTmFixakxdQ7VCkcuI9tQhFxhQnK2Pun61Cc6eNKcsgNppD2DMOO1QWgcMNiiSFtNZI
        opI3w1chWcm6Uh5Fz/iWXBFjxLbLQ+dmQqb+qbtWRgO+/n2bZcV0MioIGAbt3y0QHD5JAzBU+RtJT
        5ilbIDNGF566RvgE1KB1VyzJku4UxZm1i8gTMArg6REiAGEXcgKHQ4r+atYTD1DCq8M2ckTByzowl
        w0DD3IVw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBOum-0003m4-OA; Mon, 09 Mar 2020 20:22:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 35E553011E0;
        Mon,  9 Mar 2020 21:22:15 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1EF51214344E6; Mon,  9 Mar 2020 21:22:15 +0100 (CET)
Date:   Mon, 9 Mar 2020 21:22:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200309202215.GM12561@hirez.programming.kicks-ass.net>
References: <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
 <87ftek9ngq.fsf@nanos.tec.linutronix.de>
 <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de>
 <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
 <877dzu8178.fsf@nanos.tec.linutronix.de>
 <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
 <871rq199oz.fsf@nanos.tec.linutronix.de>
 <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
 <87d09l73ip.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d09l73ip.fsf@nanos.tec.linutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
> Andy Lutomirski <luto@kernel.org> writes:

> > I'm okay with the save/restore dance, I guess.  It's just yet more
> > entry crud to deal with architecture nastiness, except that this
> > nastiness is 100% software and isn't Intel/AMD's fault.
> 
> And we can do it in C and don't have to fiddle with it in the ASM
> maze.

Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if
we do the save/restore in do_nmi(). That is some wild brain melt. Also,
AFAIK none of the distros are actually shipping a PREEMPT=y kernel
anyway, so killing it shouldn't matter much.

If people want to recover that, I'd suggest they sit down and create a
sane paravirt interface for this.
