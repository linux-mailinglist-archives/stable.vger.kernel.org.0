Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57338F938
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 04:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfHPCsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 22:48:51 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:28646
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfHPCsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 22:48:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1hXOwY0P3tMwMivXTNMP6MYSyZ0E07bv2/qYM7Ya1qtLOLUIMCv2p1I+HYd/7H0XS5QryLWJUCseLI0mpbCJsyhtowKcpSEXvOmXxE1PN1kEKtqqwh05L79Jle25rHqqxd9BUR/JrgXryElgLxOrA/zkT1RpXWxS446VSmK2t9225Pp5M/+zAwh/jyoBWX4VCMcOf+e7Kg4lBYR6KucplqNV+iu8a4m6a4famIW5wg3wdkYo9qXECQjLUyytkfWIsG/4osHC5V5FNNBzmj19B2ZJsTkYJUrvtMCl1+QrIO8C5j96fBjXr743PMQNxuZJS9EgaZAe75CfJEE+AB9ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYQFmKTx8joysNmnY+lm+fXBmKyRuQ4Bg2DaH1c4pSM=;
 b=TI2ns7EBLQUsYZPEJwDLNwB7E15Gew9IyEghaOM/d6wJBJdKxv7FZ7SUpZ3U6uj0s04pojZM0S02OVlULG+OptBCo8bF476jUumU+MFQCCBcdJsy0GBzSMhBXhMyJaVHVoZKUV0U+Jczv7/FE8/7Kc7h3X8+1qeZ5U0UjOvDWPs6mEZV9tQcoKQwoS+oKM7BJlFfF5Gjtr12YO6p2+c8ZMgQHWiZcsLWAIfbolhO2UZbwEykuw+3NX0tI/8TbyOW2+jp87wjpAtf6sfQYBcoRBeKWmlcthYPTByeC5g5m36/SzA/QvT/4thOgq7+xVy49W1tbGTxMsDkVKqR+GqfOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYQFmKTx8joysNmnY+lm+fXBmKyRuQ4Bg2DaH1c4pSM=;
 b=LayS7lz2akKrkD1o31q9p3JMxmU4SbNV52LJauMzKG2hRzBJfAd3vVWrBsh1KH6iSujODEmrQMpe0T+94HjQFblTiqMB9skp0rVIHNGnH9VT8y3dKyWm4jMyo6T3qrQQCSKqj4dmkWst3FdDX2EwkHF6kZCkgcxup8tcqQ4JAfs=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.52.16) by
 VI1PR04MB5710.eurprd04.prod.outlook.com (20.178.126.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 02:48:46 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::81ec:c8ec:54d9:5dc5]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::81ec:c8ec:54d9:5dc5%2]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 02:48:46 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>, Peter Chen <peter.chen@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: chipidea: udc: don't do hardware access if gadget
 has stopped
Thread-Topic: [PATCH 1/1] usb: chipidea: udc: don't do hardware access if
 gadget has stopped
