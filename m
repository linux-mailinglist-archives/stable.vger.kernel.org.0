Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B60C1F36DC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 11:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgFIJSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 05:18:34 -0400
Received: from mail-eopbgr680072.outbound.protection.outlook.com ([40.107.68.72]:46013
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726923AbgFIJSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 05:18:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uncn5GfsBPIr8sU4lemBCCUistKvtintmsIaEvkaT+KzLy7r5mAN9SE9g4KAmrPfamDXzLhSSodYurXHNmWz6CkohGBQsOjB/6HBFlX8UGRiAt2k7ftejkCmPJgLFMHq8yTM06kzOrsimuUdugn2lBBPEbtYZMBt45BYSydrxTelZhUOKJh1OI6lZP6fj1daeYM4LLpbTnvTutmgwJamdWlsnrFjisdCGVCnRG3TH2/83HUQjrzo6JKM2ax4Og1yzJHk/YFqw0bwO7Wz8hMfkU37U/VXauWb29UI5uz94tN749A8EAv5n1rrG0rR53T1QZ+DWnYch6qYAxlPYlJTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9FXM/4Rm6p2J10fmO81c6kmzrDwnV8wjw01f0850fs=;
 b=Zk3CrLsbWYhfXkMf4EPUcrc0IlO0GLMBpFdVKu0Yc4UrCjWoHnHrDzxZhKbnYfPZoFKmS3KQIaF+lDXncxZwb31lqM6OqZihP+HyqPmf5ZZp80NeI///Kk7Of/mrg2PGiaf0fBEqcfZf0iRtVpuufNdgPtQPEsRduuASvyYmPoB8CyBsVFBS2E8cSF4BaSZRCi3Zq2NNWH4ti8SEgLH+BSpZLqm//+Mpky2EiUhvJz77n2m+8P6a9kzVJehQvZH+WBrU70ifOI/6rbBJHAyheuPAb2QzWRzwx/ZBA6Ek0J1H88KjL5MnTD1LzcRqtaKuan36N6veU+NQGW7UcoKPCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9FXM/4Rm6p2J10fmO81c6kmzrDwnV8wjw01f0850fs=;
 b=hYme+gDTKfWOUFKzg6GQ053GtBd1BqkOE9lTAdskmZigTm0au5xjnDL/fmmyeKnpuMG7PAZtQRK8iDQ+XczyC+E2++20AKkxIOJ8jY2Z+gOTma+wlZfW9ABpJB/Q45+126lFIDrfRa/ek8B21OyqRaXHxIbYpuzBt5tVWhVqU3U=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (2603:10b6:408:ae::24)
 by BN8PR10MB3345.namprd10.prod.outlook.com (2603:10b6:408:d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19; Tue, 9 Jun
 2020 09:18:27 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::c158:d59f:e3bc:1941]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::c158:d59f:e3bc:1941%2]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 09:18:27 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Subject: [PATCH] cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
Thread-Topic: [PATCH] cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
Thread-Index: AQHWPj7vE6bGMvPEXUO2kanZKLBwtw==
Date:   Tue, 9 Jun 2020 09:18:27 +0000
Message-ID: <20200605105418.22263-1-joakim.tjernlund@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
received-spf: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.191 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.191; helo=owa.infinera.com;
x-ms-publictraffictype: Email
authentication-results: spf=pass (sender IP is 8.4.225.191)
 smtp.mailfrom=infinera.com; infinera.mail.onmicrosoft.com; dkim=none (message
 not signed) header.d=none;infinera.mail.onmicrosoft.com; dmarc=pass
 action=none header.from=infinera.com;
