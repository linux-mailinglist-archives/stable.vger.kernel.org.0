Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A2E6CB6D
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389549AbfGRJCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:02:51 -0400
Received: from mail-eopbgr150109.outbound.protection.outlook.com ([40.107.15.109]:61477
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727633AbfGRJCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 05:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifz9wzmY5t8VUYDGA0m25e8deF8ohlT0PsQQaTJvjgn+VqRxThRmVCC8jnfG1/FR4+YKGq/1RV52JqQ1Jy6dV1XnqR+Z1HqS1X6gyf85K2vtyOPnXJHvrTmuYEgmWXQfSf4yHbOkQQrtlcSHeGuLH/a4jaKNEyLhJyXzyrAbAZxVDkqO40vNLnurSKleEVZYOgWhizJ8rZnS5RBOG2CZjEO/w1zxQK0dfnAku5JIxJCUVjJS9gyGKmHY2qWQYQQmCF4YCscScidQ4WJc34Gt6VfNXNmrEKZ80goaBsCRoaTDk/Wokn5vCuWPW/c2L2KU60G5QMg6fYwnmyWczFlS0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S87Civ+imIotVJnH/pRunGuVH1yWxjeYZ9AM8eXK11s=;
 b=WCZgbzQmymLZtYysWsarwmVpQTC30IHvfEBwLNVmNPna+IrG9/G4KAKzq9mQe+lhKtb48eOdEVFAG9HIMG1bZo6MuYBpdXYC+wVq0dqzyp3CPO4nq/BNIJax5RHjJkm6ZqIL092QL2SXEih0qSG1zH2vCkfirVsteBO6CkOIvNb3VasvIP5WWhPPL6K7iVg10Yk7xqjY5YDPqaS3jHwd73TgTkSWJPsPt5tQGCJnV3qGvZefFBh72oxPCSeJAv5ypsC8rwD/Y/ewaLn9P3UX2Ld7Eb7N9RLuWo47F2Iq5kTMcbBYFt+M96fclRW4fJJvDh2jOmFEuzSNkY11zUFKiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S87Civ+imIotVJnH/pRunGuVH1yWxjeYZ9AM8eXK11s=;
 b=bI1kk/RJZN28IZXceylRPHDFOSEKmuSAYRe2zJT+bHfGmrbgtf4G4M04Kect7Icuj9dthSJ8m6fOYfh1moRv8Yckmf4jGWISZakaLVbYU+F69M80zD451mBbI/DflvfvJ4VvNgLIGMKHdoj/T0sf4NWE5g3ibsf88sJHGJBMA3E=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5013.eurprd05.prod.outlook.com (20.177.35.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.12; Thu, 18 Jul 2019 09:02:45 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Thu, 18 Jul 2019
 09:02:45 +0000
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
Subject: [PATCH v5 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Topic: [PATCH v5 1/6] ASoC: Define a set of DAPM pre/post-up events
Thread-Index: AQHVPUeQIlRxXSX2H0OhdtyVf6Sb7w==
Date:   Thu, 18 Jul 2019 09:02:45 +0000
Message-ID: <20190718090240.18432-2-oleksandr.suvorov@toradex.com>
References: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
In-Reply-To: <20190718090240.18432-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::46) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c76ede34-0c0f-414e-e279-08d70b5eb2fb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB5013;
x-ms-traffictypediagnostic: AM6PR05MB5013:
x-microsoft-antispam-prvs: <AM6PR05MB5013CB503FA430C3D2A6635AF9C80@AM6PR05MB5013.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(346002)(366004)(376002)(396003)(136003)(199004)(189003)(2616005)(99286004)(68736007)(476003)(446003)(50226002)(11346002)(486006)(86362001)(8936002)(81166006)(76176011)(81156014)(26005)(14454004)(4326008)(186003)(386003)(6506007)(316002)(102836004)(6916009)(54906003)(52116002)(36756003)(6486002)(6436002)(71190400001)(71200400001)(6512007)(25786009)(66066001)(256004)(66946007)(64756008)(66476007)(66556008)(66446008)(1076003)(1411001)(5660300002)(4744005)(8676002)(478600001)(7736002)(44832011)(6116002)(3846002)(305945005)(53936002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5013;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d8RjVqcodn8twyL9OeTLVp4nqi97gBaqQK3CBOR7PTmg4itUVDJ5v5rAf/7Vfes+X6eXbsGFmai/uvwGiwGXfLj+FWXzvirbZMQCJ56P/BX7s/UYiLH3LYU8/eEa3XfgwU07bXoKK5xAmfLPxoXSnt99jG9Ctc+Mxg3LVHh01og4P0QZf2eZCnsVEC1kGPzoW//1pIlQmTAuHWHbnHrmQ9gElk62j73nHm4JIexs2pZeiw5zk2FXUbLm/eYKJt67suQ+/7a2Hanh1k7td+lGRVDYQ6uI38hmj94pbdXSILiNSh62nCCOPW5z/TpaQDFnv5Gnm9Rj+TqmWrTCU0BcC93Fk4oBXfXu6bLku0TVy5OOyjfgaR5lqefO+n6WLxtdtTkNngvDFbzMen+e9oEk0Kivby9xipSmAIsC4ypZA24=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76ede34-0c0f-414e-e279-08d70b5eb2fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 09:02:45.4767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5013
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

