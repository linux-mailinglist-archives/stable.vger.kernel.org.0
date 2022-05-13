Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761705262AB
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380546AbiEMNKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 09:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379583AbiEMNKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 09:10:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27964EDFB
        for <stable@vger.kernel.org>; Fri, 13 May 2022 06:10:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npV3o-0002QY-04; Fri, 13 May 2022 15:10:24 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5977D7DA6F;
        Fri, 13 May 2022 13:10:19 +0000 (UTC)
Date:   Fri, 13 May 2022 15:10:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-can@vger.kernel.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Chee Hou Ong <chee.houx.ong@intel.com>,
        Aman Kumar <aman.kumar@intel.com>,
        Pallavi Kumari <kumari.pallavi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "can: m_can: pci: use custom bit timings for
 Elkhart Lake"
Message-ID: <20220513131018.x4xgeqtgamo4pm43@pengutronix.de>
References: <20220512124144.536850-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="noyjhbacdu6a2cvp"
Content-Disposition: inline
In-Reply-To: <20220512124144.536850-1-jarkko.nikula@linux.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--noyjhbacdu6a2cvp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.05.2022 15:41:43, Jarkko Nikula wrote:
> This reverts commit 0e8ffdf3b86dfd44b651f91b12fcae76c25c453b.
>=20
> Commit 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for
> Elkhart Lake") broke the test case using bitrate switching.
>=20
> 	ip link set can0 up type can bitrate 500000 dbitrate 4000000 fd on
> 	ip link set can1 up type can bitrate 500000 dbitrate 4000000 fd on
> 	candump can0 &
> 	cangen can1 -I 0x800 -L 64 -e -fb -D 11223344deadbeef55667788feedf00daab=
bccdd44332211 -n 1 -v -v
>=20
> Above commit does everything correctly according to the datasheet.
> However datasheet wasn't correct.
>=20
> I got confirmation from hardware engineers that the actual CAN hardware
> on Intel Elkhart Lake is based on M_CAN version v3.2.0. Datasheet was
> mirroring values from an another specification which was based on earlier
> M_CAN version leading to wrong bit timings.
>=20
> Therefore revert the commit and switch back to common bit timings.
>=20
> Fixes: 0e8ffdf3b86d ("can: m_can: pci: use custom bit timings for Elkhart=
 Lake")
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Reported-by: Chee Hou Ong <chee.houx.ong@intel.com>
> Reported-by: Aman Kumar <aman.kumar@intel.com>
> Reported-by: Pallavi Kumari <kumari.pallavi@intel.com>
> Cc: <stable@vger.kernel.org> # v5.16+

Added to can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--noyjhbacdu6a2cvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ+WLgACgkQrX5LkNig
0125jQgAkUQSFWcR4lAaEI04wCZ8S9IKxFmEG+kP+Q/QTfGTbZTXMbg/5HrdjSjf
nrC/hI0nEZsLfQzRYJVlcfiv44PS7ci0PfIKX9lfULAQV2OjppPIXYmCoYShBn1c
2VsGi17XaYXXoJV+tNAFoh3MPv2yNrTOTmFS8qOfNfMDVNC8nPNXx/nNDo07cC+5
bVVcIV00uvBogxNXjFIKCpTj0M4bgyV3wCqAqcu1AVl4otb9cO1NN2MJ/GBQ0DVJ
gU2WKs246fkA+EDRcz+yk7L8Vyon9203Hao6vSITcNy11ddHUoOd8ANSaAY/s6F/
B8Hxe8R/YDJ/PfXL5Ndehg+dkiq4JA==
=J3St
-----END PGP SIGNATURE-----

--noyjhbacdu6a2cvp--
