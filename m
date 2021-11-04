Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A3445600
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhKDPHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhKDPHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33ACC611EE;
        Thu,  4 Nov 2021 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636038298;
        bh=Woio3dNzq1FSYGajaTRv8vIQvOiGl6VtJQn+HlW3IQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b/EwSA1GbUPgzHPqbuDk93sqbgfYFDUCCa5mV5Hz06x/p3tC3ggR7ZD5CB0Aty0+R
         yOBp1/jzvuRkzqN7O/o+NXR8JnL0h+HnpX1QXJudyGvqEdaqMcPf1PHuv2Tr60IHbH
         uzNBsBUssxGq7KcrTxs4D+ezhiobkU1cB4n9K6JAiLHKtaX88lM+y9FFKWBfWQgtXt
         EO6ZVUFIUwnRccoQsCBAaSBzPMpBvYMu3uT18pfz7vVMMEegSG/Err0/DEj9yQ44CV
         z3o84njOaiqUBQPFwqZtlo3N8ksIahHst8Wf/IhjILHwDL5fOA0Z0fnPlpz/ypVlf+
         KicNjdJvrTiXQ==
Message-ID: <e88d6d580354aadaa8eaa5ee6fa703f021786afb.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Free backing memory after faulting the enclave
 page
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Nov 2021 17:04:56 +0200
In-Reply-To: <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
References: <20211103232238.110557-1-jarkko@kernel.org>
         <6831ed3c-c5b1-64f7-2ad7-f2d686224b7e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-11-04 at 06:50 -0700, Dave Hansen wrote:
> On 11/3/21 4:22 PM, Jarkko Sakkinen wrote:
> > The backing memory was not freed, after loading it back to the SGX
> > reserved memory. This problem was not prevalent with the systems that
> > were available at the time when SGX was first upstreamed, as the swappe=
d
> > memory could grow only up to 128 MB.=C2=A0 However, Icelake Server can =
have
> > gigabytes of SGX memory, and thus this has become a real bottleneck.
> >=20
> > Free the swap space for other use by calling shmem_truncate_range(),
> > when a page is faulted back.
>=20
> This needs a _bit_ more context.=C2=A0 Could you include a few sentences
> about what backing memory is?
>=20
> It's also not a big deal but it is nice to include something like:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0This was found by inspect=
ion.
>=20
> and:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Reported-by: Dave Hansen =
<dave.hansen@linux.intel.com>

Oops, I'm sorry, I was planning to add this but forgot to do it.

> Also, what is the end-user-visible effect of this bug?=C2=A0 What would a
> user see if they were impacted by this?=C2=A0 How did you determine that =
this
> fixed the issue?=C2=A0 This memory will be recovered when the enclave is =
torn
> down, right?

You're absolutely right.

I just realized how to make the whole thing concrete and reproduce OOM with=
 the
128 MB EPC that I have in my i5-9600KF desktop. I'll just reconfigure my te=
st
VM to have sufficiently small amount of RAM, and come up with an appropriat=
e
workload.

> Do we also need to deal with truncating the PCMD?=C2=A0 (For those watchi=
ng
> along at home, there are two things SGX swaps to RAM: the actual page
> data and also some metadata that ensures page integrity and helps
> prevent things like rolling back to old versions of swapped pages)

Yes.

This can be achieved by iterating through all of the enclave pages,
which share the same shmem page for storing their PCMD's, as the one
being faulted back. If none of those pages is swapped, the PCMD page can
safely truncated.

I guess it makes sense to put this into patch of its own.

/Jarkko


