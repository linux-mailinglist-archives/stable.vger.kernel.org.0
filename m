Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AB314363A
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 05:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgAUEgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 23:36:31 -0500
Received: from mail-eopbgr770092.outbound.protection.outlook.com ([40.107.77.92]:49991
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727144AbgAUEgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jan 2020 23:36:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwaRAtvHIkp3BojOfIVAUP5Q/5w/Ogz2UJzTNj+EwwbuIL/J90/NZ5iu4OaQwbho15LgCNC7ScHgXWuma5cUzBuWFRcbx8jOm2pc0HPWC/Dkmaj2a9vpWSlN3HSfA9mE3HtXAP3rKjJZO0FiVImBJZ706dkrg59XaMIBtWmF+rlj1FsZuTXUJnmSsFXR38TCo6tlqfBV6zmiJJzSzDy4HWbCXpgkHJBUjTmTSOrAZul88zCTG//TvoaY/Q0yYgxnXU/VxLquL2AWU52wympnekJyXcvw/g4U6GPUvtejjHCcFxiumEdTKKAqV7YN/L0pPc38+rca64cygY+s8KuC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynRKzE09nmUmoB0p9s5JHASZWWJL+BO34fRO8nF7i0s=;
 b=Bu6pmdwGv8RNljTH+QSZU1UQamFMPNfoH3ZOUHvtlFynFIYBOgZn1O+wE/82XKUNC8aLTufyQQ55ExVPg1TmPKuOmZS/z1dK7GDo1JTe9ocHm+l6jqLejk7NbNPl5T+Pe90K574KQlO0Tm64Tp/kyioeJUgIg2bUfLFbeJ8XZ+hYrzeVMNpjkdH/CT8kARZdEc80EwDY8GVcysAK+hm/061SQ7bOxMYTYqTmpNihGOKKoGsKPbg4memJ1L6bQSVaNzDp/DTOx0GrjWPDK6TPpdbgB6flmF2gdcqUKw/Jro4yXKPcUBR1fgKXFP7ceZ2ys1Y1Kwg9nqn+pkntPDu8MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynRKzE09nmUmoB0p9s5JHASZWWJL+BO34fRO8nF7i0s=;
 b=iPPheTWEMZgo+BoKcRjoNsNqu6CFoh3ynSe4SPiHKbN4gVi0aBGcTPCv2zUBw72gotkTcZ3Hk4U7jRdcSYddlgm+G+/Bc5hxcLgMKEkVNbJyxQIa+iijBTJegneLUvWQ/V+ltc+xmgmPETKwRUaUl7axgryuNN/RUjYFxzVf2h8=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (52.132.149.16) by
 MW2PR2101MB1019.namprd21.prod.outlook.com (52.132.146.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.5; Tue, 21 Jan 2020 04:36:26 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::f1bb:c094:cb30:ba1f%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 04:36:26 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V4] x86/Hyper-V: Balloon up according to request page
 number
Thread-Topic: [PATCH V4] x86/Hyper-V: Balloon up according to request page
 number
Thread-Index: AQHV0A3GBUzuwrNQPkiQ3m+XvSCqe6f0iE2A
Date:   Tue, 21 Jan 2020 04:36:26 +0000
Message-ID: <MW2PR2101MB1052B2248B0F9B92F98A2201D70D0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200121034912.2725-1-Tianyu.Lan@microsoft.com>
In-Reply-To: <20200121034912.2725-1-Tianyu.Lan@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-01-21T04:36:24.8335169Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6a5b1614-bf9b-4f69-b1f7-1c86ace96c88;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a599d154-172c-4e45-dd20-08d79e2b7a53
x-ms-traffictypediagnostic: MW2PR2101MB1019:|MW2PR2101MB1019:|MW2PR2101MB1019:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB10194A8BF9AE1F51F97985BAD70D0@MW2PR2101MB1019.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(26005)(186003)(71200400001)(66946007)(6506007)(7696005)(2906002)(33656002)(64756008)(66556008)(8990500004)(76116006)(5660300002)(66446008)(52536014)(66476007)(4744005)(10290500003)(55016002)(81166006)(9686003)(4326008)(478600001)(316002)(8936002)(8676002)(81156014)(110136005)(86362001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1019;H:MW2PR2101MB1052.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ms8ZSm1mmRQNr3/G+ohA2sbAs/Ti02bflejUMcxKV+xuuorogtZf5ZBpyJMUnDuNBu1PasGujwUZqzVqw2f8/Lc50UdLb8NebxhcoxBc4nScDzVdxxxk0cOUKzwNiFQCQjIRClx7Ml2SMzh8jsouQFP9+yq44I1Zw+9JUbtLJ6FGf1D2dXCAv/awBtQFcNmZPcSL/Gl6eHFWqIVZLh70j+g0qAxXA4C9G8ZFcxFWAsOcuxSANbYk75zoShpoTzVP/ik1GNHEeaX40inl+0YYjEHq5pd11i9zJa4qbxPnO1cCmKmIGe6x8ZcteKaJfsZIkEBhcH8OyxHk30RtJWOP5MWIhQdFwwOv45zDj19+tot50kW+gte/MtXlaXrlaiadn4uLAddLwUxDjVVuj/7CVKpbu6XSpNlRWDYojzGU0aQ8bA7I7AXdvKppIWJ5to3g
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a599d154-172c-4e45-dd20-08d79e2b7a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 04:36:26.8014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqThfqFqPuL6iRci4NrwUA2IA5QcUBrA9QIrXTR1vJynSJskP9W4uQ20qyBrroBPGgK8izZgVkeJ2MatZjK7E+T4n9HFJFegiqV8IybBC4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1019
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com> Sent: Monday, January 20, 2020 =
7:49 PM
>=20
> Current code has assumption that balloon request memory size aligns
> with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
> balloon driver receives non-aligned balloon request, it produces warning
> and balloon up more memory than requested in order to keep 2MB alignment.
> Remove the warning and balloon up memory according to actual requested
> memory size.
>=20
> Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of=
 2MB memory
> block")
> Cc: stable@vger.kernel.org
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
