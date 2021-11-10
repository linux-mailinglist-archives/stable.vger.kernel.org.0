Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FC44C41F
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 16:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKJPOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 10:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232062AbhKJPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 10:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8FD2610FF;
        Wed, 10 Nov 2021 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636557113;
        bh=e9tnSW3iIAV4FoDSSI0tVaZqg1Wa20jPHGx0DLL4Krs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MEXne+JQRwVTeUO4JwxM09cK9a2fJEhawivcF/clegnPbuC4O8tcIbDnSuawh0umX
         9n0RcoE9DwYYU9LKNgMzUwobIgtwE1dbI9KoMNzeWdwxTtbjPYceUIWar746qH/aXN
         GRC/foRb49jBvz4zEsnP8XPF8Yy/T4+ELUVJYdamKT/kVQGrbodv4aUybv7ui2gP13
         u6hDPDAxOrag7qAl3oN5pggvNurs5Lf7I3qHii6Wbn6wYUpIWfnmdMR0oRDRXlM64O
         j/BBr05SlVPgjZNS8L9nwaEgMxq3E/9ckbV77kp1fSx7RcpUWGHS7yZabDoQmLb/oW
         h0jw721o1CBYQ==
Message-ID: <8e0bb87f05b79317a06ed2d8ab5e2f5cf6132b6a.camel@kernel.org>
Subject: Re: [PATCH V2] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Wed, 10 Nov 2021 17:11:50 +0200
In-Reply-To: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
References: <b2e69e9febcae5d98d331de094d9cc7ce3217e66.1636487172.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-11-09 at 12:00 -0800, Reinette Chatre wrote:
> The SGX driver maintains a single global free page counter,
> sgx_nr_free_pages, that reflects the number of free pages available
> across all NUMA nodes. Correspondingly, a list of free pages is
> associated with each NUMA node and sgx_nr_free_pages is updated
> every time a page is added or removed from any of the free page
> lists. The main usage of sgx_nr_free_pages is by the reclaimer
> that will run when it (sgx_nr_free_pages) goes below a watermark
> to ensure that there are always some free pages available to, for
> example, support efficient page faults.
>=20
> With sgx_nr_free_pages accessed and modified from a few places
> it is essential to ensure that these accesses are done safely but
> this is not the case. sgx_nr_free_pages is read without any
> protection and updated with inconsistent protection by any one
> of the spin locks associated with the individual NUMA nodes.
> For example:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU_A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 CPU_B
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -----=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 -----
> =C2=A0spin_lock(&nodeA->lock);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&nodeB->lock);
> =C2=A0...=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0sgx_nr_free_pages--;=C2=A0 /* NOT SAFE */=C2=A0 sgx_nr_free_pages--=
;
>=20
> =C2=A0spin_unlock(&nodeA->lock);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&nodeB->lock);

I don't understand the "NOT SAFE" part here. It is safe to access
the variable, even when it is not atomic...

I don't understand what the sequence above should tell me.

> The consequence of sgx_nr_free_pages not being protected is that
> its value may not accurately reflect the actual number of free
> pages on the system, impacting the availability of free pages in
> support of many flows. The problematic scenario isu when the

In non-atomicity is not a problem, when it is not a problem :-)

> reclaimer does not run because it believes there to be sufficient
> free pages while any attempt to allocate a page fails because there
> are no free pages available.
>=20
> The worst scenario observed was a user space hang because of
> repeated page faults caused by no free pages made available.
>=20
> The following flow was encountered:
> asm_exc_page_fault
> =C2=A0...
> =C2=A0=C2=A0 sgx_vma_fault()
> =C2=A0=C2=A0=C2=A0=C2=A0 sgx_encl_load_page()
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sgx_encl_eldu() // Encrypted page ne=
eds to be loaded from backing
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 // storage int=
o newly allocated SGX memory page
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sgx_alloc_epc_page() // =
Allocate a page of SGX memory
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __sgx_alloc_=
epc_page() // Fails, no free SGX memory
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sgx_shou=
ld_reclaim(SGX_NR_LOW_PAGES)) // Wake reclaimer
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
wake_up(&ksgxd_waitq);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EBUS=
Y; // Return -EBUSY giving reclaimer time to run
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EBUSY;
> =C2=A0=C2=A0=C2=A0=C2=A0 return -EBUSY;
> =C2=A0=C2=A0 return VM_FAULT_NOPAGE;
>=20
> The reclaimer is triggered in above flow with the following code:
>=20
> static bool sgx_should_reclaim(unsigned long watermark)
> {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return sgx_nr_free_pages < wat=
ermark &&
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 !list_empty(&sgx_active_page_list);
> }
>=20
> In the problematic scenario there were no free pages available yet the
> value of sgx_nr_free_pages was above the watermark. The allocation of
> SGX memory thus always failed because of a lack of free pages while no
> free pages were made available because the reclaimer is never started
> because of sgx_nr_free_pages' incorrect value. The consequence was that
> user space kept encountering VM_FAULT_NOPAGE that caused the same
> address to be accessed repeatedly with the same result.

That causes sgx_should_reclaim() executed to be multiple times as the
fault is retried. Eventually it should be successful.

> Change the global free page counter to an atomic type that
> ensures simultaneous updates are done safely. While doing so, move
> the updating of the variable outside of the spin lock critical
> section to which it does not belong.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_=
alloc_epc_page()")
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

I'm not yet sure if this a bug, even if it'd be a improvement
to the performance.

/Jarkko

