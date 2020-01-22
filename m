Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510D8145D11
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 21:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAVUZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 15:25:33 -0500
Received: from foss.arm.com ([217.140.110.172]:60376 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVUZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 15:25:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BBC031B;
        Wed, 22 Jan 2020 12:25:32 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07C7E3F52E;
        Wed, 22 Jan 2020 12:25:31 -0800 (PST)
Date:   Wed, 22 Jan 2020 20:25:30 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Jaroslav Kysela <perex@perex.cz>,
        ALSA development <alsa-devel@alsa-project.org>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: topology: fix
 soc_tplg_fe_link_create() - link->dobj initialization order
Message-ID: <20200122202530.GG3833@sirena.org.uk>
References: <20200122190752.3081016-1-perex@perex.cz>
 <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
Content-Disposition: inline
In-Reply-To: <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
X-Cookie: Sorry.  Nice try.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 22, 2020 at 01:28:57PM -0600, Pierre-Louis Bossart wrote:
> On 1/22/20 1:07 PM, Jaroslav Kysela wrote:

> > The code which checks the return value for snd_soc_add_dai_link() call
> > in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
> > link->dobj members initialization.

> > While it does not affect the latest kernels, the old soc-core.c code
> > in the stable kernels is affected. The snd_soc_add_dai_link() function uses
> > the link->dobj.type member to check, if the link structure is valid.

> > Reorder the link->dobj initialization to make things work again.
> > It's harmless for the recent code (and the structure should be properly
> > initialized before other calls anyway).

> > The problem is in stable linux-5.4.y since version 5.4.11 when the
> > upstream commit 76d270364932 was applied.

> I am not following. Is this a fix for linux-5.4-y only, or is it needed on
> Mark's tree? In the latter case, what is broken? We've been using Mark's
> tree without issues, wondering what we missed?

He's saying it's a fix for stable but it's just a cleanup and robustness
improvement in current kernels - when the patch 76d270364932 (ASoC:
topology: Check return value for snd_soc_add_dai_link()) was backported
by the bot the bot missed some other context which triggered bugs.

Copying in Sasha and Greg for stable (not sure if the list works by
itself).

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl4or7kACgkQJNaLcl1U
h9AlFAf9GdHLtyqqHm/oAX8vYaBlzhtllzk3dKrVF51LCH5SfT4IjLbjo98Jwqry
DfJAww08q99muDghi/G0ZXEx9xDszoCztyW4qp7CHK0P059Y4GEGzP9N1Dvb1BfD
RQsnabaekuh0AD0TykUIvwG/a/NCAWLSRc033WL/iGFlQ46BOnXD2QwcaCI9KY3l
OBX3eXh692YUqFVuOuoA8udZGi0fTQyrHpzc6YmOsDpvxwenm7wh6R28UH7Pi4YR
r4ALhsV6opuUZXIzIbnNHne6Q7k2NfxGgWlaax+gaZpOoZs+vKMFRnm5E1hi8j4a
6ENoV1eW/T1irjGFmygmDVN6/VAS6g==
=aOM6
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
