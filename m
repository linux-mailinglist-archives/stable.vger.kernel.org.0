Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF7680013
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 20:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406614AbfHBSNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 14:13:15 -0400
Received: from mail-eopbgr1320111.outbound.protection.outlook.com ([40.107.132.111]:28608
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406250AbfHBSNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 14:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKqHZgp+EZke7rbVxWEK94XyZq/wOKMx0NpnnB1UzyNM19ggMmeMPfMSnWhKojuTA9SOwgblt/XcDoCLI6ztVat48gFcjDKkbBgFolqI/PB6zvW7XEEe1seIZ6KcpKkEVO6f3VMxvZ+vC65TRJjXJbSYW9S0Aybzuqw51yhxTcJXI4HTyg0iZzfKUWGlrpzXgtgTRXqOSLI4Py1mtQFqTV9kWfwoA7Jmm39KWbsAUYroFmQHd2OcO3IYN+ONMDKCnlRie1q6IHEqUhytr8bFMNJKm+zmXoWOagBo3a/3Lc/b9zabbBk684ch94Q2gTa1duJFA5+t4oSsO/Ig4xOEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+e5itCCD7ywxr19+s2sVzE1D5JA/cfNT6ET4VizZXQ=;
 b=Hd4v2PTnQljnkezhtAHBg36RViuumIcuWhQG4mS0YPN8gcdwUYNNoGa7i87iPIVxgiSNofWYP35ih+sCrqbTLXrYhltoyEterL6gGhe2B1Veha47ahgpB+lCpa7JgElMhXDtfnAuJLUhjSPM9sJise9I4ngOAHbzi+n3eUY3CC1lmmI1X7REhKl//eTnpRaA7fVEPYpNBIHRFGXoSU4Ly+GU3dV9d/19TS4Z+rOxyAQSgOFHWXj76KCe1oNH4b2cbhNs/jBHExUE+d1z8MnP4VSxFRNmEYOA2ZJ2UYZsHdwJyawbqyfou7eSSlQeZbqPyfVh+8Mb6Wbh0s/UqHg7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+e5itCCD7ywxr19+s2sVzE1D5JA/cfNT6ET4VizZXQ=;
 b=aI4l2QGunms5y72WNQnz2pnkKbfdVt7f7buazCizbvHkFTAfVqL4M1OCmOqYo/jqYH8UoRfjoJ5B4VixI3FpP+AhOT+BY40wty7T5WKuqkAd5CO2PmJGo6Ba8jTrMq2lS9bD+2LtnqQTniDv3XvfjDmip8OXtGJ3dT8na2C58e8=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0105.APCP153.PROD.OUTLOOK.COM (10.170.188.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Fri, 2 Aug 2019 18:13:09 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::d44e:57b7:d8fc:e91c%7]) with mapi id 15.20.2157.001; Fri, 2 Aug 2019
 18:13:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] PCI: hv: Fix panic by calling hv_pci_remove_slots()
 earlier
Thread-Topic: [PATCH] PCI: hv: Fix panic by calling hv_pci_remove_slots()
 earlier
Thread-Index: AdVI0ZE8ZG/OuLUpRiCFkuQ9gvUCcwAi7BwAAAAbHeA=
Date:   Fri, 2 Aug 2019 18:13:09 +0000
Message-ID: <PU1P153MB01698E1925212D201C07E416BFD90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB0169DBCFEE7257F5BB93580ABFD90@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190802180817.A206520578@mail.kernel.org>
In-Reply-To: <20190802180817.A206520578@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-02T18:13:07.1594604Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=68e854ba-e199-403c-8959-1440b948a593;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:71c8:ee0a:27d:d7aa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f513358c-6a1b-4a80-c7c4-08d717751347
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:PU1P153MB0105;
x-ms-traffictypediagnostic: PU1P153MB0105:
x-microsoft-antispam-prvs: <PU1P153MB01056BB544554B193A10EF89BFD90@PU1P153MB0105.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(11346002)(486006)(5660300002)(52536014)(4744005)(8676002)(478600001)(10090500001)(8936002)(4326008)(10290500003)(71200400001)(74316002)(64756008)(76176011)(33656002)(7696005)(53936002)(2501003)(66446008)(99286004)(66946007)(186003)(66556008)(81156014)(81166006)(6506007)(7736002)(102836004)(55016002)(9686003)(68736007)(256004)(2906002)(76116006)(66476007)(229853002)(110136005)(8990500004)(6436002)(14454004)(305945005)(25786009)(71190400001)(22452003)(476003)(54906003)(316002)(446003)(6246003)(6116002)(86362001)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0105;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gUs5L4QN8gT0zv5O+Vj0Qq6azA738L8S2Lg3McDR8Xv3FoRvt3JJ5Qmsp1KjzajPIwMyHtPhJSG265uN4KMW4v/b+XuxkNl+24FnoFZlyR+hnkQw5wq7SYpKN2umIu0zj3ZV6yks3PwCC78NhqEIu/HCXKme5BUSlyouart3feQokhxrkqUlT6ssXJcMT8t+nyRmVTm1bb3rMnDDAlwRCLUgRFOSMn4eTeFZE1fbQox6nrpDLyb5WQdNvvDyHAA6q+xijLcENWNXn15IG42my8NXXuX1JSR6eI/bwZ9ModxCAYEeOelM3gGRDFkRmCBpjtiyzQeAhtFZWYv5B6o2XKHDX0Oraq/6mulXF/0Xoowuv9KacGS+4mFFpHSRFl7rdLrB5n6WxchbkaRWqWBNPYrJADWkmKtPQ16I575hqI0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f513358c-6a1b-4a80-c7c4-08d717751347
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 18:13:09.2871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FcIn5hRrvv/PugbWYz4sjc4AgikgOrb1BdbptmEtAQRS9BSqDs7mTxh5R0coVOgIGLNA7FNPfC/vU3DB5gsmPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0105
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Sasha Levin <sashal@kernel.org>
> Sent: Friday, August 2, 2019 11:08 AM
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 15becc2b56c6 PCI: hv: Add hv_pci_remove_slots() when we
> unload the driver.
>=20
> The bot has tested the following trees: v5.2.5, v4.19.63, v4.14.135.
>=20
> v5.2.5: Build OK!
> v4.19.63: Build OK!
> v4.14.135: Failed to apply! Possible dependencies:
>     Unable to calculate
>=20
> NOTE: The patch will not be queued to stable trees until it is upstream.
>=20
> How should we proceed with this patch?
> Sasha

I'm waiting the patch to be accepted into the pci tree first.
We do not need to do anything at this moment.

Thanks,
-- Dexuan
