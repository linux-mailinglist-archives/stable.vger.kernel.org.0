Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1363EE753
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 09:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbhHQHha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 03:37:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55340 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhHQHh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 03:37:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D9EE31C0B76; Tue, 17 Aug 2021 09:36:55 +0200 (CEST)
Date:   Tue, 17 Aug 2021 09:36:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 49/62] PCI/MSI: Enable and mask MSI-X early
Message-ID: <20210817073655.GA15132@amd>
References: <20210816125428.198692661@linuxfoundation.org>
 <20210816125429.897761686@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20210816125429.897761686@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I'm sorry to report here, but 4.4 patches were not yet sent to the
lists (and it may be worth correcting before release).

> +++ b/drivers/pci/msi.c
> @@ -778,18 +778,25 @@ static int msix_capability_init(struct p
=2E..
> =20
>  	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
>  	/* Request & Map MSI-X table region */
>  	base =3D msix_map_region(dev, msix_table_size(control));
> -	if (!base)
> -		return -ENOMEM;
> +	if (!base) {
> +		ret =3D -ENOMEM;
> +		goto out_disable;
> +	}
> =20
>  	ret =3D msix_setup_entries(dev, base, entries, nvec, affd);
>  	if (ret)

This one is correct, and so is the version queued for 4.19, but 4.4
version (9da69496e86237e94c4ffa2a5b375a4d2ee7c482) has:

 /* Request & Map MSI-X table region */
    	  base =3D msix_map_region(dev, msix_table_size(control));
 -       if (!base)
 +       if (!base) {
                 return -ENOMEM;
 +               goto out_disable;
 +       }
=20
	ret =3D msix_setup_entries(dev, base, entries, nvec);
=09

That return is misplaced, it should be ret =3D -ENOMEM, similar to 4.19
and newer.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEbZxcACgkQMOfwapXb+vI7MwCgjj8fHxZOQt3ZF3Qa4aWHLNb0
aLoAn1X7OQxXCS+NHeeuVN/UoMaKjBQ3
=qvwj
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
