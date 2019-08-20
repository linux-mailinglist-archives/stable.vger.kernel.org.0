Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21719540B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 04:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfHTCIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 22:08:42 -0400
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:56194
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728719AbfHTCIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Aug 2019 22:08:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6ExexYSSjyZ24oj0L/VKmuz6vWx/mIuu5swxNqjsoSiQTmIM7Pow/ZgB57/7aknA+yPms8V48tt+3MKZ9rnXz2DrzX88r/dSczEJrIpaFJ+f/xo6vp2/lZjTInUqB6r/6Bp+4rBQ43exgWQLYpaTmBMyLPDrZVfcNP4E0GWe+wgcE5Oe34E8582wFgjFYIMRg85haC8hUF5Ua8iTma7UeLLEKlKcSaSvcoxDzpY+xTaw9GKHOSfeeOWBtqk7PMc6D4ErGuiIt9r6EXTzW1+woQ0cAYWnOVsaB6/iK0kaVdJJ5zdp0utAxvOte+5GvCLQa7UPDkbKoi7LSt4uXHonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYQFmKTx8joysNmnY+lm+fXBmKyRuQ4Bg2DaH1c4pSM=;
 b=BdT32rArOQffFdJMIcOAO72yg0uND0RWPZKopG1mc+iObLK+pg0hll3j9PdMac+qKWymo5EScp88jBI6G/WL/X8RNh4N08iutSgpnZUGEqjQO5to5zQjOCRWygEMb+Zn8SI/TLJxyAl42iQAVfkHvRH4aPyXBTIcKq/txSjbwMW3dsxK/pE6C0LRzapbm4vGx6KDi85x6QpdISMk/Wj5EBzCgBTIzjRoDNCQdwUNnrjFHUyC3bVRaY3rqdl/V1oR1Y5l2R1lpNCr1dRmxYcARiN1ZyPLXk9WBMaRzMe5IOXG0cYH6w/AqNmaxf/6p3GljUOmnbtOCVghjOaM/EXpeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYQFmKTx8joysNmnY+lm+fXBmKyRuQ4Bg2DaH1c4pSM=;
 b=RhexRU+MH4SaTOnGHWu9NOwCD9ORFryKCsWhC+LOtsVs3ntvIT2sF4xa0vcubrhSg7iJkAXiXSj2QPc9h5Q6WySORltdlil7UBnLjfK07aHhVc9pFFPY0d0wTx/7o9TZ+4IsSjCNpU8RqGVzD6it5BWBxZNjS6/2EXxAk/0bsfo=
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com (20.177.52.16) by
 VI1PR04MB5151.eurprd04.prod.outlook.com (20.177.50.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 02:07:58 +0000
Received: from VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::e039:172d:fe77:320a]) by VI1PR04MB5327.eurprd04.prod.outlook.com
 ([fe80::e039:172d:fe77:320a%4]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 02:07:58 +0000
From:   Peter Chen <peter.chen@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Peter Chen <peter.chen@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/1] usb: chipidea: udc: don't do hardware access if gadget
 has stopped
Thread-Topic: [PATCH 1/1] usb: chipidea: udc: don't do hardware access if
 gadget has stopped
Thread-Index: AQHVVvwWTQ6Qj5K1vkm21gPuuE4jQg==
Date:   Tue, 20 Aug 2019 02:07:58 +0000
Message-ID: <20190820020503.27080-2-peter.chen@nxp.com>
References: <20190820020503.27080-1-peter.chen@nxp.com>
In-Reply-To: <20190820020503.27080-1-peter.chen@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: HK2PR02CA0213.apcprd02.prod.outlook.com
 (2603:1096:201:20::25) To VI1PR04MB5327.eurprd04.prod.outlook.com
 (2603:10a6:803:60::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peter.chen@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00e3a9f6-c898-430a-88dc-08d7251338bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5151;
x-ms-traffictypediagnostic: VI1PR04MB5151:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB51514BE375B027B4130C722C8BAB0@VI1PR04MB5151.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(209900001)(199004)(189003)(50226002)(1730700003)(36756003)(6916009)(5660300002)(186003)(7736002)(66446008)(8936002)(81166006)(6116002)(81156014)(66476007)(2351001)(66066001)(71190400001)(386003)(26005)(66556008)(6486002)(5640700003)(6506007)(25786009)(8676002)(2906002)(64756008)(66946007)(102836004)(6306002)(54906003)(6436002)(99286004)(316002)(6512007)(44832011)(305945005)(2616005)(446003)(1076003)(71200400001)(53376002)(486006)(86362001)(476003)(478600001)(52116002)(3846002)(76176011)(2501003)(53936002)(256004)(14454004)(14444005)(11346002)(4326008)(966005)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5151;H:VI1PR04MB5327.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gbmdlv8cfY8hvHsXJ7s4uO9YoE61dNBMnLcltBntOukGYlcBvX39q8q0ReF85TK0JdhCds7o8+4YZRsAbG5ogTm3xOWIf65Kn4qo7OC8muByYEaM+EhTUPLTK4+rSzR6sDIDRp/++S5wgrG+DSNMSzocopSW0yaOzHJNHpbr/ZJjJL3lSVmF7m7qBMkpSaFjsMiuzixcFkanHE19D26kaJCVZf2+wd53tACDULqyubeSDjpKtlPO68Co0YAC6sNgObKYJYyFctwHi+iZjkhVQTvltW/5N0w926NbVL0cZou/cLiMmRpOEh9gOWWMYUiRtxCSrSE9TFrUx1bbbH1S4R+c6ODux1Ba9RFpCGcqkMRNjaAivyMLwMlLEGgSF1NMRZk8n0E0UqIJR/3JntewieTh3r7W2JumYKVZNANhozI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e3a9f6-c898-430a-88dc-08d7251338bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 02:07:58.5353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCwHfFQFDUX+dvbpMW4rjSRwe1ftwBzOXTkcN78yPqr1pDfPqxu8V6SsserzxUpezvqXIHgHuouY2nnbn6/yfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5151
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

