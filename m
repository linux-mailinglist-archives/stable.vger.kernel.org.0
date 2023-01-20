Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CCF674ED2
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 09:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjATIAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 03:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjATIAN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 03:00:13 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B0E7E6BA
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 00:00:08 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p189so2140919iod.0
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 00:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vkROn0Vntl7nBa8S7Q6mJrtEOMySGP7JTtcpxEojjK4=;
        b=H6dV66orHJFVtlQ9NoYGyz+uFTNkVusCuv1/Kks4T2m8/PBSy4iAbbMPGDcz6dg2qA
         TV7me1h8S41/vV9EJhcGfZdchehYAUNKcVHC+nUK62p8Yk+2BG0CjKluocsSO6J3Mhrj
         qZgRndf/52pxJq6HqJZgFF0GHiFUkzQClNY/vSeeHjuMxSgU6TB5uPGkIiYMi+sX1H3X
         04j3xrV2K5riv8s+4PYDLDkpfOzAMa7IW2PsslER8vlr5CClpN1mZRLbD9v591pryICX
         RvV9uEl/oeSOR4yeOI8gRyAkgJWa7LQZ8HpzvcpVMMKOFc3NE7rOAhLJx4+YUnDgrg81
         zsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkROn0Vntl7nBa8S7Q6mJrtEOMySGP7JTtcpxEojjK4=;
        b=FXl4NKj1jtlGCG9XHo7zwul6A6ORi/Hrtqj9eHxMfxbvIRFfA+JZwQTF5AvOdNOARg
         dTPcMeHlk25jjpkHp/JjCZJlXWWU0LHw5w1XA4hCzgKk9UOvaIZHbe5Hrir/NNcBQPDe
         yAAhQzA9BFzcwnWBx5Y5oISk8rOMfVTHaIX2zXf+j2zwk54FwnUDw8204N50kHgWSO6L
         hputIAOAPyW4pKFfZZalYSiqeUlW6Gu81npN+T//vM0IcwwSX3N5oYnrpAFqDdjjwqQb
         NU65HGlI94zpU7f4QI1uU1cynbd4QxT4KboWBa9AY3m42xuCDInUikXHjNZZF0/5wW8J
         ew3Q==
X-Gm-Message-State: AFqh2kovhvbyrgK6cYPV/0+SykP+v4/npP58NqgAeEDkX+3qUdeID2O2
        04O9yIPdbTHfKRPlMGKurAzCoZDlK8I=
X-Google-Smtp-Source: AMrXdXs6mtN2O4H/rimU8SBMW/Vf2oM3ILvi1brkeXvcWJ6uHef6bFnbLde1egPyMuP1G0kGnRTmZg==
X-Received: by 2002:a05:6602:1850:b0:6e3:fbde:b48d with SMTP id d16-20020a056602185000b006e3fbdeb48dmr9894461ioi.20.1674201608061;
        Fri, 20 Jan 2023 00:00:08 -0800 (PST)
Received: from pek-khao-d2 (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id t19-20020a056602141300b006e01740c3b6sm13160649iov.2.2023.01.20.00.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 00:00:07 -0800 (PST)
Date:   Fri, 20 Jan 2023 16:00:02 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <Y8pKApXOhnU2Ucle@pek-khao-d2>
References: <20230120042650.3722921-1-haokexin@gmail.com>
 <Y8o3BIHcGt6FIKmY@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rSBee4R39wgigRG4"
Content-Disposition: inline
In-Reply-To: <Y8o3BIHcGt6FIKmY@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rSBee4R39wgigRG4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2023 at 07:39:00AM +0100, Greg Kroah-Hartman wrote:
>=20
> That is because that is NOT how you mark commits for stable backports.
> Please see:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.

I see where the problem is and will make sure to do it right next time. Tha=
nks Greg.

Thanks,
Kevin

--rSBee4R39wgigRG4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmPKSgIACgkQk1jtMN6u
sXGHcggAts2cIOn3hHbgpwpuM3FSlNVJWqR2CQfP1Z0k4Y7OIXUAo3RO3NRRNj15
dA//pnUg284xvn4T4cirJH/7J01H5deGhWuhAdJFSa/D7rbyS6zFzgJ/9wKqiXWL
1m37Hxg6/Wp2o5e0Tz6PNwdKQO5cCZoPlJevg+WSaKnBq97wGNJKANIbOjS0Z66d
uZYOEtMIIqjaLxmub5vtFDM80jjyB7b/PEpqsjsJK03O+rmZEDrtTJQlWTaJ5tKD
tKIy4UatKKgXykuZexpOCKHAVsSXBuZ+LU4ik39f0zxJWL5FJMHiOXHf2457mmkj
n5/W6NZcSbP6xljD5+kznJS0A7xgWg==
=H5yt
-----END PGP SIGNATURE-----

--rSBee4R39wgigRG4--