Thread-Index: AQHVU90f+G/ECz0Bo0ykpcSubYzQSQ==
Date:   Fri, 16 Aug 2019 02:48:46 +0000
Message-ID: <20190816024553.8754-1-peter.chen@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: HK0PR03CA0047.apcprd03.prod.outlook.com
 (2603:1096:203:2f::35) To VI1PR04MB5327.eurprd04.prod.outlook.com
 (2603:10a6:803:60::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 560a128f-8ea8-47bf-a04b-08d721f441f3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5710;
x-ms-traffictypediagnostic: VI1PR04MB5710:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB571099EBBE5E4177E2AEF67B8BAF0@VI1PR04MB5710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(209900001)(189003)(199004)(316002)(6916009)(53936002)(102836004)(450100002)(966005)(4326008)(186003)(25786009)(26005)(53376002)(14444005)(476003)(256004)(52116002)(486006)(8936002)(50226002)(99286004)(8676002)(81156014)(81166006)(3846002)(6116002)(54906003)(478600001)(7736002)(6506007)(386003)(305945005)(2351001)(44832011)(2906002)(2616005)(6306002)(86362001)(6436002)(5660300002)(5640700003)(66446008)(36756003)(1076003)(6486002)(64756008)(66556008)(66476007)(66946007)(2501003)(71190400001)(14454004)(66066001)(71200400001)(6512007)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5710;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h3yYzvS+Dt5FXI+N3VJtZLBsqzKpfUwV7t19Qj3wZFp7gDw+D4xlhaamuNgfAGqvlgkUJf9tNUwJ8KnoBpoKYrBvvcT2zYLtiR0NLAr7Z60wCQLUTdZAijc9drJUprTU3eN57urq4rxfNflZTgL/qiwk59WlnP9SU5NLpR8bzAWZEPUVlF6GA/itTIKHBlKD2lVM3af8pSbh6aZ5w+jqbvhAvqOOqhVzROWP5up59IdiJNNYbJnTgFkXrSfelqRgL0QNi154LDJ2/uKHW+JAcWjiL7z6KrMbGq8Ul3CoG9+qECfmAKw1Qh4YZvCwZ0F+SVhmmT+80tVeuwmG5vODJSWDktTEmU+lV7z715IGyWg48TMccC2SN/Tdspe+LTUNKf1twfOPwq8ItLarMVr/V+5YxDNjhUSKdNmlo0K6++g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560a128f-8ea8-47bf-a04b-08d721f441f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 02:48:46.1464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cieqOdR3B8r58u8W6giEMqB/uOEKJ9L1fqwRAR25z+Lm0SBPJAnQi8cy40tps50Sm2I7n0BVpAV6btE8fynVKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5710
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After _gadget_stop_activity is executed, we can consider the hardware
operation for gadget has finished, and the udc can be stopped and enter
low power mode. So, any later hardware operations (from usb_ep_ops APIs
or usb_gadget_ops APIs) should be considered invalid, any deinitializatons
has been covered at _gadget_stop_activity.

I meet this problem when I plug out usb cable from PC using mass_storage
gadget, my callstack like: vbus interrupt->.vbus_session->
composite_disconnect ->pm_runtime_put_sync(&_gadget->dev),
the composite_disconnect will call fsg_disable, but fsg_disable calls
usb_ep_disable using async way, there are register accesses for
usb_ep_disable. So sometimes, I get system hang due to visit register
without clock, sometimes not.

The Linux Kernel USB maintainer Alan Stern suggests this kinds of solution.
See: http://marc.info/?l=3Dlinux-usb&m=3D138541769810983&w=3D2.

Cc: <stable@vger.kernel.org> #v4.9+
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
This patch is at NXP internal tree long time, and no issues have found.
Submit to mainline kenrel.

 drivers/usb/chipidea/udc.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 053432d79bf7..8f18e7b6cadf 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -709,12 +709,6 @@ static int _gadget_stop_activity(struct usb_gadget *ga=
dget)
 	struct ci_hdrc    *ci =3D container_of(gadget, struct ci_hdrc, gadget);
 	unsigned long flags;
=20
-	spin_lock_irqsave(&ci->lock, flags);
-	ci->gadget.speed =3D USB_SPEED_UNKNOWN;
-	ci->remote_wakeup =3D 0;
-	ci->suspended =3D 0;
-	spin_unlock_irqrestore(&ci->lock, flags);
-
 	/* flush all endpoints */
 	gadget_for_each_ep(ep, gadget) {
 		usb_ep_fifo_flush(ep);
@@ -732,6 +726,12 @@ static int _gadget_stop_activity(struct usb_gadget *ga=
dget)
 		ci->status =3D NULL;
 	}
=20
+	spin_lock_irqsave(&ci->lock, flags);
+	ci->gadget.speed =3D USB_SPEED_UNKNOWN;
+	ci->remote_wakeup =3D 0;
+	ci->suspended =3D 0;
+	spin_unlock_irqrestore(&ci->lock, flags);
+
 	return 0;
 }
=20
@@ -1303,6 +1303,10 @@ static int ep_disable(struct usb_ep *ep)
 		return -EBUSY;
=20
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed =3D=3D USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
=20
 	/* only internal SW should disable ctrl endpts */
=20
@@ -1392,6 +1396,10 @@ static int ep_queue(struct usb_ep *ep, struct usb_re=
quest *req,
 		return -EINVAL;
=20
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed =3D=3D USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return 0;
+	}
 	retval =3D _ep_queue(ep, req, gfp_flags);
 	spin_unlock_irqrestore(hwep->lock, flags);
 	return retval;
@@ -1415,8 +1423,8 @@ static int ep_dequeue(struct usb_ep *ep, struct usb_r=
equest *req)
 		return -EINVAL;
=20
 	spin_lock_irqsave(hwep->lock, flags);
-
-	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
+	if (hwep->ci->gadget.speed !=3D USB_SPEED_UNKNOWN)
+		hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
=20
 	list_for_each_entry_safe(node, tmpnode, &hwreq->tds, td) {
 		dma_pool_free(hwep->td_pool, node->ptr, node->dma);
@@ -1487,6 +1495,10 @@ static void ep_fifo_flush(struct usb_ep *ep)
 	}
=20
 	spin_lock_irqsave(hwep->lock, flags);
+	if (hwep->ci->gadget.speed =3D=3D USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(hwep->lock, flags);
+		return;
+	}
=20
 	hw_ep_flush(hwep->ci, hwep->num, hwep->dir);
=20
@@ -1559,6 +1571,10 @@ static int ci_udc_wakeup(struct usb_gadget *_gadget)
 	int ret =3D 0;
=20
 	spin_lock_irqsave(&ci->lock, flags);
+	if (ci->gadget.speed =3D=3D USB_SPEED_UNKNOWN) {
+		spin_unlock_irqrestore(&ci->lock, flags);
+		return 0;
+	}
 	if (!ci->remote_wakeup) {
 		ret =3D -EOPNOTSUPP;
 		goto out;
--=20
2.17.1

