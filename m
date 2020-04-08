Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E631A2C21
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 01:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgDHXOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 19:14:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50960 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgDHXOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 19:14:22 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jMJtW-0005pC-UV; Thu, 09 Apr 2020 01:14:08 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7616D101150; Thu,  9 Apr 2020 01:14:06 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
In-Reply-To: <875ze9r304.fsf@nanos.tec.linutronix.de>
References: <875ze9r304.fsf@nanos.tec.linutronix.de>
Date:   Thu, 09 Apr 2020 01:14:06 +0200
Message-ID: <87369dr2o1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
> and the host completion injection which handles the queued completion
> when guest IF=0 does:

obviously IF=1 ...

>
>         struct ve_page *vp = vcpu->ve_page;
>
>         vp->host_current = idx;
>         inject_ve_complete(vcpu);
>
> The guest completion does:
>
>         struct ve_page *vp = this_cpu_ptr(&ve_page);
>         struct ve_info *info;
>
>         info = vp->info + vp->host_current;
>         rcuwait_wake_up(&info->wait);
>
> There are a bunch of life time issues to think about (not rocket
> science), but you get the idea.
>
> Thanks,
>
>         tglx
