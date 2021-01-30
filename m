Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453DF309800
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 20:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhA3TVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 14:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhA3TVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Jan 2021 14:21:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5604264E11;
        Sat, 30 Jan 2021 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612034443;
        bh=Khh0VPiLPgid7W8oQUKVvgLkQvNgFEAVk+7jPu0KPAs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cvgESfj7iMt6iLU0YpOpPMenYYT4PhZF+Ik3HiIX2xDNg4Jlu/q+wE9LfZlyDGdpS
         qgakvREVhl/YpRSsYEiVeUzYiOJpLgZcW7e+PRAGoRT+xgjf6+YIgip1gfbMqOiGS8
         KL8IwslquLNeZkpPgY/i50l5wakXppS5aMLB9YCbi9adCQpB760RtP15yJTK4lWEN5
         7yloPUeUbnPFoqMuFGtL2fykOS7FfCVwTVoAXlvogZytIiNaRxAER6oUwbB0CnfNHL
         vNm9fc6xn55AeXeeNDq073jcj8Nk9G89jxQav+je9IF+Ug3SNkzz2fq6vicxWg0T/S
         SaZm2c3ozU7/w==
Message-ID: <fa43948ba860d6ac99adabad3d8b6ff11f5d2239.camel@kernel.org>
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
Date:   Sat, 30 Jan 2021 21:20:39 +0200
In-Reply-To: <9dd2a962-2328-8784-9aed-b913502e1102@intel.com>
References: <20210128125823.18660-1-jarkko@kernel.org>
         <9dd2a962-2328-8784-9aed-b913502e1102@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-01-28 at 08:33 -0800, Dave Hansen wrote:
> On 1/28/21 4:58 AM, Jarkko Sakkinen wrote:
> > The most trivial example of a race condition can be demonstrated by thi=
s
> > sequence where mm_list contains just one entry:
> >=20
> > CPU A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 CPU B
> > -> sgx_release()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> sgx_mmu_notifier_release()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> list_del_rcu()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <- list_del_rcu()
> > -> kref_put()
> > -> sgx_encl_release()
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> synchronize_srcu()
> > -> cleanup_srcu_struct()
>=20
> This is missing some key details including a clear, unambiguous, problem
> statement.=C2=A0 To me, the patch should concentrate on the SRCU warning
> since that's where we started.=C2=A0 Here's the detail that needs to be a=
dded
> about the issue and the locking in general in this path:
>=20
> sgx_release() also does this:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mmu_notifier_unregister(&=
encl_mm->mmu_notifier, encl_mm->mm);
>=20
> which does another synchronize_srcu() on the mmu_notifier's srcu_struct.
> =C2=A0*But*, it only does this if its own list_del_rcu() is successful.=
=C2=A0 It
> does all of this before the kref_put().
>=20
> In other words, sgx_release() can *only* get to this buggy path if
> sgx_mmu_notifier_release() races with sgx_release and does a
> list_del_rcu() first.
>=20
> The key to this patch is that the sgx_mmu_notifier_release() will now
> take an 'encl' reference in that case, which prevents kref_put() from
> calling sgx_release() which cleans up and frees 'encl'.
>=20
> I was actually also hoping to see some better comments about the new
> refcount, and the locking in general.=C2=A0 There are *TWO* struct_srcu's=
 in
> play, a spinlock and a refcount.=C2=A0 I took me several days with Sean a=
nd
> your help to identify the actual path and get a proper fix (versions 1-4
> did *not* fix the race).

This was really good input, thank you. It made realize something but
now I need a sanity check.

I think that this bug fix is *neither* a legit one :-)

Example scenario would such that all removals "side-channel" through
the notifier callback. Then mmu_notifier_unregister() gets called
exactly zero times. No MMU notifier srcu sync would be then happening.

NOTE: There's bunch of other examples, I'm just giving one.

How I think this should be actually fixed is:

1. Whenever MMU notifier is *registered* kref_get() should be called for
   the enclave reference count.
2. *BOTH* sgx_release() and sgx_mmu_notifier_release() should
   decrease the refcount when they process an entry.
  =20
I.e. the fix that I sent does kref_get() in wrong location. Please
sanity check my conclusion.=20
=20
> Also, the use-after-free is *fixed* in sgx_mmu_notifier_release() but
> does not *occur* in sgx_mmu_notifier_release().=C2=A0 The subject here is=
 a
> bit misleading in that regard.

Right, this is a valid point. It's incorrect. So if I just change the
short summary by substituting sgx_mmu_notifier_release() with
sgx_release()?

/Jarkko
