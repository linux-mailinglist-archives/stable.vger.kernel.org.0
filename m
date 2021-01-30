Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C667309808
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 20:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhA3T0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 14:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231861AbhA3T0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 14:26:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D1CE64E11;
        Sat, 30 Jan 2021 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612034771;
        bh=I6LY0HAE2jupB8OMT00M3A3D03Qojgg5AwyLaL3ZKmU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RGhxGTeY1H58fysQfw6t9t7eKNNxC5GTQYKvoihoGMH4uaMr6kGX5svzc4Kpo/y6F
         CJHCWJu6tTZ9iqBHiPKLp8WpqjovIk9YRqlu4y8TEau5oxKPf24aOX5PhMrA29I0Pr
         46KEF5CiKS7hBuY0fspgbgEPVQG8LZJbi2iiko+SiifUqHUqO2xKHTjwy1wtcuUaGD
         683AtJYIgMfXXLvKC0EsrX3bCBd1GUcPSgm1eZ/Nni3PqJins3eylgBdDHNwg6pTW5
         hDeHLZRfzTtS8i4hQFRs818Ih86qisXFMODGDZ+kap4a37QOJja60/osInYCImUU2F
         +0hLcxgq7vLCg==
Message-ID: <c11fb781953e0fc84f77ca75eca8db43ac10d289.camel@kernel.org>
Subject: Re: [PATCH v5] x86/sgx: Fix use-after-free in
 sgx_mmu_notifier_release()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org
Cc:     stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 30 Jan 2021 21:26:07 +0200
In-Reply-To: <fa43948ba860d6ac99adabad3d8b6ff11f5d2239.camel@kernel.org>
References: <20210128125823.18660-1-jarkko@kernel.org>
         <9dd2a962-2328-8784-9aed-b913502e1102@intel.com>
         <fa43948ba860d6ac99adabad3d8b6ff11f5d2239.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-01-30 at 21:20 +0200, Jarkko Sakkinen wrote:
> On Thu, 2021-01-28 at 08:33 -0800, Dave Hansen wrote:
> > On 1/28/21 4:58 AM, Jarkko Sakkinen wrote:
> > > The most trivial example of a race condition can be demonstrated by t=
his
> > > sequence where mm_list contains just one entry:
> > >=20
> > > CPU A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 CPU B
> > > -> sgx_release()
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> sgx_mmu_notifier_release()
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> list_del_rcu()
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <- list_del_rcu()
> > > -> kref_put()
> > > -> sgx_encl_release()
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> synchronize_srcu()
> > > -> cleanup_srcu_struct()
> >=20
> > This is missing some key details including a clear, unambiguous, proble=
m
> > statement.=C2=A0 To me, the patch should concentrate on the SRCU warnin=
g
> > since that's where we started.=C2=A0 Here's the detail that needs to be=
 added
> > about the issue and the locking in general in this path:
> >=20
> > sgx_release() also does this:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mmu_notifier_unregister=
(&encl_mm->mmu_notifier, encl_mm->mm);
> >=20
> > which does another synchronize_srcu() on the mmu_notifier's srcu_struct=
.
> > =C2=A0*But*, it only does this if its own list_del_rcu() is successful.=
=C2=A0 It
> > does all of this before the kref_put().
> >=20
> > In other words, sgx_release() can *only* get to this buggy path if
> > sgx_mmu_notifier_release() races with sgx_release and does a
> > list_del_rcu() first.
> >=20
> > The key to this patch is that the sgx_mmu_notifier_release() will now
> > take an 'encl' reference in that case, which prevents kref_put() from
> > calling sgx_release() which cleans up and frees 'encl'.
> >=20
> > I was actually also hoping to see some better comments about the new
> > refcount, and the locking in general.=C2=A0 There are *TWO* struct_srcu=
's in
> > play, a spinlock and a refcount.=C2=A0 I took me several days with Sean=
 and
> > your help to identify the actual path and get a proper fix (versions 1-=
4
> > did *not* fix the race).
>=20
> This was really good input, thank you. It made realize something but
> now I need a sanity check.
>=20
> I think that this bug fix is *neither* a legit one :-)
>=20
> Example scenario would such that all removals "side-channel" through
> the notifier callback. Then mmu_notifier_unregister() gets called
> exactly zero times. No MMU notifier srcu sync would be then happening.
>=20
> NOTE: There's bunch of other examples, I'm just giving one.
>=20
> How I think this should be actually fixed is:
>=20
> 1. Whenever MMU notifier is *registered* kref_get() should be called for
> =C2=A0=C2=A0 the enclave reference count.
> 2. *BOTH* sgx_release() and sgx_mmu_notifier_release() should
> =C2=A0=C2=A0 decrease the refcount when they process an entry.
> =C2=A0=C2=A0=20
> I.e. the fix that I sent does kref_get() in wrong location. Please
> sanity check my conclusion.=20
> =C2=A0
> > Also, the use-after-free is *fixed* in sgx_mmu_notifier_release() but
> > does not *occur* in sgx_mmu_notifier_release().=C2=A0 The subject here =
is a
> > bit misleading in that regard.
>=20
> Right, this is a valid point. It's incorrect. So if I just change the
> short summary by substituting sgx_mmu_notifier_release() with
> sgx_release()?

I.e. refcount should be increased in sgx_encl_mm_add(). That way the
whole thing should be somewhat stable.

/Jarkko
