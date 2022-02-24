Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE754C339E
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 18:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiBXR2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 12:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiBXR1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 12:27:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1443A14CC93;
        Thu, 24 Feb 2022 09:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C83EDB827F8;
        Thu, 24 Feb 2022 17:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C1C340E9;
        Thu, 24 Feb 2022 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645723620;
        bh=qCpxIPkZrPYm3MRUETUhcfW4faQsayzUe443tI29gZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WnGhCRLd8t9bKXokSUyN7vu/rS4sMRo3OjkMPiGKRxd94Bv+krIhaRp4pY8s3t8Wv
         QlYtp3yXcR/oYhxV6p6kX/QYQrNMkUrIsKa9isyu1y78T475R6sW5u68I+6BlLGg8j
         2ZnHcFOfZs9Fc7RXGQfUuQlBBenj0OXL77yltANwHw9mBKZVSlwD77R+YyPAZhGp1Q
         EXfwMkc5zfvKSa/Nof2eWmmFPhmqmNuogJ8MFxhgl/Scmk7+bKXjfTMggoEYeksMDR
         /F1sRsVapIqxee+PIWja3SqW7IWep99CGha/TrjgD4X4rDTbAIqCvc/lUF6Slt8IPG
         7itTNySzn9VUA==
Date:   Thu, 24 Feb 2022 17:26:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Message-ID: <Yhe/3rELNfFOdU4L@sirena.org.uk>
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P1GVxpuNWL6fQTf7"
Content-Disposition: inline
In-Reply-To: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
X-Cookie: I smell a wumpus.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--P1GVxpuNWL6fQTf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2022 at 09:51:24PM +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>=20
> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
> -ENOMEM because it leads to a NULL pointer dereference bug.
>=20
> The dmesg says:
>=20
>   <6>[109482.497835][T138537] usb 1-2: Manufacturer: SIGMACHIP
>   <6>[109482.502506][T138537] input: SIGMACHIP USB Keyboard as /devices/p=
ci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:1C4F:0002.000D/input/input34
>   <6>[109482.558976][T138537] hid-generic 0003:1C4F:0002.000D: input,hidr=
aw1: USB HID v1.10 Keyboard [SIGMACHIP USB Keyboard] on usb-0000:00:14.0-2/=
input0
>   <6>[109482.561653][T138537] input: SIGMACHIP USB Keyboard Consumer Cont=
rol as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:1C4F:0002.000=
E/input/input35

Please think hard before including complete backtraces in upstream
reports, they are very large and contain almost no useful information
relative to their size so often obscure the relevant content in your
message. If part of the backtrace is usefully illustrative (it often is
for search engines if nothing else) then it's usually better to pull out
the relevant sections.

--P1GVxpuNWL6fQTf7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIXv90ACgkQJNaLcl1U
h9DGNggAglmdN2ru7N2IfI7rxiJiO0A5rEtjeaQiUAWknIbQnz1voUjRkigNNdGY
6zRoxcOr1bqgbD5x5fLFhmsYfXpGjrCWXMTEZS+0gZdnwdhDPMbmUrzA2N2/K3Bv
+pfDNojNUKogEyIYcOv0us5bTxHFSm1OWFfFVyxhWHZz+L6MPQ2BfQiRGeh9fA4X
b2JhqifhWnbijUOAizyCtfhiaVk2O4ZOyoldhtkDiRdx6eM49ADyaEv+Kq2rnCkZ
MqOt4Oz4EKAdmCoAIv2m8/Vb8V2p9J2J91N8SVG/GUxM7zZ03kp2vbbLXyWNfb1u
foJsHidMgWYzQAWqIFvYLuIb7xZ0Qg==
=oFvq
-----END PGP SIGNATURE-----

--P1GVxpuNWL6fQTf7--
