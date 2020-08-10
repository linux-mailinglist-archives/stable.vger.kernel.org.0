Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B468824091D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHJP3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgHJP25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 11:28:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEABAC061756;
        Mon, 10 Aug 2020 08:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=Gxr9Wg9+yp2z13ZJTC6Dw97Pj6/kna+6WtFiBzohkno=; b=JZhwJYJJi0HJ+Matj3JwxdHq4T
        Nh62m9VTnl5pOLSKA3wPSfTOPVeNihvFYJGmhp/3MEiCyNO7DwVbSzTovrCvLG3SMe2Cqx2vQ8W9i
        KDRG05zQfojO+sCH+QYH1u3s6uKvEX5WNNw3Z/mjr1uE0niosmUG5f0rA7PQbyjQPuFsrdGuUz+c0
        g4VBRqfKwTxcZPSQYsV4quKOYvYLFfG8RtJA9yxpbSztmS+Sr6Ej+hUMORVRfsMt+tyAMoI3vflMU
        Rpwl+d8jAfyK9H7NJHYFX+mKL63VIwkLrepyF0LBLnFXhYZyGmB4fwpxw/dBvOEUkDhcctyyzvwjk
        xwR3hvag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k59jL-0006oH-9L; Mon, 10 Aug 2020 15:28:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 58BE930797C;
        Mon, 10 Aug 2020 17:28:54 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4AA582BB8FCE9; Mon, 10 Aug 2020 17:28:54 +0200 (CEST)
Date:   Mon, 10 Aug 2020 17:28:54 +0200
From:   peterz@infradead.org
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel: split task_work_add() into two separate
 helpers
Message-ID: <20200810152854.GA2674@hirez.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-2-axboe@kernel.dk>
 <20200810113740.GR2674@hirez.programming.kicks-ass.net>
 <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 09:01:02AM -0600, Jens Axboe wrote:

> >> +struct callback_head work_exited = {
> >> +	.next = NULL	/* all we need is ->next == NULL */
> >> +};
> > 
> > Would it make sense to make this const ? Esp. with the thing exposed,
> > sticking it in R/O memory might avoid a mistake somewhere.
> 
> That was my original intent, but that makes 'head' in task_work_run()
> const as well, and cmpxchg() doesn't like that:
> 
> kernel/task_work.c: In function ‘task_work_run’:
> ./arch/x86/include/asm/cmpxchg.h:89:29: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
>    89 |  __typeof__(*(ptr)) __new = (new);    \
>       |                             ^
> ./arch/x86/include/asm/cmpxchg.h:134:2: note: in expansion of macro ‘__raw_cmpxchg’
>   134 |  __raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
>       |  ^~~~~~~~~~~~~
> ./arch/x86/include/asm/cmpxchg.h:149:2: note: in expansion of macro ‘__cmpxchg’
>   149 |  __cmpxchg(ptr, old, new, sizeof(*(ptr)))
>       |  ^~~~~~~~~
> ./include/asm-generic/atomic-instrumented.h:1685:2: note: in expansion of macro ‘arch_cmpxchg’
>  1685 |  arch_cmpxchg(__ai_ptr, __VA_ARGS__);    \
>       |  ^~~~~~~~~~~~
> kernel/task_work.c:126:12: note: in expansion of macro ‘cmpxchg’
>   126 |   } while (cmpxchg(&task->task_works, work, head) != work);
>       |            ^~~~~~~
> 
> which is somewhat annoying. Because there's really no good reason why it
> can't be const, it'll just require the changes to dig a bit deeper.

Bah! Best I can come up with is casting the const away there, what a
mess :-(
