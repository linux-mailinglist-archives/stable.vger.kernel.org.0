Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AA92B7B2C
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 11:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgKRKXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 05:23:09 -0500
Received: from mail-eopbgr40115.outbound.protection.outlook.com ([40.107.4.115]:20206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgKRKXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 05:23:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mV9FKGc5WfbxSR4Z9daSB4p57FFFtryYdUuXs7KNuFbAGyPUFNMW8SSFkg+ea4CoaGlnyLklWIamGDBZypS6xMGkFEMzSZBf3VVEV/hyjA+yaG41XUdL3DFEyeyqe2lEb2/+F0LvyxseLOIL65fqTWDUnbvPSDVzf3onQInOdE4EnZhI8YFuo9wMjKLEiJLthRAooB1AH/hcBaGTGcsXaPHAEH9DUyw6stpkFjthRgrcoR7wvLseuwvAnF8AWw890N7SOSsO74aE2ZlgYsnMirRiJqb5v2L6ne2pdzEAbzQvnhuhJgKRJAg17YgG76YH9vytVXY0Gz44V48i40Wstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSsV819DNqQzp+F9TppxxBQm4eHaojNh9XMGJntbbno=;
 b=DzyqpGR+izrncrIscV1OXcpO1QOq4iysliUMc3W6d8to+jlLPeNaxmlg6erKSo9Pq4kLBbiKTgITwesPQzJEsA+YIr8yh44q2Xxqxq67RudlnSNO1p9TjUcAr/bwsIqkWNuJ9ZUiSJYC4R3I3JYEitZTi2Q8jOO99p6jTAbPZRag5XPFWXOt8ARkv3FmlfcayR6ErPcvB7z2hGVw5txv0t1MkLX24yxfooRZVS+t5SFRkGRN89ByIs08yC/KrW/00EmTwilOCAXWPpqEN3ssK9WNGvxXdWxpMcA4CO4VnebPxcwNWg3ZkOo2vIWADFIwH+yxCk7xhFqL/vz23WgWzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSsV819DNqQzp+F9TppxxBQm4eHaojNh9XMGJntbbno=;
 b=AyRqRtQV5TDKatfqraVh50F3HxnT4yrTvvnbIJTDX/aMQeZEz3/Km0mSyG+VzDSOo5qo+2SVX4IATkcxFhGuQ/InTjlRNkMiFfsHz6y002huU+bQlGlFDYYCEdKISBlkAtf9lbAYpeo+Rxq6+Cxukq51f+sAtBT8jysJPcdJ8cg=
Received: from AM7PR07MB6707.eurprd07.prod.outlook.com (2603:10a6:20b:1af::11)
 by AM6PR07MB3942.eurprd07.prod.outlook.com (2603:10a6:209:35::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.16; Wed, 18 Nov
 2020 10:23:02 +0000
Received: from AM7PR07MB6707.eurprd07.prod.outlook.com
 ([fe80::f5d7:501f:102d:60c3]) by AM7PR07MB6707.eurprd07.prod.outlook.com
 ([fe80::f5d7:501f:102d:60c3%9]) with mapi id 15.20.3589.017; Wed, 18 Nov 2020
 10:23:02 +0000
From:   "Wiebe, Wladislav (Nokia - DE/Ulm)" <wladislav.wiebe@nokia.com>
To:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wiebe, Wladislav (Nokia - DE/Ulm)" <wladislav.wiebe@nokia.com>
Subject: [PATCH] clk: move orphan_list back to DEBUG_FS section
Thread-Topic: [PATCH] clk: move orphan_list back to DEBUG_FS section
Thread-Index: Ada9k+6gKWQKOxMWRaK2973BbyOELw==
Date:   Wed, 18 Nov 2020 10:23:02 +0000
Message-ID: <AM7PR07MB67076EAED784F061D17AC015FAE10@AM7PR07MB6707.eurprd07.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: baylibre.com; dkim=none (message not signed)
 header.d=none;baylibre.com; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [109.192.217.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 19ca8b69-2668-46da-3224-08d88babee4c
x-ms-traffictypediagnostic: AM6PR07MB3942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR07MB3942547394822F71BD526317FAE10@AM6PR07MB3942.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgicYTxIEsEUr8sVieyISRvqXdVG9+Noa+1hzAF+aeygkE4WnZ9SEZjEREHJoRJrYbdXlbgBDjeXVG138we/UkmMUz7UQ5alT6ZPZb9iz8P6XrmMMI+HO64PhMKavFlDSyxwW94hTusfGZtddyGYzpRicaet1xg9+ndmev7QUONQkbDSlx7ip8wKs/sWnduVH2YfUkczWCb5AcauE6K8GUkJEb7cCT9/02pXVKXNiYaC7/okZySVh75HVAFghxz3HcYVM/rHMX7q39VsmKtRc8G8o6XRGFaxcXqOjkIxDAOEsD8zGIf/wJAdQmhtB4GOTcB5iVJkfSPuLW9HsERtmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR07MB6707.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(186003)(316002)(478600001)(54906003)(26005)(4326008)(76116006)(6506007)(110136005)(2906002)(55016002)(107886003)(8676002)(7696005)(8936002)(86362001)(33656002)(66446008)(52536014)(71200400001)(9686003)(66946007)(5660300002)(64756008)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: IjRijlDJBTrMZ7nvnhvU3uEhq4JggLCGQ2bJh4CmgzgWy+O2qC4Pr8sDyTN1EbQNlsKSje7G8/XijSCuTNEe7CZM3MT2TrNPU/QwHwy/NZs5Fa5fW4OOY4XUx/a1YDjZ7qS9yW1WF/+9IEnwRGB6C4OUaT+at7BvndND1zVWvbn8I0KnD6FV9qStV82cD+TFAda6ITeMCRwQlKpLiGnLtXFtmKuIRJ8C3sy6NPr9CGUVAl/JNuoCSoXt526E0EuZEyroUMGGrLudl9Rv494DvM5OFohKr2zEtOqQzAY0wtCV/QFDUc4A+bf5S49WNAaT+v/qSdBvVHAG52dmMyA9+ftSnot4w+wfIzExWQSElmBfyVTh+zZ2icZqmqHY06+YhgpLvGV5uRxJw1k9zOPzLgGD6PcJyenQrIGrbXuDSTn6y5Fj/vdihe458RnEZdVM+uGmffe63KzjpqOFZ3QSkuogy6sbgfzhou3fTBR4SZAizjpuQUFkV3AsdbwGqgVXgBJtaoIvvjDNpqPRX687YI+o1zbdwGGOL3HQMHv9PITwcC0kfhB+s4bL3F1mT1Myzt1md+7AsFH64CUZQRNHLtxbeUUJgp5xPc7apYjm7jOjcTS+2tKxt67m8HFxWiF6NRnv1oHqZZGckb+gV/VYOcvy/8Dl4+fqe4m13p6UpSkOs34l/v5rl7bgXckktv/jDpTjLH8K5Bf1G39x/cnUQtUM8z8SkWdiNCxHtwy8WqZ/jz/5qAXmD1Bh4c+lKGd9ZzlRzm8yp3YPcIj3aJAhPSiw9UHyhmHTdBFs2JG+c4Dcne9/uW4Li3B0LZr60oLn3JwUKSZS0QcRa4yr7njzqbzFsWTM95LWIrkSNySRM/w+ZLK7rXDKRgoTRxh6ODrzSogwO8TDQIG1DtyNbRgJog==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR07MB6707.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ca8b69-2668-46da-3224-08d88babee4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 10:23:02.6086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FklsNaNApjKVWtNZqArbsNloOvvhTS2krzIFvFeWhXl6Waf0fsxxeRf1XylUedOoNlDjnZoSx3pDtFhUX3cvlM5f5SPF52JFcDOAdXuh3aU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB3942
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 903c6bd937ca ("clk: Evict unregistered clks from parent caches")
in v4.19.142 moves orphan_list to global section which is not used when
CONFIG_DEBUG_FS is disabled.

Fixes:
drivers/clk/clk.c:49:27: error: 'orphan_list' defined but not used
[-Werror=3Dunused-variable]
 static struct hlist_head *orphan_list[] =3D {
                           ^~~~~~~~~~~

Fixes: 903c6bd937ca ("clk: Evict unregistered clks from parent caches")

Signed-off-by: Wladislav Wiebe <wladislav.wiebe@nokia.com>

---
 drivers/clk/clk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c5cf9e77fe86..925dd84293f4 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -46,11 +46,6 @@ static struct hlist_head *all_lists[] =3D {
 	NULL,
 };
=20
-static struct hlist_head *orphan_list[] =3D {
-	&clk_orphan_list,
-	NULL,
-};
-
 /***    private data structures    ***/
=20
 struct clk_core {
@@ -2629,6 +2624,11 @@ static int inited =3D 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
=20
+static struct hlist_head *orphan_list[] =3D {
+	&clk_orphan_list,
+	NULL,
+};
+
 static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {
--=20
2.29.2
