Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA91ACE5B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 19:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389279AbgDPRFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 13:05:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46456 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbgDPRFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 13:05:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DB6931C01E5; Thu, 16 Apr 2020 19:05:15 +0200 (CEST)
Date:   Thu, 16 Apr 2020 19:05:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 003/146] rxrpc: Abstract out the calculation of
 whether theres Tx space
Message-ID: <20200416170515.GA29803@duo.ucw.cz>
References: <20200416131242.353444678@linuxfoundation.org>
 <20200416131242.886803103@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20200416131242.886803103@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Abstract out the calculation of there being sufficient Tx buffer space.
> This is reproduced several times in the rxrpc sendmsg code.

I don't think this is suitable for stable. It does not fix anything.

> +/*
> + * Return true if there's sufficient Tx queue space.
> + */
> +static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_=
tx_win)
> +{
> +	unsigned int win_size =3D
> +		min_t(unsigned int, call->tx_winsize,
> +		      call->cong_cwnd + call->cong_extra);
> +	rxrpc_seq_t tx_win =3D READ_ONCE(call->tx_hard_ack);
> +
> +	if (_tx_win)
> +		*_tx_win =3D tx_win;

Plus, this is very very strange. Most callers pass NULL here, so we
do READ_ONCE(call->tx_hard_ack) and it can't be optimized out, and
then we drop the result.

> @@ -72,9 +85,7 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrp=
c_sock *rx,
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> =20
>  		tx_win =3D READ_ONCE(call->tx_hard_ack);
> -		if (call->tx_top - tx_win <
> -		    min_t(unsigned int, call->tx_winsize,
> -			  call->cong_cwnd + call->cong_extra))
> +		if (rxrpc_check_tx_space(call, &tx_win))
>  			return 0;
> =20
>  		if (call->state >=3D RXRPC_CALL_COMPLETE)

And the remaining caller already has right value in tx_win, and it is
discarded and READ again.

This does not make sense.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXpiQSwAKCRAw5/Bqldv6
8pxlAJ4jlYRivfobYEnRilD+7i/P/WH66QCeK3UC3V/yoW3FBSFpofNrBuqkwgs=
=oxcX
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
