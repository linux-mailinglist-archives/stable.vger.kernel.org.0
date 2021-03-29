Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703E334D8E0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 22:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhC2UK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 16:10:57 -0400
Received: from a27-81.smtp-out.us-west-2.amazonses.com ([54.240.27.81]:55039
        "EHLO a27-81.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230395AbhC2UKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 16:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617048649;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id;
        bh=K7KIbWMyfNkSCg4+/gHzQaPHfkkMmVADENdA1HNdl1I=;
        b=R0Dvtv5p5WU/1fwv4JbgF5bZdz31q72q+gwFZseQzBrHTRny+vjmDgZIe1Kr9jz/
        CXySZBy5fyc8jyMawNyb//gIk1TDEb2g+eMDhRX4suE9i3IXJI6pbEeNcUnVoB9z+tn
        aJyXgn8DQztL+/A/d37OafXezfh/eD7NMrG3qjx0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617048649;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:References:Message-Id:Feedback-ID;
        bh=K7KIbWMyfNkSCg4+/gHzQaPHfkkMmVADENdA1HNdl1I=;
        b=L9yEBe+VAxejLLUEFDZE+4qcdfnGVQEmhK+JDF+ESm1YTsTGqmUbuCp5dy6NXtnS
        aP5P25MPFGatIo9vEYR5XXymZHizLosZOtbYCh1PLNpXbqmJiIGE6TEV73Uvd9PVXqC
        jneIPzuulK0SsOXjLd7Slx0UW5oXTZnV9PsTzBis=
Subject: [PATCH v2] sc16is7xx: Defer probe if device read fails
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?linux-serial=40vger=2Ekernel=2Eorg?= 
        <linux-serial@vger.kernel.org>,
        =?UTF-8?Q?gregkh=40linuxfoundation=2Eo?= =?UTF-8?Q?rg?= 
        <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?jirislaby=40kernel=2Eorg?= <jirislaby@kernel.org>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Mon, 29 Mar 2021 20:10:49 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20210329200848.409660-1-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJNebtcpZwxGpQ4q0FBV1tWCzFg==
Thread-Topic: [PATCH v2] sc16is7xx: Defer probe if device read fails
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617048648
Message-ID: <010101787f9c3fd8-c1815c00-2d6b-4c85-a96a-a13e68597fda-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.29-54.240.27.81
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
Fixes: 2aa916e67db3 ("sc16is7xx: Read the LSR register for basic device p=
resence check")=0D=0ACc: stable@vger.kernel.org=0D=0ASigned-off-by: Annal=
iese McDermond <nh6z@nh6z.net>=0D=0A---=0D=0A drivers/tty/serial/sc16is7x=
x.c | 2 +-=0D=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0D=0A=0D=0A=
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7x=
x.c=0D=0Aindex f86ec2d2635b..9adb8362578c 100644=0D=0A--- a/drivers/tty/s=
erial/sc16is7xx.c=0D=0A+++ b/drivers/tty/serial/sc16is7xx.c=0D=0A@@ -1196=
,7 +1196,7 @@ static int sc16is7xx_probe(struct device *dev,=0D=0A =09ret=
 =3D regmap_read(regmap,=0D=0A =09=09=09  SC16IS7XX_LSR_REG << SC16IS7XX_=
REG_SHIFT, &val);=0D=0A =09if (ret < 0)=0D=0A-=09=09return ret;=0D=0A+=09=
=09return -EPROBE_DEFER;=0D=0A=20=0D=0A =09/* Alloc port structure */=0D=0A=
 =09s =3D devm_kzalloc(dev, struct_size(s, p, devtype->nr_uart), GFP_KERN=
EL);=0D=0A--=20=0D=0A2.27.0=0D=0A=0D=0A
