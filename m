Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CADA4903DE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 09:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbiAQIan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 03:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiAQIan (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 03:30:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FCFC061574;
        Mon, 17 Jan 2022 00:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC25F610A2;
        Mon, 17 Jan 2022 08:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4644C36AE3;
        Mon, 17 Jan 2022 08:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642408242;
        bh=6UfY3mIawXOU0h+45xtXjR0jKTtZForlEE8MaDpHi+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXYYSrTnV24+5pzRLA6GjVlX20YkV+wwuzD2+HCLxftKr+FVp0Psw1HJTOGCktHlV
         RTIsX0ojNX3eYU7Dvgx0UqrgGFonVN9gYsrzZKmcP1KrDAXaMwdD+QzM2Mu+feBK1R
         Eb7u/qLyi/5HEhCY9T7RsPi/bzIWFmj3DmwIXlGgq9spGK7nq6Jm1EMjIxgmrRTs5I
         lzFWcVVbl0hSz5ee7WfnOR6physbHk0sTfDpb7RDHnrXtW+3Xsq1296s6uMWmZHHEk
         zWfVwAEepKD+N2B2qewXJmbzeD7ckts9yvgeGoI1kGazmOceJL0BmrslzjbE+/DJUZ
         Ggq5EKW/Q8I2g==
Date:   Mon, 17 Jan 2022 10:30:27 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YeUpI8L2c9h/TEFk@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <cd26205a-8551-194f-58df-05f89cd4f049@intel.com>
 <YeHqW8AaQ3HZZoQx@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YeHqW8AaQ3HZZoQx@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 11:25:47PM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 12, 2022 at 10:08:02PM -0800, Reinette Chatre wrote:
> > Hi Jarkko,
> >=20
> > On 1/8/2022 6:05 AM, Jarkko Sakkinen wrote:
> > > There is a limited amount of SGX memory (EPC) on each system.  When t=
hat
> > > memory is used up, SGX has its own swapping mechanism which is similar
> > > in concept but totally separate from the core mm/* code.  Instead of
> > > swapping to disk, SGX swaps from EPC to normal RAM.  That normal RAM
> > > comes from a shared memory pseudo-file and can itself be swapped by t=
he
> > > core mm code.  There is a hierarchy like this:
> > >=20
> > > 	EPC <-> shmem <-> disk
> > >=20
> > > After data is swapped back in from shmem to EPC, the shmem backing
> > > storage needs to be freed.  Currently, the backing shmem is not freed.
> > > This effectively wastes the shmem while the enclave is running.  The
> > > memory is recovered when the enclave is destroyed and the backing
> > > storage freed.
> > >=20
> > > Sort this out by freeing memory with shmem_truncate_range(), as soon =
as
> > > a page is faulted back to the EPC.  In addition, free the memory for
> > > PCMD pages as soon as all PCMD's in a page have been marked as unused
> > > by zeroing its contents.
> > >=20
> > > Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > > v3:
> > > * Resend.
> > > v2:
> > > * Rewrite commit message as proposed by Dave.
> > > * Truncate PCMD pages (Dave).
> > > ---
> > >  arch/x86/kernel/cpu/sgx/encl.c | 48 +++++++++++++++++++++++++++++++-=
--
> > >  1 file changed, 44 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx=
/encl.c
> > > index 001808e3901c..ea43c10e5458 100644
> > > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > > @@ -12,6 +12,27 @@
> > >  #include "encls.h"
> > >  #include "sgx.h"
> > > =20
> > > +
> > > +/*
> > > + * Get the page number of the page in the backing storage, which sto=
res the PCMD
> > > + * of the enclave page in the given page index.  PCMD pages are loca=
ted after
> > > + * the backing storage for the visible enclave pages and SECS.
> > > + */
> > > +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *=
encl, pgoff_t index)
> > > +{
> > > +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> > > +}
> > > +
> > > +/*
> > > + * Free a page from the backing storage in the given page index.
> > > + */
> > > +static inline void sgx_encl_truncate_backing_page(struct sgx_encl *e=
ncl, pgoff_t index)
> > > +{
> > > +	struct inode *inode =3D file_inode(encl->backing);
> > > +
> > > +	shmem_truncate_range(inode, PFN_PHYS(index), PFN_PHYS(index) + PAGE=
_SIZE - 1);
> > > +}
> > > +
> > >  /*
> > >   * ELDU: Load an EPC page as unblocked. For more info, see "OS Manag=
ement of EPC
> > >   * Pages" in the SDM.
> > > @@ -24,7 +45,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *e=
ncl_page,
> > >  	struct sgx_encl *encl =3D encl_page->encl;
> > >  	struct sgx_pageinfo pginfo;
> > >  	struct sgx_backing b;
> > > +	bool pcmd_page_empty;
> > >  	pgoff_t page_index;
> > > +	pgoff_t pcmd_index;
> > > +	u8 *pcmd_page;
> > >  	int ret;
> > > =20
> > >  	if (secs_page)
> > > @@ -38,8 +62,8 @@ static int __sgx_encl_eldu(struct sgx_encl_page *en=
cl_page,
> > > =20
> > >  	pginfo.addr =3D encl_page->desc & PAGE_MASK;
> > >  	pginfo.contents =3D (unsigned long)kmap_atomic(b.contents);
> > > -	pginfo.metadata =3D (unsigned long)kmap_atomic(b.pcmd) +
> > > -			  b.pcmd_offset;
> > > +	pcmd_page =3D kmap_atomic(b.pcmd);
> > > +	pginfo.metadata =3D (unsigned long)pcmd_page + b.pcmd_offset;
> > > =20
> > >  	if (secs_page)
> > >  		pginfo.secs =3D (u64)sgx_get_epc_virt_addr(secs_page);
> > > @@ -55,11 +79,27 @@ static int __sgx_encl_eldu(struct sgx_encl_page *=
encl_page,
> > >  		ret =3D -EFAULT;
> > >  	}
> > > =20
> > > -	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - b.pcmd_offs=
et));
> > > +	memset(pcmd_page + b.pcmd_offset, 0, sizeof(struct sgx_pcmd));
> > > +
> > > +	/*
> > > +	 * The area for the PCMD in the page was zeroed above.  Check if the
> > > +	 * whole page is now empty meaning that all PCMD's have been zeroed:
> > > +	 */
> > > +	pcmd_page_empty =3D !memchr_inv(pcmd_page, 0, PAGE_SIZE);
> > > +
> > > +	kunmap_atomic(pcmd_page);
> > >  	kunmap_atomic((void *)(unsigned long)pginfo.contents);
> > > =20
> > >  	sgx_encl_put_backing(&b, false);
> > > =20
> > > +	/* Free the backing memory. */
> > > +	sgx_encl_truncate_backing_page(encl, page_index);
> > > +
> > > +	if (pcmd_page_empty) {
> > > +		pcmd_index =3D sgx_encl_get_backing_pcmd_nr(encl, page_index);
> > > +		sgx_encl_truncate_backing_page(encl, pcmd_index);
> > > +	}
> > > +
> > >  	return ret;
> > >  }
> > > =20
> > > @@ -577,7 +617,7 @@ static struct page *sgx_encl_get_backing_page(str=
uct sgx_encl *encl,
> > >  int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_i=
ndex,
> > >  			 struct sgx_backing *backing)
> > >  {
> > > -	pgoff_t pcmd_index =3D PFN_DOWN(encl->size) + 1 + (page_index >> 5);
> > > +	pgoff_t pcmd_index =3D sgx_encl_get_backing_pcmd_nr(encl, page_inde=
x);
> > >  	struct page *contents;
> > >  	struct page *pcmd;
> > > =20
> >=20
> > I applied this patch on top of commit 2056e2989bf4 ("x86/sgx: Fix NULL =
pointer
> > dereference on non-SGX systems") found on branch x86/sgx of the tip rep=
o.
> >=20
> > When I run the SGX selftests the new oversubscription test case is fail=
ing with
> > the error below:
> > ./test_sgx
> > TAP version 13
> > 1..6
> > # Starting 6 tests from 2 test cases.
> > #  RUN           enclave.unclobbered_vdso ...
> > #            OK  enclave.unclobbered_vdso
> > ok 1 enclave.unclobbered_vdso
> > #  RUN           enclave.unclobbered_vdso_oversubscribed ...
> > # main.c:330:unclobbered_vdso_oversubscribed:Expected (&self->run)->fun=
ction (2) =3D=3D EEXIT (4)
> > # main.c:330:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000f=
ff
> > # main.c:338:unclobbered_vdso_oversubscribed:Expected get_op.value (0) =
=3D=3D MAGIC (1234605616436508552)
> > # main.c:339:unclobbered_vdso_oversubscribed:Expected (&self->run)->fun=
ction (2) =3D=3D EEXIT (4)
> > # main.c:339:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f6000000f=
ff
> > # unclobbered_vdso_oversubscribed: Test failed at step #2
> > #          FAIL  enclave.unclobbered_vdso_oversubscribed
> > not ok 2 enclave.unclobbered_vdso_oversubscribed
> > #  RUN           enclave.clobbered_vdso ...
> > #            OK  enclave.clobbered_vdso
> > ok 3 enclave.clobbered_vdso
> > #  RUN           enclave.clobbered_vdso_and_user_function ...
> > #            OK  enclave.clobbered_vdso_and_user_function
> > ok 4 enclave.clobbered_vdso_and_user_function
> > #  RUN           enclave.tcs_entry ...
> > #            OK  enclave.tcs_entry
> > ok 5 enclave.tcs_entry
> > #  RUN           enclave.pte_permissions ...
> > #            OK  enclave.pte_permissions
> >=20
> > The kernel logs also contain a splat that I have not encountered before:
> >=20
> > ------------[ cut here ]------------
> > ELDU returned 9 (0x9)
> > WARNING: CPU: 6 PID: 2470 at arch/x86/kernel/cpu/sgx/encl.c:77 sgx_encl=
_eldu+0x37c/0x3f0
> > Modules linked in: intel_rapl_msr intel_rapl_common i10nm_edac x86_pkg_=
temp_thermal ipmi_ssif coretemp kvm_intel kvm cmdlinepart intel_spi_pci int=
el_spi spi_nor ipmi_si mei_me ipmi_devintf input_leds irqbypass mtd mei ioa=
tdma intel_pch_thermal wmi ipmi_msghandler acpi_power_meter iscsi_tcp libis=
csi_tcp libiscsi scsi_transport_iscsi btrfs blake2b_generic zstd_compress r=
aid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xo=
r raid6_pq raid1 raid0 multipath linear ixgbe crct10dif_pclmul crc32_pclmul=
 ghash_clmulni_intel hid_generic aesni_intel crypto_simd xfrm_algo usbhid c=
ryptd ast dca hid mdio drm_vram_helper drm_ttm_helper
> > CPU: 6 PID: 2470 Comm: test_sgx Not tainted 5.16.0-rc1+ #24
> > Hardware name: Intel Corporation=20
> > RIP: 0010:sgx_encl_eldu+0x37c/0x3f0
> > Code: 89 c2 48 c7 c6 e1 e9 3e 9b 48 c7 c7 e6 e9 3e 9b 44 89 95 54 ff ff=
 ff 4c 89 85 58 ff ff ff c6 05 fc bd dd 01 01 e8 54 88 03 00 <0f> 0b 44 8b =
95 54 ff ff ff 4c 8b 85 58 ff ff ff e9 46 fe ff ff 48
> > <snip>
> > Call Trace:
> > <TASK>
> > sgx_encl_load_page+0x82/0xc0
> > ? sgx_encl_load_page+0x82/0xc0
> > sgx_vma_fault+0x40/0xe0
> > __do_fault+0x32/0x110
> > __handle_mm_fault+0xf84/0x1510
> > handle_mm_fault+0x13e/0x3f0
> > do_user_addr_fault+0x210/0x660
> > ? rcu_read_lock_sched_held+0x4f/0x80
> > exc_page_fault+0x7b/0x270
> > ? asm_exc_page_fault+0x8/0x30
> > asm_exc_page_fault+0x1e/0x30
> > RIP: 0033:0x7ffe7fdc3dba
> > <snip>
> >=20
> > I ran the test on two systems and in both cases the test failed accompa=
nied by
> > the kernel splat.
> >=20
> > Reinette
>=20
> Thank you for testing this.
>=20
> I did not get any errors when I run kselftest at the time *but* it was
> exactly two months ago (2021-11-11). I cannot recall whether this test
> was already in at the time, or did I run the overcommit test out-of-tree,
> or if some confliciting non-kselftest changes have been applied.
>=20
> I'll do the backtracking when I have the time by doing git bisect between
> 2021-11-11 x86/sgx and the current one.

Yep, I think I get the exact same result with tip/x86/sgx.

$ ./test_sgx=20
TAP version 13
1..6
# Starting 6 tests from 2 test cases.
#  RUN           enclave.unclobbered_vdso ...
#            OK  enclave.unclobbered_vdso
ok 1 enclave.unclobbered_vdso
#  RUN           enclave.unclobbered_vdso_oversubscribed ...
# main.c:330:unclobbered_vdso_oversubscribed:Expected (&self->run)->functio=
n (2) =3D=3D EEXIT (4)
# main.c:330:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f3160000fff
# main.c:338:unclobbered_vdso_oversubscribed:Expected get_op.value (0) =3D=
=3D MAGIC (1234605616436508552)
# main.c:339:unclobbered_vdso_oversubscribed:Expected (&self->run)->functio=
n (2) =3D=3D EEXIT (4)
# main.c:339:unclobbered_vdso_oversubscribed:0x0e 0x06 0x00007f3160000fff
# unclobbered_vdso_oversubscribed: Test failed at step #2
#          FAIL  enclave.unclobbered_vdso_oversubscribed
not ok 2 enclave.unclobbered_vdso_oversubscribed
#  RUN           enclave.clobbered_vdso ...
#            OK  enclave.clobbered_vdso
ok 3 enclave.clobbered_vdso
#  RUN           enclave.clobbered_vdso_and_user_function ...
#            OK  enclave.clobbered_vdso_and_user_function
ok 4 enclave.clobbered_vdso_and_user_function
#  RUN           enclave.tcs_entry ...
#            OK  enclave.tcs_entry
ok 5 enclave.tcs_entry
#  RUN           enclave.pte_permissions ...
#            OK  enclave.pte_permissions
ok 6 enclave.pte_permissions
# FAILED: 5 / 6 tests passed.
# Totals: pass:5 fail:1 xfail:0 xpass:0 skip:0 error:0

And dmesg output:

[ 4267.158920] ------------[ cut here ]------------
[ 4267.158923] ELDU returned 9 (0x9)
[ 4267.158936] WARNING: CPU: 1 PID: 1343 at arch/x86/kernel/cpu/sgx/encl.c:=
77 sgx_encl_eldu+0x3f7/0x420
[ 4267.158945] Modules linked in: cfg80211 rfkill ccm algif_aead des_generi=
c libdes ecb algif_skcipher cmac md4 algif_hash af_alg intel_rapl_msr intel=
_rapl_common kvm_intel kvm snd_hda_codec_generic ledtrig_audio irqbypass sn=
d_hda_intel rapl snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec iTCO_wdt=
 intel_pmc_bxt iTCO_vendor_support snd_hda_core psmouse vfat snd_hwdep fat =
snd_pcm intel_agp i2c_i801 intel_gtt pcspkr joydev i2c_smbus snd_timer agpg=
art mousedev ext4 snd lpc_ich soundcore mac_hid qemu_fw_cfg crc16 mbcache j=
bd2 pkcs8_key_parser fuse ip_tables x_tables btrfs blake2b_generic libcrc32=
c crc32c_generic xor raid6_pq dm_crypt cbc encrypted_keys trusted asn1_enco=
der tee usbhid dm_mod virtio_gpu virtio_dma_buf drm_kms_helper syscopyarea =
sysfillrect sysimgblt fb_sys_fops virtio_rng cec virtio_balloon virtio_blk =
virtio_console drm virtio_net net_failover failover crct10dif_pclmul crc32_=
pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd tpm_=
crb tpm_tis serio_raw
[ 4267.159078]  tpm_tis_core xhci_pci xhci_pci_renesas tpm virtio_pci virti=
o_pci_legacy_dev virtio_pci_modern_dev rng_core
[ 4267.159089] CPU: 1 PID: 1343 Comm: test_sgx Not tainted 5.16.0-rc1-1-sgx=
-g142746670045 #1
[ 4267.159092] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0=
=2E0 02/06/2015
[ 4267.159095] RIP: 0010:sgx_encl_eldu+0x3f7/0x420
[ 4267.159098] Code: ff ff ff 89 c1 89 c2 48 c7 c6 03 06 d6 9c 4c 89 0c 24 =
48 c7 c7 08 06 d6 9c 44 89 54 24 08 c6 05 5f 45 b6 01 01 e8 d2 78 a6 00 <0f=
> 0b 4c 8b 0c 24 44 8b 54 24 08 e9 36 fe ff ff e8 5b 8b fa ff e9
[ 4267.159099] RSP: 0000:ffffb5314074bcc0 EFLAGS: 00010282
[ 4267.159100] RAX: 0000000000000000 RBX: ffffb5314074bce0 RCX: 00000000000=
00027
[ 4267.159101] RDX: ffff8bd9f7d20728 RSI: 0000000000000001 RDI: ffff8bd9f7d=
20720
[ 4267.159102] RBP: ffffb5314074bd70 R08: 0000000000000000 R09: ffffb531407=
4baf0
[ 4267.159103] R10: ffffb5314074bae8 R11: ffffffff9d4cbd28 R12: ffff8bd9a3c=
a18c0
[ 4267.159104] R13: 0000000000000000 R14: ffff8bd882139000 R15: ffffb531403=
a9420
[ 4267.159105] FS:  00007f3163e48c00(0000) GS:ffff8bd9f7d00000(0000) knlGS:=
0000000000000000
[ 4267.159106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4267.159107] CR2: 00007f3160000fff CR3: 00000001a2046001 CR4: 00000000003=
70ee0
[ 4267.159111] Call Trace:
[ 4267.159116]  <TASK>
[ 4267.159124]  sgx_encl_load_page+0x73/0xb0
[ 4267.159126]  sgx_vma_fault+0x3a/0xd0
[ 4267.159127]  __do_fault+0x36/0xd0
[ 4267.159132]  __handle_mm_fault+0xd4e/0x1540
[ 4267.159135]  handle_mm_fault+0xb2/0x280
[ 4267.159137]  do_user_addr_fault+0x1ba/0x690
[ 4267.159140]  exc_page_fault+0x72/0x170
[ 4267.159144]  ? asm_exc_page_fault+0x8/0x30
[ 4267.159147]  asm_exc_page_fault+0x1e/0x30
[ 4267.159150] RIP: 0033:0x7ffe771c4c8a
[ 4267.159153] Code: 43 48 8b 4d 10 48 c7 c3 28 00 00 00 48 83 3c 19 00 75 =
31 48 83 c3 08 48 81 fb 00 01 00 00 75 ec 48 8b 19 48 8d 0d 00 00 00 00 <0f=
> 01 d7 48 8b 5d 10 c7 43 08 04 00 00 00 48 83 7b 18 00 75 21 31
[ 4267.159154] RSP: 002b:00007ffe7719ce88 EFLAGS: 00010246
[ 4267.159155] RAX: 0000000000000002 RBX: 00007f3160000000 RCX: 00007ffe771=
c4c8a
[ 4267.159156] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffe771=
9d020
[ 4267.159157] RBP: 00007ffe7719ce90 R08: 0000000000000000 R09: 00000000000=
00000
[ 4267.159158] R10: 00007f3163e86bb0 R11: 00007f3163fcd9f0 R12: 000055c4ac5=
8a410
[ 4267.159158] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[ 4267.159162]  </TASK>
[ 4267.159163] ---[ end trace 1b44544248db3939 ]---
[ 5395.692320] audit: type=3D1100 audit(1642407877.716:143): pid=3D1397 uid=
=3D1000 auid=3D1000 ses=3D3 msg=3D'op=3DPAM:authentication grantors=3D? acc=
t=3D"jarkko" exe=3D"/usr/bin/sudo" hostname=3D? addr=3D? terminal=3D/dev/pt=
s/0 res=3Dfailed'
[ 5400.216126] audit: type=3D1100 audit(1642407882.243:144): pid=3D1397 uid=
=3D1000 auid=3D1000 ses=3D3 msg=3D'op=3DPAM:authentication grantors=3Dpam_f=
aillock,pam_permit,pam_faillock acct=3D"jarkko" exe=3D"/usr/bin/sudo" hostn=
ame=3D? addr=3D? terminal=3D/dev/pts/0 res=3Dsuccess'
[ 5400.216289] audit: type=3D1101 audit(1642407882.243:145): pid=3D1397 uid=
=3D1000 auid=3D1000 ses=3D3 msg=3D'op=3DPAM:accounting grantors=3Dpam_unix,=
pam_permit,pam_time acct=3D"jarkko" exe=3D"/usr/bin/sudo" hostname=3D? addr=
=3D? terminal=3D/dev/pts/0 res=3Dsuccess'
[ 5400.217010] audit: type=3D1110 audit(1642407882.243:146): pid=3D1397 uid=
=3D1000 auid=3D1000 ses=3D3 msg=3D'op=3DPAM:setcred grantors=3Dpam_faillock=
,pam_permit,pam_faillock acct=3D"root" exe=3D"/usr/bin/sudo" hostname=3D? a=
ddr=3D? terminal=3D/dev/pts/0 res=3Dsuccess'
[ 5400.219633] audit: type=3D1105 audit(1642407882.246:147): pid=3D1397 uid=
=3D1000 auid=3D1000 ses=3D3 msg=3D'op=3DPAM:session_open grantors=3Dpam_sys=
temd_home,pam_limits,pam_unix,pam_permit acct=3D"root" exe=3D"/usr/bin/sudo=
" hostname=3D? addr=3D? terminal=3D/dev/pts/0 res=3Dsuccess'

This was run in QEMU.

/Jarkko
