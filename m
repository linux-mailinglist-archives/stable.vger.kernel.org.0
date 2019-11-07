Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7665BF258C
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 03:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfKGCuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 21:50:18 -0500
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:47273
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727443AbfKGCuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 21:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wx6cUXi7jNQqG9mRMdxdSQd9FFa9PfFZBzy/YYpB+q7VAEa7oqucObMNDifo2+ep0ocS4BSErwuyyD8pKpoNX2pEi0zfcIqTTnH42xJv6AQUa1N/lchvGdxEnlTWbO4ikNgf0NTGMhbz+SPAX7Dl/B6rqPkf6McaHTtfoKzmWEQ0JMChzjlgs44rslGSbxIEPfIMAOGZrbZsVT0bN/bKCVcm1TljMzOoU8LfnyKv0h4F2TAr316y05M4itkjoB0Koem69Yd1k3FRW9TMgK5i8tDDcNTNQdTgw6vdGRT/FPuEpKHe0wvjiqgDBHi1uPm9DBRzGmSDNkRU/dXSmBJu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unqBt/b/gl1rAw16u8293Z3hbtG8r71fTuyo76w1e0E=;
 b=FUSkOVITwrXNPSZyMnFsy6hrNnFALPopgnMgRMCjw49hx4J97keyyNSXpBIsABona9v8QLU8o8SMp8VxptcL6+xDSQ//R8p/AMhwZBnQKLoiC71pDhPw6yjcac4nFBqRHjF8ms8IPgjb4OD/+8x+r18xIhXoBSQxCtFmVwf9PGO9p1JgkPzuAUxVnUBYUz1g78T5hRzCen55FSWlvu3zy23o1oxuCnb8TTTZaLBy1rXbP51jdShsERvt6Klkh60my3dkI8kZwVSmwXW6k9qAwzb1oRxrGPdwlGhD2E61SyEGlW9sr5IGsNSVBenQ8ai6uDere3pbAHiZfb+u+a94bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unqBt/b/gl1rAw16u8293Z3hbtG8r71fTuyo76w1e0E=;
 b=mFjs0gFYuHjU9dv8AhzBGaUB67Ux0Hb9Xg18ufuAq9FSUeXCA3fca5BG2gXP8TENS9auz8oyf+11DP+QhSbSMDyvOZx16k4AEhT4cbA9PfkJ24hea+TYjilgRHP4LzWMVZvy+6htpkJDNxJymYEz67jZiP4VfchqmMkId5ubBCk=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB5699.eurprd04.prod.outlook.com (20.178.119.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 02:50:11 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::f16d:a26a:840:f97c%4]) with mapi id 15.20.2408.028; Thu, 7 Nov 2019
 02:50:11 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.com" <jslaby@suse.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Duan <fugang.duan@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from dma_map_sg
Thread-Topic: [PATCH V2] tty: serial: fsl_lpuart: use the sg count from
 dma_map_sg
Thread-Index: AQHVlRYSjb10LGdSBU+AJ5B7rW7xAw==
Date:   Thu, 7 Nov 2019 02:50:11 +0000
Message-ID: <1573094911-448-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR0302CA0022.apcprd03.prod.outlook.com
 (2603:1096:202::32) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2339faf9-d6a6-4d4b-3220-08d7632d34c8
x-ms-traffictypediagnostic: AM0PR04MB5699:|AM0PR04MB5699:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB56990BB0C6FD8D913D530AC088780@AM0PR04MB5699.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(189003)(199004)(386003)(66066001)(6506007)(26005)(6486002)(81166006)(2906002)(2201001)(102836004)(36756003)(8936002)(6436002)(2501003)(256004)(8676002)(186003)(81156014)(86362001)(52116002)(64756008)(66446008)(478600001)(66556008)(66946007)(14454004)(66476007)(486006)(54906003)(476003)(6116002)(305945005)(7736002)(2616005)(44832011)(25786009)(3846002)(50226002)(6512007)(5660300002)(4326008)(71200400001)(71190400001)(99286004)(110136005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5699;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oz1GuG5t9QUFU8bMUlOoAvoVs6itYvNijXOuRugtIxdMnT+VQQz4ExWckdvFp8Jln1dxlUuub0e/Km8WmNrEblORuJgULrd+SxaAoiSQ4KfcI/z7K2sdprgnnIqIdTS6rA5+dnHRxv/ten8OZHj10l7EGACdjvqZxLg8254r0G/g5TZlpw3NNwJ9nm9Ltk6xZjOrNEB22SKNnVMFOr/YUFOup4/+ZBcH/fdMwmbkqrxZrOzuz2cUCQUn/B1hMw9jQn++0BnsWrWBNaijhON6IFZKgCDN4aqdJpW3LJuVHMoePAQghjgFDhMNGxzJRZMR18d7I+mGeEfgTPkdgEcMS2cCOV4kh3Bl2tlPqx5vnbbM8PFZNzB4G+jTKbtV5xOF/ziFR2tpXPe4YikfzBPLOaYwG43P/WJ4CxQ7o/BlftNITx7RtrfcIeI1sX/Q8KTD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2339faf9-d6a6-4d4b-3220-08d7632d34c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 02:50:11.2554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/qV7mURo3krD3l81b2PP2mgKfXWgH3JFgMvOKONv9YdrNgK1hdD8B49B4nVt3zvtnX3h/2M9+95zh71ybLFJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5699
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

V2:
 Assign ret to sport->dma_tx_nents, then we no need to fix dma_unmap_sg
 Hi Greg,
  I saw v1 patch merged to tty-next, please help to replace with V2 if this
  is ok for you, or you need I have a follow up fix for v1.

 drivers/tty/serial/fsl_lpuart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuar=
t.c
index 3e17bb8a0b16..ec5ea098669e 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -436,6 +436,7 @@ static void lpuart_dma_tx(struct lpuart_port *sport)
 		return;
 	}
=20
+	sport->dma_tx_nents =3D ret;
 	sport->dma_tx_desc =3D dmaengine_prep_slave_sg(sport->dma_tx_chan, sgl,
 					sport->dma_tx_nents,
 					DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
--=20
2.16.4

