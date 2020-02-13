Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA35315C814
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgBMQS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:18:57 -0500
Received: from sauhun.de ([88.99.104.3]:48812 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbgBMQS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 11:18:57 -0500
Received: from localhost (p54B33627.dip0.t-ipconnect.de [84.179.54.39])
        by pokefinder.org (Postfix) with ESMTPSA id 16FEC2C07AD;
        Thu, 13 Feb 2020 17:18:55 +0100 (CET)
Date:   Thu, 13 Feb 2020 17:18:54 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Fix BUG_ON during device removal
Message-ID: <20200213161854.GA5929@ninjato>
References: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20200213151503.545269-1-jarkko.nikula@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2020 at 05:15:03PM +0200, Jarkko Nikula wrote:
> Function i2c_dw_pci_remove() -> pci_free_irq_vectors() ->
> pci_disable_msi() -> free_msi_irqs() will throw a BUG_ON() for MSI
> enabled device since the driver has not released the requested IRQ before
> calling the pci_free_irq_vectors().
>=20
> Here driver requests an IRQ using devm_request_irq() but automatic
> release happens only after remove callback. Fix this by explicitly
> freeing the IRQ before calling pci_free_irq_vectors().

Does it make sense to keep devm for irq handling, then?


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl5FduoACgkQFA3kzBSg
Kbbyvg/+OGL0pHycnPQFzH1+8IB5gMh4SgTKK3pyluaAeNOrYo5lb9iD+jJAQRYP
mrx025T13yRuiTisJvFtqDZKuYzQXn+A2wCLVZjBu2fwHyBqgS9PjcmqJ7j9MnVY
vPP/Y0WZVJ00IEvBvwgexyxi2Sk1Om95fI/sOIo3XvAg6q1JgDTDs7hu6fRSWZ5Y
qnjOFS1uvtJKP7NjxuouCy8aQHieCd2k4HWTfn4co9cXM/g2MeChIDiA4X4ZFiB6
LxCCJre50dNw+Jz1ykqxHKRygFFAdy7O2bTlbckYnJItBCZZA6JaWeb6B7vdmw/c
4EGFpYIAJuomSNkVHTy37Z3HbUtBSdpYJ7GghloxHep1tjAbJhgIPY8+RQhnHOkm
Sl2GnOiqixwykhdBDDchUuHfQXo0Gj7374uu+ksadkiQYFXuGHTJy6t+G09AfNtr
EbNwAW2xLo46SrZ5Kol1Y3SPV4Kt7O825g4c0ZxiN6u4z/8mvyb6cwpgNffKdC06
2Bj9Vl9HNofndTJKwTiMQaXENCCetsGQ+bCSrO95cMw1Njd+70nE8RvlbIxZnWJn
MZY5lqhSIGcD8NR62492Rcyvi5n4lCBR5CiRY0Gr88xrLY92kNy4Z//IxD6zITwr
JSvdz4cXLLQk8zYpbo1B5+6+PljTKCScn9fAl1kblDZxkGx7I70=
=2LAC
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
