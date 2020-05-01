Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E511C0BDF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgEACBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgEACBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:01:11 -0400
Received: from devnote (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21AB2073E;
        Fri,  1 May 2020 02:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588298470;
        bh=TGng++haxmjKEAxWTDMCt+me7RqYg/DPhKnyheMa2+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=URt7r82KCUw4/FpnlqtLK2lwwbKBKLoUccNmriUdGhHDebv21eK1bGHH6DTwRa128
         67HmXFSGYmNdy9h3gS+T/kIStuMRe1Ls0QxtGSuGO8srfn4PuYocXspwYHUfUQhOXN
         IYRTXGNcySptZupssYgZE9jnS/sJ9dUIFhp/12iY=
Date:   Fri, 1 May 2020 11:01:07 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "bibo,mao" <bibo.mao@intel.com>,
        "Ziqian SUN (Zamir)" <zsun@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2] kretprobe: Prevent triggering kretprobe from within
 kprobe_flush_task
Message-Id: <20200501110107.bc859c6603704c0bcdb8889a@kernel.org>
In-Reply-To: <20200428213627.GI1476763@krava>
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
        <20200428213627.GI1476763@krava>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Apr 2020 23:36:27 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> On Fri, Apr 17, 2020 at 04:38:10PM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > > 
> > > The code within the kretprobe handler checks for probe reentrancy,
> > > so we won't trigger any _raw_spin_lock_irqsave probe in there.
> > > 
> > > The problem is in outside kprobe_flush_task, where we call:
> > > 
> > >   kprobe_flush_task
> > >     kretprobe_table_lock
> > >       raw_spin_lock_irqsave
> > >         _raw_spin_lock_irqsave
> > > 
> > > where _raw_spin_lock_irqsave triggers the kretprobe and installs
> > > kretprobe_trampoline handler on _raw_spin_lock_irqsave return.
> > > 
> > > The kretprobe_trampoline handler is then executed with already
> > > locked kretprobe_table_locks, and first thing it does is to
> > > lock kretprobe_table_locks ;-) the whole lockup path like:
> > > 
> > >   kprobe_flush_task
> > >     kretprobe_table_lock
> > >       raw_spin_lock_irqsave
> > >         _raw_spin_lock_irqsave ---> probe triggered, kretprobe_trampoline installed
> > > 
> > >         ---> kretprobe_table_locks locked
> > > 
> > >         kretprobe_trampoline
> > >           trampoline_handler
> > >             kretprobe_hash_lock(current, &head, &flags);  <--- deadlock
> > > 
> > > Adding kprobe_busy_begin/end helpers that mark code with fake
> > > probe installed to prevent triggering of another kprobe within
> > > this code.
> > > 
> > > Using these helpers in kprobe_flush_task, so the probe recursion
> > > protection check is hit and the probe is never set to prevent
> > > above lockup.
> > > 
> > 
> > Thanks Jiri!
> > 
> > Ingo, could you pick this up?
> 
> Ingo, any chance you could take this one?

Hi Ingo,

Should I make a pull request for all kprobes related patches to you?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
