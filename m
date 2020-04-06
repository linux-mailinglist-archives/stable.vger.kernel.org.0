Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2636519FDE2
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgDFTKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 15:10:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46419 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726310AbgDFTKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 15:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586200200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2WntavKAAILKmUl5tuzVQBGYOFdZ1K83H/b52IOT1/E=;
        b=NCWEwV6c9gOnYDRP5msUjPOdy+lWkCKNMtmtVOa4/XEsSDN8bqmIKD13jqHtreKQ2Ogz3s
        S32JTP7SsSS2DkJNhR7VXvgT59jEVONW5iKAQJX+iWZIbCZGcb8ZSy3UaXSjrWs0Z8hdGY
        wrQpTHaou0YwviKdnMJiq+vkAPIpd8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-bU9l9M8MMvWWter2viivmA-1; Mon, 06 Apr 2020 15:09:54 -0400
X-MC-Unique: bU9l9M8MMvWWter2viivmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 694FC8018A8;
        Mon,  6 Apr 2020 19:09:52 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-173.rdu2.redhat.com [10.10.115.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 331809D36D;
        Mon,  6 Apr 2020 19:09:52 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A9577220515; Mon,  6 Apr 2020 15:09:51 -0400 (EDT)
Date:   Mon, 6 Apr 2020 15:09:51 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200406190951.GA19259@redhat.com>
References: <87ftek9ngq.fsf@nanos.tec.linutronix.de>
 <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de>
 <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
 <877dzu8178.fsf@nanos.tec.linutronix.de>
 <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
 <871rq199oz.fsf@nanos.tec.linutronix.de>
 <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
 <87d09l73ip.fsf@nanos.tec.linutronix.de>
 <20200309202215.GM12561@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309202215.GM12561@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
> > Andy Lutomirski <luto@kernel.org> writes:
> 
> > > I'm okay with the save/restore dance, I guess.  It's just yet more
> > > entry crud to deal with architecture nastiness, except that this
> > > nastiness is 100% software and isn't Intel/AMD's fault.
> > 
> > And we can do it in C and don't have to fiddle with it in the ASM
> > maze.
> 
> Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if
> we do the save/restore in do_nmi(). That is some wild brain melt. Also,
> AFAIK none of the distros are actually shipping a PREEMPT=y kernel
> anyway, so killing it shouldn't matter much.

It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have another
use case outside CONFIG_PREEMPT.

I am trying to extend async pf interface to also report page fault errors
to the guest.

https://lore.kernel.org/kvm/20200331194011.24834-1-vgoyal@redhat.com/

Right now async page fault interface assumes that host will always be
able to successfully resolve the page fault and sooner or later PAGE_READY
event will be sent to guest. And there is no mechnaism to report the
errors back to guest.

I am trying to add enhance virtiofs to directly map host page cache in guest.

https://lore.kernel.org/linux-fsdevel/20200304165845.3081-1-vgoyal@redhat.com/

There it is possible that a file page on host is mapped in guest and file
got truncated and page is not there anymore. Guest tries to access it,
and it generates async page fault. On host we will get -EFAULT and I 
need to propagate it back to guest so that guest can either send SIGBUS
to process which caused this. Or if kernel was trying to do memcpy(),
then be able to use execpetion table error handling and be able to
return with error.  (memcpy_mcflush()).

For the second case to work, I will need async pf events to come in
even if guest is in kernel and CONFIG_PREEMPT=n.

So it would be nice if we can keep KVM_ASYNC_PF_SEND_ALWAYS around.

Thanks
Vivek

