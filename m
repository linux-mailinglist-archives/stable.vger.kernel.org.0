Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F9252B986
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 14:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiERMH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiERMHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 08:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31151BC6CD
        for <stable@vger.kernel.org>; Wed, 18 May 2022 05:07:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C18F061573
        for <stable@vger.kernel.org>; Wed, 18 May 2022 12:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28784C385AA;
        Wed, 18 May 2022 12:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875672;
        bh=J3/tR7Q+oe314sxSoPFX/GSG0Vdo8AD9s6k1muJ+ljU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cJjZHkBObVRkXwkcwhWs5fveXQL0Gcs6hJB31Q20uSJt3Qmo4uu4hHE3K5fJ6rDca
         V2JaAHOvGUfSEAbkNE/r+27qv0comKbEetagxZCQXXOJlMWPwTf1XRUTVh/My8zBoK
         8OXg/lME5acrrWyuBdOqiQzo+y2dnSbGuhuC+v8Z3RJlKsF9m3zNZCZ/yBHwIH0SuK
         axfRGd8rhYKZun5IrDygOVroIWHNnR+b////WWLXHEqTMYOfMtDa+dOYUtTmBgFwvt
         ReF549LeKDH1lGoVhxwjk8TPLjtgFxoGgHdHw/BzLcggTuulZIxaZ/RL1x0/bwlIVe
         EqUkbK7jDCERA==
Date:   Wed, 18 May 2022 13:07:47 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Tan =?utf-8?B?TmF5xLFy?= <tannayir@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Message-ID: <YoThkxU9Q2cDrq4v@sirena.org.uk>
References: <fde0dc8a-a861-3c8e-1316-cfa81affc19e@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TLTzlqRTLGHvHfuN"
Content-Disposition: inline
In-Reply-To: <fde0dc8a-a861-3c8e-1316-cfa81affc19e@gmail.com>
X-Cookie: Alaska:
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TLTzlqRTLGHvHfuN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2022 at 10:58:40PM +0300, Tan Nay=C4=B1r wrote:

> The commit message in your fix states this:
> > For _sx controls the semantics of the max field is not the usual one, m=
ax
> > is the number of steps rather than the maximum value. This means that o=
ur
> > check in snd_soc_put_volsw_sx() needs to just check against the maximum
> > value.

> For some reason, this is not the case on my end.
> Both the $platform_max and $max fields are set to the maximum value
> of the range that is specified inside the codec code which is -84 to 40
> and not the number of steps.
> This was also the reason behind my patch to the bounds check.

If you look at snd_soc_info_volsw_sx() you can see the code reporting
the range to userspace - you can see the range reported to userspace
there, note that the minimum value reported is unconditionally set to 0.
This is also visible through the API.  What exactly is reported through
the API on your system, and what value is being written?

--TLTzlqRTLGHvHfuN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKE4ZMACgkQJNaLcl1U
h9DU0gf/XqJbrB+FYxPpYOds/aWdFPKoyOIllMLSlTedGqDSRVyxbbvf8cObG2lw
mXfBe3Ut/n6h8KkgwqH9MxrSFWIPwoVuvCVcBdcQt/T24Tq1PLSKIVpltHJrq4UR
+RNdNEpDrj7G6hxHoBYODI2L8mxObTeDGc9PwoEnBo7r2EHm/MwpEx+Y4C7/IQAr
qU7rQVF0V8tlWgkUL+zYmMuCOcEotDUvw0FBOYAVOUwsl7kU5AP8LXmcYXz9lBv6
2tOMSUHF+drmKNES3Eu+nq+80idSzbnqeo/EVwsHOlXBozPo8un2ORafcByXCmPj
cHarzXRNihI25kgyXNeiVPNip7r2Qg==
=nta/
-----END PGP SIGNATURE-----

--TLTzlqRTLGHvHfuN--
