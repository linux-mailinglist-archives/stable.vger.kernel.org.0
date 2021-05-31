Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65B73968B6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhEaU0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:26:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51222 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhEaU0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:26:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C7BFC1C0B76; Mon, 31 May 2021 22:24:53 +0200 (CEST)
Date:   Mon, 31 May 2021 22:24:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.10 036/252] ath10k: drop MPDU which has discard flag
 set by firmware for SDIO
Message-ID: <20210531202453.GA18772@amd>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130659.215132273@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20210531130659.215132273@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 079a108feba474b4b32bd3471db03e11f2f83b81 upstream.
>=20
> When the discard flag is set by the firmware for an MPDU, it should be
> dropped. This allows a mitigation for CVE-2020-24588 to be implemented
> in the firmware.
>=20
> Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

This introduces bitfields for communication with firmware.

> +++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
> @@ -1282,7 +1282,19 @@ struct fw_rx_desc_base {
>  #define FW_RX_DESC_UDP              (1 << 6)
> =20
>  struct fw_rx_desc_hl {
> -	u8 info0;
> +	union {
> +		struct {
> +		u8 discard:1,
> +		   forward:1,
> +		   any_err:1,
> +		   dup_err:1,
> +		   reserved:1,
> +		   inspect:1,
> +		   extension:2;
> +		} bits;
> +		u8 info0;
> +	} u;
> +

That is a) quite unusual (see the define just above) and b) very
fragile AFAICT. Compilers on LE and BE machines behave differently,
for example. Should it use usual bit manipulation functions?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1RhUACgkQMOfwapXb+vKNYQCfSGX5lSJApig3eMZB7iUP+QZN
64gAoJjL3ULTCduk5WT9GOgiRDWywIbn
=RW3Y
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
