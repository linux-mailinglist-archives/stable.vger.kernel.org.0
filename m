Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010981BCEDB
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgD1Vgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 17:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726282AbgD1Vgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 17:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588109798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VxNwBZUZ2kN7UJQo+O+guQfCddd05dL5E51oV8I0MCk=;
        b=RPH9rvFlHeOn3EKLgpYsTT6wtP8XBnl8E+VDJYJNk3nfAxvLyk0JYiEzgkgFMQA8tr5ebm
        mOjYPaZPrLMsDGFooIlH1NyKPYlF97vtwnT1OJjYwrby3KPYeVTjzw12qD3OEkCwIL1vMq
        ZzGHcjalJL1tXrtErK6M0zlvjthNB6w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-sDMcUIM7OkuVg8DCyCAglg-1; Tue, 28 Apr 2020 17:36:35 -0400
X-MC-Unique: sDMcUIM7OkuVg8DCyCAglg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DC98107B7CD;
        Tue, 28 Apr 2020 21:36:33 +0000 (UTC)
Received: from krava (ovpn-112-36.ams2.redhat.com [10.36.112.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 829215C1BE;
        Tue, 28 Apr 2020 21:36:30 +0000 (UTC)
Date:   Tue, 28 Apr 2020 23:36:27 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "bibo,mao" <bibo.mao@intel.com>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2] kretprobe: Prevent triggering kretprobe from within
 kprobe_flush_task
Message-ID: <20200428213627.GI1476763@krava>
References: <20200409184451.GG3309111@krava>
 <20200409201336.GH3309111@krava>
 <20200410093159.0d7000a08fd76c2eaf1398f8@kernel.org>
 <20200414160338.GE208694@krava>
 <20200415090507.GG208694@krava>
 <20200416105506.904b7847a1b621b75463076d@kernel.org>
 <20200416091320.GA322899@krava>
 <20200416224250.7a53fb581e50aa32df75a0cf@kernel.org>
 <20200416143104.GA400699@krava>
 <20200417163810.ffe5c9145eae281fc493932c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417163810.ffe5c9145eae281fc493932c@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 04:38:10PM +0900, Masami Hiramatsu wrote:

SNIP

> > 
> > The code within the kretprobe handler checks for probe reentrancy,
> > so we won't trigger any _raw_spin_lock_irqsave probe in there.
> > 
> > The problem is in outside kprobe_flush_task, where we call:
> > 
> >   kprobe_flush_task
> >     kretprobe_table_lock
> >       raw_spin_lock_irqsave
> >         _raw_spin_lock_irqsave
> > 
> > where _raw_spin_lock_irqsave triggers the kretprobe and installs
> > kretprobe_trampoline handler on _raw_spin_lock_irqsave return.
> > 
> > The kretprobe_trampoline handler is then executed with already
> > locked kretprobe_table_locks, and first thing it does is to
> > lock kretprobe_table_locks ;-) the whole lockup path like:
> > 
> >   kprobe_flush_task
> >     kretprobe_table_lock
> >       raw_spin_lock_irqsave
> >         _raw_spin_lock_irqsave ---> probe triggered, kretprobe_trampoline installed
> > 
> >         ---> kretprobe_table_locks locked
> > 
> >         kretprobe_trampoline
> >           trampoline_handler
> >             kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
> > 
> > Adding kprobe_busy_begin/end helpers that mark code with fake
> > probe installed to prevent triggering of another kprobe within
> > this code.
> > 
> > Using these helpers in kprobe_flush_task, so the probe recursion
> > protection check is hit and the probe is never set to prevent
> > above lockup.
> > 
> 
> Thanks Jiri!
> 
> Ingo, could you pick this up?

Ingo, any chance you could take this one?

thanks,
jirka

