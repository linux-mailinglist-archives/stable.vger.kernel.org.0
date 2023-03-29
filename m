Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093276CF3B4
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 21:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjC2Tvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 15:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjC2Tvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 15:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609947DA0;
        Wed, 29 Mar 2023 12:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A97B82435;
        Wed, 29 Mar 2023 19:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A242C433D2;
        Wed, 29 Mar 2023 19:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680119445;
        bh=DdQ/InU+JW6FxMcEa544An9vo1GjuN7pFdS9qPTwzR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FBi6j/qw9eZ7S+XE7GyglFFe6nIcEepVGw/DOcSKnd/j6Eb3QlyQfhm366ogCr3qH
         lYYkW+fqmZskhWF23oz88zeyfcXxvMECpRZI7H1w6HCyVu/uy+ZfeQletZYWD44Fol
         shTvFUmhzCoHQfD0bjlXxZVwWhVJJBWPHRBCSFH/5lIVlpt5NzaEzsqdVOZrF2E614
         1Qn11Ot6C1/KDBrSVTqLu07QFFa7KjVVM4kMUvgZIt++hX+lqrFSZYFiyhVfUgNNfD
         efRwFGaND95MyeCelC4PyYTjsbka4+J+SGj4ayMKgROGEKMi3EFs4rq/Onk7QDvpKh
         vpET/yHmUU+wQ==
Date:   Wed, 29 Mar 2023 21:50:42 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Benjamin Bara <bbara93@gmail.com>
Cc:     Lee Jones <lee@kernel.org>, rafael.j.wysocki@intel.com,
        dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] i2c: core: run atomic i2c xfer when !preemptible
Message-ID: <ZCSWkhyQjnzByDoR@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Benjamin Bara <bbara93@gmail.com>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com, dmitry.osipenko@collabora.com,
        jonathanh@nvidia.com, richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>, stable@vger.kernel.org
References: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
 <20230327-tegra-pmic-reboot-v3-2-3c0ee3567e14@skidata.com>
 <ZCGuMzmS0Lz5WX2/@ninjato>
 <CAJpcXm6bt100442y8ajz7kR0nF3Gm9PVVwo3EKVBDC4Pmd-7Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VVeP+HbfnOeUVDlq"
Content-Disposition: inline
In-Reply-To: <CAJpcXm6bt100442y8ajz7kR0nF3Gm9PVVwo3EKVBDC4Pmd-7Ag@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VVeP+HbfnOeUVDlq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27, 2023 at 06:23:24PM +0200, Benjamin Bara wrote:
> On Mon, 27 Mar 2023 at 16:54, Wolfram Sang <wsa@kernel.org> wrote:
> > For the !CONFIG_PREEMPT_COUNT case, preemptible() is defined 0. So,
> > don't we lose the irqs_disabled() check in that case?
>=20
> Thanks for the feedback!
> PREEMPT_COUNT is selected by PREEMPTION, so I guess in the case of
> !PREEMPT_COUNT,
> we should be atomic (anyways)?

Could you make sure please? Asking Peter Zijlstra might be a good idea.
He helped me with the current implementation.


--VVeP+HbfnOeUVDlq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQklpIACgkQFA3kzBSg
KbYNNA/+Lc8HqdBhMVtjtKZDd3Km+SqobG8vzuo0octKy5b3E6mK3/y6ZdGssoBs
EBZ30DQ1H3dBfNsLFz4Ydy2Dir2SLgcxBKT3IPp6bTzjheXumCjCMTa65N8jmBX2
zX2eu9mVBv5XZAZ1pVzeZVK9EVUU2u/stFuknIg8Cmk+jEgaNCxkKsCnPbnL2l/a
lKzps+mfNQWI+Tda5XdBPmLP0gtcHvqQpAJ2SRvDwtf03w+YLY4dJ2jN6IhuwSGO
fisy58cwOPwgen46mk3BLPoEftAw9Ss7smkGmQOb8QY6ZWBo1d2KaxOnaY325kI7
oGqqtJP1lWinThlqmEhNfUnqJpDrSySgisyT1NKJ6b60Wr0u9BbM8rkfclpnnzyY
QGZW7lfL4EFzKKbMq1GQiMCDn3tN9nR35W9KtqXPM7i3urOHKWQ3/3dFjcv69Tuk
QU79XKhnrzEhb43YAhzpfYb8QMB4YdahH78/PhDrwTsfZodqN5yNJeAvx70XiCYp
3J9jrzmwKquFhz/too/2CLjsiJHie9tcwQZthiV/9+NsulXGg4E0Kv9XKKINB4+e
condSDcIwRbw0c0T5V5GSHILnNptQywbPoU8npgThFQGsJX4dluRv9+SD4K4hwsf
qOPVXjiwt+UIZPyz3qW0dHp+dD4TgwmyuH3rl7HAZyk4Csiu/Vw=
=JbH5
-----END PGP SIGNATURE-----

--VVeP+HbfnOeUVDlq--
