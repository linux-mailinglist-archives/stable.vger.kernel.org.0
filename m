Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B825A5F5A4A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiJETBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 15:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbiJETBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 15:01:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AA227B08;
        Wed,  5 Oct 2022 12:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09476B81A02;
        Wed,  5 Oct 2022 19:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3841C433C1;
        Wed,  5 Oct 2022 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664996490;
        bh=uWVkvumQgQnDH4uzpkg/RNsFPnUEzMx1/jqg1fffNms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sybmgEi8NkEWJm778I3Ds4u0kugkxvLB6n9dBJWzmDicNZmIDTB4OD/W0+NJaX4nL
         pFo3QiPrIe3GYHrkX3mMcWCVhJEcv0zIexFFyM7MLBjB8neH0313pV2gEsB+LrK8Za
         iSvh80N0Hb5XxE7KiwN3DI1MjQDPtWKlQnFzhuiQxCvT1a8CWD/YsU9XJBQGKDSmN8
         RsE5533foyi1JIcMhJMEAZ+B8t0KCykyEe90rfIIZnMjzMmbVxfRdFYxsi3gceQhim
         a/W+9+IFBZ3VhNUZijNuNyqcU/p42eUgqtoM/flgzPbug+klz8Ao0B8hfPZHkL3p2b
         Vc70nsVBLSLRg==
Date:   Wed, 5 Oct 2022 21:01:25 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Fix handling of real but unexpected
 device interrupts
Message-ID: <Yz3Uhe3roLepyzfr@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>, Samuel Clark <slc2015@gmail.com>,
        stable@vger.kernel.org
References: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WkcacvfBhT2PoFhy"
Content-Disposition: inline
In-Reply-To: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WkcacvfBhT2PoFhy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2022 at 04:56:44PM +0300, Jarkko Nikula wrote:
> Commit c7b79a752871 ("mfd: intel-lpss: Add Intel Alder Lake PCH-S PCI
> IDs") caused a regression on certain Gigabyte motherboards for Intel
> Alder Lake-S where system crashes to NULL pointer dereference in
> i2c_dw_xfer_msg() when system resumes from S3 sleep state ("deep").
>=20
> I was able to debug the issue on Gigabyte Z690 AORUS ELITE and made
> following notes:
>=20
> - Issue happens when resuming from S3 but not when resuming from
>   "s2idle"
> - PCI device 00:15.0 =3D=3D i2c_designware.0 is already in D0 state when
>   system enters into pci_pm_resume_noirq() while all other i2c_designware
>   PCI devices are in D3. Devices were runtime suspended and in D3 prior
>   entering into suspend
> - Interrupt comes after pci_pm_resume_noirq() when device interrupts are
>   re-enabled
> - According to register dump the interrupt really comes from the
>   i2c_designware.0. Controller is enabled, I2C target address register
>   points to a one detectable I2C device address 0x60 and the
>   DW_IC_RAW_INTR_STAT register START_DET, STOP_DET, ACTIVITY and
>   TX_EMPTY bits are set indicating completed I2C transaction.
>=20
> My guess is that the firmware uses this controller to communicate with
> an on-board I2C device during resume but does not disable the controller
> before giving control to an operating system.
>=20
> I was told the UEFI update fixes this but never the less it revealed the
> driver is not ready to handle TX_EMPTY (or RX_FULL) interrupt when device
> is supposed to be idle and state variables are not set (especially the
> dev->msgs pointer which may point to NULL or stale old data).
>=20
> Introduce a new software status flag STATUS_ACTIVE indicating when the
> controller is active in driver point of view. Now treat all interrupts
> that occur when is not set as unexpected and mask all interrupts from
> the controller.
>=20
> Fixes: c7b79a752871 ("mfd: intel-lpss: Add Intel Alder Lake PCH-S PCI IDs=
")
> Reported-by: Samuel Clark <slc2015@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D215907
> Cc: stable@vger.kernel.org # v5.12+
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Applied to for-current, thanks!


--WkcacvfBhT2PoFhy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmM91IUACgkQFA3kzBSg
KbZ3FxAAmp2/QNVAZOR+QOnS8JRy05TvUG9m1gqqOBjqlDnf/1Y0EnHDgUUqy1xT
jGjXR3Ov8fNopMi7mz+GtVeQuY8UJFD4ZIU2zh/QInvJTgU/Ga7aUbwZ2nI9twxW
BPrgIJDqWALnzupzlZm5hk9Df1hgiwsSM1ygEuUNGsO+iRCN7m9E3wwoNgwae1O0
HXjtICf3LtN64YFwwMRM0O9hZTf8l9iiL8JD/ye/BJTiyY+x3WOGHH/I7PGITwRo
g1Xbag41GV3KYulpNpO+OFYRw9yIgDawoXt+mf24YOMmV2pCZHnbgz/+/4UpURbv
TO3HDhdzh0E/HPqY/GNH0B48+jzUNQvSz/8HttxCTp4hJdJAojkF6UVK0s7I+6U3
NpWwqkOENHpaZfF9Dkrw/R1UGuFfZx2UlaxMAM2sqSm2EN6Wp0PZx9a+g0peY5lD
QRl9Z6TNHEIxemlZcNbS1Oufz5oeC1gLKi7Pu9JUqCLVz0HPv/yiT/n/jcAmkPVJ
2PwEz7/iWhCNmW//KG7/6LixhHlJfUlEsh/SihPN7OMgriQbXxqNKtQ2zAyNGI+k
KoZHYQ7Rk6Ph1ZivfUrQ5j+xf3+8jncMCiF+vClgeAhidpd/m/NJSJdT0I20/WWu
362YH6w5SiTlxTpEMLEeVbh6XlHR+B32dQaQoIPmxNsUF2edhvA=
=42My
-----END PGP SIGNATURE-----

--WkcacvfBhT2PoFhy--
