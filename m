Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB50E6BF9D
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 18:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfGQQap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 12:30:45 -0400
Received: from mail-eopbgr00115.outbound.protection.outlook.com ([40.107.0.115]:22949
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfGQQao (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 12:30:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og+RGvyTyiNwi6GX+3YZr03BMTnKRHLsc3X9hup24wA8gRVsS+uK51D1aMgPVuGk4MNgqDbJmhbDswtIrObM1wTiaMiwRksfsxxrrsM1QUpvDVzRnd1bq+FzKMLpBoNFKu+imZDb4CfBiUL6E+9R1K/4X69N8hr6/I4qbb9R2w5MiaXCmi8+xwOTc4j45SJCKEzLBypQz2BqqGzB3JKlC3+HpKagp0un/JiVsed8wXuNcVof+uR2EmjSGPuGb/DTVOPuQwsI0+WR7MsliOLoeuKZOv3Yjk/oGR3OA3pYZpgh7wYr64pfT7OUz/2W7PqQMP4KqKVUywTTjW5FVPWEoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2UXyMi9DYe+ul0wF8SP426L4Srsrjmy/9dcjFCM2jA=;
 b=SvHvPex5pAWXt5A7kUlhKfjKgOSzaimsQsah3GgbgJ57bHCXW5tGRXFNuitSjf9C+pvZ+hjB2CyYurNIS/qTE8L4NkpSx9ub69sBTm18Nz6HvG0niRyQezyYF2PNfkyZ0SkuBu4VDS2exxmTrryOM+577VyY9CheAcaK4tWwvD4B1AnXT31sMFj4BqVkt/hQAHA61WHUHbjk1t/XgSg1UW63CLf36zyhaxbvn/LzE5APjZTzuV9S5omkw5JavPn3GCxfw6o3GcLutw2fvquGBaj59TgLFahRjWeaStm26aBYEfbX2Ag6heUKseIVIXlJB5OsBWouFgJjImYgy0Bx3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2UXyMi9DYe+ul0wF8SP426L4Srsrjmy/9dcjFCM2jA=;
 b=jCvqkDRCIWd1oPRjY7j/gpcoxqZWbrbNVrmYcbto6WTKJwfvf+rEYMIeHafNOnnPRtCQzmpR+3sBalXfBGhJWxkoBsMFtgrUcWagNCzUy4/QdLu92XvSXoG2W+EiTPFBz5A1wzwvOF9Rnk3Jacfv/R7QRHl2JRxJ0bTC+8hXG4Q=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.6.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Wed, 17 Jul 2019 16:30:40 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Wed, 17 Jul 2019
 16:30:40 +0000
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
Subject: [PATCH v4 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Topic: [PATCH v4 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Index: AQHVPLz4I2peC5u/q0ONqoJMqxCAfQ==
Date:   Wed, 17 Jul 2019 16:30:40 +0000
Message-ID: <20190717163014.429-2-oleksandr.suvorov@toradex.com>
References: <20190717163014.429-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190717163014.429-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0001.eurprd02.prod.outlook.com
 (2603:10a6:200:89::11) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2b052f8-35dc-48ea-5460-08d70ad41b40
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB6408;
x-ms-traffictypediagnostic: AM6PR05MB6408:
x-microsoft-antispam-prvs: <AM6PR05MB64088BE6176B49F732C7B578F9C90@AM6PR05MB6408.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(136003)(346002)(396003)(376002)(366004)(189003)(199004)(486006)(305945005)(7736002)(2616005)(11346002)(476003)(446003)(1076003)(52116002)(36756003)(53936002)(66066001)(81156014)(81166006)(71200400001)(8676002)(6436002)(4744005)(6512007)(50226002)(8936002)(256004)(71190400001)(4326008)(3846002)(44832011)(6486002)(68736007)(14454004)(6116002)(2906002)(316002)(5660300002)(1411001)(99286004)(478600001)(66476007)(66556008)(64756008)(66446008)(66946007)(76176011)(86362001)(6916009)(6506007)(102836004)(386003)(26005)(186003)(54906003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6408;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CnRA2phoJVoUe3lDqRmYC5IF8kcpUTpITrYAYzefnTbJlbyewZ3j0V41tKqJSoreWyAYLJcC1uBgsUE1+GSOypeY1zWTr83GYRCoXj/WvYPtfYuZPVY/E3ykExbZdYkNxV/l+L2RykQ9uNh4O47tRFvGK5mfMN6rKSsnQ012cE/N2ySArINbHHWnEgKnX4HUKiUbb14DECw5Tygop3EmHqp6kyl9sVTv8Rq5vf8kXmzrY036p3cQsrHhGTZEnuz3FO8+BR/YZr9AVt9nhAXxK6Z8uaLYX0XnCjU7mnNnTUsx5yhsc2kEgpsyC0rJ3H7dItfcy9e//iuy/4Sg6JcfD6DmWYZ4apzyQzpOBVUNaOldstYRmWmnirYnmO1E+xqaD0D7LcZ06jI9zjm0PdK9FUtmd4/nvvnjEEhbxC/7Io8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b052f8-35dc-48ea-5460-08d70ad41b40
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2019 16:30:40.4698
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

Prepare to use SND_SOC_DAPM_PRE_POST_PMU definition to
reduce coming code size and make it more readable.

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
---

Changes in v4:
- CC the patch to kernel-stable

Changes in v3: None
Changes in v2:
- Fix patch formatting

 include/sound/soc-dapm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index c00a0b8ade086..6c66941601307 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -353,6 +353,8 @@ struct device;
 #define SND_SOC_DAPM_WILL_PMD   0x80    /* called at start of sequence */
 #define SND_SOC_DAPM_PRE_POST_PMD \
 				(SND_SOC_DAPM_PRE_PMD | SND_SOC_DAPM_POST_PMD)
+#define SND_SOC_DAPM_PRE_POST_PMU \
+				(SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU)
=20
 /* convenience event type detection */
 #define SND_SOC_DAPM_EVENT_ON(e)	\
--=20
2.20.1

