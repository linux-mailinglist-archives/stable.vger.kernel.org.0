Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20AC4A31E
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 15:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbfFRN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 09:59:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbfFRN7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 09:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5rihIar1qARykSREZLm4vtBN9o2tMlTetAcfWA8C5Pg=; b=G/bPQ2SfD5W8WwEs50dsV84QH
        luA+t3KYCMVhr+OTY5J+zq8rrkyp82y6BhNPTfeq1VDMHBpR4fnHGHbcNDWCfjpwjcVKmUyDbHJvF
        0eI5wxRLkbZRlNX+0ZbqIsOorFvwLQwFIs9gClJcAxZo9qFrk1qlAcVfP6ZUhSb9hivNmAWbyEIsJ
        EgwJ6e3vsYu9d7/ILw0/PD0HrCO4Ful90hpav9urzv2l0LVTeCxswlvQ/flmRtuqKriJNNZZZV6A3
        kR5n1py+UDomYG56aJR5BUVntIL+VK+C7f7l/fbGS7ISI5lBtCavAyJwwqN7g8nVgAYBU1g/uudYL
        hNHZE99DA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdEdl-0003G9-K5; Tue, 18 Jun 2019 13:59:13 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9D2DF20A4A686; Tue, 18 Jun 2019 15:59:11 +0200 (CEST)
Date:   Tue, 18 Jun 2019 15:59:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
Message-ID: <20190618135911.GR3436@hirez.programming.kicks-ass.net>
References: <20190617123109.667090-1-arnd@arndb.de>
 <20190617140210.GB3436@hirez.programming.kicks-ass.net>
 <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
 <fc10bc69-0628-59eb-c243-9cd1dd3b47a4@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc10bc69-0628-59eb-c243-9cd1dd3b47a4@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 18, 2019 at 04:27:45PM +0300, Andrey Ryabinin wrote:
> 
> 
> On 6/18/19 3:56 PM, Arnd Bergmann wrote:
> > On Mon, Jun 17, 2019 at 4:02 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> On Mon, Jun 17, 2019 at 02:31:09PM +0200, Arnd Bergmann wrote:
> >>> objtool points out a condition that it does not like:
> >>>
> >>> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> >>> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled
> >>>
> >>> I guess this is related to the call ubsan_type_mismatch_common()
> >>> not being inline before it calls user_access_restore(), though
> >>> I don't fully understand why that is a problem.
> >>
> >> The rules are that when AC is set, one is not allowed to CALL schedule,
> >> because scheduling does not save/restore AC.  Preemption, through the
> >> exceptions is fine, because the exceptions do save/restore AC.
> >>
> >> And while most functions do not appear to call into schedule, function
> >> trace ensures that every single call does in fact call into schedule.
> >> Therefore any CALL (with AC set) is invalid.
> > 
> > I see that stackleak_track_stack is already marked 'notrace',
> > since we must ensure we don't recurse when calling into it from
> > any of the function trace logic.
> > 
> > Does that mean we could just mark it as another safe call?
> > 
> > --- a/tools/objtool/check.c
> > +++ b/tools/objtool/check.c
> > @@ -486,6 +486,7 @@ static const char *uaccess_safe_builtin[] = {
> >         "__ubsan_handle_type_mismatch",
> >         "__ubsan_handle_type_mismatch_v1",
> >         /* misc */
> > +       "stackleak_track_stack",
> >         "csum_partial_copy_generic",
> >         "__memcpy_mcsafe",
> >         "ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */

Indeed, we could do this.

> > 
> >> Maybe we should disable stackleak when building ubsan instead? We
> >> already disable stack-protector when building ubsan.
> > 
> > I couldn't find out how that is done.
> > 
> 
> I guess this:
> ccflags-y += $(DISABLE_STACKLEAK_PLUGIN)

Or more specifically this, I guess:

CFLAGS_ubsan.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) $(DISABLE_STACKLEAK_PLUGIN)

we'd not want to exclude all of lib/ from stackleak I figure.

Of these two options, I think I prefer the latter, because a smaller
whitelist is a better whitelist and since we already disable
stack protector, it is only consistent to also disable stack leak.
