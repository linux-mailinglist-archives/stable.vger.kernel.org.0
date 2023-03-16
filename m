Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772A06BC856
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCPILD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCPILC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:11:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95319B32AD
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 01:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678954252; x=1710490252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hPQ/wSm9pBZB9wQDxoC1YX4MTEbSkGD3sRtUDapssCc=;
  b=ZsvgBpjPXxMs6BvRD5acY3o+Xe9DFv8gocqT0Pd1jVP8S06+UL0ZdKEd
   ps9Dl+kGnwSfa4aKe02bCQNcmhH+7zJaizH9ZVCDXPBhAEpwvqIqq+O96
   Xib4MWBtO/t0f5C42qZ29Zd/uSNkyyHxbECqayWkkzSf/q3/EKq+Bk7wF
   Znromdv3mgs8AJqEDX1m4bwjCGvrIiUEnn/I/D0GXogXM+7uIQfj+PA4t
   YdawxZwh3B8OstAdgbBNejg/VWKBXjr4LbakXO6ffye5tyq6/pTgv32Bc
   yD+JGy18Z6/aOJp/CjdBMHVjmpmrnenJQwRLgCdhFiTps7+gBlAcDIp0B
   g==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="asc'?scan'208";a="205366602"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 01:10:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 01:10:48 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 01:10:47 -0700
Date:   Thu, 16 Mar 2023 08:10:17 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Conor Dooley <conor@kernel.org>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 113/141] RISC-V: take text_mutex during alternative
 patching
Message-ID: <ff51d87e-67ae-4b02-9367-d9c00ade27bf@spud>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.437505798@linuxfoundation.org>
 <43a91137-87bd-490a-bd53-196aedb497e8@spud>
 <ZBLEv2MdkAijCx44@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k+xFwHnsmEP0NOjF"
Content-Disposition: inline
In-Reply-To: <ZBLEv2MdkAijCx44@kroah.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--k+xFwHnsmEP0NOjF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 08:26:55AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 15, 2023 at 01:10:04PM +0000, Conor Dooley wrote:
> > Hey Greg,
> >=20
> > Looks like the authorship for this commit has been lost as part of
> > backporting.
> >=20
> > On Wed, Mar 15, 2023 at 01:13:36PM +0100, Greg Kroah-Hartman wrote:
> > > [ Upstream commit 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 ]
> > >=20
> > > Guenter reported a splat during boot, that Samuel pointed out was the
> > > lockdep assertion failing in patch_insn_write():
> > >=20
> > > WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 patch_insn_wri=
te+0x222/0x2f6
> > > epc : patch_insn_write+0x222/0x2f6
> > >  ra : patch_insn_write+0x21e/0x2f6
> > > epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffffff81803df0
> > >  gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffffffffffe000
> > >  t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81803e40
> > >  s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffffffffffffff
> > >  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000001
> > >  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
> > >  s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffffff80b48828
> > >  s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 0000000000000fff
> > >  s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 0000000000000018
> > >  s11: 000000000000000b t3 : 0000000000000001 t4 : 000000000000000d
> > >  t5 : ffffffffd8180000 t6 : ffffffff81803bc8
> > > status: 0000000200000100 badaddr: 0000000000000000 cause: 00000000000=
00003
> > > [<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
> > > [<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
> > > [<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x98
> > > [<ffffffff80003348>] _apply_alternatives+0x46/0x86
> > > [<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
> > > [<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
> > > [<ffffffff80c0075a>] start_kernel+0xa2/0x8f8
> > >=20
> > > This issue was exposed by 702e64550b12 ("riscv: fpu: switch has_fpu()=
 to
> > > riscv_has_extension_likely()"), as it is the patching in has_fpu() th=
at
> > > triggers the splats in Guenter's report.
> > >=20
> > > Take the text_mutex before doing any code patching to satisfy lockdep.
> > >=20
> > > Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
> > > Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
> > > Fixes: 1a0e5dbd3723 ("riscv: sifive: Add SiFive alternative ports")
> > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > Link: https://lore.kernel.org/all/20230212154333.GA3760469@roeck-us.n=
et/
> > > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> >=20
> > The original author on the submitted patch matched this signoff here,
> > not sure what went wrong along the way.
>=20
> I do not understand, sorry, the signed off by area of this commit in the
> queue seems to match up with what is in Linus's tree with the exception
> that Sasha:
>=20
> > > Reviewed-by: Samuel Holland <samuel@sholland.org>
> > > Tested-by: Guenter Roeck <linux@roeck-us.net>
> > > Link: https://lore.kernel.org/r/20230212194735.491785-1-conor@kernel.=
org
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> Added himself to the end of it.
>=20
> What exactly is not correct here?

The author of the patch is not the same as Linus' tree, which,
admittedly, is hard to tell from a patch email. In Linus' tree, the
author is me, but it's been attributed to Sasha somewhere along the way.

Perhaps this is something normal for stable stuff, I usually don't go
digging around in the stable-rc tree, but I wanted to make sure that
this stuff was backported correctly.
The cover-letter for this patch also shows the incorrect author for this
patch, but I am only noticing that now.

Cheers,
Conor.

--k+xFwHnsmEP0NOjF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBLO2gAKCRB4tDGHoIJi
0t6YAP0ebUymrw06fYZeAHo0KMcXn2i4k2TZNvQBTju5449RQAEArSsycfY+PclG
s7d2XMQmoVgqH91+lYXHWpElddDQoAE=
=ypQW
-----END PGP SIGNATURE-----

--k+xFwHnsmEP0NOjF--
