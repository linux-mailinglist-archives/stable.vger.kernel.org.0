Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAF52D92A
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 17:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbiESPuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 11:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241470AbiESPuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 11:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C5C98594
        for <stable@vger.kernel.org>; Thu, 19 May 2022 08:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CEDD61C15
        for <stable@vger.kernel.org>; Thu, 19 May 2022 15:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFDEC34113;
        Thu, 19 May 2022 15:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652975282;
        bh=dc2x7Fl07K42fV9l0A7KIo576nGWt2FICQLI1JJWCCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAfFPiUHAmJKOfkCF2wspMU4fHZ5ohRLrb5ElL//IFd1DLosUQBVmJSEqVp5P0PJG
         p9KwMbYN6AjgqaK4yg8JoDUxf+gSUh5UTRJcXIYiflRmFrQYYlEWEsfPZ7Sbr2DMcm
         Yr7BkxkwkiINKRYbEEvi6bSljGJjAdL5ql+ANPNedtTO6xY8gLUhwhREsuKYdoA8iu
         hYBdsV/UpgxbOjqXJErQ1WzRiYWwd6F8ymKF8naUlwl9KrCPeKSp3a2LwSZSBYGjv0
         YuXPtdC0ksSP3GQB9pbnyB+12GpoEwB/Pxgc0399HYaxDzUh6/E+M50TjTMo0ptVaB
         IRR3FtU6rYRrQ==
Date:   Thu, 19 May 2022 16:47:58 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Tan =?utf-8?B?TmF5xLFy?= <tannayir@gmail.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] ASoC: ops: Fix the bounds checking in
 snd_soc_put_volsw_sx and snd_soc_put_xr_sx
Message-ID: <YoZmrhYJPu8Gy/sb@sirena.org.uk>
References: <fde0dc8a-a861-3c8e-1316-cfa81affc19e@gmail.com>
 <YoThkxU9Q2cDrq4v@sirena.org.uk>
 <5a0e9339-5bdc-3e05-08f4-9137ebeb5ce5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GU+gfGMqKvoMOtu/"
Content-Disposition: inline
In-Reply-To: <5a0e9339-5bdc-3e05-08f4-9137ebeb5ce5@gmail.com>
X-Cookie: Some restrictions may apply.
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GU+gfGMqKvoMOtu/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 19, 2022 at 02:56:34AM +0300, Tan Nay=C4=B1r wrote:
> For a control defined like this:
> -- SOC_SINGLE_S8_TLV("IIR0 INP0 Volume",
> WCD934X_CDC_SIDETONE_IIR0_IIR_GAIN_B1_CTL, -84, 40, digital_gain) --
> This is what the snd_soc_info_volsw_sx reports:
> $mc->platform_max:40, $mc->max:40, $mc->min:-84,
> $uinfo->value.integer.max:40, $uinfo->value.integer.min:0

OK, so anything setting a value outside of 0..40 was buggy.  Note that
we've not changed the info() code at all here, snd_soc_info_volsw()
subtracts min and then snd_soc_volsw_sx() adds it back on so what we end
up with is whatever max was set to reported as the maximum to userspace,
with the userpace minimum hard coded to zero meaning the range the
control has is 0..max.

> So the min and max fields inside the $mc are the same in snd_soc_put_vols=
w_sx
> so this means that the code without my patch has an incorrect check.

The check is enforcing the constraint we advertised to userspace, which
should be all that any well written userpace application has accessed
(though I appreciate that due to lack of bounds checking in the ALSA
core it's been possible to do so).

> Is the $mc->platform_max supposed to be set to the number of steps
> as opposed to the maximum value?

It is hard to understand why one would set platform_max in the above
situation other than to limit to -44, however there *is* a lot of
confusion in the code since in the generic function it gets substituted
in like a register value.

> Also the snd_soc_put_volsw_sx still checks the value from userspace
> which has a range of 0 to 124 against the maximum of the signed range
> which is from -84 to 40 regardless of the patches below.

> 65c7d020fbee8 ("ASoC: Update the Max value of integer controls.")
> https://git.codelinaro.org/clo/la/kernel/msm-4.9/-/commit/65c7d020fbee807=
0f33072291c32eef7584a56d4

That looks confused since it makes the interpretation of platform_max
depend on if the control has a negative bottom for the range which isn't
going to help with maintainability...

> 0d873de90eb16 ("ASoC: sound: soc: fix incorrect max value")
> https://git.codelinaro.org/clo/la/kernel/msm-4.9/-/commit/0d873de90eb16e3=
af499eb87da1ed14440b788d5

=2E..which I guess is why that bit of the change is reverted in this
commit, though that then has two different interpretations of
platform_max depending on if the control is an integer control for some
reason I can't fathom.  These two would need to be squashed together for
upstreaming, but note that these controls were added by and are used by
non-Qualcomm people (see 34198710f55b5 ASoC: Add info callback for
SX_TLV controls), and note the comment in there about the max being set
to the number of levels rather than a value, so I'm concerned about
other users here, the code doesn't look as self consistent as it should
be.

I think these controls need a separate, clearly written, info() callback
rather than trying to bodge on the side of the main one.  That would
help a lot with working out if the put() is consistent with it.  We
probably also need an audit of all the existing users to try to figure
out what they think they're doing and what, if anything, it's consistent
with.  Your patch is clearly not consistent with the info() callback as
it stands if nothing else.

--GU+gfGMqKvoMOtu/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKGZq0ACgkQJNaLcl1U
h9CtKgf8C4rURwEk/xo0IsuefLFqn44IhlUuVmm2IWzZP0gSIuzFr4T6PqLcLQ2W
aaO/lVChnrKGSZsiZswZ7uYniJT7Ahxq+W/y+PVlPTXF68t95/zVUfW21FkecB09
2F6/dSQ6bi1iUl2xgwKjv1UK+sl7fAg162fgqk6ihqSxECsI5yphIKWu7cOe3GF3
1ND8KBJppKW+6Qo5mmTy2rYght3MbyWNiqjNpjudq7LL8rI3/3gRPR9IDVtKTS+L
GCgn5fDGkZNqZWj/YYlpW6E2tRFNKoEq7m2QkWcX9HhReT2E5Gj0DwxePocBTu6q
eG3Yutc/lOwby16Kw9UEXzVqOoTNiA==
=VJmt
-----END PGP SIGNATURE-----

--GU+gfGMqKvoMOtu/--
