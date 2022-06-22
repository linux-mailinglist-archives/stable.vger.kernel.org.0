Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC535545FB
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 14:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357791AbiFVLsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 07:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346969AbiFVLsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 07:48:50 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ABC3CA58;
        Wed, 22 Jun 2022 04:48:47 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 20F4E1C0B9B; Wed, 22 Jun 2022 13:48:45 +0200 (CEST)
Date:   Wed, 22 Jun 2022 13:48:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH 4.9 13/20] x86/speculation/mmio: Add mitigation for
 Processor MMIO Stale Data
Message-ID: <20220622114844.GA6854@duo.ucw.cz>
References: <20220614183722.061550591@linuxfoundation.org>
 <20220614183725.181834522@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20220614183725.181834522@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> +static int __init mmio_stale_data_parse_cmdline(char *str)
> +{
> +	if (!boot_cpu_has_bug(X86_BUG_MMIO_STALE_DATA))
> +		return 0;
> +
> +	if (!str)
> +		return -EINVAL;
> +
> +	if (!strcmp(str, "off")) {
> +		mmio_mitigation =3D MMIO_MITIGATION_OFF;
> +	} else if (!strcmp(str, "full")) {
> +		mmio_mitigation =3D MMIO_MITIGATION_VERW;
> +	} else if (!strcmp(str, "full,nosmt")) {
> +		mmio_mitigation =3D MMIO_MITIGATION_VERW;
> +		mmio_nosmt =3D true;
> +	}
> +
> +	return 0;
> +}

This is wrong, AFAICT. Returning 0 will pollute init's environment;
Randy was cleaning those lately and we are even seeing them in
-stable. See for example b793a01000122d2bd133ba451a76cc135b5e162c.

The early return 0 should disappear, too; we should validate the
option even on non-buggy machines.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrMBnAAKCRAw5/Bqldv6
8iJtAJsERFxro0FFV011k6a29uJIEIKqNACdHrxH1Umdyzcz1saie73RD0zpgmE=
=iyCs
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
