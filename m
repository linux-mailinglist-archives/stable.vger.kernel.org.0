Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349506E156A
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 21:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjDMTvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 15:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMTvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 15:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAEF271E;
        Thu, 13 Apr 2023 12:51:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE0A3615B7;
        Thu, 13 Apr 2023 19:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251F8C433EF;
        Thu, 13 Apr 2023 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681415488;
        bh=VD3AH8/BOXPv2IMvKmDKEehX7IswoAmODYA+TR627Jo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCtYT890v2FRNOna+n2kFlQUZGsy0rBa70/M8Fi0623Yy6A8HCCzDldPFgV/ej/xA
         F1YzJ+Iq1TUbxiDFT+wAZQYKhXSeSDYdq3tkrl+fimUZ0kTr5BryN3l884PPyUGjwt
         X8cOefnM3db3riLehwMJJ6vV4E/KLhNRL6ikaUoN4tIK/Vdqp/PBwp+6oDrHRc4e/C
         B/1+1g8M3Z7pWFX4iIjYdKgmVfCM+bMU5z5/iQ5Nu5SPF4CkzTzP1JEpTG1CpKb/Ws
         GGc3M/KZegRLpXQBISjk4gvp1tRkumWNf7zu5pxa2YVlro/J3OSz5us5R5z+FfF6fz
         CS5IjwjBxtgUQ==
Date:   Thu, 13 Apr 2023 21:51:25 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Benjamin Bara <bbara93@gmail.com>
Cc:     Lee Jones <lee@kernel.org>, rafael.j.wysocki@intel.com,
        dmitry.osipenko@collabora.com, peterz@infradead.org,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] i2c: core: run atomic i2c xfer when !preemptible
Message-ID: <ZDhdPbcHFaR+2dhR@sai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Benjamin Bara <bbara93@gmail.com>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com, dmitry.osipenko@collabora.com,
        peterz@infradead.org, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>, stable@vger.kernel.org
References: <20230327-tegra-pmic-reboot-v4-0-b24af219fb47@skidata.com>
 <20230327-tegra-pmic-reboot-v4-2-b24af219fb47@skidata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+d+oo9lOK+g04O7i"
Content-Disposition: inline
In-Reply-To: <20230327-tegra-pmic-reboot-v4-2-b24af219fb47@skidata.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+d+oo9lOK+g04O7i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2023 at 09:46:40AM +0200, Benjamin Bara wrote:
> From: Benjamin Bara <benjamin.bara@skidata.com>
>=20
> Since bae1d3a05a8b, i2c transfers are non-atomic if preemption is
> disabled. However, non-atomic i2c transfers require preemption (e.g. in
> wait_for_completion() while waiting for the DMA).
>=20
> panic() calls preempt_disable_notrace() before calling
> emergency_restart(). Therefore, if an i2c device is used for the
> restart, the xfer should be atomic. This avoids warnings like:
>=20
> [   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu=
_note_context_switch+0x33c/0x6b0
> [   12.676926] Voluntary context switch within RCU read-side critical sec=
tion!
> ...
> [   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x=
114
> [   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completio=
n+0x40/0x70
> ...
> [   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
> [   13.001050]  machine_restart from panic+0x2a8/0x32c
>=20
> Use !preemptible() instead, which is basically the same check as
> pre-v5.2.
>=20
> Fixes: bae1d3a05a8b ("i2c: core: remove use of in_atomic()")
> Cc: stable@vger.kernel.org # v5.2+
> Suggested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>

So, with Peter's input and me checking again:

Acked-by: Wolfram Sang <wsa@kernel.org>

I assume this shall go in via the mfd-tree. Let me know if I should pick
it instead.


--+d+oo9lOK+g04O7i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQ4XT0ACgkQFA3kzBSg
KbbAJA//f+xXOS04L16X+BQ/HPdV9h08kJltv/KDQ7sfvNd+ALOJslAZbEdgNVKH
zj96ZFX4u75ZdDH6YiImSGUfXqWoseKZiK4ZvkPaKabsG8uv/uHZIJdYG6qXpD7Q
b0sg6z6TgvpVSAp0l4n0FgeNQE2KVCZ5WAcjFQx46vcXufyvyycZPUU0Ht37ufZL
x0kCd04YeX+wnRUp9nH9JNI4frjnR/uqwfTM4MCdnyrX1WXk70J6AMQ/C5UuKfGe
EYsWRs6cTUyo7vMqLEImkb4XXTZMJqCl+dmC1oP2w8w+Lvm9P7RcwuI0Q1yuKKp/
1fypvphtyrsqnIzaox57pMgE6Fzh8qVSaC0ZMZWX1fje9PWwFhnBX79RBx6V3OIA
4NKWEtyB2KeCtEPeimh2d2ZUKg4VHjKuT4gHafLx417s7qjRe2jYLg8VM81rgukC
Qe36LnTryBcGq7TBBGCVZehnwtnHxiYmGJ5cZtKP+Tp4uFUxD8MN9UQDNoeLnI+L
mXxpmDptYoxPbJBBSCgvgMcnuW2LAAL9Jjtpt/xestPqgSdQhWQ03KwyrNkFztl/
h59ULzWc90RQoNG8lK++XEI3jyB5VpAfPE/axAjhUTtS3bxZ1iuGh6Vywn3b3iD/
M/JlFy5nloZAuabCFKByKf7emEp/Wc36fA0r42RkKQsL7IVSXbc=
=KAjA
-----END PGP SIGNATURE-----

--+d+oo9lOK+g04O7i--
