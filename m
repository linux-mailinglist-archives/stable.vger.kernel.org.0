Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACC021B357
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJKrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:47:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:35668 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgGJKrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 06:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594378018;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8yDCJPRfC5QGc4OjtInZIlLfs+9XcDvdAp6wM41o+PI=;
        b=QaJTAe8YgXn1Z5cx2tDh7xZazYdPQK8YYnU733q1tAfZupCLYINUINXznr9lRgRkUu
        YORz9dkh7eOHIuc1ICHIarcP4+m0p6VIRWpg+PYoVcJ0pojV4i/nyqjN1Hqul7aygFPe
        oVlUcjJm//qU5/23l4xB7bGcZQ8+udYRYnvTWcHdk5u+nIgUmqxLSpwYQlNjwpMzrTBw
        csecee0W0v/hLtKB+SYiyvkY1yRC+9Ol13vJjM+DjscY6rLotyZLxf1WK0U1qCDHwmPN
        MFx30AFj4mFPllqVoZ+RhvYu3wjDy3BJST/Tc/hi9xMj47dUv+D9kGfh+yq2Efxo2e/Z
        S+qA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmAvw4TuZw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id V07054w6AAkm7qi
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 12:46:48 +0200 (CEST)
Subject: Re: [PATCH] Revert "pwm: jz4740: Enhance precision in calculation of duty cycle"
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=iso-8859-1
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200710101827.rkaxju7msco4mez7@pengutronix.de>
Date:   Fri, 10 Jul 2020 12:46:47 +0200
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, linux-mips@vger.kernel.org,
        tsbogend@alpha.franken.de, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3FFAD80E-02F0-4522-9EB5-C201A36CADC8@goldelico.com>
References: <9335b924318fb36a882d5b46e8e9f2a10bb24daa.1594365885.git.hns@goldelico.com> <20200710101827.rkaxju7msco4mez7@pengutronix.de>
To:     =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 10.07.2020 um 12:18 schrieb Uwe Kleine-K=F6nig =
<u.kleine-koenig@pengutronix.de>:
>=20
> On Fri, Jul 10, 2020 at 09:24:45AM +0200, H. Nikolaus Schaller wrote:
>> This reverts commit a6030d71e62d3e0e270bf3b7fb48d32a636732db.
>>=20
>> which was applied to v5.4.49. This ends in a compile issue:
>>=20
>>  CC      drivers/pwm/pwm-jz4740.o - due to target missing
>> drivers/pwm/pwm-jz4740.c: In function 'jz4740_pwm_apply':
>> drivers/pwm/pwm-jz4740.c:111:28: error: 'rate' undeclared (first use =
in this function)
>>  tmp =3D (unsigned long long)rate * state->duty_cycle;
>>                            ^
>> drivers/pwm/pwm-jz4740.c:111:28: note: each undeclared identifier is =
reported only once for each function it appears in
>> make[4]: *** [drivers/pwm/pwm-jz4740.o] Error 1
>>=20
>> v5.5 and later include the required additional patches to define
>> the rate variable.
>=20
> So 9017dc4fbd59 ("pwm: jz4740: Enhance precision in calculation of =
duty
> cycle") which is in v5.8-rc1 was backported to stable:
>=20
> 	v5.4.49 (as commit a6030d71e62d3e0e270bf3b7fb48d32a636732db)
> 	v5.7.5 (as commit e0e71bb7852142a18fb829da419013bb6da9ed3f)
>=20
> However 9017dc4fbd59 depends on
>=20
> 	ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")
>=20
> (which in mainline comes before 9017dc4fbd59 as it's included in
> v5.7-rc1).
>=20
> As ce1f9cece057 was not backported to v5.4.x, this must either be =
done, or
> we need to patch that. Will reply with a suggested change.

That is what I did suspect that some other patch this one depends on
was not backported.

What the better strategy (backport missing parts or revert) depends
on how easy it is to backport to v5.4.y.

I am happy with either solution. It is just simpler for me to post
my workaround for the compile issue.

>=20
> In v5.7.x there is no problem.

In v5.5 and v5.6 there is also no problem. Just v5.4 starting with =
v5.4.49.

BR and thanks,
Nikolaus

