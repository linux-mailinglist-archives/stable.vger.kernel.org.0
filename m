Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7DD531889
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiEWRDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiEWRDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:03:43 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [IPv6:2a01:e0c:1:1599::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7A0DF7C
        for <stable@vger.kernel.org>; Mon, 23 May 2022 10:03:38 -0700 (PDT)
Received: from geek500.localdomain (unknown [82.65.8.64])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp5-g21.free.fr (Postfix) with ESMTPSA id 013025FFC7;
        Mon, 23 May 2022 19:03:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1653325416;
        bh=PamY8sOud+bX3TT3df5TkeLH4UqXazQSh8ociIWSFOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NK8w9QU17Gf7vr1PnpIMSEXaKDehXfsEVLsJBifiRIr7r7RsrdzIlUWmi9OFoqMEK
         aCjhkSNZtvTp6QpjQyyZ638fJF8XvtW9IDgC3RLb211M8mp5KsgZ3v1UddLvbM4k/3
         P5w/O+ldwR6l311gexAhk2Jeg6sOHiYv79UCLdeX5VqwP/BHuw//ph1FF0GR+oigc8
         J1AhAfSD11K3btBvBNRnERNJPJdP1N1hkxONGHz5efCfwhalaFK9SOO3lpSwHdZnQy
         E6PCYBSb0CbOFrvh5LLyd0NYdb5rWdRAxs20xmBqvhqx6OfX1onWQAgc6UWgxEqF4b
         qSmGCPPw4JRcQ==
From:   Christian Casteyde <casteyde.christian@free.fr>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
Date:   Mon, 23 May 2022 19:03:27 +0200
Message-ID: <2408578.XAFRqVoOGU@geek500.localdomain>
In-Reply-To: <2585440.lGaqSPkdTl@geek500.localdomain>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net> <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info> <2585440.lGaqSPkdTl@geek500.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3425024.dWV9SEqChM"
Content-Transfer-Encoding: 7Bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart3425024.dWV9SEqChM
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

I've opened the gitlab entry for this discussion:
https://gitlab.freedesktop.org/drm/amd/-/issues/2023

I confirm I 'm not receiving mails anymore from the mailing list but I'll=20
follow gitlab.

In reply to the patch proposed by Mario:
https://patchwork.freedesktop.org/patch/486836/
With this patch applied on vanilla 5.18 kernel:
=2D suspend still fails;
=2D after suspend attempt, the screen comes back with only the cursor;
=2D switching to a console let me get the following dmesg file.

CC

Le lundi 23 mai 2022, 15:02:53 CEST Christian Casteyde a =E9crit :
> Hello
>=20
> I've checked with 5.18 the problem is still there.
> Interestingly, I tried to revert the commit but it was rejected because of
> the change in the test from:
>         if (!adev->in_s0ix)
> to:
>       if (amdgpu_acpi_should_gpu_reset(adev))
>=20
> in amdgpu_pmops_suspend.
>=20
> I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
> Then I changed to restore test of in_s0ix as it was in 5.17, and it works.
> I tried with a call to amd_gpu_asic_reset without testing at all in_s0ix,=
 it
> works.
>=20
> Therefore, my APU wants a reset in amdgpu_pmops_suspend.
>=20
> By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as was
> intended in 5.18 original code, commenting out the test of
> amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
> This does not work, I got the Fence timeout errors or freezes.
>=20
> If I leave  noirq function unchanged (original 5.18 code), and just add a
> reset in suspend() as was done in 5.17, it works.
>=20
> Therefore, my GPU does NOT want to be reset in noirq, the reset must be in
> suspend.
>=20
> In other words, I modified amdgpu_pmops_suspend (partial revert) like this
> and this works on my laptop:
>=20
> static int amdgpu_pmops_suspend(struct device *dev)
> {
> 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> +	int r;
>=20
> 	if (amdgpu_acpi_is_s0ix_active(adev))
> 		adev->in_s0ix =3D true;
> 	else
> 		adev->in_s3 =3D true;
> -	return amdgpu_device_suspend(drm_dev, true);
> +	r =3D amdgpu_device_suspend(drm_dev, true);
> +	if (r)
> +		return r;
> +	if (!adev->in_s0ix)
> +		return amdgpu_asic_reset(adev);
> 	return 0;
> }
>=20
> static int amdgpu_pmops_suspend_noirq(struct device *dev)
> {
> 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
>=20
> 	if (amdgpu_acpi_should_gpu_reset(adev))
> 		return amdgpu_asic_reset(adev);
>=20
> 	return 0;
> }
>=20
> I don't know if other APU want a reset, in the same context, and how to
> differentiate all the cases, so I cannot go further, but I can test patch=
es
> if needed.
>=20
> CC
>=20
> Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a =E9crit :
> > On 18.05.22 07:54, Kai-Heng Feng wrote:
> > > On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> > >=20
> > > <regressions@leemhuis.info> wrote:
> > >> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
> > >>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da
> > >>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"),
> > >>> and
> > >>> the problem disappears so it's really this commit that breaks.
> > >>=20
> > >> In that case I'll update the regzbot status to make sure it's visible
> > >> as
> > >> regression introduced in the 5.18 cycle:
> > >>=20
> > >> #regzbot introduced: 887f75cfd0da
> > >>=20
> > >> BTW: obviously would be nice to get this fixed before 5.18 is releas=
ed
> > >> (which might already happen on Sunday), especially as the culprit
> > >> apparently was already backported to stable, but I guess that won't =
be
> > >> easy...
> > >>=20
> > >> Which made me wondering: is reverting the culprit temporarily in
> > >> mainline (and reapplying it later with a fix) a option here?
> > >=20
> > > It's too soon to call it's the culprit.
> >=20
> > Well, sure, the root-cause might be somewhere else. But from the point
> > of kernel regressions (and tracking them) it's the culprit, as that's
> > the change that triggers the misbehavior. And that's how Linus
> > approaches these things as well when it comes to reverting to fix
> > regressions -- and he even might...
> >=20
> > > The suspend on the system
> > > doesn't work properly at the first place.
> >=20
> > ...ignore things like this, as long as a revert is unlikely to cause
> > more damage than good.
> >=20
> > Ciao. Thorsten
> >=20
> > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker'
> > >> hat)
> > >>=20
> > >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > >> reports and sometimes miss something important when writing mails li=
ke
> > >> this. If that's the case here, don't hesitate to tell me in a public
> > >> reply, it's in everyone's interest to set the public record straight.


--nextPart3425024.dWV9SEqChM
Content-Disposition: attachment; filename="dmesg-bad-0523.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmesg-bad-0523.txt"

