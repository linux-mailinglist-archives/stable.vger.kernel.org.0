Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1E4380651
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhENJfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 05:35:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45722 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhENJfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 05:35:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 35E321C0B81; Fri, 14 May 2021 11:34:40 +0200 (CEST)
Date:   Fri, 14 May 2021 11:34:39 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 424/530] cxgb4: Fix unintentional sign extension
 issues
Message-ID: <20210514093439.GA12797@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144833.706658184@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20210512144833.706658184@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Colin Ian King <colin.king@canonical.com>

> The shifting of the u8 integers f->fs.nat_lip[] by 24 bits to
> the left will be promoted to a 32 bit signed int and then
> sign-extended to a u64. In the event that the top bit of the u8
> is set then all then all the upper 32 bits of the u64 end up as
> also being set because of the sign-extension. Fix this by
> casting the u8 values to a u64 before the 24 bit left shift.

Should we really use -stable series for beta-testing patches going to
-rc1? Because that's what Sasha is effectively doing.

> Addresses-Coverity: ("Unintended sign extension")
> Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

>  			set_tcb_field(adap, f, tid, TCB_RX_FRAG3_LEN_RAW_W,
>  				      WORD_MASK, f->fs.nat_lip[3] |
>  				      f->fs.nat_lip[2] << 8 |
>  				      f->fs.nat_lip[1] << 16 |
> -				      f->fs.nat_lip[0] << 24, 1);
> +				      (u64)f->fs.nat_lip[0] << 25, 1);
>  		}
>  	}


This one is wrong.

Best regards,
									Pavel
--=20
http://www.livejournal.com/~pavelmachek

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCeRC8ACgkQMOfwapXb+vLxUwCghjQthRJh+KTYoRApzGRY5U+0
6HkAnRcrRBcACVCxgEGLgIilqrrOxuwe
=vJ6O
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
