Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20781553F1
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 18:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfFYQGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 12:06:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43874 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfFYQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 12:06:10 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hfnxC-0003Mj-GE; Tue, 25 Jun 2019 18:05:54 +0200
Date:   Tue, 25 Jun 2019 18:05:53 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        mingo@redhat.com, bp@alien8.de, rkrcmar@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even
 if host does not
In-Reply-To: <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
Message-ID: <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com> <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jun 2019, Paolo Bonzini wrote:
> On 10/06/19 19:20, Alejandro Jimenez wrote:

Btw, the proper prefix is: x86/speculation: Allow guests ....

> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 03b4cc0..66ca906 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -836,6 +836,16 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
> >  	}
> >  
> >  	/*
> > +	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
> > +	 * bit in the mask to allow guests to use the mitigation even in the
> > +	 * case where the host does not enable it.
> > +	 */
> > +	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
> > +	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
> > +		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;

Well, yes. But that also allows the guest to turn off SSBD if the host has
it disabled globally. So this needs to be conditional depending on the host
mode. It affects two places:

  1) If the host has it globally disabled then the mask needs to be clear.

  2) If the host has it specifically disabled for the VCPU thread, then it
     shouldn't be allowed to be cleared by the guest either.

Thanks,

	tglx



