Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A3F6B1C60
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 08:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCIHcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 02:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCIHcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 02:32:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B4C61A91;
        Wed,  8 Mar 2023 23:31:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A277C60989;
        Thu,  9 Mar 2023 07:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EFBC433D2;
        Thu,  9 Mar 2023 07:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347087;
        bh=yDVgfe8xtdNFs1hk143OhTG5isTtChU/yLlLC18WBEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aJtjGnJ8UKBplRZLe3wQb/lVb6d5zasLP0ux9nJ+ufN720LGzRkfbyEgB9C3iROv0
         AlvB6Y4pxr+ktAitr9Ho552dHGa7J26eosJOoOKAwfvP6rMv2rEeabwPZnBlokHxPD
         veH9P1u6iakOoMTIMTO70MCmIuoZdBPCfNHACzh3MwR82/oZTxhz2EHagsnTUwhfM8
         tAuvspY/FrOZKF8nYm5ibBccqrA078ArqHh4NzG7e67Y5GHCHA5eg2u2sjKHhw8qgG
         7cHcgA8CM53P1JhsDPdEhaEsvLjLeLoBY/mUFOydCKLTd+I63R9t5GykDP5C5d8Qs0
         udKoIgorQ6/QA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paAl5-0004fH-C0; Thu, 09 Mar 2023 08:32:15 +0100
Date:   Thu, 9 Mar 2023 08:32:15 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Cyril Brulebois <kibi@debian.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: Re: [PATCH v6 06/20] irqdomain: Fix mapping-creation race
Message-ID: <ZAmLf3YKxI5fE9w5@hovoldconsulting.com>
References: <20230213104302.17307-1-johan+linaro@kernel.org>
 <20230213104302.17307-7-johan+linaro@kernel.org>
 <20230308144105.di552lbogqv2s7fk@mraw.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1pYx6IuXSbcDEQEb"
Content-Disposition: inline
In-Reply-To: <20230308144105.di552lbogqv2s7fk@mraw.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1pYx6IuXSbcDEQEb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 03:41:05PM +0100, Cyril Brulebois wrote:
> Hi Johan,
>=20
> And thanks so much for this patch series.
>=20
> Johan Hovold <johan+linaro@kernel.org> (2023-02-13):
> > Parallel probing of devices that share interrupts (e.g. when a driver
> > uses asynchronous probing) can currently result in two mappings for the
> > same hardware interrupt to be created due to missing serialisation.
> >=20
> > Make sure to hold the irq_domain_mutex when creating mappings so that
> > looking for an existing mapping before creating a new one is done
> > atomically.
>=20
> Just for information: This patch fixes a long-standing regression
> regarding Raspberry Pi devices, which have been failing to boot (at
> least reliably) due to MMC timeouts for a long while; I think that
> started between v5.17 and v5.19, but I couldn't bisect at the time
> (I was already chasing some other regression).
>=20
> Example bug report:
>   https://bugs.debian.org/1019700
>=20
> Before trying to pinpoint when the regression appeared, I've checked
> these versions, with a Debian testing userspace as of 2023-03-07:
>  - v6.1.12: affected.
>  - v6.2: affected.
>  - v6.3-rc1: not affected.
>=20
> A bisect between v6.2 and v6.3-rc1 led me to this patch specifically.
> Seeing how it's part of a patch series, and how previous patches are
> preliminary ones, I've checked that cherry-picking the first 6 patches
> on top of v6.1.15 indeed fixes the problem there too, and it does
> (git cherry-pick v6.2-rc4..601363cc08da25747feb87c55573dd54de91d66a).

That's good to hear, thanks for reporting.

> With the following systems:
>  - Pi 4 B, using external storage (SD card),
>  - CM4 Lite on CM4 IO Board, using external storage (SD card),
>  - CM4 on CM4 IO Board, using internal storage (eMMC),
>=20
> I've been able to verify that v6.1.12 (baseline in Debian testing)
> triggers this MMC timeout issue, while v6.1.15 + the aforementioned
> range of cherry-picked commits no longer triggers this issue.
>=20
> (Methodology: cold boot then reboot 20 times, monitoring via serial
> console to keep HDMI output of the equation; affected systems stop
> booting after 1-4 boots; unaffected systems boot and reboot just fine
> all the time.)
>=20
>=20
> This looks like a critical bugfix for Raspberry Pi users.
>=20
> Seeing the stable@ mention is about 4.8, I suppose this is going to be
> considered for a wide range of kernels already=E2=80=A6 but I'm happy to =
dig
> into this further to pinpoint when the regression appeared, if that's
> helpful.

I took a quick look at the rpi-4 devicetree and it looks like the emmc
indeed is sharing an irq line with another device which should make is
susceptible to the mapping race.

The corresponding drivers also use asynchronous probing since commits

	7320915c8861 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed=
 in v4.14")
	21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for drivers that existed=
 in v4.4"

that went into 5.10. So the issue should have been there for longer but
perhaps only manifested itself around 5.17 due to changes in timing.

Johan

--1pYx6IuXSbcDEQEb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQQHbPq+cpGvN/peuzMLxc3C7H1lCAUCZAmLeAAKCRALxc3C7H1l
CG9UAP9ztoxOSXxHCUZXg63cjsFhvy7S6lrLVZ5RvHvjmjv2CwD/XUbPSo+2Fd5H
Z4bA7fuXNrGMT4z40fDurbv+sBWmogw=
=aPds
-----END PGP SIGNATURE-----

--1pYx6IuXSbcDEQEb--
