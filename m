Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB4506D80
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 15:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbiDSNet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 09:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbiDSNes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 09:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91804E0AC
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 06:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D6AB61669
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 13:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DADC385A5;
        Tue, 19 Apr 2022 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650375124;
        bh=b3IJ8AcKWOSnVW4nCBkAronN7xhbEQ9CEY2LY6jMrDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FMCJyh1z7MYymbrt5FIh9Dt206M+Y6hRa+3g3vP+nmgifFB4SMJUhqkGv/9fVSvyX
         oIGIQBDA9pmVzyCMuhesj3M19mIAVBpwjsziwIxuU1B1U+1/mTVRGIG4wpBXugouJr
         fTcKtlePhu9KJuW9Hqtg+Wdm0S8v8NoH6Ks7Ip65A6aZjl30PZ9zOWSMB6Gizvjojj
         7+3osU03uXdC8smcllOTi0KVULdThCc/DyKLdiwGh/QHKmp1KdFTGueYMSQFbUsB37
         Ka02bJoamyJAFS5Kg6H6HbD/3OzbKIcTST+jSn9H1n8V3jfA40xKE+872e1HW+/csP
         UachINl27tYVw==
Date:   Tue, 19 Apr 2022 14:31:59 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mike Rapoport <rppt@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.login on
 qemu_arm-virt-gicv2-uefi
Message-ID: <Yl65zxGgFzF1Okac@sirena.org.uk>
References: <625c8753.1c69fb81.b232.69bb@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NQV1iap34Se2X7RP"
Content-Disposition: inline
In-Reply-To: <625c8753.1c69fb81.b232.69bb@mx.google.com>
X-Cookie: That's what she said.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NQV1iap34Se2X7RP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 17, 2022 at 02:32:03PM -0700, KernelCI bot wrote:

The KernelCI bisection bot found that commit 6026d4032dbbe3 ("arm:
extend pfn_valid to take into account freed memory map alignment")
triggered a regression in v5.4.x on 32 bit ARM with a qemu platform
booting UEFI firmware.  We try to dereference an invalid pointer parsing
the DMI tables:

<1>[    0.084476] 8<--- cut here ---
<1>[    0.084595] Unable to handle kernel paging request at virtual address=
 dfb76000
<1>[    0.084938] pgd =3D (ptrval)
<1>[    0.085038] [dfb76000] *pgd=3D5f7fe801, *pte=3D00000000, *ppte=3D0000=
0000

=2E..

<4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0=
x418)
<4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+=
0x8/0x10)
<4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_ini=
tcall+0x50/0x228)
<4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_=
init_freeable+0x15c/0x1f8)
<4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (ke=
rnel_init+0x8/0x10c)
<4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fo=
rk+0x14/0x2c)

This particular bisect is from GICv2 but GICv3 shows the same issue, and
it persists in the latest stable -rc:

    https://linux.kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kernel=
/v5.4.189-64-gab55553793398/plan/baseline/

A quick check seems to show that other stable branches are unaffected.
I've left all the context from the report (including full boot logs and
a Reported-by tag) below:

> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>=20
> stable-rc/linux-5.4.y bisection: baseline.login on qemu_arm-virt-gicv2-ue=
fi
>=20
> Summary:
>   Start:      e7f5213d755bc Linux 5.4.189
>   Plain log:  https://storage.kernelci.org/stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
>   HTML log:   https://storage.kernelci.org/stable-rc/linux-5.4.y/v5.4.189=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
>   Result:     6026d4032dbbe arm: extend pfn_valid to take into account fr=
eed memory map alignment
>=20
> Checks:
>   revert:     PASS
>   verify:     PASS
>=20
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
>   Branch:     linux-5.4.y
>   Target:     qemu_arm-virt-gicv2-uefi
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-10
>   Config:     multi_v7_defconfig
>   Test case:  baseline.login
>=20
> Breaking commit found:
>=20
> -------------------------------------------------------------------------=
------
> commit 6026d4032dbbe3d7f4ac2c8daa923fe74dcf41c4
> Author: Mike Rapoport <rppt@linux.ibm.com>
> Date:   Mon Dec 13 16:57:09 2021 +0800
>=20
>     arm: extend pfn_valid to take into account freed memory map alignment
>    =20
>     commit a4d5613c4dc6d413e0733e37db9d116a2a36b9f3 upstream.
>    =20
>     When unused memory map is freed the preserved part of the memory map =
is
>     extended to match pageblock boundaries because lots of core mm
>     functionality relies on homogeneity of the memory map within pageblock
>     boundaries.
>    =20
>     Since pfn_valid() is used to check whether there is a valid memory map
>     entry for a PFN, make it return true also for PFNs that have memory m=
ap
>     entries even if there is no actual memory populated there.
>    =20
>     Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>     Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>     Tested-by: Tony Lindgren <tony@atomide.com>
>     Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel=
=2Eorg/
>     Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 5635bcc419af8..ff2cd985d20e0 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -176,11 +176,22 @@ static void __init zone_sizes_init(unsigned long mi=
n, unsigned long max_low,
>  int pfn_valid(unsigned long pfn)
>  {
>  	phys_addr_t addr =3D __pfn_to_phys(pfn);
> +	unsigned long pageblock_size =3D PAGE_SIZE * pageblock_nr_pages;
> =20
>  	if (__phys_to_pfn(addr) !=3D pfn)
>  		return 0;
> =20
> -	return memblock_is_map_memory(__pfn_to_phys(pfn));
> +	/*
> +	 * If address less than pageblock_size bytes away from a present
> +	 * memory chunk there still will be a memory map entry for it
> +	 * because we round freed memory map to the pageblock boundaries.
> +	 */
> +	if (memblock_overlaps_region(&memblock.memory,
> +				     ALIGN_DOWN(addr, pageblock_size),
> +				     pageblock_size))
> +		return 1;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL(pfn_valid);
>  #endif
> -------------------------------------------------------------------------=
------
>=20
>=20
> Git bisection log:
>=20
> -------------------------------------------------------------------------=
------
> git bisect start
> # good: [7f70428f0109470aa9177d1a9e5ce02de736f480] Linux 5.4.165
> git bisect good 7f70428f0109470aa9177d1a9e5ce02de736f480
> # bad: [e7f5213d755bc34f366d36f08825c0b446117d96] Linux 5.4.189
> git bisect bad e7f5213d755bc34f366d36f08825c0b446117d96
> # bad: [902528183f4d94945a0c1ed6048d4a5d4e1e712e] mmc: block: fix read si=
ngle on recovery logic
> git bisect bad 902528183f4d94945a0c1ed6048d4a5d4e1e712e
> # bad: [c7e4004b38aa7ad482fc46ab76e28879f84ec77e] batman-adv: allow netli=
nk usage in unprivileged containers
> git bisect bad c7e4004b38aa7ad482fc46ab76e28879f84ec77e
> # bad: [db0c834abbc186bda56b1e13b4eb61f7126c12c5] rndis_host: support Hyt=
era digital radios
> git bisect bad db0c834abbc186bda56b1e13b4eb61f7126c12c5
> # bad: [0b01c51c4f47f59ad7eb1ea5bac47fab14b188a5] qlcnic: potential deref=
erence null pointer of rx_queue->page_ring
> git bisect bad 0b01c51c4f47f59ad7eb1ea5bac47fab14b188a5
> # bad: [e7660f9535ade84ea57aed1c55d102bfb23dd2ff] mac80211: fix lookup wh=
en adding AddBA extension element
> git bisect bad e7660f9535ade84ea57aed1c55d102bfb23dd2ff
> # bad: [802a1a8501563714a5fe8824f4ed27fec04a0719] firmware: arm_scpi: Fix=
 string overflow in SCPI genpd driver
> git bisect bad 802a1a8501563714a5fe8824f4ed27fec04a0719
> # good: [2fb8e4267c47d69d6bada6310607ea3762f6c962] KVM: x86: Ignore spars=
e banks size for an "all CPUs", non-sparse IPI req
> git bisect good 2fb8e4267c47d69d6bada6310607ea3762f6c962
> # good: [492f4d3cde95aadcd1d070db5dd4796ae8019165] memblock: ensure there=
 is no overflow in memblock_overlaps_region()
> git bisect good 492f4d3cde95aadcd1d070db5dd4796ae8019165
> # bad: [e8ef940326efd17ca7fdd3cb8791c29a24b04f28] Linux 5.4.167
> git bisect bad e8ef940326efd17ca7fdd3cb8791c29a24b04f28
> # bad: [c97579584fa88df65ff6e4653b175acba154862d] arm: ioremap: don't abu=
se pfn_valid() to check if pfn is in RAM
> git bisect bad c97579584fa88df65ff6e4653b175acba154862d
> # bad: [6026d4032dbbe3d7f4ac2c8daa923fe74dcf41c4] arm: extend pfn_valid t=
o take into account freed memory map alignment
> git bisect bad 6026d4032dbbe3d7f4ac2c8daa923fe74dcf41c4
> # first bad commit: [6026d4032dbbe3d7f4ac2c8daa923fe74dcf41c4] arm: exten=
d pfn_valid to take into account freed memory map alignment
> -------------------------------------------------------------------------=
------
>=20
>=20
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Groups.io Links: You receive all messages sent to this group.
> View/Reply Online (#25917): https://groups.io/g/kernelci-results/message/=
25917
> Mute This Topic: https://groups.io/mt/90529234/1131744
> Group Owner: kernelci-results+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci-results/unsub [broonie@kernel.o=
rg]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>=20
>=20

--NQV1iap34Se2X7RP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJeuc4ACgkQJNaLcl1U
h9BA/wf/dNbyjzQANpaaSeKMQI+oj3S84GXdpxYxdWVxdq0mhJfl2ON0qQMdhh9R
paaRcApf5ns4xTAEowa0YgOfOkoiK/O+XnALAke2oHqNbTHgRlg/5XVpz85TgYLq
jh6DQqWsXvywLYTJ1Kmvq4fjqibhDu1oVGrz7oqH0+kNFOpeCqzGGBhYg4ras6aq
tqqUo7NUUP+lqC3J3yXyXc3oFVFObw60fLw1YwsdQkXMv40iT8Hm4QtPlunjydeX
0yyzSV0OZzYAfZ2pmzbYN2vnA6KN85WaOX2pocvVKjZEBRHuiPTOWOxwRnl7glG3
WBrtNUeqkgxxTHEnezk1HWl+SRyM/A==
=aDw2
-----END PGP SIGNATURE-----

--NQV1iap34Se2X7RP--
