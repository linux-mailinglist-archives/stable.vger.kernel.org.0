Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46A84C3466
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 19:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiBXSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 13:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBXSPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 13:15:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB283253146;
        Thu, 24 Feb 2022 10:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58C3960C77;
        Thu, 24 Feb 2022 18:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A536EC340E9;
        Thu, 24 Feb 2022 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645726479;
        bh=0tnbQuuR1loseTOVkHNgK1i4o0rJpGHkKLedHU7WA3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O6+zhvkgE5SOGjZqosBUShYmmK30Kv6oXuH+8frrX8X8SvMchdAWwel+ZJEOfQ6lc
         4m7g+jj+9gYoGKlZXTCNqUPpks/kYKqgaMSVzQLkptK0mxifR8qRFJk5jJNwElBSmS
         KDUswDo8SYFm+etrVflVgBDCgavsDlBO10GkTkCLVfK1l8zJ6QUhCsQ44oUUDne2Y7
         s3Mf548/EFjLhJl72LEWzsQx8Y7pdB0/Tq1AzLAIAlGntQZailpzkDPcKvc70Iv3Me
         QvCJhh3xebooqo+2anPzZfcZFRzYDwZPduXv6jgWqLJJZsEPsRCBlORJWwl6+oaMRo
         F+I9sZzzF4niw==
Date:   Thu, 24 Feb 2022 18:14:33 +0000
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
Subject: Re: [PATCH v2] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Message-ID: <YhfLCWm0Ms3E+j4z@sirena.org.uk>
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
 <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
 <Yhe/3rELNfFOdU4L@sirena.org.uk>
 <04e79b9c-ccb1-119a-c2e2-34c8ca336215@linux.intel.com>
 <20220224180850.34592-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zl5egPN1PrqPYZ2+"
Content-Disposition: inline
In-Reply-To: <20220224180850.34592-1-ammarfaizi2@gnuweeb.org>
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


--zl5egPN1PrqPYZ2+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 25, 2022 at 01:08:50AM +0700, Ammar Faizi wrote:

> The dmesg says:
>=20
>   [ T1387] sof-audio-pci-intel-tgl 0000:00:1f.3: error: memory alloc fail=
ed: -12
>   [ T1387] BUG: kernel NULL pointer dereference, address: 0000000000000000
>   [ T1387] #PF: supervisor read access in kernel mode
>   [ T1387] #PF: error_code(0x0000) - not-present page
>   [ T1387] PGD 0 P4D 0
>   [ T1387] Oops: 0000 [#1] PREEMPT SMP NOPTI

This is still an enormous and not super useful section of backtrace, at
a glance the backtrace is longer than the rest of the commit :(

--zl5egPN1PrqPYZ2+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIXywgACgkQJNaLcl1U
h9D27QgAg7b99eY8qB9SbE2FGqEhJaR6N+rx0g1pg3KcyvVd85xyV0mqBabwfvvS
9qNMyjpcHMpMlUWKNPtSAL7PcAmQcM2GJGD8TJRYgM9LcQHwEDcNABIu1nJIa2oD
zls9hFti82GjNEaZZ5OTWLLfSAUvSCKHWtvtsQSAwAuZszqoYt5fgrKQvQDneWiG
ybi3FB4/bp4msSyaqvoWtxVEaeiChIAerim9/umCqpP5xgfRbm5hjrVdBoHDVgTl
ZK5SiLFxNEB3XZK4pqiHXqeHoryeLadPEZdabsdCmSjWLXPYQ08mtcUtctyF7q7d
fPJlv7rZ+PWPWlibnrkfBRbK0bMDGQ==
=Q3Zo
-----END PGP SIGNATURE-----

--zl5egPN1PrqPYZ2+--
