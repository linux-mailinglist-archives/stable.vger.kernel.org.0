Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750913DBCFA
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 18:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhG3QUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 12:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhG3QUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 12:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DE5560F3A;
        Fri, 30 Jul 2021 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627662036;
        bh=VGa6prA1nzRPbhwNcJKeBBIqmDX/7MYK01Bhpb3t+70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7oBXUB/+TuEyOeWERLFTiUFVCvas9noVX7Fh4i1NVGQztMDTKCGkqGLR4a7QsmFg
         VdkmtGw7VIoT8HllAfhaae+FnDczEoU1rCQ+7vRUm26Nc/rHp5Wb5yvnuo424ieoTd
         0mehdVexG0pxgmhSDVIPmkErFogPd4HGK8vrfBu5yPTytZ1M48fuLIPp8AgJEuofOf
         E8LUuBxzHqFkQn5zJcGeRROepbhrCftdNI32wNBRYrkBb6VXTaTQ+d1I8G36QwlGuP
         NEXo7C2Onm6Jg3BtUfmp1C1NQHf53OHfPO8Zrdf7/dYZQsmtwJrUXPORfZE2I9vPqz
         8tgkuIygdeDrg==
Date:   Fri, 30 Jul 2021 17:20:25 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] ASoC: amd: Fix reference to PCM buffer address
Message-ID: <20210730162025.GB4670@sirena.org.uk>
References: <20210728112353.6675-1-tiwai@suse.de>
 <20210728112353.6675-2-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4hVWSOEjyjyaPny9"
Content-Disposition: inline
In-Reply-To: <20210728112353.6675-2-tiwai@suse.de>
X-Cookie: Vini, vidi, Linux!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4hVWSOEjyjyaPny9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 28, 2021 at 01:23:49PM +0200, Takashi Iwai wrote:
> PCM buffers might be allocated dynamically when the buffer
> preallocation failed or a larger buffer is requested, and it's not
> guaranteed that substream->dma_buffer points to the actually used
> buffer.  The driver needs to refer to substream->runtime->dma_addr
> instead for the buffer address.

This breaks the build for me on an x86-64 allmodconfig:

/mnt/kernel/sound/soc/amd/renoir/acp3x-pdm-dma.c: In function 'acp_pdm_dma_hw_params':
/mnt/kernel/sound/soc/amd/renoir/acp3x-pdm-dma.c:245:18: error: 'runtime' undeclared (first use in this function); did you mean 'vtime'?
  rtd->dma_addr = runtime->dma_addr;
                  ^~~~~~~
                  vtime

--4hVWSOEjyjyaPny9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmEEJsgACgkQJNaLcl1U
h9D/ggf+NKw2azq43RPY9BmrkJs2AXXIxLk8D2crutNB4pWDwp3vU3+FdtgawWg/
wiO6repRQLXVvOy8RhggU97anU0EjrZQ1gMwiMcqTKjulwisnRVp1MSEJQlHFgbN
WtAcJZr6op6O2HZZa9lOSmtnQjI4dQYDN4IMk9dwz9aIubA2FYBIPY61xC7MkQ7g
EHHZC2emn3LJ2bvk4WdZMFj8SD0dUzpcAOSdrwcT6jvb8kwqFqBapZz9TgpQWaZg
o+7gSWoQB9+AaeO/KXjFMoE/UPDhH07k7rV2rYpNTuohkx3ZjnAZUw3wzikHBQY0
1eD4ZEeHP9Is9IGAx1DC/7Crzrq4jw==
=eZ+w
-----END PGP SIGNATURE-----

--4hVWSOEjyjyaPny9--
