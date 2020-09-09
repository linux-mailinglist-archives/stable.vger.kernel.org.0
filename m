Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D797D262A8A
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 10:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIIiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 04:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIIIit (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 04:38:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0959C061573;
        Wed,  9 Sep 2020 01:38:49 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id y5so1627265otg.5;
        Wed, 09 Sep 2020 01:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+MNe+SAiEeqDTi17enw+pfUJJQZGcCa+ssq/JHHPAo=;
        b=QGyeBrUjnUggrtqnsRg9jhhUV7pJGNTatfaJVeSi694ehw7Zd2N/j0a1G953R8ie+x
         7NBPE33xIbS7SaxU+VsN78spkC19ZXpl1Rq+pwBm8hKHq710W70wimyUyj/FLWuCOsYe
         w1hGtSCFdwVcJQNcZVfnUTmTiBXOn8sBdymWch4RRpJp8lR3r2MiQB3ZJQOsP7VFt7y0
         ceusoL11yPJGLAJhhixx4qmLhDjjWbZ4J+Uh5ShkmDP9x1qRWHmrBQe2Idsk4TkI2ts4
         l2jI5DDD+P0wUawWuR6XHaMhCKvX8mhcx3rR5kOdxw8wfdIAyfkfQjvt5+KgtgYr0NYu
         2RGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+MNe+SAiEeqDTi17enw+pfUJJQZGcCa+ssq/JHHPAo=;
        b=KUVqVXbAwCqJedMchfx7qauWQPOrg5q/WStFcjG2IPoNikeaLy40cap0f42GN4o7+u
         JhLYOb0MA3qFBQ0QnNqRg+1NU9yY4QAZmCUyR36Is3sq+XkK122fnGArV8Z23AIe50bW
         BCTGmUE1duVwGvvAQjs9hJK6gFubJqPObMNepYGbeZTp2tU1oz/Bc1+RQCuyitmLf7Is
         EXQ1LscTGZi+DTBMIH6uDpTrVM6Ee2Og56oiRYm6S3vwXrpYnMmTKQdZPJDacOQoAUIH
         +lEcsBdyHnZ6Y536Ox1NmA+X+sSGenKhZWOnwc4MAE0H92x1MceOF4709GGdYqp1sRr6
         PD4w==
X-Gm-Message-State: AOAM530JnAoWkXTToe43q04Vzxt5Gyo8mW1+Gg0CM+KSVprP1YVHP80j
        Skj12bw+IEMZtR5pCk3Aq4StrPfbDT1yFdsXtJ0=
X-Google-Smtp-Source: ABdhPJxam++etckMEJmUW6ODQ/l8UeOTZGbwOU80+ustU7g5jT4kVjK6Le3OfomRhfHwUN1qmxuL1uw5bE9gMIroGEU=
X-Received: by 2002:a05:6830:10c4:: with SMTP id z4mr2031518oto.254.1599640729110;
 Wed, 09 Sep 2020 01:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <1599620043-12908-1-git-send-email-wanpengli@tencent.com> <87h7s7mk93.fsf@vitty.brq.redhat.com>
In-Reply-To: <87h7s7mk93.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Sep 2020 16:38:37 +0800
Message-ID: <CANRm+CxLpGaC66TVUftrxXdfBg+CHJzDMKh4mFvdpm-HTK0QwA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>,
        "# v3 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Sep 2020 at 16:23, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Analysis from Sean:
> >
> >  | svm->next_rip is reset in svm_vcpu_run() only after calling
> >  | svm_exit_handlers_fastpath(), which will cause SVM's
> >  | skip_emulated_instruction() to write a stale RIP.
> >
>
> This should only happen when svm->vmcb->control.next_rip is not set by
> hardware as skip_emulated_instruction() itself sets 'svm->next_rip'
> otherwise, right?

The bug is reported here
https://bugzilla.kernel.org/show_bug.cgi?id=209155 , the old machine
which the reporter uses doesn't have NRIP save on #VMEXIT support. :)

    Wanpeng
