Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13663B1C58
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFWOYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:24:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55794 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWOYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 10:24:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B9AB01C0B76; Wed, 23 Jun 2021 16:22:36 +0200 (CEST)
Date:   Wed, 23 Jun 2021 16:22:36 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 038/146] mptcp: do not warn on bad input from the
 network
Message-ID: <20210623142235.GA27348@amd>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154912.589676201@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20210621154912.589676201@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Paolo Abeni <pabeni@redhat.com>
>=20
> [ Upstream commit 61e710227e97172355d5f150d5c78c64175d9fb2 ]
>=20
> warn_bad_map() produces a kernel WARN on bad input coming
> from the network. Use pr_debug() to avoid spamming the system
> log.

So... we switched from WARN _ONCE_ to pr_debug, as many times as we
detect the problem.

Should this be pr_debug_once?

Best regards,
								Pavel


> +++ b/net/mptcp/subflow.c
> @@ -655,10 +655,10 @@ static u64 expand_seq(u64 old_seq, u16 old_data_len=
, u64 seq)
>  	return seq | ((old_seq + old_data_len + 1) & GENMASK_ULL(63, 32));
>  }
> =20
> -static void warn_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
> +static void dbg_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
>  {
> -	WARN_ONCE(1, "Bad mapping: ssn=3D%d map_seq=3D%d map_data_len=3D%d",
> -		  ssn, subflow->map_subflow_seq, subflow->map_data_len);
> +	pr_debug("Bad mapping: ssn=3D%d map_seq=3D%d map_data_len=3D%d",
> +		 ssn, subflow->map_subflow_seq, subflow->map_data_len);
>  }
> =20
>  static bool skb_is_fully_mapped(struct sock *ssk, struct sk_buff *skb)

Best regards,
									Pavel
--=20
http://www.livejournal.com/~pavelmachek

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDTQ6sACgkQMOfwapXb+vLTHwCfYuGShn4ZlWkW5HubXshWQVKL
3+cAn2aVMKRgXeeEE4q8EztWTVlAihzk
=wxNu
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
