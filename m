Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572911D3EF7
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgENU2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:28:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37911 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726035AbgENU2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 16:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589488131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TSLa/dtbCyvxyN5oIuPfHoLuHt8yn4QjYXztKgqiblU=;
        b=Q1nOj8P07empx1mqkH3jer8hjP1Gw1AMekXFiyk+U+1PHYlBiojU9ZRNHxb27oCUtKtTUR
        dT3BLaU9WZ8Dl9ZFdLdC7RVBH1U2tSWzFCzp7kB28ZVgIrKuvykp447TY21rzqeyXMfbQv
        qWJMRiOiwS6K5JL5zORF75iPE4vQ/Wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-qANUTNzSPaqn5qHUdJuQOg-1; Thu, 14 May 2020 16:28:47 -0400
X-MC-Unique: qANUTNzSPaqn5qHUdJuQOg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52D641005510;
        Thu, 14 May 2020 20:28:45 +0000 (UTC)
Received: from treble (ovpn-117-14.rdu2.redhat.com [10.10.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D31F1C933;
        Thu, 14 May 2020 20:28:42 +0000 (UTC)
Date:   Thu, 14 May 2020 15:28:39 -0500
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
Message-ID: <20200514202839.l2ztrqd4zff4e4as@treble>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094402.645961403@linuxfoundation.org>
 <20200513215210.GB27858@amd>
 <20200514194457.wipphhvyhzcshcup@treble>
 <20200514201340.GA14148@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200514201340.GA14148@amd>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 10:13:40PM +0200, Pavel Machek wrote:
> > > > @@ -563,6 +560,9 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
> > > >  void __unwind_start(struct unwind_state *state, struct task_struct *task,
> > > >  		    struct pt_regs *regs, unsigned long *first_frame)
> > > >  {
> > > > +	if (!orc_init)
> > > > +		goto done;
> > > > +
> > > >  	memset(state, 0, sizeof(*state));
> > > >  	state->task = task;
> > > >  
> > > 
> > > As this returns the *state to the caller, should the "goto done" move
> > > below the memset? Otherwise we are returning partialy-initialized
> > > struct, which is ... weird.
> > 
> > Yeah, it is a little weird.  In most cases it should be fine, but there
> > is an edge case where if there's a corrupt ORC table and this returns
> > early, 'arch_stack_walk_reliable() -> unwind_error()' could check an
> > uninitialized value.
> > 
> > Also the __unwind_start() error handling needs to set that error bit
> > anyway, in its error cases.  I'll fix it up.
> 
> I did this in the mean time. It moves goto around memset, and I
> believe that 8 in get_reg should have been sizeof(long) [not that it
> matters, x86-32 is protected by build bug on.]
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

I already have the same memset patch (along with other error-handling
fixes) which I'll be posting shortly once it runs through my testing.

Since the sizeof(long) thing isn't really a bug, I'll make that change
later, along with some other pending improvements I have.

-- 
Josh

