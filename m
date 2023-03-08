Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E059D6B0BB3
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 15:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjCHOn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 09:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjCHOng (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 09:43:36 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C662D160F;
        Wed,  8 Mar 2023 06:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DEabxd1v23Tin5QpBxzS/rr27f1GPpemZn4RAYsZQ4g=; b=WVAd2GG64xSxybP+9vkI0rAy7R
        /U+clgaDlEs+OF8N7VpCHYBj1ufEfkJPXDGFhYA6UOIWjiw0/kOuKiVUZ6j/WNqQOkO4sl/zsBU99
        zYUUK8yCjdNYu6cG7CarMorJaNpL2KSIUp4XYDFkO0X4EXZy+oAY6BjNqi8ydxJMb8EwsKhgmBfsA
        n+Qd+dPsBgF3+aW8uzb6mYAY7CQeB8rLWprtwDFYG/1hcfB2Z6HfZ4vgjF0Rh1wZDrU4ux7MWiTph
        qGAFaOG8TSsCFtYnmVSPdo1CmA0bUYKOMbuy1o5TR8rXnEUMNMv/RMK7SFDtFQqeX+WUMzZFBN5Tz
        WKGnblzQ==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <kibi@debian.org>)
        id 1pZuyb-003fuS-9j; Wed, 08 Mar 2023 14:41:10 +0000
Date:   Wed, 8 Mar 2023 15:41:05 +0100
From:   Cyril Brulebois <kibi@debian.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: Re: [PATCH v6 06/20] irqdomain: Fix mapping-creation race
Message-ID: <20230308144105.di552lbogqv2s7fk@mraw.org>
Organization: Debian
References: <20230213104302.17307-1-johan+linaro@kernel.org>
 <20230213104302.17307-7-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bswmu74sozzwegdo"
Content-Disposition: inline
In-Reply-To: <20230213104302.17307-7-johan+linaro@kernel.org>
X-Debian-User: kibi
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bswmu74sozzwegdo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Johan,

And thanks so much for this patch series.

Johan Hovold <johan+linaro@kernel.org> (2023-02-13):
> Parallel probing of devices that share interrupts (e.g. when a driver
> uses asynchronous probing) can currently result in two mappings for the
> same hardware interrupt to be created due to missing serialisation.
>=20
> Make sure to hold the irq_domain_mutex when creating mappings so that
> looking for an existing mapping before creating a new one is done
> atomically.

Just for information: This patch fixes a long-standing regression
regarding Raspberry Pi devices, which have been failing to boot (at
least reliably) due to MMC timeouts for a long while; I think that
started between v5.17 and v5.19, but I couldn't bisect at the time
(I was already chasing some other regression).

Example bug report:
  https://bugs.debian.org/1019700

Before trying to pinpoint when the regression appeared, I've checked
these versions, with a Debian testing userspace as of 2023-03-07:
 - v6.1.12: affected.
 - v6.2: affected.
 - v6.3-rc1: not affected.

A bisect between v6.2 and v6.3-rc1 led me to this patch specifically.
Seeing how it's part of a patch series, and how previous patches are
preliminary ones, I've checked that cherry-picking the first 6 patches
on top of v6.1.15 indeed fixes the problem there too, and it does
(git cherry-pick v6.2-rc4..601363cc08da25747feb87c55573dd54de91d66a).


With the following systems:
 - Pi 4 B, using external storage (SD card),
 - CM4 Lite on CM4 IO Board, using external storage (SD card),
 - CM4 on CM4 IO Board, using internal storage (eMMC),

I've been able to verify that v6.1.12 (baseline in Debian testing)
triggers this MMC timeout issue, while v6.1.15 + the aforementioned
range of cherry-picked commits no longer triggers this issue.

(Methodology: cold boot then reboot 20 times, monitoring via serial
console to keep HDMI output of the equation; affected systems stop
booting after 1-4 boots; unaffected systems boot and reboot just fine
all the time.)


This looks like a critical bugfix for Raspberry Pi users.

Seeing the stable@ mention is about 4.8, I suppose this is going to be
considered for a wide range of kernels already=E2=80=A6 but I'm happy to dig
into this further to pinpoint when the regression appeared, if that's
helpful.


Cheers,
--=20
Cyril Brulebois (kibi@debian.org)            <https://debamax.com/>
D-I release manager -- Release team member -- Freelance Consultant

--bswmu74sozzwegdo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEtg6/KYRFPHDXTPR4/5FK8MKzVSAFAmQInn4ACgkQ/5FK8MKz
VSCE9BAAgmMQR4Q3Zho88R/bmOrHbVmcbWcuRY4R1Xt4JP2sJ/3KX9L4nDOVuw2X
u/0AdJ23/Ahgyp681MJJKWm7i2kW8qleOtsoxSUunPwzNIA/ulCrMSITJYY3FB/a
dczq66dvClI3YW2wbT/ruuw+0qr/c594rOD9SeGtmeiWxV/ac6tz5TG10yvMQadi
EKayXUiNRmSL93aN67YnugG0YMqqo8hDLVivlcES5IYtCbQTyxV4ucA6qBITAybc
AxMZXtEkCnTCgD8svyehp0P2CQeyJbpj0JS68sJW9GeJoeLyf0+b8zW9a4aLPQQr
5ngBZldPDCf0lE1u5XlV4is46AN5CjyjwRbIUZTN6fzt8zlI8jZuHQF2R7UeWwB8
qvlO9eXziVPp+DruSy5rFppZJ7OKq04POCL4AIcron4kaUpt2TIuD+pjtsZEbMld
0a/BjD+YR91kikMTgBHD5G9qu1Dcc5HG6akGfjNzf3poZF8aJzEC3C8cGP2sM/bh
//TN0Flsf5PoMAsWcFeVEvxtoWp27JCFDsG0FEl8OhEDQesUQynKaAyAVj+TGVq+
ILd2qtPJJxC5HCbUX4OHymZtbyEi2C1RyyquAyRb81wxEWd6AO2699SgcMgbbOZY
uDTAEWhb4stci4FveA7xK/cFAfjTdXdJkpEwhw1iTX26lNWZQ5k=
=HYJC
-----END PGP SIGNATURE-----

--bswmu74sozzwegdo--
