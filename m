Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8635832FE1C
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 01:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhCGAEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 19:04:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59418 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCGAEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 19:04:07 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D73651C0B76; Sun,  7 Mar 2021 01:04:04 +0100 (CET)
Date:   Sun, 7 Mar 2021 01:04:04 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: qemu meltdown test failure was Re: [PATCH 4.4 00/30] 4.4.260-rc1
 review
Message-ID: <20210307000403.GB10472@amd>
References: <20210305120849.381261651@linuxfoundation.org>
 <20210305220634.GA27686@amd>
 <YEM4d6O+6Jfw3RH/@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <YEM4d6O+6Jfw3RH/@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Ok, so we ran some tests.
> >=20
> > And they failed:
> >=20
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/10=
75959449
> >=20
> > [   26.785861] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3DCVE-2018-3639 RESUL=
T=3Dfail>
> > Received signal: <TESTCASE> TEST_CASE_ID=3DCVE-2018-3639 RESULT=3Dfail
> >=20
> > Testcase name is spectre-meltdown-checker... Failing on qemu? Somehow
> > strange, but it looks like real test failure.

First let me try 7d472e4a11d6a2fb1c492b02c7d7dacd3297bbf4 --
v4.4.257-cip54. That is
https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/266532179
=2E.. Qemu is OKAY.

add3ff3730919447a7519fede0b8554132e0f8d5 Merge remote-tracking branch
'stable/queue/4.4' in to v4.4.260-bisect. Results will be at
https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/266534478
=2E.. ... still pending.

Aha, but I won't be able to bisect in that :-(.

So let's create v4.4.259-cip:

e988bf453263ff43de27336a31115e8f552cd520 Merge commit
'93af63b25443f66d90450845526843076c81c7f0' into v4.4.260-bisect
93af63b25443f66d90450845526843076c81c7f0 Linux 4.4.259

And rebase v4.4.260 on top of that. So we now have this ... and it
should enable bisection:

https://gitlab.com/cip-project/cip-kernel/linux-cip/-/pipelines/XXX

                     c700659b7d3efe7e5e1482aac93ccc6d88896696 media: v4l: i=
octl: Fix memory leak in video_usercopy
                     430f39261e34361d909df9d25cdd7fe4925ab147 swap: fix swa=
pfile read/write offset
                     0a3f4c372b91921ffc9976c142cc7de42f527d15 zsmalloc: acc=
ount the number of compacted pages correctly
test 266539168       8c461bb103f89696576945ad9cb376df34fa9d28 xen-netback: =
respect gnttab_map_refs()'s return value
                     c6352c9b2e66258bd78101a85858e1b1c6c01fe2 Xen/gnttab: h=
andle p2m update errors on a per-slot basis
                     b854b5154c7a682856081b25552f59ff13b5edf6 scsi: iscsi: =
Verify lengths on passthrough PDUs
                     015110b4ba859649dd94f23040732c75fcd3c0f2 scsi: iscsi: =
Ensure sysfs attributes are limited to PAGE_SIZE
                     679dbc5d12389622c842ccce08b92bab3d8ce853 sysfs: Add sy=
sfs_emit and sysfs_emit_at to format sysfs output
                     8f5a499b4489f8aaeb7e95ec8da955317006f767 scsi: iscsi: =
Restrict sessions and handles to admin capabilities
                     8e3bd2f64a90b6be947fc8636e2642f2f4186077 media: uvcvid=
eo: Allow entities with no pads
                     55a0611f55d162faecf4514dea4351612b2ffc26 staging: most=
: sound: add sanity check for function argument
                     76471b77ee8eb76795cfaffef9065cf219fef432 Bluetooth: Fi=
x null pointer dereference in amp_read_loc_assoc_final_data
                     163650eed99950e9a1b485fd927323430db2a01a x86/build: Tr=
eat R_386_PLT32 relocation as R_386_PC32
                     fcd9411f34ca2b80244adeb4589ee592cebabe58 ath10k: fix w=
mi mgmt tx queue full due to race condition
                     c8b13f3c80f4ff8201a149a1eb2a45859be5b28b pktgen: fix m=
isuse of BUG_ON() in pktgen_thread_worker()
                     a3a6ff3d2a4a5f6f092c3294c9c7c8d3a26a1190 wlcore: Fix c=
ommand execute failure 19 for wl12xx
                     0334ca6c8e3a07688ceb5bbf7589d9ca8ad25d53 vt/consolemap=
: do font sum unsigned
                     48145a8b9d1aa1a8eada534df395f39355eb02f8 x86/reboot: A=
dd Zotac ZBOX CI327 nano PCI reboot quirk
test 266538760       1efe86b456816c95485c65cf9ba46a5bff8a241e staging: fwse=
rial: Fix error handling in fwserial_create
                     d1b114d9ab15fe3f9f87178af194c8e6573948a5 mm/hugetlb.c:=
 fix unnecessary address expansion of pmd sharing
                     ee60af793079bcf79a4ae0ff0877bd1c5767b0de net: fix up t=
ruesize of cloned skb in skb_prepare_for_shift()
                     6f2e9739399d5d2ba02d82fe32177c1e933116e9 xfs: Fix asse=
rt failure in xfs_setattr_size()
                     1ba9d3843164451426cc37413cd20d55a5702b3e JFS: more che=
cks for invalid superblock
                     11f19718da9f3e5307a08d03e6bb72aef9450a9c hugetlb: fix =
update_and_free_page contig page struct assumption
                     d2f0c8c15ff0900d76496b7cbb870c830b120867 scripts: set =
proper OpenSSL include dir also for sign-file
                     ae3507eb02e8b6449add4d356d6ba788d65aee14 scripts: use =
pkg-config to locate libcrypto
                     66e96f4397bd1ca22275c3d7c2820d04a11ff765 mmc: sdhci-es=
dhc-imx: fix kernel panic when remove module
test 266539768       8b4bc0f97fdd13b08c2436aad01bd4515d07f93a iwlwifi: pcie=
: fix to correct null check
                     6805f20f2187dde9e2ad44e045747bcaa621ee51 net: usb: qmi=
_wwan: support ZTE P685M modem
                     3879e0dbe534ac4b937455fe3af2248692e9f6d8 futex: Ensure=
 the correct return value from futex_lock_pi()
                     e988bf453263ff43de27336a31115e8f552cd520 Merge commit =
'93af63b25443f66d90450845526843076c81c7f0' into v4.4.260-bisect
                     93af63b25443f66d90450845526843076c81c7f0 Linux 4.4.259

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBEGHMACgkQMOfwapXb+vIHcQCgmp6uREQR7wNan4DqNpsEz/8Z
85YAn3i2QJ15faVCyUZZCDzJLo8//fzE
=TBcc
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
