Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EF12411BE
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgHJUcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgHJUcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:32:46 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08550C061756;
        Mon, 10 Aug 2020 13:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/neesKfvNQRJRo2TVOQugH982rXifErtdvQUIJ3WJC8=; b=P2NO+wRbRdox0RYw3nD7H9RcfU
        jbifNUwgJEmd94DT3sJuUqtqB8vIwHJO2UMPzW2vZchfpVXNaCtO5bw6aPDYVro3NJtmZ/57GvKL9
        BV4ZDCyJ1cX6ND8uI8leTzP+moGIo5h9b7XxoQ9v2t9xNW7mnVM/ozjHPrhqYmSy10WYpMiGU700y
        3Ntw555yFv67/ypIa0c9Ogq43bFYyYIPJSLCYXKkFby9es0YisY9oqtSW0rOYujSGaADrVdm/XAyA
        VBGYAKEL4myRWCCg3XzX2TvJrs20oaYhDUz3ctSr+y9rF6ee2JjfdPe2Ede6SPjnSKl9BNmCEs5sR
        WiJ7Z/Fw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5ETK-0000Qm-FU; Mon, 10 Aug 2020 20:32:42 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BEA77980D39; Mon, 10 Aug 2020 22:32:40 +0200 (CEST)
Date:   Mon, 10 Aug 2020 22:32:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
Message-ID: <20200810203240.GE3982@worktop.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 02:25:48PM -0600, Jens Axboe wrote:
> On 8/10/20 2:13 PM, Jens Axboe wrote:
> >> Would it be clearer to write it like so perhaps?
> >>
> >> 	/*
> >> 	 * Optimization; when the task is RUNNING we can do with a
> >> 	 * cheaper TWA_RESUME notification because,... <reason goes
> >> 	 * here>. Otherwise do the more expensive, but always correct
> >> 	 * TWA_SIGNAL.
> >> 	 */
> >> 	if (READ_ONCE(tsk->state) == TASK_RUNNING) {
> >> 		__task_work_notify(tsk, TWA_RESUME);
> >> 		if (READ_ONCE(tsk->state) == TASK_RUNNING)
> >> 			return;
> >> 	}
> >> 	__task_work_notify(tsk, TWA_SIGNAL);
> >> 	wake_up_process(tsk);
> > 
> > Yeah that is easier to read, wasn't a huge fan of the loop since it's
> > only a single retry kind of condition. I'll adopt this suggestion,
> > thanks!
> 
> Re-write it a bit on top of that, just turning it into two separate
> READ_ONCE, and added appropriate comments. For the SQPOLL case, the
> wake_up_process() is enough, so we can clean up that if/else.
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=49bc5c16483945982cf81b0109d7da7cd9ee55ed

OK, that works for me, thanks!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
