Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D9124E2B1
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHUV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 17:29:43 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47324 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHUV3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 17:29:43 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E5BBD1C0BB0; Fri, 21 Aug 2020 23:29:41 +0200 (CEST)
Date:   Fri, 21 Aug 2020 23:29:41 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: Track page table modifications in
 __apply_to_page_range()
Message-ID: <20200821212941.GA5408@amd>
References: <20200821123746.16904-1-joro@8bytes.org>
 <20200821133548.be58a3b0881b41a32759fa04@linux-foundation.org>
 <159804301810.32652.14249776487575415877@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <159804301810.32652.14249776487575415877@build.alporthouse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The __apply_to_page_range() function is also used to change and/or
> > > allocate page-table pages in the vmalloc area of the address space.
> > > Make sure these changes get synchronized to other page-tables in the
> > > system by calling arch_sync_kernel_mappings() when necessary.
> >=20
> > There's no description here of the user-visible effects of the bug.=20
> > Please always provide this, especially when proposing a -stable
> > backport.  Take pity upon all the downstream kernel maintainers who are
> > staring at this wondering whether they should risk adding it to their
> > kernels.
>=20
> The impact appears limited to x86-32, where apply_to_page_range may miss
> updating the PMD. That leads to explosions in drivers like
>=20
> [   24.227844] BUG: unable to handle page fault for address: fe036000
> [   24.228076] #PF: supervisor write access in kernel mode
> [   24.228294] #PF: error_code(0x0002) - not-present page
> [   24.228494] *pde =3D 00000000
> [   24.228640] Oops: 0002 [#1] SMP
> [   24.228788] CPU: 3 PID: 1300 Comm: gem_concurrent_ Not tainted 5.9.0-r=
c1+ #16
> [   24.228957] Hardware name:  /NUC6i3SYB, BIOS SYSKLi35.86A.0024.2015.10=
27.2142 10/27/2015
> [   24.229297] EIP: __execlists_context_alloc+0x132/0x2d0 [i915]
> [   24.229462] Code: 31 d2 89 f0 e8 2f 55 02 00 89 45 e8 3d 00 f0 ff ff 0=
f 87 11 01 00 00 8b 4d e8 03 4b 30 b8 5a 5a 5a 5a ba 01 00 00 00 8d 79 04 <=
c7> 01 5a 5a 5a 5a c7 81 fc 0f 00 00 5a 5a 5a 5a 83 e7 fc 29 f9 81
> [   24.229759] EAX: 5a5a5a5a EBX: f60ca000 ECX: fe036000 EDX: 00000001
> [   24.229915] ESI: f43b7340 EDI: fe036004 EBP: f6389cb8 ESP: f6389c9c
> [   24.230072] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010=
286
> [   24.230229] CR0: 80050033 CR2: fe036000 CR3: 2d361000 CR4: 001506d0
> [   24.230385] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   24.230539] DR6: fffe0ff0 DR7: 00000400
> [   24.230675] Call Trace:
> [   24.230957]  execlists_context_alloc+0x10/0x20 [i915]
> [   24.231266]  intel_context_alloc_state+0x3f/0x70 [i915]
> [   24.231547]  __intel_context_do_pin+0x117/0x170 [i915]
> [   24.231850]  i915_gem_do_execbuffer+0xcc7/0x2500 [i915]
> [   24.232024]  ? __kmalloc_track_caller+0x54/0x230
> [   24.232181]  ? ktime_get+0x3e/0x120
> [   24.232333]  ? dma_fence_signal+0x34/0x50
> [   24.232617]  i915_gem_execbuffer2_ioctl+0xcd/0x1f0 [i915]
> [   24.232912]  ? i915_gem_execbuffer_ioctl+0x2e0/0x2e0 [i915]
> [   24.233084]  drm_ioctl_kernel+0x8f/0xd0
> [   24.233236]  drm_ioctl+0x223/0x3d0
> [   24.233505]  ? i915_gem_execbuffer_ioctl+0x2e0/0x2e0 [i915]
> [   24.233684]  ? pick_next_task_fair+0x1b5/0x3d0
> [   24.233873]  ? __switch_to_asm+0x36/0x50
> [   24.234021]  ? drm_ioctl_kernel+0xd0/0xd0
> [   24.234167]  __ia32_sys_ioctl+0x1ab/0x760
> [   24.234313]  ? exit_to_user_mode_prepare+0xe5/0x110
> [   24.234453]  ? syscall_exit_to_user_mode+0x23/0x130
> [   24.234601]  __do_fast_syscall_32+0x3f/0x70
> [   24.234744]  do_fast_syscall_32+0x29/0x60
> [   24.234885]  do_SYSENTER_32+0x15/0x20
> [   24.235021]  entry_SYSENTER_32+0x9f/0xf2
> [   24.235157] EIP: 0xb7f28559
> [   24.235288] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 0=
7 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <=
5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
> [   24.235576] EAX: ffffffda EBX: 00000005 ECX: c0406469 EDX: bf95556c
> [   24.235722] ESI: b7e68000 EDI: c0406469 EBP: 00000005 ESP: bf9554d8
> [   24.235869] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000=
296
> [   24.236018] Modules linked in: i915 x86_pkg_temp_thermal intel_powercl=
amp crc32_pclmul crc32c_intel intel_cstate intel_uncore intel_gtt drm_kms_h=
elper intel_pch_thermal video button autofs4 i2c_i801 i2c_smbus fan
> [   24.236336] CR2: 00000000fe036000
>=20
> It looks like kasan, xen and i915 are vulnerable.

And actual impact is "on thinkpad X60 in 5.9-rc1, screen starts
blinking after 30-or-so minutes, and macine is unusable"... that is
assuming we are taking same bug.

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9APMUACgkQMOfwapXb+vIqlQCgm7zxsEBdfcvxbL1Na0G7WDPX
+KUAn2d/s1U+J6N41YFcV66zr9KtN9+q
=89db
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
