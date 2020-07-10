Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF41421B37E
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGJKvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:51:47 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:10090 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgGJKvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:51:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594378304;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=35ZUWAb3rlQutkZQ6lYuI6RvsV6D5cDyRIaUgYu1kBQ=;
        b=Ws4I3wucJ7aWzZ4XH/nYtw+AeUvfn69/HAp6nAtCj77NOZ0nFFfvL0uNEU5eMpJwcr
        H5sYrRvm+ORxlEvCDsU9HsO8GGTHK18SRnQ5ZihqSiSz2hmMoTAe00qromiqSFt2f7HD
        cg4049JGhfFr1VN2kSB/QZVstFX7qhlojmmm2+DKM5HG92oiJWfUznebZCENobZD8812
        4b+mrPs6clwjikkS6tCt6cHhNDbb9KOB6Yz+AlSeCqweN4unTtffXfYxxYVs4qOgfM48
        xVOQ/d9MpXxGitXyM3Tb3YqZBau9WB6RW5CnTe/5Ndly30o5fKTmAa/Z9f12cGEr3gwC
        0brw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmAvw4TuZw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id V07054w6AAmb7rG
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 12:48:37 +0200 (CEST)
Subject: Re: [PATCH] [stable v5.4.x] pwm: jz4740: Fix build failure
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200710102758.8341-1-u.kleine-koenig@pengutronix.de>
Date:   Fri, 10 Jul 2020 12:48:36 +0200
Cc:     stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        tsbogend@alpha.franken.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <DB8C7C01-0FBB-4A9F-B068-15C06BBC0873@goldelico.com>
References: <20200710102758.8341-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 10.07.2020 um 12:27 schrieb Uwe Kleine-K=C3=B6nig =
<u.kleine-koenig@pengutronix.de>:
>=20
> When commit 9017dc4fbd59 ("pwm: jz4740: Enhance precision in =
calculation
> of duty cycle") from v5.8-rc1 was backported to v5.4.x its dependency =
on
> commit ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver") was =
not
> noticed which made the pwm-jz4740 driver fail to build.

Please can you add my "reported by?"

> As ce1f9cece057 depends on still more rework, just backport a small =
part
> of this commit to make the driver build again. (There is no dependency
> on the functionality introduced in ce1f9cece057, just the rate =
variable
> is needed.)

BR and thanks,
Nikolaus

>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>=20
> @Paul: Can you please check this is correct? I only build-tested this
> change.
>=20
> Best regards
> Uwe
>=20
> drivers/pwm/pwm-jz4740.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> index d0f5c69930d0..77c28313e95f 100644
> --- a/drivers/pwm/pwm-jz4740.c
> +++ b/drivers/pwm/pwm-jz4740.c
> @@ -92,11 +92,12 @@ static int jz4740_pwm_apply(struct pwm_chip *chip, =
struct pwm_device *pwm,
> {
> 	struct jz4740_pwm_chip *jz4740 =3D to_jz4740(pwm->chip);
> 	unsigned long long tmp;
> -	unsigned long period, duty;
> +	unsigned long rate, period, duty;
> 	unsigned int prescaler =3D 0;
> 	uint16_t ctrl;
>=20
> -	tmp =3D (unsigned long long)clk_get_rate(jz4740->clk) * =
state->period;
> +	rate =3D clk_get_rate(jz4740->clk);
> +	tmp =3D rate * state->period;
> 	do_div(tmp, 1000000000);
> 	period =3D tmp;
>=20
> --=20
> 2.27.0
>=20

