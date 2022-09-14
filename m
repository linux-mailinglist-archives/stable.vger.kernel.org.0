Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6F5B8F03
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 20:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiINSqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 14:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiINSqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 14:46:13 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72347C322;
        Wed, 14 Sep 2022 11:46:11 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oYXOi-0004Uw-Pq; Wed, 14 Sep 2022 20:46:08 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oYXOh-000nwv-1m;
        Wed, 14 Sep 2022 20:46:07 +0200
Message-ID: <c4dbfd1eea23b4495bb310dc78d174ef65adfc28.camel@decadent.org.uk>
Subject: Re: [PATCH 4.19 77/79] x86/nospec: Fix i386 RSB stuffing
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date:   Wed, 14 Sep 2022 20:46:00 +0200
In-Reply-To: <20220913140352.600717282@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
         <20220913140352.600717282@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-s3E3CzPI00VjpMVybfvG"
User-Agent: Evolution 3.45.3-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-s3E3CzPI00VjpMVybfvG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-09-13 at 16:07 +0200, Greg Kroah-Hartman wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>=20
> From: Peter Zijlstra <peterz@infradead.org>
>=20
> commit 332924973725e8cdcc783c175f68cf7e162cb9e5 upstream.

This should have only "From: Peter Zijlstra".

Ben.

>=20
> Turns out that i386 doesn't unconditionally have LFENCE, as such the
> loop in __FILL_RETURN_BUFFER isn't actually speculation safe on such
> chips.
>=20
> Fixes: ba6e31af2be9 ("x86/speculation: Add LFENCE to RSB fill sequence")
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: https://lkml.kernel.org/r/Yv9tj9vbQ9nNlXoY@worktop.programming.kick=
s-ass.net
> [bwh: Backported to 4.19/5.4:
>  - __FILL_RETURN_BUFFER takes an sp parameter
>  - Open-code __FILL_RETURN_SLOT]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/include/asm/nospec-branch.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -35,6 +35,7 @@
>   * the optimal version =E2=80=94 two calls, each with their own speculat=
ion
>   * trap should their return address end up getting used, in a loop.
>   */
> +#ifdef CONFIG_X86_64
>  #define __FILL_RETURN_BUFFER(reg, nr, sp)	\
>  	mov	$(nr/2), reg;			\
>  771:						\
> @@ -55,6 +56,19 @@
>  	add	$(BITS_PER_LONG/8) * nr, sp;	\
>  	/* barrier for jnz misprediction */	\
>  	lfence;
> +#else
> +/*
> + * i386 doesn't unconditionally have LFENCE, as such it can't
> + * do a loop.
> + */
> +#define __FILL_RETURN_BUFFER(reg, nr, sp)	\
> +	.rept nr;				\
> +	call	772f;				\
> +	int3;					\
> +772:;						\
> +	.endr;					\
> +	add	$(BITS_PER_LONG/8) * nr, sp;
> +#endif
> =20
>  /* Sequence to mitigate PBRSB on eIBRS CPUs */
>  #define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
>=20
>=20

--=20
Ben Hutchings
It is easier to change the specification to fit the program
than vice versa.

--=-s3E3CzPI00VjpMVybfvG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMiIWgACgkQ57/I7JWG
EQlhxA//e6whw2n1t7ggWh9/rK0zVn5WMnCZyUqgflfuEJtWb3th6ANv49ZT/gJe
EpZG0dnJcfRDZQ1IpkaG+Wg6Oz5quUuj1o7Rfym2pHAiVOBDNMV12Rt/7DI5IqEM
Qu9oIAqOjWk21xkPPavVVdHS5lbNQUQeNUfKkxTFyuzrPWG1OFC1sngGnO3xyiq8
zLScBPHwy5vYPSjzLj398OEiGVbV+PKoL1XMPQCyInP1X+nUQVfb8OMzDJwbVbMk
mtkvDGbxiy5/yE8JAGMe6TLy8NDW267a/9NsQQ/8HfZcGjiUaD9y5Z+BUAylBjCU
NbZxC0dVsI8vboCPo2lgspUuxRzGPFwBh7LNf3AGIo4YHnH0bLGQSApz1Q035uar
oQ/Q0ZzTCbUzOA0+EiOJ3qpK2S7QIUA9sHI3snheztKhKOIlg+04X9h4H17hCuyR
quDqFSPkZlBNmZrr1H/9VJFYrgEXjogLHWJRHdcX1B9XyCxKifcdpFQ0X+yf1cnL
Vr8EEvvgJHHY+jnl45UqOiVWaArLBwuoJSNGz4gFWCJS3M4hEJcDFikm5UfkAfhC
Jg6ZsMHYun0P4ZflaZ8BX5SIu9ZNp/h/GEZxA81UA8KP8GQEtWPA/MDY3YUI6f4E
6YZ6qX07zJw/a1iQeLxXzHVhDgnrq/9bXWIuwzJlrNA708jCKno=
=MPyT
-----END PGP SIGNATURE-----

--=-s3E3CzPI00VjpMVybfvG--
