Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3EACC2C9
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfJDSig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:38:36 -0400
Received: from mail-eopbgr780105.outbound.protection.outlook.com ([40.107.78.105]:57568
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725775AbfJDSig (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 14:38:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpme58YAI+Kdje4mFt74Of/FkZT1+8hbxb7z1qiKBY+hB1p8pFcvK6+2VM09GYqcoudpm5JfsHchhaqhfUnaL1y5iBKMkrdN20A0pBOqBqshEtD06OAHZo7hVxVMfA9oSo2DH7q1gHfenwHdMD5znfrXCRvT9ZIukgGyrIuT2rApD5xxXSJRZg9mYsB3gU/xypKoCAwg+pa6zixeV/Hv39dWLlMtWwD24Aj/u+3vV4BEc/qR2NmnpA+vFlqzl/np4mDP6KD7drfVk4MbVsjvCXllYOMZK4EwG4x1hGOo6G3V6Iyu8PA6Ss3kd6byVapc1LRL2bnswkBsr23b71JFAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmIxy/PjlZyB6WiPy5Y1mXP4cKe/6PSz1vCAtIda/Uc=;
 b=S032L/Hjr5fkvdSJ1kQBkQ7kIVmoP4T3Umff+3PP9seB4Z5hukw/E4hQAjUZli5710eDtZM3emyjfd2WU40MLvVpP5vyjSKmKLI1w41rhjFO6wbEpYlC2R6Ekn2IuEueAl4DWZoefxzgbrf6zvUk8/u0TiJP4BL4vcy9TMWRp3tR9DPPzVkLI76KS/JpH5aXnbbBGanHFMghKOzcqlPUJSB31blx21rwaGUr/ZWVWouZ/ZQHec0j0LhO7Z9TrrE6+Dw+7v/+2i2qxmO18jnCp1TI3yiGzsEYvHJq/6U6p9Ph5WOBzofc5tpc+RFG6zryikmS/jgEmWvniauDolq3fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmIxy/PjlZyB6WiPy5Y1mXP4cKe/6PSz1vCAtIda/Uc=;
 b=uWHUWtpweCeYJcbjpcan8ciixm/0D/p5R/3BKtthZpm83itqlcbMPC0TJ3CM19abHZX/Hq3UTLrIq5bBsqtX5tN8Vo6d2M0pu4wu3AHI9OnvBijbaOvKS4MfbDs1DfsjYta25JjRJgO2XTPrLPGhFCxEr6JH/5DXveUJau+9Uic=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1646.namprd22.prod.outlook.com (10.174.167.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Fri, 4 Oct 2019 18:38:33 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::3050:9a38:9d8e:8033%5]) with mapi id 15.20.2327.023; Fri, 4 Oct 2019
 18:38:33 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] mtd: rawnand: au1550nd: Fix au_read_buf16() prototype
Thread-Topic: [PATCH] mtd: rawnand: au1550nd: Fix au_read_buf16() prototype
Thread-Index: AQHVeuLtostA17/f6UyQ8/BtivUYgw==
Date:   Fri, 4 Oct 2019 18:38:33 +0000
Message-ID: <20191004183706.850363-1-paul.burton@mips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0007.prod.exchangelabs.com (2603:10b6:a02:80::20)
 To MWHPR2201MB1277.namprd22.prod.outlook.com (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f04e93b6-6e42-4112-a795-08d748fa0f77
x-ms-traffictypediagnostic: MWHPR2201MB1646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB16462C0976DF7F6523348FBAC19E0@MWHPR2201MB1646.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39840400004)(346002)(366004)(376002)(199004)(189003)(66556008)(66946007)(66446008)(66476007)(64756008)(316002)(6486002)(54906003)(4326008)(5640700003)(6116002)(3846002)(66066001)(6436002)(2906002)(1076003)(5660300002)(478600001)(14454004)(2351001)(486006)(8676002)(25786009)(6916009)(386003)(36756003)(81156014)(81166006)(44832011)(50226002)(8936002)(99286004)(71190400001)(26005)(71200400001)(7416002)(2501003)(186003)(6506007)(102836004)(52116002)(42882007)(305945005)(7736002)(256004)(14444005)(2616005)(476003)(6512007)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1646;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t3OFo/a0xq/BZZNB32zuWmCYOdnRMRaXSLVWT5nCERy3jthSJ1A2zrrdMSFfRk0Alt2cVK3tuIMd0TImVFbrhwzfEBHRnO9KuV0bzEaduNC2hBCoD6nzCN+TBR9ZC6G039PZ4apb0al+qBPEVFPgiX9QKB9thchbpKJuXhaQMG3kiPgXxKFs5rQiyug/WigQ15fkfHfSBStzPaV67oKdVfUiptZQi0dwjWLSQeW8L1cc46+ggiBc19TyAbYpIPGO71NbMdSCXrvD9ikzlZqwqyjo/X5z521whds+8nS29LZBp24o9yoybMMx2jNXhH5QaGOI628ggYtz1Z7YbPFFKm1XNYO6HCHyrKpKdhcL/3Lv+hMUD5vTfTEJq8IvixJOHD2WbwEacWVyC5aYZmfidvzwIzLzzajOgyENzLuDcWU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04e93b6-6e42-4112-a795-08d748fa0f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 18:38:33.6717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5eSqV3glVtPTgjt1tqDtUpAZh4HL7Y5NXH4ermDaWtItT0iwlvCn55d4sb1EjUL8QkzjXjnVdkzLrBmCDm2QFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1646
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to
chip->read_xxx() hooks") modified the prototype of the struct nand_chip
read_buf function pointer. In the au1550nd driver we have 2
implementations of read_buf. The previously mentioned commit modified
the au_read_buf() implementation to match the function pointer, but not
au_read_buf16(). This results in a compiler warning for MIPS
db1xxx_defconfig builds:

  drivers/mtd/nand/raw/au1550nd.c:443:57:
    warning: pointer type mismatch in conditional expression

Fix this by updating the prototype of au_read_buf16() to take a struct
nand_chip pointer as its first argument, as is expected after commit
7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx()
hooks").

Note that this shouldn't have caused any functional issues at runtime,
since the offset of the struct mtd_info within struct nand_chip is 0
making mtd_to_nand() effectively a type-cast.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_x=
xx() hooks")
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v4.20+

---

 drivers/mtd/nand/raw/au1550nd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/au1550nd.c b/drivers/mtd/nand/raw/au1550n=
d.c
index 97a97a9ccc36..2bc818dea2a8 100644
--- a/drivers/mtd/nand/raw/au1550nd.c
+++ b/drivers/mtd/nand/raw/au1550nd.c
@@ -140,10 +140,9 @@ static void au_write_buf16(struct nand_chip *this, con=
st u_char *buf, int len)
  *
  * read function for 16bit buswidth
  */
-static void au_read_buf16(struct mtd_info *mtd, u_char *buf, int len)
+static void au_read_buf16(struct nand_chip *this, u_char *buf, int len)
 {
 	int i;
-	struct nand_chip *this =3D mtd_to_nand(mtd);
 	u16 *p =3D (u16 *) buf;
 	len >>=3D 1;
=20
--=20
2.23.0

