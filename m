Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAF86BF9B
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 18:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGQQan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 12:30:43 -0400
Received: from mail-eopbgr00115.outbound.protection.outlook.com ([40.107.0.115]:22949
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbfGQQan (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 12:30:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxfUs6kehsMvVBAi5qUoRbDX2+On5rA4mV+Kgj6eVhPNt+R+DL/qlJFCWS6PyyrlQu0+OSPVHtPsz+90196dwTsC21cSs0yQ6PzQMu9kLQ3rbAl0yuEBupqFog4HxtnFYdhAr6/JFH2why9XJAkKpbhndMJUM9YUhoD9CJgPgUSVOVnemH6QNjUkTEAhZysf15PAoOcncTRpKkGAx+m49pxmvR33vKADSYrWb8g2HXp6Aw9r7lRJ/7mAW4drKBzHOrwb3RfiAhwp6pQTvDX8D+12N05XNX5WG8zwzBJ51IwbvkInNxIZa0bZCojwM69II3aH73RK75ZDgQumIUPrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VDUFDNac/euhH89n7GGAs2rb56FVnKQw2Xlz0NBH0s=;
 b=NfpPL59+DLBZ+GdbON0NJhzz/ytrdUFlbqssqR3l83gc/pAgjxlp9Hvs1+KmrMGX4dHYbwpH+6OKBCfczKVjFlIgta5mqLkTZ4UNxOxyBma8UxN4nrRgC/OB6jfQ7vBIMNmB9CFLvCS8/9F4hIGCH1ybDeU6Shlnc0v0BntoJh1CQNnYH1ujbpMm1pzGqgFsPR8H5DgM5QbbtVs/dFzwXT6BPsQW29Ze3yVM/1OdlooeaA5JoOz79T1+hkgzSa7+2lTC/hzgZBQwfZufTomQEirgUhIBF9RoKokT4pd+pTG2Kj3+MdRv+98mnr8oUDOZWng9Ua9lbGg6oLQP+HDuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VDUFDNac/euhH89n7GGAs2rb56FVnKQw2Xlz0NBH0s=;
 b=aS52fKOE1Bwii4hk3nDBMdkXgLAlJaqbfjZMs5D9KRYrISuwHx9hkGonIftBX1iE2987dpWedz39lsjmtxUOR8h+Atzh9Wd7MIueCDSVLwrw3xPHPZE7RuElumCwcB0HwAkvFm8nuNok/7yicFWVOS0i9DQ6v/2EGOmcUMKblg0=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.6.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 16:30:38 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Wed, 17 Jul 2019
 16:30:38 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v4 0/6] VAG power control improvement for sgtl5000 codec
Thread-Topic: [PATCH v4 0/6] VAG power control improvement for sgtl5000 codec
Thread-Index: AQHVPLz3hwtP1inkKEa+Vly0wUwu8A==
Date:   Wed, 17 Jul 2019 16:30:38 +0000
Message-ID: <20190717163014.429-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::14) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb803498-3fd7-4c3e-fd3b-08d70ad41a46
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB6408;
x-ms-traffictypediagnostic: AM6PR05MB6408:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB64088C99A0E212E979C8E4C5F9C90@AM6PR05MB6408.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(136003)(346002)(396003)(376002)(366004)(189003)(199004)(486006)(305945005)(7736002)(2616005)(476003)(1076003)(52116002)(36756003)(53936002)(66066001)(81156014)(81166006)(71200400001)(8676002)(6436002)(6512007)(50226002)(6306002)(8936002)(14444005)(256004)(71190400001)(4326008)(3846002)(44832011)(6486002)(68736007)(14454004)(6116002)(2906002)(316002)(5660300002)(1411001)(99286004)(966005)(478600001)(66476007)(66556008)(64756008)(66446008)(66946007)(86362001)(6916009)(6506007)(102836004)(386003)(26005)(186003)(54906003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6408;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XgXSLyQqRXGpa5ZIIr1biOPGN2oxeBTp65DjBUFjh1jGuGd9/WbgUhBukXXguyLewC6b2IzXuCsrEzW4QLHjKvOt4BFBeFdQn02dlBoNwB93FxVx+uD+wDdXbkfz2kWAlhro3PeqFfbJXJREDkPTXl81wdb5hjTI3/GH0Iq3gxNnj/P9A9zN2jXnCUqGVutobWg9ih1Hzjd5isqX2OU60gLtgv0OLsrhzdZPzFBeXDYtFHtA3vPc5OgU2QAAZgtgFVqYExzWNudsL9227YR2u+k9OfszU24RbSloSllhOfZXTNVA2fNtRQM003LZqEi6k96BiHtlaf8s597C1ZT7oEi0t6Zml4GI4O0NICR96/UXgaaAXb+jcm+a6sfda0x7kUwBXi10KjSypO8+OO07TC9fJMKRtcD+CYzn6fAUMFY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb803498-3fd7-4c3e-fd3b-08d70ad41a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 16:30:38.7618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6408
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


VAG power control is improved to fit the manual [1]. This patchset fixes as
minimum one bug: if customer muxes Headphone to Line-In right after boot,
the VAG power remains off that leads to poor sound quality from line-in.

I.e. after boot:
- Connect sound source to Line-In jack;
- Connect headphone to HP jack;
- Run following commands:
$ amixer set 'Headphone' 80%
$ amixer set 'Headphone Mux' LINE_IN

Also this series includes fixes of non-important bugs in sgtl5000 codec
driver.

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Changes in v4:
- CC the patch to kernel-stable
- Code optimization, simplify function signature
  (thanks to Cezary Rojewski <cezary.rojewski@intel.com> for an idea)
- CC the patch to kernel-stable
- Add a Fixes tag

Changes in v3:
- Add the reference to NXP SGTL5000 data sheet to commit message
- Add the reference to NXP SGTL5000 data sheet to commit message
- Fix multi-line comment format

Changes in v2:
- Fix patch formatting
- Fix patch formatting
- Fix patch formatting
- Fix patch formatting
- Fix patch formatting
- Fix patch formatting

Oleksandr Suvorov (6):
  ASoC: Define a set of DAPM pre/post-up events
  ASoC: sgtl5000: Improve VAG power and mute control
  ASoC: sgtl5000: Fix definition of VAG Ramp Control
  ASoC: sgtl5000: add ADC mute control
  ASoC: sgtl5000: Fix of unmute outputs on probe
  ASoC: sgtl5000: Fix charge pump source assignment

 include/sound/soc-dapm.h    |   2 +
 sound/soc/codecs/sgtl5000.c | 240 ++++++++++++++++++++++++++++++------
 sound/soc/codecs/sgtl5000.h |   2 +-
 3 files changed, 203 insertions(+), 41 deletions(-)

--=20
2.20.1

