Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C2434D428
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhC2PlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 11:41:07 -0400
Received: from a27-85.smtp-out.us-west-2.amazonses.com ([54.240.27.85]:50947
        "EHLO a27-85.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230167AbhC2Pki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 11:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617032436;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
        bh=cJTRSqc4BP2jIQ52BQB6Hzmg9RUU74TP2jKEZ10q4nk=;
        b=A+NUQafxahAFEwz5mV+E6rS+JcfEEolzziP19MuiBQXe8jkNWyhztQ+EWCaP9zGe
        C0mZWx0PgZJKzDqElZ21iFLIC4Wrs7jaYckEX0aHvb35SRGyCUXDdAWtZA6AStRtB3E
        x0JP1XhVTlU+f22emS64u80AEC0xfQXxxAzZMN9o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617032436;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
        bh=cJTRSqc4BP2jIQ52BQB6Hzmg9RUU74TP2jKEZ10q4nk=;
        b=fmrix/obMD7642qeiRlM131vaKDaq9lmI59lUQi+jPwlEI8O1Sy66zeAFhKD5Tvn
        XtpxZ6UvZxs7FDmTlhoQxoLGPmhqYEjEgE1KeSBFJsljnF7WguH/uIcmEyqWV4zTMGb
        obD/rCj9Fm5w3FPWo4W9kE09NVnDNxlJiSDL9h8o=
Subject: [PATCH] sc16is7xx: Defer probe if device read fails
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?linux-serial=40vger=2Ekernel=2Eorg?= 
        <linux-serial@vger.kernel.org>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Mon, 29 Mar 2021 15:40:35 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20210329154013.408967-1-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJLHb+f11tj/5RVCWuJdkpEj6bA==
Thread-Topic: [PATCH] sc16is7xx: Defer probe if device read fails
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617032435
Message-ID: <010101787ea4d8c4-08608e8d-9755-4a88-9908-af95233a4f8e-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.29-54.240.27.85
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A test was added to the probe function to ensure the device was=0D=0Aactu=
ally connected and working before successfully completing a=0D=0Aprobe.  =
If the device was actually there, but the I2C bus was not=0D=0Aready yet =
for whatever reason, the probe fails permanently.=0D=0A=0D=0AChange the p=
robe so that we defer the probe on a regmap read=0D=0Afailure so that we =
try the probe again when the dependent drivers=0D=0Aare potentially loade=
d.  This should not affect the case where the=0D=0Adevice truly isn't pre=
sent because the probe will never successfully=0D=0Acomplete.=0D=0A=0D=0A=
Fixes: 2aa916e ("sc16is7xx: Read the LSR register for basic device presen=
ce check")=0D=0ACc: stable@vger.kernel.org=0D=0ASigned-off-by: Annaliese =
McDermond <nh6z@nh6z.net>=0D=0A---=0D=0A drivers/tty/serial/sc16is7xx.c |=
 2 +-=0D=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0D=0A=0D=0Adiff=
 --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c=0D=
=0Aindex f86ec2d2635b..9adb8362578c 100644=0D=0A--- a/drivers/tty/serial/=
sc16is7xx.c=0D=0A+++ b/drivers/tty/serial/sc16is7xx.c=0D=0A@@ -1196,7 +11=
96,7 @@ static int sc16is7xx_probe(struct device *dev,=0D=0A =09ret =3D r=
egmap_read(regmap,=0D=0A =09=09=09  SC16IS7XX_LSR_REG << SC16IS7XX_REG_SH=
IFT, &val);=0D=0A =09if (ret < 0)=0D=0A-=09=09return ret;=0D=0A+=09=09ret=
urn -EPROBE_DEFER;=0D=0A=20=0D=0A =09/* Alloc port structure */=0D=0A =09=
s =3D devm_kzalloc(dev, struct_size(s, p, devtype->nr_uart), GFP_KERNEL);=
=0D=0A--=20=0D=0A2.27.0=0D=0A=0D=0A
