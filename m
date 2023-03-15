Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B42A6BB3F6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjCONKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjCONKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F4A18AA
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 06:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3065061CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 13:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD193C433D2;
        Wed, 15 Mar 2023 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678885808;
        bh=G2q2dJAStdUCZECOzt7+ARgUFx9NwTP/y4Mr2wGEZh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZjKKayI6Yuu6/BIULvxYBpXA2rIeUvl5UjXLDTf6SQR3qdlPwcdfaGTjnZZfZMI7
         rAcAZaa5Q/48/qeK63wsEJIAX7Ah3r2PvVGIjUDvQtxjUYO9cahWdc1ziTiTGxGIuO
         zVqJWGMvNE9HfqOn40T11WiRh9uvDKcdcOuKPn9zsdGxmgByghleZj/Furzf27y7+c
         MIBrdjWO7a8Jdq58TnaGYeGCz4IVxnDM+4WK5XxvRwwA8/kg89F/Cu+9xtzkdrchGQ
         Fn15JSqWybYnRmH2msVzInSadY37i+b8LRpckJMWm8IVvwQPrAU+TaV9YsuSRAEdEJ
         SkAGOhyAlANPQ==
Date:   Wed, 15 Mar 2023 13:10:04 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Guenter Roeck <linux@roeck-us.net>,
        Conor Dooley <conor.dooley@microchip.com>,
        Samuel Holland <samuel@sholland.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.2 113/141] RISC-V: take text_mutex during alternative
 patching
Message-ID: <43a91137-87bd-490a-bd53-196aedb497e8@spud>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.437505798@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0+OR4pBqOv8IMJmq"
Content-Disposition: inline
In-Reply-To: <20230315115743.437505798@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0+OR4pBqOv8IMJmq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

Looks like the authorship for this commit has been lost as part of
backporting.