[    0.000000] Linux version 5.18.0 (root@geek500.localdomain) (gcc (GCC) 11.2.0, GNU ld version 2.38-slack151) #15 SMP PREEMPT_DYNAMIC Mon May 23 18:12:46 CEST 2022
[    0.000000] Command line: ro root=/dev/nvme0n1p4
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'compacted' format.
[    0.000000] signal: max sigframe size: 1776
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009ecffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000009ed0000-0x0000000009ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a20cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000a20d000-0x00000000a7383fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a7384000-0x00000000a74d9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a74da000-0x00000000a753ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000a7540000-0x00000000a76eefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000a76ef000-0x00000000acffdfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000acffe000-0x00000000adffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ae000000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000042f33ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000042f340000-0x00000004701fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xa4177018-0xa41a0857] usable ==> usable
[    0.000000] e820: update [mem 0xa4177018-0xa41a0857] usable ==> usable
[    0.000000] e820: update [mem 0xa423a018-0xa4247457] usable ==> usable
[    0.000000] e820: update [mem 0xa423a018-0xa4247457] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000009ecffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000009ed0000-0x0000000009ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000a000000-0x000000000a1fffff] usable
[    0.000000] reserve setup_data: [mem 0x000000000a200000-0x000000000a20cfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000000a20d000-0x00000000a4177017] usable
[    0.000000] reserve setup_data: [mem 0x00000000a4177018-0x00000000a41a0857] usable
[    0.000000] reserve setup_data: [mem 0x00000000a41a0858-0x00000000a423a017] usable
[    0.000000] reserve setup_data: [mem 0x00000000a423a018-0x00000000a4247457] usable
[    0.000000] reserve setup_data: [mem 0x00000000a4247458-0x00000000a7383fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000a7384000-0x00000000a74d9fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000a74da000-0x00000000a753ffff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000a7540000-0x00000000a76eefff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000a76ef000-0x00000000acffdfff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000acffe000-0x00000000adffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ae000000-0x00000000afffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fd000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000042f33ffff] usable
[    0.000000] reserve setup_data: [mem 0x000000042f340000-0x00000004701fffff] reserved
[    0.000000] efi: EFI v2.70 by American Megatrends
[    0.000000] efi: ACPI=0xa753f000 ACPI 2.0=0xa753f014 TPMFinalLog=0xa76a7000 SMBIOS=0xace1b000 SMBIOS 3.0=0xace1a000 MEMATTR=0xa6019018 ESRT=0xa6621d18 RNG=0xace68f98 TPMEventLog=0xa609a018 
[    0.000000] efi: seeding entropy pool
[    0.000000] SMBIOS 3.2.0 present.
[    0.000000] DMI: HP HP Pavilion Gaming Laptop 15-ec1xxx/87B2, BIOS F.25 08/18/2021
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2994.264 MHz processor
[    0.000133] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000135] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000139] last_pfn = 0x42f340 max_arch_pfn = 0x400000000
[    0.000247] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[    0.000479] e820: update [mem 0xb0000000-0xffffffff] usable ==> reserved
[    0.000486] last_pfn = 0xae000 max_arch_pfn = 0x400000000
[    0.000496] esrt: Reserving ESRT space from 0x00000000a6621d18 to 0x00000000a6621d50.
[    0.000506] e820: update [mem 0xa6621000-0xa6621fff] usable ==> reserved
[    0.000547] Using GB pages for direct mapping
[    0.001064] Secure boot disabled
[    0.001066] ACPI: Early table checksum verification disabled
[    0.001069] ACPI: RSDP 0x00000000A753F014 000024 (v02 HPQOEM)
[    0.001072] ACPI: XSDT 0x00000000A753E728 0000EC (v01 HPQOEM SLIC-MPC 01072009 AMI  01000013)
[    0.001076] ACPI: FACP 0x00000000A7534000 000114 (v06 HPQOEM SLIC-MPC 01072009 HP   00010013)
[    0.001079] ACPI: DSDT 0x00000000A751F000 0149B8 (v02 HPQOEM 87B2     01072009 ACPI 20120913)
[    0.001082] ACPI: FACS 0x00000000A76A5000 000040
[    0.001083] ACPI: SSDT 0x00000000A7536000 007216 (v02 HPQOEM 87B2     00000002 ACPI 04000000)
[    0.001085] ACPI: IVRS 0x00000000A7535000 0001A4 (v02 HPQOEM 87B2     00000001 HP   00000000)
[    0.001087] ACPI: FIDT 0x00000000A751E000 00009C (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.001089] ACPI: MCFG 0x00000000A751D000 00003C (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.001091] ACPI: HPET 0x00000000A751C000 000038 (v01 HPQOEM 87B2     01072009 HP   00000005)
[    0.001093] ACPI: SSDT 0x00000000A751B000 000228 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001095] ACPI: VFCT 0x00000000A750D000 00D484 (v01 HPQOEM 87B2     00000001 HP   31504F47)
[    0.001097] ACPI: SSDT 0x00000000A750C000 000050 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001098] ACPI: TPM2 0x00000000A750B000 00004C (v04 HPQOEM 87B2     00000001 HP   00000000)
[    0.001100] ACPI: SSDT 0x00000000A7508000 002B80 (v01 HPQOEM 87B2     00000001 ACPI 00000001)
[    0.001102] ACPI: CRAT 0x00000000A7507000 000BA8 (v01 HPQOEM 87B2     00000001 HP   00000001)
[    0.001104] ACPI: CDIT 0x00000000A7506000 000029 (v01 HPQOEM 87B2     00000001 HP   00000001)
[    0.001106] ACPI: SSDT 0x00000000A7505000 000139 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001108] ACPI: SSDT 0x00000000A7504000 0000C2 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001109] ACPI: SSDT 0x00000000A7503000 000D37 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001111] ACPI: SSDT 0x00000000A7501000 0010AC (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001113] ACPI: SSDT 0x00000000A7500000 000D87 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001115] ACPI: SSDT 0x00000000A74FC000 0030C8 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001117] ACPI: WSMT 0x00000000A74FB000 000028 (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.001118] ACPI: APIC 0x00000000A74FA000 0000DE (v03 HPQOEM 87B2     01072009 HP   00010013)
[    0.001120] ACPI: SSDT 0x00000000A74F9000 00007D (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001122] ACPI: SSDT 0x00000000A74F8000 000517 (v01 HPQOEM 87B2     00000001 ACPI 20120913)
[    0.001124] ACPI: FPDT 0x00000000A74F7000 000044 (v01 HPQOEM 87B2     01072009 HP   01000013)
[    0.001126] ACPI: BGRT 0x00000000A74F6000 000038 (v01 HPQOEM 87B2     01072009 HP   00010013)
[    0.001128] ACPI: Reserving FACP table memory at [mem 0xa7534000-0xa7534113]
[    0.001129] ACPI: Reserving DSDT table memory at [mem 0xa751f000-0xa75339b7]
[    0.001130] ACPI: Reserving FACS table memory at [mem 0xa76a5000-0xa76a503f]
[    0.001131] ACPI: Reserving SSDT table memory at [mem 0xa7536000-0xa753d215]
[    0.001131] ACPI: Reserving IVRS table memory at [mem 0xa7535000-0xa75351a3]
[    0.001132] ACPI: Reserving FIDT table memory at [mem 0xa751e000-0xa751e09b]
[    0.001133] ACPI: Reserving MCFG table memory at [mem 0xa751d000-0xa751d03b]
[    0.001134] ACPI: Reserving HPET table memory at [mem 0xa751c000-0xa751c037]
[    0.001135] ACPI: Reserving SSDT table memory at [mem 0xa751b000-0xa751b227]
[    0.001135] ACPI: Reserving VFCT table memory at [mem 0xa750d000-0xa751a483]
[    0.001136] ACPI: Reserving SSDT table memory at [mem 0xa750c000-0xa750c04f]
[    0.001137] ACPI: Reserving TPM2 table memory at [mem 0xa750b000-0xa750b04b]
[    0.001138] ACPI: Reserving SSDT table memory at [mem 0xa7508000-0xa750ab7f]
[    0.001139] ACPI: Reserving CRAT table memory at [mem 0xa7507000-0xa7507ba7]
[    0.001139] ACPI: Reserving CDIT table memory at [mem 0xa7506000-0xa7506028]
[    0.001140] ACPI: Reserving SSDT table memory at [mem 0xa7505000-0xa7505138]
[    0.001141] ACPI: Reserving SSDT table memory at [mem 0xa7504000-0xa75040c1]
[    0.001142] ACPI: Reserving SSDT table memory at [mem 0xa7503000-0xa7503d36]
[    0.001143] ACPI: Reserving SSDT table memory at [mem 0xa7501000-0xa75020ab]
[    0.001143] ACPI: Reserving SSDT table memory at [mem 0xa7500000-0xa7500d86]
[    0.001144] ACPI: Reserving SSDT table memory at [mem 0xa74fc000-0xa74ff0c7]
[    0.001145] ACPI: Reserving WSMT table memory at [mem 0xa74fb000-0xa74fb027]
[    0.001146] ACPI: Reserving APIC table memory at [mem 0xa74fa000-0xa74fa0dd]
[    0.001146] ACPI: Reserving SSDT table memory at [mem 0xa74f9000-0xa74f907c]
[    0.001147] ACPI: Reserving SSDT table memory at [mem 0xa74f8000-0xa74f8516]
[    0.001148] ACPI: Reserving FPDT table memory at [mem 0xa74f7000-0xa74f7043]
[    0.001149] ACPI: Reserving BGRT table memory at [mem 0xa74f6000-0xa74f6037]
[    0.001172] Zone ranges:
[    0.001173]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.001174]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.001175]   Normal   [mem 0x0000000100000000-0x000000042f33ffff]
[    0.001176] Movable zone start for each node
[    0.001177] Early memory node ranges
[    0.001177]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
[    0.001178]   node   0: [mem 0x0000000000100000-0x0000000009ecffff]
[    0.001179]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
[    0.001180]   node   0: [mem 0x000000000a20d000-0x00000000a7383fff]
[    0.001181]   node   0: [mem 0x00000000acffe000-0x00000000adffffff]
[    0.001182]   node   0: [mem 0x0000000100000000-0x000000042f33ffff]
[    0.001183] Initmem setup node 0 [mem 0x0000000000001000-0x000000042f33ffff]
[    0.001187] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.001202] On node 0, zone DMA: 96 pages in unavailable ranges
[    0.001333] On node 0, zone DMA32: 304 pages in unavailable ranges
[    0.005488] On node 0, zone DMA32: 13 pages in unavailable ranges
[    0.005746] On node 0, zone DMA32: 23674 pages in unavailable ranges
[    0.027907] On node 0, zone Normal: 8192 pages in unavailable ranges
[    0.027939] On node 0, zone Normal: 3264 pages in unavailable ranges
[    0.028507] ACPI: PM-Timer IO Port: 0x808
[    0.028512] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.028522] IOAPIC[0]: apic_id 13, version 33, address 0xfec00000, GSI 0-23
[    0.028528] IOAPIC[1]: apic_id 14, version 33, address 0xfec01000, GSI 24-55
[    0.028530] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.028532] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.028534] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.028535] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.028548] e820: update [mem 0xa47b1000-0xa47c4fff] usable ==> reserved
[    0.028555] smpboot: Allowing 16 CPUs, 4 hotplug CPUs
[    0.028571] [mem 0xb0000000-0xefffffff] available for PCI devices
[    0.028574] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.033752] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:16 nr_node_ids:1
[    0.034227] percpu: Embedded 56 pages/cpu s192512 r8192 d28672 u262144
[    0.034233] pcpu-alloc: s192512 r8192 d28672 u262144 alloc=1*2097152
[    0.034235] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 13 14 15 
[    0.034253] Built 1 zonelists, mobility grouping on.  Total pages: 3964594
[    0.034255] Kernel command line: root=/dev/nvme0n1p4 ro ro root=/dev/nvme0n1p4
[    0.035872] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes, linear)
[    0.036699] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
[    0.036742] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.073066] Memory: 15650360K/16110752K available (20497K kernel code, 2897K rwdata, 8000K rodata, 1236K init, 3852K bss, 460132K reserved, 0K cma-reserved)
[    0.073073] random: get_random_u64 called from __kmem_cache_create+0x1f/0x4d0 with crng_init=0
[    0.073170] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.073221] Dynamic Preempt: full
[    0.073253] rcu: Preemptible hierarchical RCU implementation.
[    0.073254] rcu: 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=16.
[    0.073255] 	Trampoline variant of Tasks RCU enabled.
[    0.073256] rcu: RCU calculated value of scheduler-enlistment delay is 100 jiffies.
[    0.073257] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
[    0.074335] NR_IRQS: 16640, nr_irqs: 1096, preallocated irqs: 16
[    0.074560] Console: colour dummy device 80x25
[    0.074735] printk: console [tty0] enabled
[    0.074745] ACPI: Core revision 20211217
[    0.074922] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484873504 ns
[    0.074941] APIC: Switch to symmetric I/O mode setup
[    0.075642] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR0, rdevid:160
[    0.075645] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR1, rdevid:160
[    0.075647] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR2, rdevid:160
[    0.075649] AMD-Vi: ivrs, add hid:AMDI0020, uid:\_SB.FUR3, rdevid:160
[    0.075894] Switched APIC routing to physical flat.
[    0.076464] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.080942] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x2b291b4c42f, max_idle_ns: 440795358207 ns
[    0.080953] Calibrating delay loop (skipped), value calculated using timer frequency.. 5988.52 BogoMIPS (lpj=2994264)
[    0.080957] pid_max: default: 32768 minimum: 301
[    0.082839] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.082887] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes, linear)
[    0.083066] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    0.083102] LVT offset 1 assigned for vector 0xf9
[    0.083160] LVT offset 2 assigned for vector 0xf4
[    0.083177] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.083179] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB 0
[    0.083184] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
[    0.083186] Spectre V2 : Mitigation: Retpolines
[    0.083187] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.083189] Spectre V2 : Enabling Restricted Speculation for firmware calls
[    0.083191] Spectre V2 : mitigation: Enabling conditional Indirect Branch Prediction Barrier
[    0.083193] Spectre V2 : User space: Mitigation: STIBP via prctl
[    0.083194] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl
[    0.084744] Freeing SMP alternatives memory: 48K
[    0.187578] smpboot: CPU0: AMD Ryzen 5 4600H with Radeon Graphics (family: 0x17, model: 0x60, stepping: 0x1)
[    0.187668] cblist_init_generic: Setting adjustable number of callback queues.
[    0.187673] cblist_init_generic: Setting shift to 4 and lim to 1.
[    0.187683] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
[    0.187688] ... version:                0
[    0.187689] ... bit width:              48
[    0.187690] ... generic registers:      6
[    0.187692] ... value mask:             0000ffffffffffff
[    0.187693] ... max period:             00007fffffffffff
[    0.187694] ... fixed-purpose events:   0
[    0.187695] ... event mask:             000000000000003f
[    0.187746] rcu: Hierarchical SRCU implementation.
[    0.187892] smp: Bringing up secondary CPUs ...
[    0.187947] x86: Booting SMP configuration:
[    0.187947] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11
[    0.199987] smp: Brought up 1 node, 12 CPUs
[    0.199992] smpboot: Max logical packages: 2
[    0.199994] smpboot: Total of 12 processors activated (71862.33 BogoMIPS)
[    0.201754] devtmpfs: initialized
[    0.201956] ACPI: PM: Registering ACPI NVS region [mem 0x0a200000-0x0a20cfff] (53248 bytes)
[    0.201960] ACPI: PM: Registering ACPI NVS region [mem 0xa7540000-0xa76eefff] (1765376 bytes)
[    0.201993] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.201997] futex hash table entries: 4096 (order: 6, 262144 bytes, linear)
[    0.202032] pinctrl core: initialized pinctrl subsystem
[    0.202114] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.202158] DMA: preallocated 2048 KiB GFP_KERNEL pool for atomic allocations
[    0.202164] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[    0.202169] DMA: preallocated 2048 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[    0.202203] thermal_sys: Registered thermal governor 'fair_share'
[    0.202204] thermal_sys: Registered thermal governor 'bang_bang'
[    0.202206] thermal_sys: Registered thermal governor 'step_wise'
[    0.202207] thermal_sys: Registered thermal governor 'user_space'
[    0.202215] cpuidle: using governor ladder
[    0.202219] cpuidle: using governor menu
[    0.202240] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.202240] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.202240] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.202240] PCI: Using configuration type 1 for base access
[    0.204956] cryptd: max_cpu_qlen set to 1000
[    0.204976] ACPI: Added _OSI(Module Device)
[    0.204978] ACPI: Added _OSI(Processor Device)
[    0.204980] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.204981] ACPI: Added _OSI(Processor Aggregator Device)
[    0.204983] ACPI: Added _OSI(Linux-Dell-Video)
[    0.204984] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.204986] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.212469] ACPI BIOS Error (bug): Could not resolve symbol [\_SB.PCI0.GPP1.WLAN], AE_NOT_FOUND (20211217/dswload2-162)
[    0.212475] ACPI Error: AE_NOT_FOUND, During name lookup/catalog (20211217/psobject-220)
[    0.212478] ACPI: Skipping parse of AML opcode: OpcodeName unavailable (0x0010)
[    0.213688] ACPI: 13 ACPI AML tables successfully acquired and loaded
[    0.214491] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.215534] ACPI: EC: EC started
[    0.215536] ACPI: EC: interrupt blocked
[    0.540004] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.540010] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC used to handle transactions
[    0.540014] ACPI: Interpreter enabled
[    0.540029] ACPI: PM: (supports S0 S3 S5)
[    0.540031] ACPI: Using IOAPIC for interrupt routing
[    0.540205] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.540525] ACPI: Enabled 5 GPEs in block 00 to 1F
[    0.541951] ACPI: PM: Power Resource [P0S0]
[    0.541976] ACPI: PM: Power Resource [P3S0]
[    0.542044] ACPI: PM: Power Resource [P0S1]
[    0.542067] ACPI: PM: Power Resource [P3S1]
[    0.542678] ACPI: PM: Power Resource [PG00]
[    0.549527] ACPI: PM: Power Resource [PRWL]
[    0.549951] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.549959] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI HPX-Type3]
[    0.549964] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.550034] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.550038] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
[    0.550259] PCI host bridge to bus 0000:00
[    0.550262] pci_bus 0000:00: root bus resource [io  0x0000-0x03af window]
[    0.550266] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 window]
[    0.550270] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df window]
[    0.550273] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.550276] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000dffff window]
[    0.550279] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfebfffff window]
[    0.550283] pci_bus 0000:00: root bus resource [mem 0xfee00000-0xffffffff window]
[    0.550287] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.550300] pci 0000:00:00.0: [1022:1630] type 00 class 0x060000
[    0.550383] pci 0000:00:00.2: [1022:1631] type 00 class 0x080600
[    0.550469] pci 0000:00:01.0: [1022:1632] type 00 class 0x060000
[    0.550533] pci 0000:00:01.1: [1022:1633] type 01 class 0x060400
[    0.550594] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.550667] pci 0000:00:01.2: [1022:1634] type 01 class 0x060400
[    0.550693] pci 0000:00:01.2: enabling Extended Tags
[    0.550732] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
[    0.550807] pci 0000:00:02.0: [1022:1632] type 00 class 0x060000
[    0.550869] pci 0000:00:02.1: [1022:1634] type 01 class 0x060400
[    0.550894] pci 0000:00:02.1: enabling Extended Tags
[    0.550932] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    0.550999] pci 0000:00:02.4: [1022:1634] type 01 class 0x060400
[    0.551024] pci 0000:00:02.4: enabling Extended Tags
[    0.551062] pci 0000:00:02.4: PME# supported from D0 D3hot D3cold
[    0.551132] pci 0000:00:08.0: [1022:1632] type 00 class 0x060000
[    0.551194] pci 0000:00:08.1: [1022:1635] type 01 class 0x060400
[    0.551218] pci 0000:00:08.1: enabling Extended Tags
[    0.551249] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    0.551316] pci 0000:00:08.2: [1022:1635] type 01 class 0x060400
[    0.551340] pci 0000:00:08.2: enabling Extended Tags
[    0.551371] pci 0000:00:08.2: PME# supported from D0 D3hot D3cold
[    0.551454] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
[    0.551566] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
[    0.551683] pci 0000:00:18.0: [1022:1448] type 00 class 0x060000
[    0.551728] pci 0000:00:18.1: [1022:1449] type 00 class 0x060000
[    0.551771] pci 0000:00:18.2: [1022:144a] type 00 class 0x060000
[    0.551814] pci 0000:00:18.3: [1022:144b] type 00 class 0x060000
[    0.551857] pci 0000:00:18.4: [1022:144c] type 00 class 0x060000
[    0.551903] pci 0000:00:18.5: [1022:144d] type 00 class 0x060000
[    0.551949] pci 0000:00:18.6: [1022:144e] type 00 class 0x060000
[    0.551992] pci 0000:00:18.7: [1022:144f] type 00 class 0x060000
[    0.552089] pci 0000:01:00.0: [10de:1f95] type 00 class 0x030000
[    0.552101] pci 0000:01:00.0: reg 0x10: [mem 0xfb000000-0xfbffffff]
[    0.552113] pci 0000:01:00.0: reg 0x14: [mem 0xb0000000-0xbfffffff 64bit pref]
[    0.552124] pci 0000:01:00.0: reg 0x1c: [mem 0xc0000000-0xc1ffffff 64bit pref]
[    0.552132] pci 0000:01:00.0: reg 0x24: [io  0xf000-0xf07f]
[    0.552139] pci 0000:01:00.0: reg 0x30: [mem 0xfc000000-0xfc07ffff pref]
[    0.552199] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.552247] pci 0000:01:00.0: 63.008 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x8 link at 0000:00:01.1 (capable of 126.016 Gb/s with 8.0 GT/s PCIe x16 link)
[    0.552566] pci 0000:01:00.1: [10de:10fa] type 00 class 0x040300
[    0.552579] pci 0000:01:00.1: reg 0x10: [mem 0xfc080000-0xfc083fff]
[    0.552714] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.552719] pci 0000:00:01.1:   bridge window [io  0xf000-0xffff]
[    0.552723] pci 0000:00:01.1:   bridge window [mem 0xfb000000-0xfc0fffff]
[    0.552728] pci 0000:00:01.1:   bridge window [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.552774] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.552791] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.552810] pci 0000:02:00.0: reg 0x18: [mem 0xfc904000-0xfc904fff 64bit]
[    0.552824] pci 0000:02:00.0: reg 0x20: [mem 0xfc900000-0xfc903fff 64bit]
[    0.552912] pci 0000:02:00.0: supports D1 D2
[    0.552915] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.553037] pci 0000:00:01.2: PCI bridge to [bus 02]
[    0.553042] pci 0000:00:01.2:   bridge window [io  0xe000-0xefff]
[    0.553046] pci 0000:00:01.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.553421] pci 0000:03:00.0: [10ec:c822] type 00 class 0x028000
[    0.553442] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.553467] pci 0000:03:00.0: reg 0x18: [mem 0xfc800000-0xfc80ffff 64bit]
[    0.553586] pci 0000:03:00.0: supports D1 D2
[    0.553588] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.553907] pci 0000:00:02.1: PCI bridge to [bus 03]
[    0.553912] pci 0000:00:02.1:   bridge window [io  0xd000-0xdfff]
[    0.553915] pci 0000:00:02.1:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.553964] pci 0000:04:00.0: [1c5c:1339] type 00 class 0x010802
[    0.553984] pci 0000:04:00.0: reg 0x10: [mem 0xfc700000-0xfc703fff 64bit]
[    0.554099] pci 0000:04:00.0: supports D1
[    0.554101] pci 0000:04:00.0: PME# supported from D0 D1 D3hot
[    0.554156] pci 0000:04:00.0: 16.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x4 link at 0000:00:02.4 (capable of 31.504 Gb/s with 8.0 GT/s PCIe x4 link)
[    0.554214] pci 0000:00:02.4: PCI bridge to [bus 04]
[    0.554220] pci 0000:00:02.4:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.554265] pci 0000:05:00.0: [1002:1636] type 00 class 0x030000
[    0.554278] pci 0000:05:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.554288] pci 0000:05:00.0: reg 0x18: [mem 0xe0000000-0xe01fffff 64bit pref]
[    0.554296] pci 0000:05:00.0: reg 0x20: [io  0xc000-0xc0ff]
[    0.554303] pci 0000:05:00.0: reg 0x24: [mem 0xfc500000-0xfc57ffff]
[    0.554313] pci 0000:05:00.0: enabling Extended Tags
[    0.554362] pci 0000:05:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.554386] pci 0000:05:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:08.1 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    0.554440] pci 0000:05:00.2: [1022:15df] type 00 class 0x108000
[    0.554455] pci 0000:05:00.2: reg 0x18: [mem 0xfc400000-0xfc4fffff]
[    0.554467] pci 0000:05:00.2: reg 0x24: [mem 0xfc5c8000-0xfc5c9fff]
[    0.554476] pci 0000:05:00.2: enabling Extended Tags
[    0.554556] pci 0000:05:00.3: [1022:1639] type 00 class 0x0c0330
[    0.554569] pci 0000:05:00.3: reg 0x10: [mem 0xfc300000-0xfc3fffff 64bit]
[    0.554595] pci 0000:05:00.3: enabling Extended Tags
[    0.554628] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
[    0.554683] pci 0000:05:00.4: [1022:1639] type 00 class 0x0c0330
[    0.554697] pci 0000:05:00.4: reg 0x10: [mem 0xfc200000-0xfc2fffff 64bit]
[    0.554723] pci 0000:05:00.4: enabling Extended Tags
[    0.554756] pci 0000:05:00.4: PME# supported from D0 D3hot D3cold
[    0.554811] pci 0000:05:00.5: [1022:15e2] type 00 class 0x048000
[    0.554820] pci 0000:05:00.5: reg 0x10: [mem 0xfc580000-0xfc5bffff]
[    0.554844] pci 0000:05:00.5: enabling Extended Tags
[    0.554874] pci 0000:05:00.5: PME# supported from D0 D3hot D3cold
[    0.554924] pci 0000:05:00.6: [1022:15e3] type 00 class 0x040300
[    0.554934] pci 0000:05:00.6: reg 0x10: [mem 0xfc5c0000-0xfc5c7fff]
[    0.554959] pci 0000:05:00.6: enabling Extended Tags
[    0.554989] pci 0000:05:00.6: PME# supported from D0 D3hot D3cold
[    0.555051] pci 0000:00:08.1: PCI bridge to [bus 05]
[    0.555056] pci 0000:00:08.1:   bridge window [io  0xc000-0xcfff]
[    0.555060] pci 0000:00:08.1:   bridge window [mem 0xfc200000-0xfc5fffff]
[    0.555064] pci 0000:00:08.1:   bridge window [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.555101] pci 0000:06:00.0: [1022:7901] type 00 class 0x010601
[    0.555132] pci 0000:06:00.0: reg 0x24: [mem 0xfc601000-0xfc6017ff]
[    0.555142] pci 0000:06:00.0: enabling Extended Tags
[    0.555201] pci 0000:06:00.0: 126.016 Gb/s available PCIe bandwidth, limited by 8.0 GT/s PCIe x16 link at 0000:00:08.2 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
[    0.555246] pci 0000:06:00.1: [1022:7901] type 00 class 0x010601
[    0.555277] pci 0000:06:00.1: reg 0x24: [mem 0xfc600000-0xfc6007ff]
[    0.555287] pci 0000:06:00.1: enabling Extended Tags
[    0.555369] pci 0000:00:08.2: PCI bridge to [bus 06]
[    0.555375] pci 0000:00:08.2:   bridge window [mem 0xfc600000-0xfc6fffff]
[    0.555402] pci_bus 0000:00: on NUMA node 0
[    0.555894] ACPI: PCI: Interrupt link LNKA configured for IRQ 0
[    0.555937] ACPI: PCI: Interrupt link LNKB configured for IRQ 0
[    0.555976] ACPI: PCI: Interrupt link LNKC configured for IRQ 0
[    0.556021] ACPI: PCI: Interrupt link LNKD configured for IRQ 0
[    0.556060] ACPI: PCI: Interrupt link LNKE configured for IRQ 0
[    0.556093] ACPI: PCI: Interrupt link LNKF configured for IRQ 0
[    0.556126] ACPI: PCI: Interrupt link LNKG configured for IRQ 0
[    0.556159] ACPI: PCI: Interrupt link LNKH configured for IRQ 0
[    0.557541] ACPI: EC: interrupt unblocked
[    0.557544] ACPI: EC: event unblocked
[    0.557551] ACPI: EC: EC_CMD/EC_SC=0x66, EC_DATA=0x62
[    0.557553] ACPI: EC: GPE=0x3
[    0.557555] ACPI: \_SB_.PCI0.SBRG.EC0_: Boot DSDT EC initialization complete
[    0.557559] ACPI: \_SB_.PCI0.SBRG.EC0_: EC: Used to handle transactions and events
[    0.557610] iommu: Default domain type: Translated 
[    0.557610] iommu: DMA domain TLB invalidation policy: lazy mode 
[    0.557610] SCSI subsystem initialized
[    0.557610] libata version 3.00 loaded.
[    0.557610] ACPI: bus type USB registered
[    0.557610] usbcore: registered new interface driver usbfs
[    0.557610] usbcore: registered new interface driver hub
[    0.557610] usbcore: registered new device driver usb
[    0.559349] mc: Linux media interface: v0.10
[    0.559357] videodev: Linux video capture interface: v2.00
[    0.559402] Registered efivars operations
[    0.559418] Advanced Linux Sound Architecture Driver Initialized.
[    0.559418] Bluetooth: Core ver 2.22
[    0.559418] NET: Registered PF_BLUETOOTH protocol family
[    0.559418] Bluetooth: HCI device and connection manager initialized
[    0.559418] Bluetooth: HCI socket layer initialized
[    0.559418] Bluetooth: L2CAP socket layer initialized
[    0.559418] Bluetooth: SCO socket layer initialized
[    0.559418] PCI: Using ACPI for IRQ routing
[    0.564059] PCI: pci_cache_line_size set to 64 bytes
[    0.564794] Expanded resource Reserved due to conflict with PCI Bus 0000:00
[    0.564798] e820: reserve RAM buffer [mem 0x09ed0000-0x0bffffff]
[    0.564800] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
[    0.564801] e820: reserve RAM buffer [mem 0xa4177018-0xa7ffffff]
[    0.564802] e820: reserve RAM buffer [mem 0xa423a018-0xa7ffffff]
[    0.564804] e820: reserve RAM buffer [mem 0xa47b1000-0xa7ffffff]
[    0.564805] e820: reserve RAM buffer [mem 0xa6621000-0xa7ffffff]
[    0.564806] e820: reserve RAM buffer [mem 0xa7384000-0xa7ffffff]
[    0.564807] e820: reserve RAM buffer [mem 0xae000000-0xafffffff]
[    0.564808] e820: reserve RAM buffer [mem 0x42f340000-0x42fffffff]
[    0.564822] pci 0000:01:00.0: vgaarb: setting as boot VGA device
[    0.564822] pci 0000:01:00.0: vgaarb: bridge control possible
[    0.564822] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    0.564822] pci 0000:05:00.0: vgaarb: setting as boot VGA device (overriding previous)
[    0.564822] pci 0000:05:00.0: vgaarb: bridge control possible
[    0.564822] pci 0000:05:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    0.564822] vgaarb: loaded
[    0.565122] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.565128] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.567013] clocksource: Switched to clocksource tsc-early
[    0.574190] pnp: PnP ACPI init
[    0.574307] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.574595] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.574600] system 00:03: [io  0x040b] has been reserved
[    0.574604] system 00:03: [io  0x04d6] has been reserved
[    0.574607] system 00:03: [io  0x0c00-0x0c01] has been reserved
[    0.574610] system 00:03: [io  0x0c14] has been reserved
[    0.574613] system 00:03: [io  0x0c50-0x0c51] has been reserved
[    0.574617] system 00:03: [io  0x0c52] has been reserved
[    0.574620] system 00:03: [io  0x0c6c] has been reserved
[    0.574623] system 00:03: [io  0x0c6f] has been reserved
[    0.574625] system 00:03: [io  0x0cd0-0x0cd1] has been reserved
[    0.574628] system 00:03: [io  0x0cd2-0x0cd3] has been reserved
[    0.574631] system 00:03: [io  0x0cd4-0x0cd5] has been reserved
[    0.574634] system 00:03: [io  0x0cd6-0x0cd7] has been reserved
[    0.574637] system 00:03: [io  0x0cd8-0x0cdf] has been reserved
[    0.574640] system 00:03: [io  0x0800-0x089f] has been reserved
[    0.574643] system 00:03: [io  0x0b00-0x0b0f] has been reserved
[    0.574645] system 00:03: [io  0x0b20-0x0b3f] has been reserved
[    0.574648] system 00:03: [io  0x0900-0x090f] has been reserved
[    0.574651] system 00:03: [io  0x0910-0x091f] has been reserved
[    0.574655] system 00:03: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.574658] system 00:03: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.574661] system 00:03: [mem 0xfedc0000-0xfedc0fff] has been reserved
[    0.574664] system 00:03: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.574668] system 00:03: [mem 0xfed80000-0xfed8ffff] could not be reserved
[    0.574671] system 00:03: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.574674] system 00:03: [mem 0xff000000-0xffffffff] has been reserved
[    0.575320] pnp: PnP ACPI: found 4 devices
[    0.581199] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.581260] NET: Registered PF_INET protocol family
[    0.581489] IP idents hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.584125] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes, linear)
[    0.584162] TCP established hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.584459] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes, linear)
[    0.584643] TCP: Hash tables configured (established 131072 bind 65536)
[    0.584678] UDP hash table entries: 8192 (order: 6, 262144 bytes, linear)
[    0.584720] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes, linear)
[    0.584784] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.585018] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.585024] pci 0000:00:01.1:   bridge window [io  0xf000-0xffff]
[    0.585030] pci 0000:00:01.1:   bridge window [mem 0xfb000000-0xfc0fffff]
[    0.585034] pci 0000:00:01.1:   bridge window [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.585041] pci 0000:00:01.2: PCI bridge to [bus 02]
[    0.585044] pci 0000:00:01.2:   bridge window [io  0xe000-0xefff]
[    0.585048] pci 0000:00:01.2:   bridge window [mem 0xfc900000-0xfc9fffff]
[    0.585054] pci 0000:00:02.1: PCI bridge to [bus 03]
[    0.585057] pci 0000:00:02.1:   bridge window [io  0xd000-0xdfff]
[    0.585062] pci 0000:00:02.1:   bridge window [mem 0xfc800000-0xfc8fffff]
[    0.585068] pci 0000:00:02.4: PCI bridge to [bus 04]
[    0.585072] pci 0000:00:02.4:   bridge window [mem 0xfc700000-0xfc7fffff]
[    0.585080] pci 0000:00:08.1: PCI bridge to [bus 05]
[    0.585083] pci 0000:00:08.1:   bridge window [io  0xc000-0xcfff]
[    0.585087] pci 0000:00:08.1:   bridge window [mem 0xfc200000-0xfc5fffff]
[    0.585090] pci 0000:00:08.1:   bridge window [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.585096] pci 0000:00:08.2: PCI bridge to [bus 06]
[    0.585100] pci 0000:00:08.2:   bridge window [mem 0xfc600000-0xfc6fffff]
[    0.585108] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.585111] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.585114] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.585117] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.585120] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000dffff window]
[    0.585123] pci_bus 0000:00: resource 9 [mem 0xb0000000-0xfebfffff window]
[    0.585126] pci_bus 0000:00: resource 10 [mem 0xfee00000-0xffffffff window]
[    0.585130] pci_bus 0000:01: resource 0 [io  0xf000-0xffff]
[    0.585132] pci_bus 0000:01: resource 1 [mem 0xfb000000-0xfc0fffff]
[    0.585135] pci_bus 0000:01: resource 2 [mem 0xb0000000-0xc1ffffff 64bit pref]
[    0.585139] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.585142] pci_bus 0000:02: resource 1 [mem 0xfc900000-0xfc9fffff]
[    0.585145] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.585148] pci_bus 0000:03: resource 1 [mem 0xfc800000-0xfc8fffff]
[    0.585151] pci_bus 0000:04: resource 1 [mem 0xfc700000-0xfc7fffff]
[    0.585154] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.585156] pci_bus 0000:05: resource 1 [mem 0xfc200000-0xfc5fffff]
[    0.585159] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xe01fffff 64bit pref]
[    0.585163] pci_bus 0000:06: resource 1 [mem 0xfc600000-0xfc6fffff]
[    0.585280] pci 0000:01:00.1: D0 power state depends on 0000:01:00.0
[    0.585649] pci 0000:05:00.3: extending delay after power-on from D3hot to 20 msec
[    0.585793] pci 0000:05:00.4: extending delay after power-on from D3hot to 20 msec
[    0.585856] PCI: CLS 64 bytes, default 64
[    0.585868] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    0.585908] pci 0000:00:00.2: can't derive routing for PCI INT A
[    0.585912] pci 0000:00:00.2: PCI INT A: not connected
[    0.585934] pci 0000:00:01.0: Adding to iommu group 0
[    0.585945] pci 0000:00:01.1: Adding to iommu group 1
[    0.585954] pci 0000:00:01.2: Adding to iommu group 2
[    0.585968] pci 0000:00:02.0: Adding to iommu group 3
[    0.585979] pci 0000:00:02.1: Adding to iommu group 4
[    0.585989] pci 0000:00:02.4: Adding to iommu group 5
[    0.586006] pci 0000:00:08.0: Adding to iommu group 6
[    0.586015] pci 0000:00:08.1: Adding to iommu group 6
[    0.586023] pci 0000:00:08.2: Adding to iommu group 6
[    0.586039] pci 0000:00:14.0: Adding to iommu group 7
[    0.586048] pci 0000:00:14.3: Adding to iommu group 7
[    0.586079] pci 0000:00:18.0: Adding to iommu group 8
[    0.586088] pci 0000:00:18.1: Adding to iommu group 8
[    0.586097] pci 0000:00:18.2: Adding to iommu group 8
[    0.586106] pci 0000:00:18.3: Adding to iommu group 8
[    0.586118] pci 0000:00:18.4: Adding to iommu group 8
[    0.586127] pci 0000:00:18.5: Adding to iommu group 8
[    0.586136] pci 0000:00:18.6: Adding to iommu group 8
[    0.586145] pci 0000:00:18.7: Adding to iommu group 8
[    0.586161] pci 0000:01:00.0: Adding to iommu group 9
[    0.586171] pci 0000:01:00.1: Adding to iommu group 9
[    0.586181] pci 0000:02:00.0: Adding to iommu group 10
[    0.586191] pci 0000:03:00.0: Adding to iommu group 11
[    0.586202] pci 0000:04:00.0: Adding to iommu group 12
[    0.586211] pci 0000:05:00.0: Adding to iommu group 6
[    0.586217] pci 0000:05:00.2: Adding to iommu group 6
[    0.586221] pci 0000:05:00.3: Adding to iommu group 6
[    0.586227] pci 0000:05:00.4: Adding to iommu group 6
[    0.586232] pci 0000:05:00.5: Adding to iommu group 6
[    0.586237] pci 0000:05:00.6: Adding to iommu group 6
[    0.586242] pci 0000:06:00.0: Adding to iommu group 6
[    0.586247] pci 0000:06:00.1: Adding to iommu group 6
[    0.587730] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.587738] AMD-Vi: Extended features (0x206d73ef22254ade): PPR X2APIC NX GT IA GA PC GA_vAPIC
[    0.587746] AMD-Vi: Interrupt remapping enabled
[    0.587748] AMD-Vi: Virtual APIC enabled
[    0.587750] AMD-Vi: X2APIC enabled
[    0.587859] software IO TLB: tearing down default memory pool
[    0.588855] RAPL PMU: API unit is 2^-32 Joules, 1 fixed counters, 163840 ms ovfl timer
[    0.588862] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.588867] LVT offset 0 assigned for vector 0x400
[    0.589047] perf: AMD IBS detected (0x000003ff)
[    0.589053] amd_uncore: 4  amd_df counters detected
[    0.589058] amd_uncore: 6  amd_l3 counters detected
[    0.589407] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
[    0.589597] SVM: TSC scaling supported
[    0.589599] kvm: Nested Virtualization enabled
[    0.589601] SVM: kvm: Nested Paging enabled
[    0.589610] SVM: Virtual VMLOAD VMSAVE supported
[    0.589612] SVM: Virtual GIF supported
[    0.589613] SVM: LBR virtualization supported
[    0.596307] Initialise system trusted keyrings
[    0.596345] workingset: timestamp_bits=46 max_order=22 bucket_order=0
[    0.597648] fuse: init (API version 7.36)
[    0.597700] SGI XFS with ACLs, security attributes, scrub, repair, no debug enabled
[    0.602228] NET: Registered PF_ALG protocol family
[    0.602232] Key type asymmetric registered
[    0.602234] Asymmetric key parser 'x509' registered
[    0.602245] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    0.602314] io scheduler mq-deadline registered
[    0.602319] io scheduler kyber registered
[    0.602329] io scheduler bfq registered
[    0.605811] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.659022] ACPI: AC: AC Adapter [ACAD] (off-line)
[    0.659100] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.659135] ACPI: button: Power Button [PWRB]
[    0.659181] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.659205] ACPI: button: Lid Switch [LID]
[    0.659243] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.659517] ACPI: button: Power Button [PWRF]
[    0.659629] ACPI: video: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    0.659946] acpi device:08: registered as cooling_device0
[    0.659995] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:07/LNXVIDEO:00/input/input3
[    0.660194] Monitor-Mwait will be used to enter C-1 state
[    0.660212] ACPI: \_SB_.PLTF.P000: Found 3 idle states
[    0.660225] ACPI: FW issue: working around C-state latencies out of order
[    0.660465] ACPI: \_SB_.PLTF.P001: Found 3 idle states
[    0.660481] ACPI: FW issue: working around C-state latencies out of order
[    0.660777] ACPI: \_SB_.PLTF.P002: Found 3 idle states
[    0.660793] ACPI: FW issue: working around C-state latencies out of order
[    0.661065] ACPI: \_SB_.PLTF.P003: Found 3 idle states
[    0.661086] ACPI: FW issue: working around C-state latencies out of order
[    0.661298] ACPI: \_SB_.PLTF.P004: Found 3 idle states
[    0.661308] ACPI: FW issue: working around C-state latencies out of order
[    0.661571] ACPI: \_SB_.PLTF.P005: Found 3 idle states
[    0.661587] ACPI: FW issue: working around C-state latencies out of order
[    0.661759] ACPI: \_SB_.PLTF.P006: Found 3 idle states
[    0.661769] ACPI: FW issue: working around C-state latencies out of order
[    0.661951] ACPI: \_SB_.PLTF.P007: Found 3 idle states
[    0.661967] ACPI: FW issue: working around C-state latencies out of order
[    0.662162] ACPI: \_SB_.PLTF.P008: Found 3 idle states
[    0.662173] ACPI: FW issue: working around C-state latencies out of order
[    0.662301] ACPI: \_SB_.PLTF.P009: Found 3 idle states
[    0.662308] ACPI: FW issue: working around C-state latencies out of order
[    0.662431] ACPI: \_SB_.PLTF.P00A: Found 3 idle states
[    0.662437] ACPI: FW issue: working around C-state latencies out of order
[    0.662524] ACPI: \_SB_.PLTF.P00B: Found 3 idle states
[    0.662531] ACPI: FW issue: working around C-state latencies out of order
[    0.663596] ACPI Error: AE_NOT_FOUND, While resolving a named reference package element - \_PR_.P000 (20211217/dspkginit-438)
[    0.663610] ACPI: \_TZ_.THRM: Invalid passive threshold
[    0.664366] thermal LNXTHERM:00: registered as thermal_zone0
[    0.664372] ACPI: thermal: Thermal Zone [THRM] (49 C)
[    0.665866] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.666164] Non-volatile memory driver v1.3
[    0.666171] Linux agpgart interface v0.103
[    0.693376] ACPI: battery: Slot [BAT0] (battery present)
[    0.696132] AMD-Vi: AMD IOMMUv2 loaded and initialized
[    0.696238] ACPI: bus type drm_connector registered
[    0.696275] [drm] amdgpu kernel modesetting enabled.
[    0.696294] amdgpu: vga_switcheroo: detected switching method \_SB_.PCI0.GP17.VGA_.ATPX handle
[    0.696742] ATPX version 1, functions 0x00000200
[    0.699251] amdgpu: Virtual CRAT table created for CPU
[    0.699262] amdgpu: Topology: Add CPU node
[    0.699307] amdgpu 0000:05:00.0: vgaarb: deactivate vga console
[    0.699349] amdgpu 0000:05:00.0: enabling device (0006 -> 0007)
[    0.699393] [drm] initializing kernel modesetting (RENOIR 0x1002:0x1636 0x103C:0x87B2 0xC7).
[    0.699399] amdgpu 0000:05:00.0: amdgpu: Trusted Memory Zone (TMZ) feature enabled
[    0.786164] [drm] register mmio base: 0xFC500000
[    0.786176] [drm] register mmio size: 524288
[    0.787724] [drm] add ip block number 0 <soc15_common>
[    0.787728] [drm] add ip block number 1 <gmc_v9_0>
[    0.787730] [drm] add ip block number 2 <vega10_ih>
[    0.787732] [drm] add ip block number 3 <psp>
[    0.787735] [drm] add ip block number 4 <smu>
[    0.787737] [drm] add ip block number 5 <dm>
[    0.787739] [drm] add ip block number 6 <gfx_v9_0>
[    0.787741] [drm] add ip block number 7 <sdma_v4_0>
[    0.787744] [drm] add ip block number 8 <vcn_v2_0>
[    0.787746] [drm] add ip block number 9 <jpeg_v2_0>
[    0.787757] amdgpu 0000:05:00.0: amdgpu: Fetched VBIOS from VFCT
[    0.787761] amdgpu: ATOM BIOS: 113-RENOIR-031
[    0.787772] [drm] VCN decode is enabled in VM mode
[    0.787774] [drm] VCN encode is enabled in VM mode
[    0.787776] [drm] JPEG decode is enabled in VM mode
[    0.787779] amdgpu 0000:05:00.0: amdgpu: PCIE atomic ops is not supported
[    0.787787] amdgpu 0000:05:00.0: amdgpu: MODE2 reset
[    0.787868] [drm] vm size is 262144 GB, 4 levels, block size is 9-bit, fragment size is 9-bit
[    0.787876] amdgpu 0000:05:00.0: amdgpu: VRAM: 512M 0x000000F400000000 - 0x000000F41FFFFFFF (512M used)
[    0.787881] amdgpu 0000:05:00.0: amdgpu: GART: 1024M 0x0000000000000000 - 0x000000003FFFFFFF
[    0.787885] amdgpu 0000:05:00.0: amdgpu: AGP: 267419648M 0x000000F800000000 - 0x0000FFFFFFFFFFFF
[    0.787894] [drm] Detected VRAM RAM=512M, BAR=512M
[    0.787896] [drm] RAM width 128bits DDR4
[    0.787940] [drm] amdgpu: 512M of VRAM memory ready
[    0.787943] [drm] amdgpu: 3072M of GTT memory ready.
[    0.787952] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    0.788075] [drm] PCIE GART of 1024M enabled.
[    0.788078] [drm] PTB located at 0x000000F400900000
[    0.788168] amdgpu 0000:05:00.0: amdgpu: PSP runtime database doesn't exist
[    0.788175] [drm] Loading DMUB firmware via PSP: version=0x0101001F
[    0.788714] [drm] Found VCN firmware Version ENC: 1.17 DEC: 5 VEP: 0 Revision: 2
[    0.788721] amdgpu 0000:05:00.0: amdgpu: Will use PSP to load VCN firmware
[    1.535068] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[    1.622060] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[    1.631579] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[    1.631585] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[    1.631845] amdgpu 0000:05:00.0: amdgpu: SMU is initialized successfully!
[    1.632616] [drm] Display Core initialized with v3.2.177!
[    1.633163] [drm] DMUB hardware initialized: version=0x0101001F
[    1.642985] tsc: Refined TSC clocksource calibration: 3016.672 MHz
[    1.643006] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2b7bcb17769, max_idle_ns: 440795327283 ns
[    1.643256] clocksource: Switched to clocksource tsc
[    1.849248] [drm] kiq ring mec 2 pipe 1 q 0
[    1.851706] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[    1.851732] [drm] JPEG decode initialized successfully.
[    1.854203] kfd kfd: amdgpu: Allocated 3969056 bytes on gart
[    1.854369] amdgpu: Virtual CRAT table created for GPU
[    1.854445] amdgpu: Topology: Add dGPU node [0x1636:0x1002]
[    1.854452] kfd kfd: amdgpu: added device 1002:1636
[    1.854466] amdgpu 0000:05:00.0: amdgpu: SE 1, SH per SE 1, CU per SH 8, active_cu_number 6
[    1.854618] amdgpu 0000:05:00.0: amdgpu: ring gfx uses VM inv eng 0 on hub 0
[    1.854624] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[    1.854631] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[    1.854637] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[    1.854642] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[    1.854648] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[    1.854654] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[    1.854659] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[    1.854665] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[    1.854671] amdgpu 0000:05:00.0: amdgpu: ring kiq_2.1.0 uses VM inv eng 11 on hub 0
[    1.854678] amdgpu 0000:05:00.0: amdgpu: ring sdma0 uses VM inv eng 0 on hub 1
[    1.854683] amdgpu 0000:05:00.0: amdgpu: ring vcn_dec uses VM inv eng 1 on hub 1
[    1.854689] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 4 on hub 1
[    1.854695] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 5 on hub 1
[    1.854701] amdgpu 0000:05:00.0: amdgpu: ring jpeg_dec uses VM inv eng 6 on hub 1
[    1.855701] [drm] Initialized amdgpu 3.46.0 20150101 for 0000:05:00.0 on minor 0
[    1.860734] fbcon: amdgpudrmfb (fb0) is primary device
[    1.860799] [drm] DSC precompute is not needed.
[    1.933522] Console: switching to colour frame buffer device 240x67
[    1.950511] amdgpu 0000:05:00.0: [drm] fb0: amdgpudrmfb frame buffer device
[    1.950654] usbcore: registered new interface driver udl
[    1.952952] brd: module loaded
[    1.954164] loop: module loaded
[    1.954662] nvme 0000:04:00.0: platform quirk: setting simple suspend
[    1.954743] nvme nvme0: pci function 0000:04:00.0
[    1.954838] ahci 0000:06:00.0: version 3.0
[    1.955207] ahci 0000:06:00.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    1.955258] ahci 0000:06:00.0: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part 
[    1.955486] scsi host0: ahci
[    1.955575] ata1: SATA max UDMA/133 abar m2048@0xfc601000 port 0xfc601100 irq 31
[    1.955751] ahci 0000:06:00.1: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
[    1.955793] ahci 0000:06:00.1: flags: 64bit ncq sntf ilck pm led clo only pmp fbs pio slum part 
[    1.955986] scsi host1: ahci
[    1.956039] ata2: SATA max UDMA/133 abar m2048@0xfc600000 port 0xfc600100 irq 33
[    1.956185] tun: Universal TUN/TAP device driver, 1.6
[    1.956259] r8169 0000:02:00.0: enabling device (0000 -> 0003)
[    1.956336] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    1.959521] nvme nvme0: missing or invalid SUBNQN field.
[    1.963525] nvme nvme0: 16/0/0 default/read/poll queues
[    1.963803] r8169 0000:02:00.0 eth0: RTL8168h/8111h, 30:24:a9:7d:03:0f, XID 541, IRQ 51
[    1.963840] r8169 0000:02:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[    1.964304] rtw_8822ce 0000:03:00.0: Firmware version 9.9.11, H2C version 15
[    1.964331] rtw_8822ce 0000:03:00.0: Firmware version 9.9.4, H2C version 15
[    1.964686] rtw_8822ce 0000:03:00.0: enabling device (0000 -> 0003)
[    1.966658]  nvme0n1: p1 p2 p3 p4 p5 p6 p7
[    1.993484] usbcore: registered new interface driver cdc_ether
[    1.993537] usbcore: registered new interface driver cdc_eem
[    1.993576] usbcore: registered new interface driver cdc_ncm
[    1.993825] xhci_hcd 0000:05:00.3: xHCI Host Controller
[    1.993929] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 1
[    1.994053] xhci_hcd 0000:05:00.3: hcc params 0x0268ffe5 hci version 0x110 quirks 0x0000020000000410
[    1.994447] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.18
[    1.994487] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.994521] usb usb1: Product: xHCI Host Controller
[    1.994545] usb usb1: Manufacturer: Linux 5.18.0 xhci-hcd
[    1.996298] usb usb1: SerialNumber: 0000:05:00.3
[    1.998140] hub 1-0:1.0: USB hub found
[    1.999057] hub 1-0:1.0: 4 ports detected
[    2.000799] xhci_hcd 0000:05:00.3: xHCI Host Controller
[    2.002122] xhci_hcd 0000:05:00.3: new USB bus registered, assigned bus number 2
[    2.002943] xhci_hcd 0000:05:00.3: Host supports USB 3.1 Enhanced SuperSpeed
[    2.003973] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    2.005026] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.18
[    2.006059] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.007488] usb usb2: Product: xHCI Host Controller
[    2.009141] usb usb2: Manufacturer: Linux 5.18.0 xhci-hcd
[    2.009988] usb usb2: SerialNumber: 0000:05:00.3
[    2.011351] hub 2-0:1.0: USB hub found
[    2.013043] hub 2-0:1.0: 2 ports detected
[    2.014589] xhci_hcd 0000:05:00.4: xHCI Host Controller
[    2.015358] xhci_hcd 0000:05:00.4: new USB bus registered, assigned bus number 3
[    2.016526] xhci_hcd 0000:05:00.4: hcc params 0x0268ffe5 hci version 0x110 quirks 0x0000020000000410
[    2.017756] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.18
[    2.018367] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.018896] usb usb3: Product: xHCI Host Controller
[    2.019401] usb usb3: Manufacturer: Linux 5.18.0 xhci-hcd
[    2.019895] usb usb3: SerialNumber: 0000:05:00.4
[    2.020760] hub 3-0:1.0: USB hub found
[    2.022132] hub 3-0:1.0: 4 ports detected
[    2.023833] xhci_hcd 0000:05:00.4: xHCI Host Controller
[    2.024538] xhci_hcd 0000:05:00.4: new USB bus registered, assigned bus number 4
[    2.025619] xhci_hcd 0000:05:00.4: Host supports USB 3.1 Enhanced SuperSpeed
[    2.026450] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    2.027524] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.18
[    2.028372] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.029455] usb usb4: Product: xHCI Host Controller
[    2.030328] usb usb4: Manufacturer: Linux 5.18.0 xhci-hcd
[    2.031428] usb usb4: SerialNumber: 0000:05:00.4
[    2.032422] hub 4-0:1.0: USB hub found
[    2.033485] hub 4-0:1.0: 2 ports detected
[    2.034281] usb: port power management may be unreliable
[    2.035455] usbcore: registered new interface driver usblp
[    2.036282] usbcore: registered new interface driver cdc_wdm
[    2.037456] usbcore: registered new interface driver uas
[    2.038057] usbcore: registered new interface driver usb-storage
[    2.039159] usbcore: registered new interface driver emi26 - firmware loader
[    2.039997] usbcore: registered new interface driver emi62 - firmware loader
[    2.041075] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.041890] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.044131] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.045137] mousedev: PS/2 mouse device common for all mice
[    2.046284] rtc_cmos 00:01: RTC can wake from S4
[    2.047236] rtc_cmos 00:01: registered as rtc0
[    2.048123] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.048906] i2c_dev: i2c /dev entries driver
[    2.050143] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    2.050976] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus port selection
[    2.052179] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[    2.052918] usbcore: registered new interface driver uvcvideo
[    2.054259] usbcore: registered new interface driver btusb
[    2.055380] EFI Variables Facility v0.08 2004-May-17
[    2.062303] pstore: Registered efi as persistent store backend
[    2.063027] ccp 0000:05:00.2: enabling device (0000 -> 0002)
[    2.074398] ccp 0000:05:00.2: tee enabled
[    2.075269] ccp 0000:05:00.2: psp enabled
[    2.076076] hid: raw HID events driver (C) Jiri Kosina
[    2.076883] usbcore: registered new interface driver usbhid
[    2.077370] usbhid: USB HID core driver
[    2.077880] hp_accel: laptop model unknown, using default axes configuration
[    2.101323] lis3lv02d: 8 bits 3DC sensor found
[    2.124090] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.131017] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input5
[    2.132382] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit offset/length 128/8 exceeds size of target Buffer (128 bits) (20211217/dsopcode-198)
[    2.133348] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.134366] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.135410] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit offset/length 128/8 exceeds size of target Buffer (128 bits) (20211217/dsopcode-198)
[    2.136349] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.137377] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.138310] input: HP WMI hotkeys as /devices/virtual/input/input6
[    2.139460] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit offset/length 128/8 exceeds size of target Buffer (128 bits) (20211217/dsopcode-198)
[    2.140482] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.141586] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.142632] random: fast init done
[    2.142783] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit offset/length 128/8 exceeds size of target Buffer (128 bits) (20211217/dsopcode-198)
[    2.145445] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.146210] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.147614] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D009] at bit offset/length 136/8 exceeds size of target Buffer (136 bits) (20211217/dsopcode-198)
[    2.148383] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.149716] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.150848] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D009] at bit offset/length 136/8 exceeds size of target Buffer (136 bits) (20211217/dsopcode-198)
[    2.151984] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.153224] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.154445] ACPI BIOS Error (bug): AE_AML_BUFFER_LIMIT, Field [D008] at bit offset/length 128/8 exceeds size of target Buffer (128 bits) (20211217/dsopcode-198)
[    2.155565] ACPI Error: Aborting method \HWMC due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.156701] ACPI Error: Aborting method \_SB.WMID.WMAA due to previous error (AE_AML_BUFFER_LIMIT) (20211217/psparse-529)
[    2.159432] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    2.160311] snd_hda_intel 0000:01:00.1: Disabling MSI
[    2.161049] snd_hda_intel 0000:01:00.1: Handle vga_switcheroo audio client
[    2.161762] snd_hda_intel 0000:05:00.6: enabling device (0000 -> 0002)
[    2.162521] usbcore: registered new interface driver snd-usb-audio
[    2.163334] NET: Registered PF_LLC protocol family
[    2.165840] Initializing XFRM netlink socket
[    2.166051] input: ELAN0718:00 04F3:30FD Mouse as /devices/platform/AMDI0010:03/i2c-0/i2c-ELAN0718:00/0018:04F3:30FD.0001/input/input7
[    2.166893] NET: Registered PF_INET6 protocol family
[    2.167786] input: ELAN0718:00 04F3:30FD Touchpad as /devices/platform/AMDI0010:03/i2c-0/i2c-ELAN0718:00/0018:04F3:30FD.0001/input/input9
[    2.169483] Segment Routing with IPv6
[    2.170621] hid-multitouch 0018:04F3:30FD.0001: input,hidraw0: I2C HID v1.00 Mouse [ELAN0718:00 04F3:30FD] on i2c-ELAN0718:00
[    2.171852] In-situ OAM (IOAM) with IPv6
[    2.173596] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input10
[    2.175547] mip6: Mobile IPv6
[    2.176951] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input11
[    2.177793] NET: Registered PF_PACKET protocol family
[    2.179124] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input12
[    2.179904] NET: Registered PF_KEY protocol family
[    2.180899] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.1/0000:01:00.1/sound/card1/input13
[    2.182800] Bluetooth: RFCOMM TTY layer initialized
[    2.184094] Bluetooth: RFCOMM socket layer initialized
[    2.185534] Bluetooth: RFCOMM ver 1.11
[    2.186894] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.188453] Bluetooth: BNEP filters: protocol multicast
[    2.189997] Bluetooth: BNEP socket layer initialized
[    2.191383] snd_hda_codec_realtek hdaudioC2D0: autoconfig for ALC285: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    2.192735] snd_hda_codec_realtek hdaudioC2D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    2.193263] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.193890] snd_hda_codec_realtek hdaudioC2D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    2.195411] Bluetooth: HIDP socket layer initialized
[    2.196370] snd_hda_codec_realtek hdaudioC2D0:    mono: mono_out=0x0
[    2.197315] l2tp_core: L2TP core driver, V2.0
[    2.198220] snd_hda_codec_realtek hdaudioC2D0:    inputs:
[    2.199153] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    2.200077] snd_hda_codec_realtek hdaudioC2D0:      Mic=0x19
[    2.201016] l2tp_netlink: L2TP netlink interface
[    2.201922] snd_hda_codec_realtek hdaudioC2D0:      Internal Mic=0x12
[    2.202847] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    2.205301] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[    2.206843] 8021q: 802.1Q VLAN Support v1.8
[    2.208192] NET: Registered PF_RDS protocol family
[    2.209593] Registered RDS/tcp transport
[    2.211825] microcode: CPU0: patch_level=0x08600106
[    2.213241] microcode: CPU1: patch_level=0x08600106
[    2.214789] microcode: CPU2: patch_level=0x08600106
[    2.216079] microcode: CPU3: patch_level=0x08600106
[    2.218027] microcode: CPU4: patch_level=0x08600106
[    2.219482] microcode: CPU5: patch_level=0x08600106
[    2.220814] microcode: CPU6: patch_level=0x08600106
[    2.222230] microcode: CPU7: patch_level=0x08600106
[    2.223571] microcode: CPU8: patch_level=0x08600106
[    2.224666] microcode: CPU9: patch_level=0x08600106
[    2.225781] microcode: CPU10: patch_level=0x08600106
[    2.226952] microcode: CPU11: patch_level=0x08600106
[    2.228155] microcode: Microcode Update Driver: v2.2.
[    2.228159] IPI shorthand broadcast: enabled
[    2.229973] AVX2 version of gcm_enc/dec engaged.
[    2.231222] AES CTR mode by8 optimization enabled
[    2.232357] sched_clock: Marking stable (2230915842, 1425836)->(2249262888, -16921210)
[    2.233419] registered taskstats version 1
[    2.234540] Loading compiled-in X.509 certificates
[    2.235841] Key type ._fscrypt registered
[    2.236960] usb 1-4: new full-speed USB device number 2 using xhci_hcd
[    2.237799] Key type .fscrypt registered
[    2.238893] Key type fscrypt-provisioning registered
[    2.260964] usb 3-3: new high-speed USB device number 2 using xhci_hcd
[    2.266091] ata1: SATA link down (SStatus 0 SControl 300)
[    2.387805] usb 1-4: New USB device found, idVendor=0bda, idProduct=b00c, bcdDevice= 0.00
[    2.388839] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.389534] usb 1-4: Product: Bluetooth Radio
[    2.390024] usb 1-4: Manufacturer: Realtek
[    2.390498] usb 1-4: SerialNumber: 00e04c000001
[    2.403776] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[    2.405649] Bluetooth: hci0: RTL: rom_version status=0 version=3
[    2.406524] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[    2.407257] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[    2.407715] bluetooth hci0: Direct firmware load for rtl_bt/rtl8822cu_config.bin failed with error -2
[    2.408148] usb 3-3: New USB device found, idVendor=30c9, idProduct=0013, bcdDevice= 0.01
[    2.408166] Bluetooth: hci0: RTL: cfg_sz -2, total sz 35080
[    2.409054] usb 3-3: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.410710] usb 3-3: Product: HP TrueVision HD Camera
[    2.411616] usb 3-3: Manufacturer: DJKCVA19IECCI0
[    2.412366] usb 3-3: SerialNumber: 0001
[    2.418982] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.421691] usb 3-3: Found UVC 1.00 device HP TrueVision HD Camera (30c9:0013)
[    2.423462] ata2.00: ATA-9: SanDisk Ultra II 960GB, X41100RL, max UDMA/133
[    2.424143] ata2.00: 1875385008 sectors, multi 1: LBA48 NCQ (depth 32), AA
[    2.426496] ata2.00: configured for UDMA/133
[    2.427382] scsi 1:0:0:0: Direct-Access     ATA      SanDisk Ultra II 00RL PQ: 0 ANSI: 5
[    2.428481] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.428660] sd 1:0:0:0: [sda] 1875385008 512-byte logical blocks: (960 GB/894 GiB)
[    2.430367] sd 1:0:0:0: [sda] Write Protect is off
[    2.430957] input: HP TrueVision HD Camera: HP Tru as /devices/pci0000:00/0000:00:08.1/0000:05:00.4/usb3/3-3/3-3:1.0/input/input14
[    2.431030] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.431632] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.432820]  sda: sda1 sda2 sda3
[    2.433634] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.586956] clocksource: timekeeping watchdog on CPU4: Marking clocksource 'tsc' as unstable because the skew is too large:
[    2.587920] clocksource:                       'hpet' wd_nsec: 507753219 wd_now: 22859e0 wd_last: 1b96b0a mask: ffffffff
[    2.588769] clocksource:                       'tsc' cs_nsec: 504000390 cs_now: 4dcde2fd4 cs_last: 4823ea9fa mask: ffffffffffffffff
[    2.589415] clocksource:                       'tsc' is current clocksource.
[    2.589901] tsc: Marking TSC unstable due to clocksource watchdog
[    2.590973] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
[    2.591578] sched_clock: Marking unstable (2589546606, 1425836)<-(2607893677, -16921210)
[    2.592813] clocksource: Checking clocksource tsc synchronization from CPU 10 to CPUs 0-2,5,11.
[    2.594049] clocksource: Switched to clocksource hpet
[    2.595325] acpi_cpufreq: overriding BIOS provided _PSD data
[    2.597444] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    2.629742] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    2.631611] Unstable clock detected, switching default tracing clock to "global"
               If you want to keep using the local clock, then add:
                 "trace_clock=local"
               on the kernel command line
