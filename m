Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93136E3E5
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 12:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfGSKFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 06:05:36 -0400
Received: from mail-eopbgr40092.outbound.protection.outlook.com ([40.107.4.92]:10046
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfGSKFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 06:05:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kid0XsvvrbUFA0wEqSmqgkmB5/zZpfqH8qLSmBt2x9NdiruTEsumGaQh2N7V4O9EANARKNXeYjxyQXuTrGyEi9iyTRbm7LDDh//2uCgxN4X4hDQiMLyfy9c5xu/xUbJZNHcY7Z4QQFq/rFjTZ6WYWGTCIuLUqWy3VCDWMQ4/Je7R6YLlynMTcT4iAM8Uvuk3ChbdkjltfZ4eGZoDwLpv2o8hlxeUiUzyJGg7l3WQlhhTVpeJ0z3seq9NXo3rHj52xpDrUxTXczG3xEmyGlEOfk4k2QKUoekVsjAkMPT3+wwW2fzcy9LHzIsOKGAVMhZFbmEET66+/iDiLmhlk59QLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieb5Ti26ow//xiXteGDsBj+wWxgrCMJrmTZW/OEQ5us=;
 b=iVREeaIbWQGKF27hM3Bl7Zvqim9mo2GFGw5QfKQ1PQhc/9s8epcB0eYntQ7xZVyUfibP6LJ3xXxTjPGMAR0cBNvGp6MB7HjVeOSul46UlVloLCj2l9ZzUAgoTxvrVtgxgHPX5t/YCSr9fJN6OwDY7KHMwVVeVmFYHqJ7jH/3FKqyZwfQfC0cm4vwWbwLmf6Ui01TJ3BBFbOWxeOZuE6AkWZiHUNlNIKCQ4ky0CXcBznjQwjSjJwjIsaKbXSuTy2KpELzPJTZ+OK70mbyT1CvUbOEFLBbUb6RW7jQgadL71E0k+wD9P1k1Gy8y464EgW87cFkI+oPHI83R3nCeZfOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieb5Ti26ow//xiXteGDsBj+wWxgrCMJrmTZW/OEQ5us=;
 b=O99xRJnLed/FC3fua5DQZyFM+sekzTVl65lI7prQJrF8XasxCN0mlaYY4b8YXtLaHr8rcoqz3LIoqZ2h5nPFgOqVufCtIi4Zc79ankuNWDtn4PLVEdYHnPAYYaNY9/pIfz4cVGOMcfWB9jG5U+p4186CcBOK7PyMkLZzTAfWjL8=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5925.eurprd05.prod.outlook.com (20.179.0.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 10:05:30 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 10:05:30 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v6 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Topic: [PATCH v6 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Index: AQHVPhl+TquGY/9OqUqqRqkRBZjHKw==
Date:   Fri, 19 Jul 2019 10:05:30 +0000
Message-ID: <20190719100524.23300-2-oleksandr.suvorov@toradex.com>
References: <20190719100524.23300-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190719100524.23300-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR04CA0149.eurprd04.prod.outlook.com (2603:10a6:207::33)
 To AM6PR05MB6535.eurprd05.prod.outlook.com (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ae0a2a7-da88-44cf-bd6c-08d70c30a15a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB5925;
x-ms-traffictypediagnostic: AM6PR05MB5925:
x-microsoft-antispam-prvs: <AM6PR05MB5925CDD945FDAA531FF4D7DDF9CB0@AM6PR05MB5925.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39840400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(14454004)(68736007)(8676002)(50226002)(6486002)(8936002)(54906003)(305945005)(7736002)(71190400001)(71200400001)(6436002)(81156014)(186003)(99286004)(66476007)(66446008)(66556008)(64756008)(1411001)(81166006)(2906002)(476003)(36756003)(66946007)(446003)(256004)(6512007)(86362001)(6916009)(26005)(478600001)(66066001)(11346002)(52116002)(53936002)(486006)(76176011)(2616005)(25786009)(1076003)(6506007)(4326008)(44832011)(3846002)(6116002)(316002)(5660300002)(102836004)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5925;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9kKUjNCnUHcCg3f+3fK/NNt1/GYnQ03PCdXzRHrTAxGt90mocttK2Av4yRPQAt9YMGosTWfmqD18ZHboEJALVjDo3liFzPX43fGi0ZeSAxBqK9VgZ//dUWYBPRqWx2beEhGqFdBWATEIc66AqY2/eKZ6q7iJCajw7D5yv0X1Zi7eB+5gKoeiEHc3/ycBiCE7zvh2ITdliG3DBB58aNqAKCgjnRf1VtRQIfHuH93WkTH5YjY5pUsZsSPN+CGQQ+LvAzk5qQEJ4rfo1V9TieIDLUB1qSS2RCzzVC8hneULtsud+SXRgsvtswW1V6xRdwL3EBrLDTYDUAcYNi6DkVCxPZBNcN394RItGSogGKZtRbggxlDWSJRycpALz1Lq9vuzSdOF4c0IP0ND44SCVfeZ32FbduvEZrW9gTlsUbFNyFw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae0a2a7-da88-44cf-bd6c-08d70c30a15a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 10:05:30.3035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5925
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prepare to use SND_SOC_DAPM_PRE_POST_PMU definition to
reduce coming code size and make it more readable.

Cc: stable@vger.kernel.org
Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Reviewed-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Reviewed-by: Igor Opaniuk <igor.opaniuk@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>

---

Changes in v6: None
Changes in v5:
- Add explicit stable tag

Changes in v4:
- CC the patch to kernel-stable

Changes in v3: None
Changes in v2:
- Fix patch formatting

 include/sound/soc-dapm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index c00a0b8ade08..6c6694160130 100644
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

