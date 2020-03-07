Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B40417CF36
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 16:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgCGP7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 10:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGP7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 10:59:37 -0500
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82B622075B
        for <stable@vger.kernel.org>; Sat,  7 Mar 2020 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583596776;
        bh=zMkJH6cK603hkiloMil4J7KbZG+wEMJbLxkolozJ8y4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wl6DWydhYNyJg+uXDV7caWUBz1t5DhX+qqoTIdiOgeLjAPAFFlLTyvGdS2MGNhdsD
         BbZNFXXAt8+rfk8lQgEp59HhLFhhQ54p1j1ZLE2N/Pz133vyTUsNnc1URmioveU0nF
         ob12zJh5RHBqImzhx6w4EdEknItkP2Is8eUfe71I=
Received: by mail-wm1-f45.google.com with SMTP id a132so5603729wme.1
        for <stable@vger.kernel.org>; Sat, 07 Mar 2020 07:59:36 -0800 (PST)
X-Gm-Message-State: ANhLgQ0ipVfnL5lQ6Bah8opoxGEOnCIajCQVjDmA/i9WP5v5bMkKvb1m
        QHkP9C7eAyZi7UGeW+IIONL/zLKyn8oIerolHEnyGA==
X-Google-Smtp-Source: ADFU+vvxDbLv30/SJ1GdrACcZi2erMHbijB2e7fHbV/Q2v+aZ/w3oszY1ocnI9nhuP4cv/N2cbSsd3T6zolnXE6tflg=
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr10159179wmj.176.1583596774941;
 Sat, 07 Mar 2020 07:59:34 -0800 (PST)
MIME-Version: 1.0
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
 <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com> <87ftek9ngq.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87ftek9ngq.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 07:59:22 -0800
X-Gmail-Original-Message-ID: <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
Message-ID: <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
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

On Sat, Mar 7, 2020 at 7:47 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
> > On Fri, Mar 6, 2020 at 6:26 PM Andy Lutomirski <luto@kernel.org> wrote:
> >> +               /*
> >> +                * We do not set KVM_ASYNC_PF_SEND_ALWAYS.  With the current
> >> +                * KVM paravirt ABI, the following scenario is possible:
> >> +                *
> >> +                * #PF: async page fault (KVM_PV_REASON_PAGE_NOT_PRESENT)
> >> +                *  NMI before CR2 or KVM_PF_REASON_PAGE_NOT_PRESENT
> >> +                *   NMI accesses user memory, e.g. due to perf
> >> +                *    #PF: normal page fault
> >> +                *     #PF reads CR2 and apf_reason -- apf_reason should be 0
> >> +                *
> >> +                *  outer #PF reads CR2 and apf_reason -- apf_reason should be
> >> +                *  KVM_PV_REASON_PAGE_NOT_PRESENT
> >> +                *
> >> +                * There is no possible way that both reads of CR2 and
> >> +                * apf_reason get the correct values.  Fixing this would
> >> +                * require paravirt ABI changes.
> >> +                */
> >> +
> >
> > Upon re-reading my own comment, I think the problem is real, but I
> > don't think my patch fixes it.  The outer #PF could just as easily
> > have come from user mode.  We may actually need the NMI code (and
> > perhaps MCE and maybe #DB too) to save, clear, and restore apf_reason.
> > If we do this, then maybe CPL0 async PFs are actually okay, but the
> > semantics are so poorly defined that I'm not very confident about
> > that.
>
> I think even with the current mode this is fixable on the host side when
> it keeps track of the state.
>
> The host knows exactly when it injects a async PF and it can store CR2
> and reason of that async PF in flight.
>
> On the next VMEXIT it checks whether apf_reason is 0. If apf_reason is 0
> then it knows that the guest has read CR2 and apf_reason. All good
> nothing to worry about.
>
> If not it needs to be careful.
>
> As long as the apf_reason of the last async #PF is not cleared by the
> guest no new async #PF can be injected. That's already correct because
> in that case IF==0 which prevents a nested async #PF.
>
> If MCE, NMI trigger a real pagefault then the #PF injection needs to
> clear apf_reason and set the correct CR2. When that #PF returns then the
> old CR2 and apf_reason need to be restored.

How is the host supposed to know when the #PF returns?  Intercepting
IRET sounds like a bad idea and, in any case, is not actually a
reliable indication that #PF returned.
