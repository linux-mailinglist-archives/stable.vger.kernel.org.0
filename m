Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CABB34D27E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 16:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhC2Oii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 10:38:38 -0400
Received: from a27-107.smtp-out.us-west-2.amazonses.com ([54.240.27.107]:46015
        "EHLO a27-107.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhC2OiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 10:38:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617028686;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
        bh=6QDlTzhgIg8bRCekF5YD0wses94UlKnnwhKWHNH9fvw=;
        b=CwO3ztsggD89iRsiWpAclw7dJnnP83skdQyalJDOFB/kv30qIw9JwItILIk6N0FL
        lIk1oPhu50PiPorxacaZxY7AsdXCBlMWZfXcDueOm4/iku/rYNhf7HKsHrEcsGDRfNG
        OJ1gOGczckX6jQFGeEk6/+a9+bm7fcKr2K1elKmU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617028686;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
        bh=6QDlTzhgIg8bRCekF5YD0wses94UlKnnwhKWHNH9fvw=;
        b=LyZI+wCeXRCH0ryN+bNLWx7qG3VY+omN1RNndPQ+bUKdOFjM6Eo/XBwHyjPLvC9o
        UfQ3bw2Rz5/hYpXUlU60TZmuysKr+770b6GK2oDwYPPHX7gAmb+vfOG1hPgArN89+i1
        H3IocA2LoVWZw3JxwoGfDyoPC9x3RFXHAzTkAWuU=
Subject: [PATCH 2/2] ASoC: tlv320aic32x4: Register clocks before registering
 component
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?alsa-devel=40alsa-project=2Eorg?= 
        <alsa-devel@alsa-project.org>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Mon, 29 Mar 2021 14:38:06 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210329143756.408604-1-nh6z@nh6z.net>
References: <20210329143756.408604-1-nh6z@nh6z.net> 
 <20210329143756.408604-3-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJKkg/ojtMl+8SNWm7v/u1huSVgAAAEpD
Thread-Topic: [PATCH 2/2] ASoC: tlv320aic32x4: Register clocks before
 registering component
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617028686
Message-ID: <010101787e6ba3ea-c69f7c7b-b586-4a5a-8297-50be27ce3534-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.29-54.240.27.107
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clock registration must be performed before the component is=0D=0Aregiste=
red.  aic32x4_component_probe attempts to get all the=0D=0Aclocks right o=
ff the bat.  If the component is registered before=0D=0Athe clocks there =
is a race condition where the clocks may not=0D=0Abe registered by the ti=
me aic32x4_componet_probe actually runs.=0D=0A=0D=0AFixes: d1c859d ("ASoC=
: codec: tlv3204: Increased maximum supported channels")=0D=0ACc: stable@=
vger.kernel.org=0D=0ASigned-off-by: Annaliese McDermond <nh6z@nh6z.net>=0D=
=0A---=0D=0A sound/soc/codecs/tlv320aic32x4.c | 8 ++++----=0D=0A 1 file c=
hanged, 4 insertions(+), 4 deletions(-)=0D=0A=0D=0Adiff --git a/sound/soc=
/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c=0D=0Aindex 1ac=
3b3b12dc6..b689f26fc4be 100644=0D=0A--- a/sound/soc/codecs/tlv320aic32x4.=
c=0D=0A+++ b/sound/soc/codecs/tlv320aic32x4.c=0D=0A@@ -1243,6 +1243,10 @@=
 int aic32x4_probe(struct device *dev, struct regmap *regmap)=0D=0A =09if=
 (ret)=0D=0A =09=09goto err_disable_regulators;=0D=0A=20=0D=0A+=09ret =3D=
 aic32x4_register_clocks(dev, aic32x4->mclk_name);=0D=0A+=09if (ret)=0D=0A=
+=09=09goto err_disable_regulators;=0D=0A+=0D=0A =09ret =3D devm_snd_soc_=
register_component(dev,=0D=0A =09=09=09&soc_component_dev_aic32x4, &aic32=
x4_dai, 1);=0D=0A =09if (ret) {=0D=0A@@ -1250,10 +1254,6 @@ int aic32x4_p=
robe(struct device *dev, struct regmap *regmap)=0D=0A =09=09goto err_disa=
ble_regulators;=0D=0A =09}=0D=0A=20=0D=0A-=09ret =3D aic32x4_register_clo=
cks(dev, aic32x4->mclk_name);=0D=0A-=09if (ret)=0D=0A-=09=09goto err_disa=
ble_regulators;=0D=0A-=0D=0A =09return 0;=0D=0A=20=0D=0A err_disable_regu=
lators:=0D=0A--=20=0D=0A2.27.0=0D=0A=0D=0A
