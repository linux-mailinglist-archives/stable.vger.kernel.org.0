Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0C952A2A7
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 15:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbiEQNFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 09:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346935AbiEQNFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 09:05:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897982C6
        for <stable@vger.kernel.org>; Tue, 17 May 2022 06:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8B1B8187F
        for <stable@vger.kernel.org>; Tue, 17 May 2022 13:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC857C34117;
        Tue, 17 May 2022 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652792686;
        bh=UPUs81sl8LnFQHTF+ddHSkDaGXS+O0BBmVFMU13CG5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Su0vNwY0LlWL0zMYdtXtfV6wS/SDWfXHHu0LwgxjCvoDgc/NF2BWNZaJ12wz9hiQJ
         bGxvtQwrl8hN6eRwcd8KOLkumoafyWTPkkwSsiwXi6uw6ukZDnZ92oAQDSWH087IZ1
         iWhokE4PXjMsORHjlA2BXs9i7RZYNBKYEg6ljOTbcHioXzCR4gljW7N+T8XpEg0T2x
         EXYf1yrvT2SyOkYT2OVjgOFB9sLvmrgTUGD8xq2HgSBWOOWA6r+fLMp3UWaWA8ATlI
         ILvV/kY6MnopDdECZGcP3ntgp4v1Tbm7J7EvbPSMzZhKnDipngK8hW6CmUP/8Zr8ah
         b5YWVRNxk/AAg==
Date:   Tue, 17 May 2022 14:04:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Tan Nayir <tannayir@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Message-ID: <YoOdauC5Q8POpHLe@sirena.org.uk>
References: <c2163c71-2f71-9011-3966-baeab8e8dc8f@gmail.com>
 <20220517011201.23530-1-tannayir@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vsNkSZC5zTfVWt3z"
Content-Disposition: inline
In-Reply-To: <20220517011201.23530-1-tannayir@gmail.com>
X-Cookie: Fats Loves Madelyn.
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vsNkSZC5zTfVWt3z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 17, 2022 at 04:12:04AM +0300, Tan Nayir wrote:

> The $val in both functions has a range between 0 and an arbitrary limit
> whereas the range specified with the $min and $max can start
> from a negative number. To do the out of bound check correctly, the
> $val must be added the $min offset.

>  	val = ucontrol->value.integer.value[0];
> -	if (mc->platform_max && val > mc->platform_max)
> +	if (mc->platform_max && ((int)val + min) > mc->platform_max)

No, the minimum value we expose to userspace is always scaled so that
userspace sees a range starting from zero and that's where platform_max
is referenced to - we're applying this limit before we start remapping
to actual register values.  The code would be a lot simpler if we didn't
do this rescaling.

Please don't send new patches in reply to old patches or serieses, this
makes it harder for both people and tools to understand what is going
on - it can bury things in mailboxes and make it difficult to keep track
of what current patches are, both for the new patches and the old ones.

--vsNkSZC5zTfVWt3z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKDnWkACgkQJNaLcl1U
h9BWjQf9FV2GSK8eu0451gypoqtGdAfYTGMGEYRV2aewgHbvYWXeSTbAT9c1OHtI
kLZi/TsAqD6Uf3aej22UlqXPx2mIMmqmzZ7fR4D306YN3GGXTBme1XanijtMPKM8
p2GTqXhu6SOyW100X9QHyMjj9JlJIxaczUozsxDJGd/feWo1l7nX14mG+ZT8aT3d
aDNdZfpdZUFDOMiXK5pU6ESIOuDmZVIAvOnvAdZpmhLIm3gLlh4xr1YcULfz0zSl
dW8V48BIxf3fXc/SrpChTP72H33IICrqFOrg/SbWQ2q8rwYb1m61xkmlIEdLth8c
Htj0ChFk+xqzylvQAO5+cbIFSBfrcA==
=p/6+
-----END PGP SIGNATURE-----

--vsNkSZC5zTfVWt3z--