x-eopattributedmessage: 0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3540.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(36756003)(26005)(1076003)(186003)(6512007)(5660300002)(6506007)(4744005)(2616005)(4326008)(8936002)(110136005)(107886003)(85236043)(316002)(83380400001)(91956017)(2906002)(66476007)(6486002)(478600001)(66446008)(64756008)(71200400001)(86362001)(8676002)(66556008)(54906003)(66946007);DIR:OUT;SFP:1101;
x-ms-office365-filtering-correlation-id: 56a2e7ae-89d8-46f6-7681-08d8093ed2a7
x-ms-traffictypediagnostic: BN7PR10MB2418:|BN8PR10MB3345:
x-ms-exchange-atpmessageproperties: SA|SL
x-mailer: git-send-email 2.26.2
x-ms-exchange-crosstenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
x-ms-exchange-crosstenant-originalarrivaltime: 05 Jun 2020 10:54:29.9128 (UTC)
x-microsoft-antispam: BCL:0;
x-ms-exchange-transport-crosstenantheadersstamped: BN7PR10MB2418
x-ms-exchange-crosstenant-fromentityheader: HybridOnPrem
x-ms-oob-tlc-oobclassifiers: OLM:381;OLM:381;
x-ms-exchange-crosstenant-network-message-id: 56a2e7ae-89d8-46f6-7681-08d8093ed2a7
x-ms-exchange-transport-endtoendlatency: 00:00:02.0055123
x-ms-exchange-processed-by-bccfoldering: 15.20.3066.021
x-psinmdfa: 1.0
x-originalarrivaltime: 05 Jun 2020 10:54:27.0387 (UTC)
 FILETIME=[AEA5C0B0:01D63B27]
x-microsoft-antispam-message-info: pzd+Vfa/JkdvlQYjdnbkdnH2p/jKXjsWfAno73QngvEX6/Zt7TRbS78lIIKXLFZCIf0xfA0fbd/JfErHVxkPWTkfiySVu3DupBzIafaBrzuE+mTsQKRJUdsAOvSWlL/6VlCtnsfZ7mNaoc+ilDqtNtUU+xhR8fZz6EhE6f54cPG73DpZapfeq/7SXmTQbdBzHZF+BqM2gPfbvHitPDDJ5ETz89I+YgO9vneIqf3qyh6oRNUBi5BnNFaU97BRi05KuNCIgnffYyTge6zfseGm/JN9p3G0szXBEWoLkFBWToiKsbwDaygSQQJ2ptCQ928L
x-ms-exchange-crosstenant-originalattributedtenantconnectingip: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.191];Helo=[owa.infinera.com]
x-originating-ip: [88.131.87.201]
x-ms-office365-filtering-correlation-id-prvs: 56a2e7ae-89d8-46f6-7681-08d8093ed2a7
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR10MB3345F0E17921BBD266419158F4820@BN8PR10MB3345.namprd10.prod.outlook.com>
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-messagedata: ipEhc1K+5fARG7+UYOsbxkLOZRpTpWQRsNY0nePrShRlpskGMZO45JGNYJvK4Mk7QRALYYK7wIAQoOSnDmGZKzrWLzdbuvpKdqJR7UYriA2yvp+0ERncar3CLXfx2Uj/ViEqFzkw6MBW6DbOr2e3EVCWMQx4g0GY8r8Kh+OCM/7kMzCavjmnYs/kXeF7QxPJ5SxlTiYHOjyrrOZRvWPOldYUJfcbNDJ32C/0uuutqDL5UOjrAua+egpqcE6mVbc12v8qLxjFZoTdUzW6xR1lTjoL87OxeEuLvUv4RPDAtfLw8rtTyXAnbu3I2upeNfPIlE10p6rD9J4ZnMq4nWcpocmDSW93vmENC+lFSywywcnzeKIR9KvJ0uM8twaAIlGV2gvS9+RbJBzSYT6nCkhhwxlAqoDovms5WZJzt+I6I3bovTaVInl4twAZV/m1jQALCQvDvAfhuvbb0PiZxL8qOfl+TqxGrfkJHHT5uYWbybU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a2e7ae-89d8-46f6-7681-08d8093ed2a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 09:18:27.6039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4DB+B27DiXKczUf+NKPEaHqMVjrherY7ItAvp+shJCcBiAGnt0vJ/xu8dQ6hLYZAlBfOEvC9yBkGNqS+rcXEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3345
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB_DEVICE(0x0424, 0x274e) can send data before cdc_acm is ready,
causing garbage chars on the TTY causing stray input to the shell
and/or login prompt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/class/cdc-acm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ded8d93834ca..d579b05a2c2b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1689,6 +1689,8 @@ static int acm_pre_reset(struct usb_interface *intf)
=20
 static const struct usb_device_id acm_ids[] =3D {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x0424, 0x274e), /* Microchip Technology, Inc. (formerly SMS=
C) */
+	  .driver_info =3D DISABLE_ECHO, }, /* DISABLE ECHO in termios flag */
 	{ USB_DEVICE(0x076d, 0x0006), /* Denso Cradle CU-321 */
 	.driver_info =3D NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
--=20
2.26.2

