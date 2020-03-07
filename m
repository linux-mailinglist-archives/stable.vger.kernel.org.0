Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4049217CFD8
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 20:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgCGTfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 14:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgCGTfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 14:35:11 -0500
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE79F20684
        for <stable@vger.kernel.org>; Sat,  7 Mar 2020 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583609710;
        bh=JDv7bMpMvn1QXvUKWn3wky5CJY+BxT3OIOtmyrSEU1A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Lk/iUN9lj+kHJKWKb7GJZsjdZ6gVAKJWr5tXpmu734LhckBUJn2JQEwjDyRn04lT0
         Rg1tw+7kaGYu+cs0IIU2bMJKqM6YQI8MGGruitvSdOSIcp0xxUAcbc5ATppuScCZbN
         bIIOyh5Ld+wDxxxD5/qfJd6MZhvbeplFfxGZtiSA=
Received: by mail-wr1-f41.google.com with SMTP id r15so1204913wrx.6
        for <stable@vger.kernel.org>; Sat, 07 Mar 2020 11:35:09 -0800 (PST)
X-Gm-Message-State: ANhLgQ0NZ+OZD53QIE/6jFscy5sh2ugTlNlWds2EGOYB9aBCeERTY6Mu
        31na9g2xQJ7QBj0c7+WR6XKVit4WsXimioXzi/du+Q==
X-Google-Smtp-Source: ADFU+vvoVxsDoBUJSLN0ucEQEhaJOf9rQ/drwaYYv/hzOKbUpezceg0sYt7Id+wlZriB7/mtoGrbIlxwwqECFzDhtnQ=
X-Received: by 2002:adf:b641:: with SMTP id i1mr10938601wre.18.1583609708391;
 Sat, 07 Mar 2020 11:35:08 -0800 (PST)
MIME-Version: 1.0
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
 <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
 <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87a74s9ehb.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 11:34:57 -0800
X-Gmail-Original-Message-ID: <CALCETrXGiZQG-h3nuXL4HZJyTJ4T2mjJhSvcqpVy8B9hr+qjNA@mail.gmail.com>
Message-ID: <CALCETrXGiZQG-h3nuXL4HZJyTJ4T2mjJhSvcqpVy8B9hr+qjNA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 7, 2020 at 11:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
> > On Sat, Mar 7, 2020 at 7:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> The host knows exactly when it injects a async PF and it can store CR2
> >> and reason of that async PF in flight.
> >>
> >> On the next VMEXIT it checks whether apf_reason is 0. If apf_reason is 0
> >> then it knows that the guest has read CR2 and apf_reason. All good
> >> nothing to worry about.
> >>
> >> If not it needs to be careful.
> >>
> >> As long as the apf_reason of the last async #PF is not cleared by the
> >> guest no new async #PF can be injected. That's already correct because
> >> in that case IF==0 which prevents a nested async #PF.
> >>
> >> If MCE, NMI trigger a real pagefault then the #PF injection needs to
> >> clear apf_reason and set the correct CR2. When that #PF returns then the
> >> old CR2 and apf_reason need to be restored.
> >
> > How is the host supposed to know when the #PF returns?  Intercepting
> > IRET sounds like a bad idea and, in any case, is not actually a
> > reliable indication that #PF returned.
>
> The host does not care about the IRET. It solely has to check whether
> apf_reason is 0 or not. That way it knows that the guest has read CR2
> and apf_reason.

/me needs actual details

Suppose the host delivers an async #PF.  apf_reason != 0 and CR2
contains something meaningful.  Host resumes the guest.

The guest does whatever (gets NMI, and does perf stuff, for example).
The guest gets a normal #PF.  Somehow the host needs to do:

if (apf_reason != 0) {
  prev_apf_reason = apf_reason;
  prev_cr2 = cr2;
  apf_reason = 0;
  cr2 = actual fault address;
}

resume guest;

Obviously this can only happen if the host intercepts #PF.  Let's
pretend for now that this is even possible on SEV-ES (it may well be,
but I would also believe that it's not.  SEV-ES intercepts are weird
and I don't have the whole manual in my head.  I'm not sure the host
has any way to read CR2 for a SEV-ES guest.)  So now the guest runs
some more and finishes handling the inner #PF.  Some time between
doing that and running the outer #PF code that reads apf_reason, the
host needs to do:

apf_reason = prev_apf_reason;
cr2 = prev_cr2;
prev_apf_reason = 0;

How is the host supposed to know when to do that?

--Andy