[    2.634603] ALSA device list:
[    2.635885]   #0: Loopback 1
[    2.636967]   #1: HDA NVidia at 0xfc080000 irq 74
[    2.715581] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[    2.867764] input: HD-Audio Generic Mic as /devices/pci0000:00/0000:00:08.1/0000:05:00.6/sound/card2/input15
[    2.869070] input: HD-Audio Generic Headphone as /devices/pci0000:00/0000:00:08.1/0000:05:00.6/sound/card2/input16
[    2.873189] EXT4-fs (nvme0n1p4): mounted filesystem with ordered data mode. Quota mode: disabled.
[    2.875013] VFS: Mounted root (ext4 filesystem) readonly on device 259:4.
[    2.877635] devtmpfs: mounted
[    2.879751] Freeing unused decrypted memory: 2044K
[    2.881528] Freeing unused kernel image (initmem) memory: 1236K
[    2.884979] Write protecting the kernel read-only data: 30720k
[    2.888152] Freeing unused kernel image (text/rodata gap) memory: 2028K
[    2.889401] Freeing unused kernel image (rodata/data gap) memory: 192K
[    2.891475] Run /sbin/init as init process
[    2.893182]   with arguments:
[    2.893183]     /sbin/init
[    2.893183]   with environment:
[    2.893184]     HOME=/
[    2.893184]     TERM=linux
[    3.433966] random: crng init done
[    3.459806] udevd[327]: starting eudev-3.2.11
[    4.099751] Adding 1048572k swap on /dev/nvme0n1p3.  Priority:-2 extents:1 across:1048572k SS
[    4.536452] EXT4-fs (nvme0n1p4): re-mounted. Quota mode: disabled.
[    4.592535] FAT-fs (nvme0n1p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    4.604520] EXT4-fs (sda3): mounted filesystem with ordered data mode. Quota mode: disabled.
[   13.944596] wlan0: authenticate with 24:4b:fe:be:28:28
[   13.944612] wlan0: bad VHT capabilities, disabling VHT
[   14.326598] wlan0: send auth to 24:4b:fe:be:28:28 (try 1/3)
[   14.443050] wlan0: send auth to 24:4b:fe:be:28:28 (try 2/3)
[   14.446398] wlan0: authenticated
[   14.448052] wlan0: associate with 24:4b:fe:be:28:28 (try 1/3)
[   14.452924] wlan0: RX AssocResp from 24:4b:fe:be:28:28 (capab=0x1411 status=0 aid=6)
[   14.453207] wlan0: associated
[   14.475939] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   15.334881] wlan0: deauthenticating from 24:4b:fe:be:28:28 by local choice (Reason: 3=DEAUTH_LEAVING)
[   22.442750] wlan0: authenticate with 24:4b:fe:be:28:2c
[   22.833893] wlan0: send auth to 24:4b:fe:be:28:2c (try 1/3)
[   22.939346] wlan0: send auth to 24:4b:fe:be:28:2c (try 2/3)
[   23.043352] wlan0: send auth to 24:4b:fe:be:28:2c (try 3/3)
[   23.147290] wlan0: authentication with 24:4b:fe:be:28:2c timed out
[   33.174818] wlan0: authenticate with 24:4b:fe:be:28:28
[   33.174834] wlan0: bad VHT capabilities, disabling VHT
[   33.554897] wlan0: send auth to 24:4b:fe:be:28:28 (try 1/3)
[   33.558275] wlan0: authenticated
[   33.559173] wlan0: associate with 24:4b:fe:be:28:28 (try 1/3)
[   33.565104] wlan0: RX AssocResp from 24:4b:fe:be:28:28 (capab=0x1411 status=0 aid=6)
[   33.565384] wlan0: associated
[   33.574936] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   39.447968] amdgpu 0000:05:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=none:owns=none
[   99.889150] nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
[  120.750272] atkbd serio0: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
[  120.750283] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[  120.758204] atkbd serio0: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
[  120.758213] atkbd serio0: Use 'setkeycodes e058 <keycode>' to make it known.
[  121.328660] PM: suspend entry (deep)
[  121.331664] Filesystems sync: 0.002 seconds
[  121.331879] Freezing user space processes ... (elapsed 0.002 seconds) done.
[  121.334121] OOM killer disabled.
[  121.334122] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
[  121.335057] printk: Suspending console(s) (use no_console_suspend to debug)
[  121.346539] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  121.347541] sd 1:0:0:0: [sda] Stopping disk
[  121.347851] wlan0: deauthenticating from 24:4b:fe:be:28:28 by local choice (Reason: 3=DEAUTH_LEAVING)
[  121.441302] [drm] free PSP TMR buffer
[  121.605308] PM: late suspend of devices failed
[  121.605540] pci 0000:00:00.2: can't derive routing for PCI INT A
[  121.605545] pci 0000:00:00.2: PCI INT A: no GSI
[  121.605705] [drm] PCIE GART of 1024M enabled.
[  121.605709] [drm] PTB located at 0x000000F400900000
[  121.605725] [drm] PSP is resuming...
[  121.606563] sd 1:0:0:0: [sda] Starting disk
[  121.622941] nvme nvme0: 16/0/0 default/read/poll queues
[  121.625763] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[  121.911657] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[  121.916068] ata1: SATA link down (SStatus 0 SControl 300)
[  121.918962] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[  121.929746] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[  121.929748] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[  121.929752] amdgpu 0000:05:00.0: amdgpu: SMU is resuming...
[  121.929879] amdgpu 0000:05:00.0: amdgpu: dpm has been disabled
[  121.930957] amdgpu 0000:05:00.0: amdgpu: SMU is resumed successfully!
[  121.931731] [drm] DMUB hardware initialized: version=0x0101001F
[  122.067221] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  122.069914] ata2.00: configured for UDMA/133
[  122.353938] [drm] kiq ring mec 2 pipe 1 q 0
[  122.590675] amdgpu 0000:05:00.0: [drm:amdgpu_ring_test_helper] *ERROR* ring gfx test failed (-110)
[  122.590684] [drm:amdgpu_device_ip_resume_phase2] *ERROR* resume of IP block <gfx_v9_0> failed -110
[  122.590689] amdgpu 0000:05:00.0: amdgpu: amdgpu_device_ip_resume failed (-110).
[  122.590691] amdgpu 0000:05:00.0: amdgpu: resume failed with -110; attempting to reset ASIC
[  122.590693] amdgpu 0000:05:00.0: amdgpu: MODE2 reset
[  122.821823] [drm] kiq ring mec 2 pipe 1 q 0
[  122.837481] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[  122.837560] [drm] JPEG decode initialized successfully.
[  122.837570] amdgpu 0000:05:00.0: amdgpu: ring gfx uses VM inv eng 0 on hub 0
[  122.837572] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[  122.837573] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[  122.837575] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[  122.837576] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[  122.837577] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[  122.837579] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[  122.837580] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[  122.837581] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[  122.837582] amdgpu 0000:05:00.0: amdgpu: ring kiq_2.1.0 uses VM inv eng 11 on hub 0
[  122.837583] amdgpu 0000:05:00.0: amdgpu: ring sdma0 uses VM inv eng 0 on hub 1
[  122.837584] amdgpu 0000:05:00.0: amdgpu: ring vcn_dec uses VM inv eng 1 on hub 1
[  122.837585] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 4 on hub 1
[  122.837586] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 5 on hub 1
[  122.837587] amdgpu 0000:05:00.0: amdgpu: ring jpeg_dec uses VM inv eng 6 on hub 1
[  122.841854] OOM killer enabled.
[  122.841855] Restarting tasks ... done.
[  122.843592] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[  122.845576] Bluetooth: hci0: RTL: rom_version status=0 version=3
[  122.845584] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[  122.845597] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[  122.848749] Bluetooth: hci0: RTL: cfg_sz 6, total sz 35086
[  122.968624] PM: suspend exit
[  122.968682] PM: suspend entry (s2idle)
[  122.970899] Filesystems sync: 0.002 seconds
[  122.971057] Freezing user space processes ... (elapsed 0.181 seconds) done.
[  123.152303] OOM killer disabled.
[  123.152304] Freezing remaining freezable tasks ... 
[  123.155652] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[  123.497300] (elapsed 0.344 seconds) done.
[  123.497310] printk: Suspending console(s) (use no_console_suspend to debug)
[  123.497362] amdgpu 0000:05:00.0: amdgpu: Power consumption will be higher as BIOS has not been configured for suspend-to-idle.
               To use suspend-to-idle change the sleep mode in BIOS setup.
