Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495DE17E68C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgCISOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 14:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgCISOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 14:14:18 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9200720873
        for <stable@vger.kernel.org>; Mon,  9 Mar 2020 18:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583777657;
        bh=GPOsnxPOWkitvcYLr873iWAuXAjAvRcZgDNyk1lxnSw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JpN6DgItReJj4bVteGdpRQHuRkryGz+QlPvJ+ob7GuABPmfHGSjjCZy1cIYhq+Ai5
         v0XG8mBjVPqu3Hjl6uo0ho+Uy4cMuAjCdBYTAxLZjybdEMyNgzptrJ7CTEvDqQkCSp
         Z3fv5bx2ECjIIOnCVyJCI6m5hBP+bSrROSa6TK7Q=
Received: by mail-wm1-f46.google.com with SMTP id f7so198788wml.4
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 11:14:17 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2XPYP0HXdMhLHWJFnC9mMqA8b8pkcQtlYZGtejNksU6qYFi/u6
        q0YTgc7ZBo2l+0NFLP7+h/bPsiVGKeBWlR5PDXjIXA==
X-Google-Smtp-Source: ADFU+vu+3khw0mvyiOjN3S2PCh5Gg+ouhuqQbOo+d62XxOfUqKh9yBjB8oCXz6OL/+7A908PJLeZq8ErBSIsPMnDAQo=
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr480519wmj.176.1583777656050;
 Mon, 09 Mar 2020 11:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <ed71d0967113a35f670a9625a058b8e6e0b2f104.1583547991.git.luto@kernel.org>
 <CALCETrVmsF9JSMLSd44-3GGWEz6siJQxudeaYiVnvv__YDT1BQ@mail.gmail.com>
 <87ftek9ngq.fsf@nanos.tec.linutronix.de> <CALCETrVsc-t=tDRPbCg5dWHDY0NFv2zjz12ahD-vnGPn8T+RXA@mail.gmail.com>
 <87a74s9ehb.fsf@nanos.tec.linutronix.de> <87wo7v8g4j.fsf@nanos.tec.linutronix.de>
 <877dzu8178.fsf@nanos.tec.linutronix.de> <37440ade-1657-648b-bf72-2b8ca4ac21ce@redhat.com>
 <871rq199oz.fsf@nanos.tec.linutronix.de>
In-Reply-To: <871rq199oz.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 9 Mar 2020 11:14:04 -0700
X-Gmail-Original-Message-ID: <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
Message-ID: <CALCETrUHwd8pNr_ZdFqY8vMjJeMdNyw2C+FL6uOUM98SEE9rNQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 9, 2020 at 2:09 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Paolo Bonzini <pbonzini@redhat.com> writes:
> > On 09/03/20 07:57, Thomas Gleixner wrote:
> >> Thomas Gleixner <tglx@linutronix.de> writes:
> >>
> >> guest side:
> >>
> >>    nmi()/mce() ...
> >>
> >>         stash_crs();
> >>
> >> +       stash_and_clear_apf_reason();
> >>
> >>         ....
> >>
> >> +       restore_apf_reason();
> >>
> >>      restore_cr2();
> >>
> >> Too obvious, isn't it?
> >
> > Yes, this works but Andy was not happy about adding more
> > save-and-restore to NMIs.  If you do not want to do that, I'm okay with
> > disabling async page fault support for now.
>
> I'm fine with doing that save/restore dance, but I have no strong
> opinion either.
>
> > Storing the page fault reason in memory was not a good idea.  Better
> > options would be to co-opt the page fault error code (e.g. store the
> > reason in bits 31:16, mark bits 15:0 with the invalid error code
> > RSVD=1/P=0), or to use the virtualization exception area.
>
> Memory store is not the problem. The real problem is hijacking #PF.
>
> If you'd have just used a separate VECTOR_ASYNC_PF then none of these
> problems would exist at all.
>

I'm okay with the save/restore dance, I guess.  It's just yet more
entry crud to deal with architecture nastiness, except that this
nastiness is 100% software and isn't Intel/AMD's fault.

At least until we get an async page fault due to apf_reason being paged out...
