Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A586355711
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 20:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfFYSW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 14:22:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44225 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfFYSW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 14:22:56 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hfq5f-0005iI-Lj; Tue, 25 Jun 2019 20:22:47 +0200
Date:   Tue, 25 Jun 2019 20:22:46 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>, mingo@redhat.com,
        Borislav Petkov <bp@alien8.de>, rkrcmar@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even
 if host does not
In-Reply-To: <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
Message-ID: <alpine.DEB.2.21.1906252019460.32342@nanos.tec.linutronix.de>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com> <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com> <alpine.DEB.2.21.1906251750140.32342@nanos.tec.linutronix.de> <56fa2729-52a7-3994-5f7c-bc308da7d710@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-974064211-1561486967=:32342"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-974064211-1561486967=:32342
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Tue, 25 Jun 2019, Alejandro Jimenez wrote:
> On 6/25/2019 12:05 PM, Thomas Gleixner wrote:
> > On Tue, 25 Jun 2019, Paolo Bonzini wrote:
> > > On 10/06/19 19:20, Alejandro Jimenez wrote:
> > > >     	/*
> > > > +	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
> > > > +	 * bit in the mask to allow guests to use the mitigation even in the
> > > > +	 * case where the host does not enable it.
> > > > +	 */
> > > > +	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
> > > > +	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
> > > > +		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
> >
> > Well, yes. But that also allows the guest to turn off SSBD if the host has
> > it disabled globally. So this needs to be conditional depending on the host
> > mode. It affects two places:
> > 
> >    1) If the host has it globally disabled then the mask needs to be clear.
> > 
> >    2) If the host has it specifically disabled for the VCPU thread, then it
> >       shouldn't be allowed to be cleared by the guest either.
>
> I see the argument that the host must be able to enforce its security policies
> on the guests running on it. The guest OS would still be 'lying' by reporting
> that is running with the mitigation turned off, but I suppose this is
> preferable to overriding the host's security policy.

True.

> I think that even with that approach there is still an unsolved problem, as I
> believe guests are allowed to write directly to SPEC_CTRL MSR without causing
> a VMEXIT, which bypasses the host masking entirely.  e.g. a guest using IBRS
> writes frequently to SPEC_CTRL, and could turn off SSBD on the VPCU while is
> running after the first non-zero write to the MSR. Do you agree?

Indeed. Of course that was a decision we made _before_ all the other fancy
things came around. Looks like we have to reopen that discussion.

Thanks,

	tglx
--8323329-974064211-1561486967=:32342--
