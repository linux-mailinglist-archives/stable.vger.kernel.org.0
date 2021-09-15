Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F940C440
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhIOLUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:20:04 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhIOLUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 07:20:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 36C991C0B76; Wed, 15 Sep 2021 13:18:44 +0200 (CEST)
Date:   Wed, 15 Sep 2021 13:18:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: Re: [PATCH 5.10 157/236] Bluetooth: Move shutdown callback before
 flushing tx and rx queue
Message-ID: <20210915111843.GA16198@duo.ucw.cz>
References: <20210913131100.316353015@linuxfoundation.org>
 <20210913131105.720088593@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20210913131105.720088593@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2 ]

Upstream commit is okay...

> So move the shutdown callback before flushing TX/RX queue to resolve the
> issue.

=2E..but something went wrong in stable. This is not moving code, this
is duplicating it:

> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1726,6 +1726,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
>  	hci_request_cancel_all(hdev);
>  	hci_req_sync_lock(hdev);
> =20
> +	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> +	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> +	    test_bit(HCI_UP, &hdev->flags)) {
> +		/* Execute vendor specific shutdown routine */
> +		if (hdev->shutdown)
> +			hdev->shutdown(hdev);
> +	}
> +
>  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
>  		cancel_delayed_work_sync(&hdev->cmd_timer);
>  		hci_req_sync_unlock(hdev);

And yes, we end up with 2 copies in 5.10.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUHWkwAKCRAw5/Bqldv6
8pcHAJwMIKymx3gC/j1OMFbG/uKphOBu0gCfVkgEvY8X8lbln2FfmF7qbfALr4k=
=TbG8
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
