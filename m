Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD12D350631
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 20:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhCaSVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 14:21:46 -0400
Received: from a27-90.smtp-out.us-west-2.amazonses.com ([54.240.27.90]:36755
        "EHLO a27-90.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234701AbhCaSVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 14:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zzmz6pik4loqlrvo6grmnyszsx3fszus; d=nh6z.net; t=1617214898;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
        bh=SET2MMom8yUlyhPewodmsitZ5ujJwagHgJ3dqXYrK/Q=;
        b=Lsg4WPK3BZXJCQJf+DgEoHL3fGFcyHVkfk/+Cf2vTMzQsX8BuqiI/c98cvrRM1bk
        YmA9ziqKEX8etJixAupCS1OVbin58N1q6vlz3S5Hjzb9bVWxFttyug94ByMMwamdnag
        3KiIP3MWT2aYV+McusctFC7McgbkOaO9pWHRYK8U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=7v7vs6w47njt4pimodk5mmttbegzsi6n; d=amazonses.com; t=1617214898;
        h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
        bh=SET2MMom8yUlyhPewodmsitZ5ujJwagHgJ3dqXYrK/Q=;
        b=LXE7qu57foLttk3bI+2OUCRrjDkGVW/qaYGKud304quHKt1ya5DYltGwLca/2mhy
        /o/QMA8waOVI/ykXgOhgXoEzhZbdfVs1vx0w/UD6jbnHD1XMetLtzxd4u5CFAENgj4m
        bElqZcpYKt6DXQOwau+3RjgRFNhlLouvGCnIUIbU=
Subject: [PATCH v2 2/2] ASoC: tlv320aic32x4: Register clocks before
 registering component
From:   =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>
To:     =?UTF-8?Q?alsa-devel=40alsa-project=2Eorg?= 
        <alsa-devel@alsa-project.org>,
        =?UTF-8?Q?broonie=40kernel=2Eorg?= <broonie@kernel.org>,
        =?UTF-8?Q?lgirdwood=40gmail=2Ecom?= <lgirdwood@gmail.com>,
        =?UTF-8?Q?perex=40perex=2Ecz?= <perex@perex.cz>,
        =?UTF-8?Q?tiwai=40suse=2E?= =?UTF-8?Q?com?= <tiwai@suse.com>
Cc:     =?UTF-8?Q?Annaliese_McDermond?= <nh6z@nh6z.net>,
        =?UTF-8?Q?team=40nwdigitalradio=2Ecom?= <team@nwdigitalradio.com>,
        =?UTF-8?Q?stable=40vger=2Ekernel=2Eorg?= <stable@vger.kernel.org>
Date:   Wed, 31 Mar 2021 18:21:38 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210331182125.413693-1-nh6z@nh6z.net>
References: <20210331182125.413693-1-nh6z@nh6z.net> 
 <20210331182125.413693-3-nh6z@nh6z.net>
X-Mailer: Amazon WorkMail
Thread-Index: AQHXJlqutU2ZzEf5Tk+l1YBnPdSJ8wAAAHbh
Thread-Topic: [PATCH v2 2/2] ASoC: tlv320aic32x4: Register clocks before
 registering component
X-Original-Mailer: git-send-email 2.27.0
X-Wm-Sent-Timestamp: 1617214897
Message-ID: <0101017889850206-dcac4cce-8cc8-4a21-80e9-4e4bef44b981-000000@us-west-2.amazonses.com>
X-SES-Outgoing: 2021.03.31-54.240.27.90
Feedback-ID: 1.us-west-2.An468LAV0jCjQDrDLvlZjeAthld7qrhZr+vow8irkvU=:AmazonSES
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clock registration must be performed before the component is=0D=0Aregiste=
red.  aic32x4_component_probe attempts to get all the=0D=0Aclocks right o=
ff the bat.  If the component is registered before=0D=0Athe clocks there =
is a race condition where the clocks may not=0D=0Abe registered by the ti=
me aic32x4_componet_probe actually runs.=0D=0A=0D=0AFixes: d1c859d314d8 (=
"ASoC: codec: tlv3204: Increased maximum supported channels")=0D=0ACc: st=
able@vger.kernel.org=0D=0ASigned-off-by: Annaliese McDermond <nh6z@nh6z.n=
et>=0D=0A---=0D=0A sound/soc/codecs/tlv320aic32x4.c | 8 ++++----=0D=0A 1 =
file changed, 4 insertions(+), 4 deletions(-)=0D=0A=0D=0Adiff --git a/sou=
nd/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c=0D=0Aind=
ex 1ac3b3b12dc6..b689f26fc4be 100644=0D=0A--- a/sound/soc/codecs/tlv320ai=
c32x4.c=0D=0A+++ b/sound/soc/codecs/tlv320aic32x4.c=0D=0A@@ -1243,6 +1243=
,10 @@ int aic32x4_probe(struct device *dev, struct regmap *regmap)=0D=0A=
 =09if (ret)=0D=0A =09=09goto err_disable_regulators;=0D=0A=20=0D=0A+=09r=
et =3D aic32x4_register_clocks(dev, aic32x4->mclk_name);=0D=0A+=09if (ret=
)=0D=0A+=09=09goto err_disable_regulators;=0D=0A+=0D=0A =09ret =3D devm_s=
nd_soc_register_component(dev,=0D=0A =09=09=09&soc_component_dev_aic32x4,=
 &aic32x4_dai, 1);=0D=0A =09if (ret) {=0D=0A@@ -1250,10 +1254,6 @@ int ai=
c32x4_probe(struct device *dev, struct regmap *regmap)=0D=0A =09=09goto e=
rr_disable_regulators;=0D=0A =09}=0D=0A=20=0D=0A-=09ret =3D aic32x4_regis=
ter_clocks(dev, aic32x4->mclk_name);=0D=0A-=09if (ret)=0D=0A-=09=09goto e=
rr_disable_regulators;=0D=0A-=0D=0A =09return 0;=0D=0A=20=0D=0A err_disab=
le_regulators:=0D=0A--=20=0D=0A2.27.0=0D=0A=0D=0A
