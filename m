Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3AEF51F
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 06:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfKEFvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 00:51:14 -0500
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:54133
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730346AbfKEFvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 00:51:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBMMxG2huW/59S4VwnUYDM8Kvxa/d3vw6v1Kj+LFIgpdWAiti2GUhFTDwKDC3ZGLPuIJOdz5k8wpgESj5g88V0Vuh2rotUSU10T2GfshN4dvOWsbUpjC9GbKiOcewCrTQnyLKHf9J04pJDXUndsNunjCS9nBTYmvzK/IFTGIPfQ5ZHlZhsMu7sxwOAqj+89c1ERWCLJe/KaJdJXbtIXsZEIqOb3I7hXq4r+yFh1ghZtxav0bj0Kb005Lkx32R3Y7hUvLws+byykpBB/EPIeuIeoSa2s/r5YOAdiEMpoRq59roJQW3AhubGDOWOezJ3+TgmMNcLqNlYZWlWg1DwUxag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPyZrmpAPaahxF+qF4gSZaY1kf6h19Xe4R3VQsF9it8=;
 b=klWZXf703drMard1boevbaRTuMEjJPBMSoXehAKvWyakJask7OB07Pcv/ea6C0E74MPa/tyonoCrq5golzCupDiuVz0RFU8ap3/qe3c78FjrGLSzARVcDUqh0Ls+CMQKnCNXjytgz/ZlDIu1aUdNp9s1RT32wwIuitAfSEPOG0UD5IJpbVFpQCtofPt38krjeHxk+119rHM4Bk4VNh3OAWdxg42HB3oMikFG31k6nVZDigEUY7/DDyou7VGVrepyLi++n/wp1NuHAOZK9cAt/akfP91FAgK5EUhAegqE7AsZ7ACqv7aKrAKr3FMkAIQoGhlJ9LS+AC9TgHBc2SKE7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPyZrmpAPaahxF+qF4gSZaY1kf6h19Xe4R3VQsF9it8=;
 b=Y2gNuspCqvJYkwPPlDM9NlZsz259Kkrq+1F6CrMflvDQIoFlNQa+cAbzrv/nze5sg40l3PBAQ58bxeKAQEGnPohCeGv5yivCd4JX4GLpFeUCP/DvvOhWPShrOTAxNtDXsLqw8aomm291CcfRviT/d8zYNks2fRHBzVghE2Z60cY=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB6241.eurprd04.prod.outlook.com (20.179.32.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 05:51:10 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c%4]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 05:51:10 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.com" <jslaby@suse.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] tty: serial: fsl_lpuart: use the sg count from dma_map_sg
Thread-Topic: [PATCH] tty: serial: fsl_lpuart: use the sg count from
 dma_map_sg
Thread-Index: AQHVk50GWgKPiRrVwUSj/ElNagRx2g==
Date:   Tue, 5 Nov 2019 05:51:10 +0000
Message-ID: <1572932977-17866-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0220.apcprd02.prod.outlook.com
 (2603:1096:201:20::32) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b1ab60dd-0507-4196-5aeb-08d761b4288a
x-ms-traffictypediagnostic: AM0PR04MB6241:|AM0PR04MB6241:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB62414AD0D526A8F6B57582E6887E0@AM0PR04MB6241.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(189003)(199004)(5660300002)(36756003)(386003)(6506007)(4326008)(102836004)(52116002)(54906003)(2501003)(316002)(14454004)(99286004)(64756008)(6512007)(66476007)(66556008)(66446008)(66946007)(478600001)(25786009)(6436002)(110136005)(2906002)(305945005)(486006)(2616005)(44832011)(50226002)(6486002)(8936002)(81166006)(81156014)(8676002)(256004)(71200400001)(71190400001)(26005)(86362001)(2201001)(6116002)(3846002)(66066001)(7736002)(476003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6241;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EIQgOMMcuSbMVc+mGDg8VYJAulWFeJSfDaGQ6GjAawTutCWYAJwE+hBPlMGMkKRHbWoXk6LPbK08PHtHQaCZg4kTJeGaPAM4efZkebSoo3bFx05xDvFd1IK1SD8OzI6YODnz22uiprzpeUvkD+Sh8DDxx84SjekBlREvJydO4/3WJv2E0gn8o7UvEJ8VF5JADOF+Y1XRm6blVuUmwUBejkOfEvjBFRb6K1BkMljQA5nRr7VTt0uOEqmF9RwCg8l6jFk8eUMf50auYw9sm2X7gaDtoMlTi7YQgfTnKg8/uAt1VtqtW3svb3LN1uGcDbl4h8Ur0l6vx8+Cz13+BD+hK/f1eFq8w1xv4NR4uLSy3N7/zMd1cbdlbSaI4LSqBY6tqbIr2rqi6vus3IeR5mcLppZJebVzwcg7VCPb2T3rbBYerzoFn/qd0vPfRApECess
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ab60dd-0507-4196-5aeb-08d761b4288a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 05:51:10.3275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0s6ppI741+S/5omhP/Z8XSUP1laq617Nck/JdLamvVeM6Zv3c3qZZTjiBV3LRJEPpQoZjBtVSUwB/nDiK2Kt3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6241
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

The dmaengine_prep_slave_sg needs to use sg count returned
by dma_map_sg, not use sport->dma_tx_nents, because the return
value of dma_map_sg is not always same with "nents".

When enabling iommu for lpuart + edma, iommu framework may concatenate
two sgs into one.

Fixes: 6250cc30c4c4e ("tty: serial: fsl_lpuart: Use scatter/gather DMA for =
Tx")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/tty/serial/fsl_lpuart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuar=
t.c
index 3e17bb8a0b16..3643b8f7a3df 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -437,8 +437,8 @@ static void lpuart_dma_tx(struct lpuart_port *sport)
 	}
=20
 	sport->dma_tx_desc =3D dmaengine_prep_slave_sg(sport->dma_tx_chan, sgl,
-					sport->dma_tx_nents,
-					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
+					ret, DMA_MEM_TO_DEV,
+					DMA_PREP_INTERRUPT);
 	if (!sport->dma_tx_desc) {
 		dma_unmap_sg(dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
 		dev_err(dev, "Cannot prepare TX slave DMA!\n");
--=20
2.16.4