On Wed, Mar 15, 2023 at 01:13:36PM +0100, Greg Kroah-Hartman wrote:
> [ Upstream commit 9493e6f3ce02f44c21aa19f3cbf3b9aa05479d06 ]
>=20
> Guenter reported a splat during boot, that Samuel pointed out was the
> lockdep assertion failing in patch_insn_write():
>=20
> WARNING: CPU: 0 PID: 0 at arch/riscv/kernel/patch.c:63 patch_insn_write+0=
x222/0x2f6
> epc : patch_insn_write+0x222/0x2f6
>  ra : patch_insn_write+0x21e/0x2f6
> epc : ffffffff800068c6 ra : ffffffff800068c2 sp : ffffffff81803df0
>  gp : ffffffff81a1ab78 tp : ffffffff81814f80 t0 : ffffffffffffe000
>  t1 : 0000000000000001 t2 : 4c45203a76637369 s0 : ffffffff81803e40
>  s1 : 0000000000000004 a0 : 0000000000000000 a1 : ffffffffffffffff
>  a2 : 0000000000000004 a3 : 0000000000000000 a4 : 0000000000000001
>  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000052464e43
>  s2 : ffffffff80b4889c s3 : 000000000000082c s4 : ffffffff80b48828
>  s5 : 0000000000000828 s6 : ffffffff8131a0a0 s7 : 0000000000000fff
>  s8 : 0000000008000200 s9 : ffffffff8131a520 s10: 0000000000000018
>  s11: 000000000000000b t3 : 0000000000000001 t4 : 000000000000000d
>  t5 : ffffffffd8180000 t6 : ffffffff81803bc8
> status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
> [<ffffffff800068c6>] patch_insn_write+0x222/0x2f6
> [<ffffffff80006a36>] patch_text_nosync+0xc/0x2a
> [<ffffffff80003b86>] riscv_cpufeature_patch_func+0x52/0x98
> [<ffffffff80003348>] _apply_alternatives+0x46/0x86
> [<ffffffff80c02d36>] apply_boot_alternatives+0x3c/0xfa
> [<ffffffff80c03ad8>] setup_arch+0x584/0x5b8
> [<ffffffff80c0075a>] start_kernel+0xa2/0x8f8
>=20
> This issue was exposed by 702e64550b12 ("riscv: fpu: switch has_fpu() to
> riscv_has_extension_likely()"), as it is the patching in has_fpu() that
> triggers the splats in Guenter's report.
>=20
> Take the text_mutex before doing any code patching to satisfy lockdep.
>=20
> Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
> Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
> Fixes: 1a0e5dbd3723 ("riscv: sifive: Add SiFive alternative ports")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/all/20230212154333.GA3760469@roeck-us.net/
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

The original author on the submitted patch matched this signoff here,
not sure what went wrong along the way.

Cheers,
Conor.

> Reviewed-by: Samuel Holland <samuel@sholland.org>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20230212194735.491785-1-conor@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/errata/sifive/errata.c | 3 +++
>  arch/riscv/errata/thead/errata.c  | 8 ++++++--
>  arch/riscv/kernel/cpufeature.c    | 6 +++++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive=
/errata.c
> index 1031038423e74..5b77d7310e391 100644
> --- a/arch/riscv/errata/sifive/errata.c
> +++ b/arch/riscv/errata/sifive/errata.c
> @@ -4,6 +4,7 @@
>   */
> =20
>  #include <linux/kernel.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/bug.h>
> @@ -107,7 +108,9 @@ void __init_or_module sifive_errata_patch_func(struct=
 alt_entry *begin,
> =20
>  		tmp =3D (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
> +			mutex_lock(&text_mutex);
>  			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +			mutex_lock(&text_mutex);
>  			cpu_apply_errata |=3D tmp;
>  		}
>  	}
> diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/e=
rrata.c
> index fac5742d1c1e6..9d71fe3d35c77 100644
> --- a/arch/riscv/errata/thead/errata.c
> +++ b/arch/riscv/errata/thead/errata.c
> @@ -5,6 +5,7 @@
> =20
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
> @@ -97,11 +98,14 @@ void __init_or_module thead_errata_patch_func(struct =
alt_entry *begin, struct al
>  		tmp =3D (1U << alt->errata_id);
>  		if (cpu_req_errata & tmp) {
>  			/* On vm-alternatives, the mmu isn't running yet */
> -			if (stage =3D=3D RISCV_ALTERNATIVES_EARLY_BOOT)
> +			if (stage =3D=3D RISCV_ALTERNATIVES_EARLY_BOOT) {
>  				memcpy((void *)__pa_symbol(alt->old_ptr),
>  				       (void *)__pa_symbol(alt->alt_ptr), alt->alt_len);
> -			else
> +			} else {
> +				mutex_lock(&text_mutex);
>  				patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +				mutex_unlock(&text_mutex);
> +			}
>  		}
>  	}
> =20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 93e45560af307..5a82d5520a1fd 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -10,6 +10,7 @@
>  #include <linux/ctype.h>
>  #include <linux/libfdt.h>
>  #include <linux/log2.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <asm/alternative.h>
> @@ -339,8 +340,11 @@ void __init_or_module riscv_cpufeature_patch_func(st=
ruct alt_entry *begin,
>  		}
> =20
>  		tmp =3D (1U << alt->errata_id);
> -		if (cpu_req_feature & tmp)
> +		if (cpu_req_feature & tmp) {
> +			mutex_lock(&text_mutex);
>  			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +			mutex_unlock(&text_mutex);
> +		}
>  	}
>  }
>  #endif
> --=20
> 2.39.2
>=20
>=20
>=20

--0+OR4pBqOv8IMJmq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBHDrAAKCRB4tDGHoIJi
0uCrAQCw1cgRjwCQD+Iy1QJpzWiy3WCXXLHs4YeqP93Uw+galwD+Jc7DxlRM7/92
rSom+jkjLUcjC5QoajF64Sievbv9Gwc=
=06ua
-----END PGP SIGNATURE-----

--0+OR4pBqOv8IMJmq--
