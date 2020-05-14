Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B761D3DD0
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgENTpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:45:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37383 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727780AbgENTpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 15:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589485508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvOZYPZ0dznaZyOMKG5Ibf44TW+ApRdGE4+b9bGQgYQ=;
        b=hTYxQXk0PoCcG72j/PIXOtWHYpehlDv0vNe+EKqRhSbGx0xBgImwbo15yux6twCLbk4rMT
        R6vzNxPYgKGiGZf4dZtySFsfBu2XkjrSmF1EvlppkoFxAWA1DlCcSh7YayYyx3QqBxDECv
        ulCIVMu0oBTEXbVO/gDLsmt//k0/lXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-ydCz80sUPZuLkv0pCXsM4g-1; Thu, 14 May 2020 15:45:04 -0400
X-MC-Unique: ydCz80sUPZuLkv0pCXsM4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D1B31005510;
        Thu, 14 May 2020 19:45:02 +0000 (UTC)
Received: from treble (ovpn-117-14.rdu2.redhat.com [10.10.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA55D100164D;
        Thu, 14 May 2020 19:44:59 +0000 (UTC)
Date:   Thu, 14 May 2020 14:44:57 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 4.19 41/48] x86/unwind/orc: Prevent unwinding before ORC
 initialization
Message-ID: <20200514194457.wipphhvyhzcshcup@treble>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094402.645961403@linuxfoundation.org>
 <20200513215210.GB27858@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200513215210.GB27858@amd>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 11:52:10PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > 
> > commit 98d0c8ebf77e0ba7c54a9ae05ea588f0e9e3f46e upstream.
> > 
> > If the unwinder is called before the ORC data has been initialized,
> > orc_find() returns NULL, and it tries to fall back to using frame
> > pointers.  This can cause some unexpected warnings during boot.
> > 
> > Move the 'orc_init' check from orc_find() to __unwind_init(), so that it
> > doesn't even try to unwind from an uninitialized state.
> 
> > @@ -563,6 +560,9 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
> >  void __unwind_start(struct unwind_state *state, struct task_struct *task,
> >  		    struct pt_regs *regs, unsigned long *first_frame)
> >  {
> > +	if (!orc_init)
> > +		goto done;
> > +
> >  	memset(state, 0, sizeof(*state));
> >  	state->task = task;
> >  
> 
> As this returns the *state to the caller, should the "goto done" move
> below the memset? Otherwise we are returning partialy-initialized
> struct, which is ... weird.

Yeah, it is a little weird.  In most cases it should be fine, but there
is an edge case where if there's a corrupt ORC table and this returns
early, 'arch_stack_walk_reliable() -> unwind_error()' could check an
uninitialized value.

Also the __unwind_start() error handling needs to set that error bit
anyway, in its error cases.  I'll fix it up.

-- 
Josh