[  123.502981] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  123.510483] sd 1:0:0:0: [sda] Stopping disk
[  123.532943] queueing ieee80211 work while going to suspend
[  123.532947] queueing ieee80211 work while going to suspend
[  123.636524] [drm] free PSP TMR buffer
[  123.666223] ACPI: EC: interrupt blocked
[  123.689376] ACPI: EC: interrupt unblocked
[  123.713392] pci 0000:00:00.2: can't derive routing for PCI INT A
[  123.713399] pci 0000:00:00.2: PCI INT A: no GSI
[  123.713440] [drm] PCIE GART of 1024M enabled.
[  123.713445] [drm] PTB located at 0x000000F400900000
[  123.713462] [drm] PSP is resuming...
[  123.714021] sd 1:0:0:0: [sda] Starting disk
[  123.731839] nvme nvme0: 16/0/0 default/read/poll queues
[  123.733502] [drm] reserve 0x400000 from 0xf41f800000 for PSP TMR
[  124.015853] usb 1-4: reset full-speed USB device number 2 using xhci_hcd
[  124.025309] ata1: SATA link down (SStatus 0 SControl 300)
[  124.026416] amdgpu 0000:05:00.0: amdgpu: RAS: optional ras ta ucode is not available
[  124.037079] amdgpu 0000:05:00.0: amdgpu: RAP: optional rap ta ucode is not available
[  124.037082] amdgpu 0000:05:00.0: amdgpu: SECUREDISPLAY: securedisplay ta ucode is not available
[  124.037086] amdgpu 0000:05:00.0: amdgpu: SMU is resuming...
[  124.037685] amdgpu 0000:05:00.0: amdgpu: dpm has been disabled
[  124.038901] amdgpu 0000:05:00.0: amdgpu: SMU is resumed successfully!
[  124.039702] [drm] DMUB hardware initialized: version=0x0101001F
[  124.187011] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  124.189830] ata2.00: configured for UDMA/133
[  124.590854] [drm] kiq ring mec 2 pipe 1 q 0
[  124.606712] [drm] VCN decode and encode initialized successfully(under DPG Mode).
[  124.606795] [drm] JPEG decode initialized successfully.
[  124.606807] amdgpu 0000:05:00.0: amdgpu: ring gfx uses VM inv eng 0 on hub 0
[  124.606812] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.0 uses VM inv eng 1 on hub 0
[  124.606815] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.0 uses VM inv eng 4 on hub 0
[  124.606817] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.0 uses VM inv eng 5 on hub 0
[  124.606819] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.0 uses VM inv eng 6 on hub 0
[  124.606821] amdgpu 0000:05:00.0: amdgpu: ring comp_1.0.1 uses VM inv eng 7 on hub 0
[  124.606823] amdgpu 0000:05:00.0: amdgpu: ring comp_1.1.1 uses VM inv eng 8 on hub 0
[  124.606825] amdgpu 0000:05:00.0: amdgpu: ring comp_1.2.1 uses VM inv eng 9 on hub 0
[  124.606827] amdgpu 0000:05:00.0: amdgpu: ring comp_1.3.1 uses VM inv eng 10 on hub 0
[  124.606829] amdgpu 0000:05:00.0: amdgpu: ring kiq_2.1.0 uses VM inv eng 11 on hub 0
[  124.606831] amdgpu 0000:05:00.0: amdgpu: ring sdma0 uses VM inv eng 0 on hub 1
[  124.606833] amdgpu 0000:05:00.0: amdgpu: ring vcn_dec uses VM inv eng 1 on hub 1
[  124.606835] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc0 uses VM inv eng 4 on hub 1
[  124.606837] amdgpu 0000:05:00.0: amdgpu: ring vcn_enc1 uses VM inv eng 5 on hub 1
[  124.606839] amdgpu 0000:05:00.0: amdgpu: ring jpeg_dec uses VM inv eng 6 on hub 1
[  125.611170] amdgpu 0000:05:00.0: [drm:amdgpu_ib_ring_tests] *ERROR* IB test failed on gfx (-110).
[  125.611187] [drm:process_one_work] *ERROR* ib ring test failed (-110).
[  125.612128] OOM killer enabled.
[  125.612132] Restarting tasks ... done.
[  125.613539] Bluetooth: hci0: RTL: examining hci_ver=0a hci_rev=000c lmp_ver=0a lmp_subver=8822
[  125.615560] Bluetooth: hci0: RTL: rom_version status=0 version=3
[  125.615567] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_fw.bin
[  125.615595] Bluetooth: hci0: RTL: loading rtl_bt/rtl8822cu_config.bin
[  125.615620] Bluetooth: hci0: RTL: cfg_sz 6, total sz 35086
[  125.742037] PM: suspend exit
[  125.924803] Bluetooth: hci0: RTL: fw version 0x19b76d7d
[  164.451331] wlan0: authenticate with 24:4b:fe:be:28:2c
[  164.838794] wlan0: send auth to 24:4b:fe:be:28:2c (try 1/3)
[  164.947057] wlan0: send auth to 24:4b:fe:be:28:2c (try 2/3)
[  165.051263] wlan0: send auth to 24:4b:fe:be:28:2c (try 3/3)
[  165.155024] wlan0: authentication with 24:4b:fe:be:28:2c timed out

--nextPart3425024.dWV9SEqChM--



