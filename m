Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501AE4978DD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 07:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbiAXGT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 01:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241551AbiAXGT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 01:19:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA3C06173B;
        Sun, 23 Jan 2022 22:19:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE3E60FA2;
        Mon, 24 Jan 2022 06:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AD5C340E1;
        Mon, 24 Jan 2022 06:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643005167;
        bh=nPNbP8694jK2hGU0MGv+hETbDJ1UjxCjyewKjVw2DuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BpGyY2uzKZcgIswCo896tcGOjc01klnFBZ/HPOW5u3btVHvsjeh+nFfJ2jr8tA5N6
         XIpYxArtgNYjKegnCvA4G63jz8e7LU4H8GrAj9DxAOJZHTiFHvbDrpzt2FR+Hu7e0w
         1IDhZ+KhOg8REByh+uflFGsd7SqfF1CYNlM+3/YY=
Date:   Mon, 24 Jan 2022 07:19:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Watson <davejwatson@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Ben Maurer <bmaurer@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Joel Fernandes <joelaf@google.com>
Subject: Re: [RFC PATCH] rseq: Fix broken uapi field layout on 32-bit little
 endian
Message-ID: <Ye5E46FrGwjlQlps@kroah.com>
References: <20220123193154.14565-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123193154.14565-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 23, 2022 at 02:31:54PM -0500, Mathieu Desnoyers wrote:
> The rseq rseq_cs.ptr.{ptr32,padding} uapi endianness handling is
> entirely wrong on 32-bit little endian: a preprocessor logic mistake
> wrongly uses the big endian field layout on 32-bit little endian
> architectures.
> 
> Fortunately, those ptr32 accessors were never used within the kernel,
> and only meant as a convenience for user-space.
> 
> While working on fixing the ppc32 support in librseq [1], I made sure
> all 32-bit little endian architectures stopped depending on little
> endian byte ordering by using the ptr32 field. It led me to discover
> this wrong ptr32 field ordering on little endian.
> 
> Because it is already exposed as a UAPI, all we can do for the existing
> fields is document the wrong behavior and encourage users to use
> alternative mechanisms.
> 
> Introduce a new rseq_cs.arch field with correct field ordering. Use this
> opportunity to improve the layout so accesses to architecture fields on
> both 32-bit and 64-bit architectures are done through the same field
> hierarchy, which is much nicer than the previous scheme.
> 
> The intended use is now:
> 
> * rseq_thread_area->rseq_cs.ptr64: Access the 64-bit value of the rseq_cs
> 				   pointer. Available on all
>                                    architectures (unchanged).
> 
> * rseq_thread_area->rseq_cs.arch.ptr: Access the architecture specific
> 				      layout of the rseq_cs pointer. This
> 				      is a 32-bit field on 32-bit
> 				      architectures, and a 64-bit field on
>                                       64-bit architectures.
> 
> Link: https://git.kernel.org/pub/scm/libs/librseq/librseq.git/ [1]
> Fixes: ec9c82e03a74 ("rseq: uapi: Declare rseq_cs field as union, update includes")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Florian Weimer <fw@deneb.enyo.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-api@vger.kernel.org
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Dave Watson <davejwatson@fb.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Ben Maurer <bmaurer@fb.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Joel Fernandes <joelaf@google.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> ---
>  include/uapi/linux/rseq.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
