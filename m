Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7534536A4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 17:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbhKPQE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 11:04:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238799AbhKPQEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 11:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FAEB63214;
        Tue, 16 Nov 2021 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637078481;
        bh=0PSG+6xaIQ+J2U2x+fg7elsNbRPYWLx/o3TGsveFJWU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sqj0xvR4s7y9f5KYvL0zyv6XxHfQsQy6es91TIbTX/FJrSBMb6B6sH12cg2zk6glL
         zNSTUw7tJg4IrsXhWbh2d13I/1VF9f8DOF3rMwKtcsQN+clGvh04ixESa2oMDeaqIj
         cvuOVghNgwpJz5WI94XkCyVTXRQAakxBWskhl4o/eiSZlpfd31wNbH39zDq27X0o9w
         uSDzky93CvDQ/CWx91Z+eSolAbdSI4qD/VT9/MiabILIiuLWgEq0rZ/X/kIIGX82ur
         nS+2o/ZexIyob3ZSQxIhHEjL8NdIxxuK+UHse5S0H4RJ9q/1qr9whzTBbYGFQpDtlJ
         W3ukyvR3hrMDQ==
Message-ID: <3f3467f0213dad19200c9485151956f630db6f60.camel@kernel.org>
Subject: Re: [PATCH V3] x86/sgx: Fix free page accounting
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, tony.luck@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 16 Nov 2021 18:01:19 +0200
In-Reply-To: <a95a40743bbd3f795b465f30922dde7f1ea9e0eb.1637004094.git.reinette.chatre@intel.com>
References: <a95a40743bbd3f795b465f30922dde7f1ea9e0eb.1637004094.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-11-15 at 11:29 -0800, Reinette Chatre wrote:
> The SGX driver maintains a single global free page counter,
> sgx_nr_free_pages, that reflects the number of free pages available
> across all NUMA nodes. Correspondingly, a list of free pages is
> associated with each NUMA node and sgx_nr_free_pages is updated
> every time a page is added or removed from any of the free page
> lists. The main usage of sgx_nr_free_pages is by the reclaimer
> that runs when it (sgx_nr_free_pages) goes below a watermark
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
>=20
> Since sgx_nr_free_pages may be protected by different spin locks
> while being modified from different CPUs, the following scenario
> is possible:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU_A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 CPU_B
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -----=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 -----
> {sgx_nr_free_pages =3D 100}
> =C2=A0spin_lock(&nodeA->lock);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&nodeB->lock);
> =C2=A0sgx_nr_free_pages--;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sgx_nr_free_pages=
--;
> =C2=A0/* LOAD sgx_nr_free_pages =3D 100 */=C2=A0=C2=A0=C2=A0 /* LOAD sgx_=
nr_free_pages =3D 100 */
> =C2=A0/* sgx_nr_free_pages--=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 */=C2=A0=C2=A0=C2=A0 /* sgx_nr_free_pages--=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0/* STORE sgx_nr_free_pages =3D 99 */=C2=A0=C2=A0=C2=A0 /* STORE sgx=
_nr_free_pages =3D 99 */
> =C2=A0spin_unlock(&nodeA->lock);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&nodeB->lock);
>=20
> In the above scenario, sgx_nr_free_pages is decremented from two CPUs
> but instead of sgx_nr_free_pages ending with a value that is two less
> than it started with, it was only decremented by one while the number
> of free pages were actually reduced by two. The consequence of
> sgx_nr_free_pages not being protected is that its value may not
> accurately reflect the actual number of free pages on the system,
> impacting the availability of free pages in support of many flows.
>=20
> The problematic scenario is when the reclaimer does not run because it
> believes there to be sufficient free pages while any attempt to allocate
> a page fails because there are no free pages available. In the SGX driver
> the reclaimer's watermark is only 32 pages so after encountering the
> above example scenario 32 times a user space hang is possible when there
> are no more free pages because of repeated page faults caused by no
> free pages made available.
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
>=20
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
> ---
> Changes since V2:
> - V2:
> https://lore.kernel.org/lkml/b2e69e9febcae5d98d331de094d9cc7ce3217e66.163=
6487172.git.reinette.chatre@intel.com/
> - Update changelog to provide example of unsafe variable modification (Ja=
rkko).
>=20
> Changes since V1:
> - V1:
> =C2=A0 https://lore.kernel.org/lkml/373992d869cd356ce9e9afe43ef4934b70d60=
4fd.1636049678.git.reinette.chatre@intel.com/
> - Add static to definition of sgx_nr_free_pages (Tony).
> - Add Tony's signature.
> - Provide detail about error scenario in changelog (Jarkko).
>=20
> =C2=A0arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
> =C2=A01 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 63d3de02bbcc..8471a8b9b48e 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -28,8 +28,7 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
> =C2=A0static LIST_HEAD(sgx_active_page_list);
> =C2=A0static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> =C2=A0
> -/* The free page list lock protected variables prepend the lock. */
> -static unsigned long sgx_nr_free_pages;
> +static atomic_long_t sgx_nr_free_pages =3D ATOMIC_LONG_INIT(0);
> =C2=A0
> =C2=A0/* Nodes with one or more EPC sections. */
> =C2=A0static nodemask_t sgx_numa_mask;
> @@ -403,14 +402,15 @@ static void sgx_reclaim_pages(void)
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0spin_lock(&node->lock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0list_add_tail(&epc_page->list, &node->free_page_lis=
t);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0sgx_nr_free_pages++;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&node->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0atomic_long_inc(&sgx_nr_free_pages);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0}
> =C2=A0
> =C2=A0static bool sgx_should_reclaim(unsigned long watermark)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return sgx_nr_free_pages < wat=
ermark && !list_empty(&sgx_active_page_list);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return atomic_long_read(&sgx_n=
r_free_pages) < watermark &&
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 !list_empty(&sgx_active_page_list);
> =C2=A0}
> =C2=A0
> =C2=A0static int ksgxd(void *p)
> @@ -471,9 +471,9 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from=
_node(int nid)
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0page =3D list_first_entry=
(&node->free_page_list, struct sgx_epc_page, list);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_del_init(&page->list=
);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nr_free_pages--;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&node->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_long_dec(&sgx_nr_free_p=
ages);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return page;
> =C2=A0}
> @@ -625,9 +625,9 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock(&node->lock);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_add_tail(&page->list=
, &node->free_page_list);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_nr_free_pages++;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&node->lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_long_inc(&sgx_nr_free_p=
ages);
> =C2=A0}
> =C2=A0
> =C2=A0static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

