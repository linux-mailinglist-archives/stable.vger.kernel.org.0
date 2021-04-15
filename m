Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D3736022F
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhDOGOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:14:52 -0400
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:53521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230164AbhDOGOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iob6gF2F6AXLN9mRe415XPvMGKC2iSErh9hyyW9jW47wDW2Dv2Kr3mcT1rDVqziK/OPNom8xG2IGSDLjABHehP1jRzL3GDbtA7sD2gfhiipVkzxT390jGXyx4NCrIpAg2KUdWSOKWU/xpy4UhL3gPAPmGaf/uwFcGZzjHPG6+DPaw5TXpLlaciNgojIRPr3KXP0W8pbJntx4TIOGu7dMtk04d0Wyk0REG2ARKU2TeSMV3K3mAP+4x8hWbIaKiKKsEopF6jVJRuBeuv0Dn8nEMjCpdS3IJ1n34nXCiaJK/X9xgz4lBHhEZrSqzRMi6k/l55QwM3nwAACvStZS+Bgy+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXVwoGZXSzr7g7YcY3XcIS8xhWc0YEdX7NgvlFAgyno=;
 b=aGZRu5gp0ExhGo7ypap9FnYXt97Ep7kgvLA+yhYeDqh8G37pFBJobWhntknGRYBUXG6pRhC60ulP1bEkRP0VUXs071wcUs+4fiwknRHnROwhJMG6Shs/JB21eXqYGXWSPtaD10m1mCOKrUUC1JhsNLCX0o+lfmXOCWbTI1EN1Vu9JB6KH/SYrfxXoDSZOrMp1rXA8fasuYv5sQN/ac9o6KO2mnS9Z32SjN8eLM1F8nsOdEWZW45sEbRJm9Gx9Y0GnaiHyUVZ8VCrECs3cZHcMHJsNG+CYx6CoizmHGnxiNlcIpzJM7AphZz6UHIBj7pvI+dkdy5Ha0VYmCagAu6aSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXVwoGZXSzr7g7YcY3XcIS8xhWc0YEdX7NgvlFAgyno=;
 b=xl6Rw58AIowGb1XD32qgsan17oKM3VSmLV/0L6PxgI/dnpX31dqzQMZESG2Qys3P3YEVF6rRfPbfKZAPs16jvGRacQYiLU4EO08LDbLpQhD0hheVzbb9hF/0XW4b1fxVex/8GUAUFG9+iK37sDPYFd4YgpQaBle6U4vQhPqU/cc=
Received: from MN2PR12MB3246.namprd12.prod.outlook.com (2603:10b6:208:af::21)
 by MN2PR12MB3213.namprd12.prod.outlook.com (2603:10b6:208:af::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Thu, 15 Apr
 2021 06:14:24 +0000
Received: from MN2PR12MB3246.namprd12.prod.outlook.com
 ([fe80::acb5:5763:d5c1:b756]) by MN2PR12MB3246.namprd12.prod.outlook.com
 ([fe80::acb5:5763:d5c1:b756%3]) with mapi id 15.20.4020.024; Thu, 15 Apr 2021
 06:14:24 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Topic: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Index: AQHXMQbUyHYou0SCfUyu35B/FPG9paq0MyIAgACQ74CAADFIgIAAIntQ
Date:   Thu, 15 Apr 2021 06:14:23 +0000
Message-ID: <MN2PR12MB32469A56859E4C72BC92F8E5FB4D9@MN2PR12MB3246.namprd12.prod.outlook.com>
References: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
 <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
 <20210414162408.GC2448507@dhcp-10-100-145-180.wdc.com>
 <BYAPR12MB3238609A9A142C8A03AA587DFB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210415035915.GA2450149@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20210415035915.GA2450149@dhcp-10-100-145-180.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=1f3dea7a-ad0f-42f7-9664-68d2cfde4171;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-15T06:02:56Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [180.167.199.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3ea61b1-60a0-4f6c-4754-08d8ffd5b751
x-ms-traffictypediagnostic: MN2PR12MB3213:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB321355DCD7832E2E707D0F67FB4D9@MN2PR12MB3213.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hV2ebxBxvMI+6rRrdOrWgCMHRbSvrGPXnpCpubVefuZqnBmBtU8Y2PXHs/U2HBLLx8oISgAQqD5tLTG5LO+iPxEdS0I7+OmLaC+i4V+vXQZu0vnqvYv3xt5JRbUxUD7BXVc+WdSKqlU6Jc/j4fcAtCMfw+jfQInwf8Z1howSw3pVhq4c2cPxHC6nX+J4flT0FfJimy+GVjBDlJpOnWVZFbjoKrpxiFbHyRHsSbwVHs6PEJUgiPqvoK2gkSQNSr5Eaci+T6OVTr+eoc4dM/mbbWqtMkxtQzpyJjDFwxUDr4SWP0WmAzsN1BguFwVMcIC6oafYZUlr5kmLIY6tET5pj5p7LJK+NM+/K4NeKOzgSPugwlXxIbZW9IwRamxIwLo4nyOJH3ez0GWfNJb19NxZMoz6T6tUtuleLgsm5SkTl5zBOfFCzY+Agp9kzvcSeT6j5akoFFpZlkb6sC9REeL1dxKC2Mu9aKllWPNfSnDSuZPNispPxf2WskAf8iVj8NBII9bLl5ylEXCNCLK4uw23sBeehB87wiXH4Cq4s7qoZkQLXz+MUrSwKQhKe5wQzsbxYCHAMyADh841r/IG3Mr1oz2UdJdxxVKREI3guOzxPgo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3246.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(33656002)(66446008)(66476007)(8676002)(64756008)(66556008)(5660300002)(66946007)(8936002)(71200400001)(54906003)(316002)(76116006)(7696005)(122000001)(15650500001)(55016002)(86362001)(26005)(478600001)(52536014)(6916009)(38100700002)(2906002)(6506007)(53546011)(186003)(9686003)(83380400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?srNW121MnVgOu2BPN3y/xqnI8bLTf25cDXKzpwz4N8Y/GikaZJLgg4woHQ8X?=
 =?us-ascii?Q?tLb31jjoc6oyFK60cHynp+x7viRNVhTAFJxOAPZQok7B5m1DC7xw+a2bMZrN?=
 =?us-ascii?Q?wSpxV54xDiMJBCAy8TfFAVDVhb8jdriRc/fOBb3RAHJ+gcWqzGOcHFMiozkV?=
 =?us-ascii?Q?eJYsGT2tQaYniNzyW5Urv85kTfMQ1M+69qbYnisKQm9mWvPJ80vrVYhcOpVQ?=
 =?us-ascii?Q?xZcG8tGAzWi9IYKeUYOCgMQkMBz255tQxSKnFwVd3AvuEW1vErJ0vjD/SlIp?=
 =?us-ascii?Q?zOa1Hj6EltHd3CpSYd/erVdoMhBlsBwErh6Lk738NCX+7mvr2pC2U7ceCQTG?=
 =?us-ascii?Q?KU3/TlL1Sib/z6UhsF7jcjrc+Ye9Bd30gD9SI4x8aBLJmJt/tvwswZ9LyKOC?=
 =?us-ascii?Q?TTdxf7kEVO5ZY4BYPkncSdmQqQHz1aOf+XKmqirVYFpaZaN2d1hNUUh/z2zi?=
 =?us-ascii?Q?trWTY1pE/eR9K/B8dQMlYHLlJZEJZlEMgSzvl5OvI1WSziQVTGHwVQ9IVyV/?=
 =?us-ascii?Q?v3G7WGumWA1bc/pApJZ3LnpOMQkg/bMRHLS3fbma/eUYEwn1LHUeK/RcySen?=
 =?us-ascii?Q?AtTkXmOwkgpFBPkmmCUab5UhNYj6xNKViQmU0PwYX6NoEzdBbUV0T2FuLBl6?=
 =?us-ascii?Q?OtL/8SkYD91EygPMwCYmTrRqkf8RK2Y7lPmd8Q25ozTGbVcZFa2Rqph7S1jP?=
 =?us-ascii?Q?25Tl9CcX/Dloqj+Ohz2hUlUMMyv9MS2L1mwJl9ZCV2NoqTqEUaM2/J0R7hkR?=
 =?us-ascii?Q?GVuHPtkGrAPeDkph8As3sQkbPMiBre/zLWUSfCSRtJvotNqtJpLoxAPyRWsM?=
 =?us-ascii?Q?KwnKS0txidc0EKWe39IQKk0PfQMvQS9qZynypzIRhY1RBA3E2UlrKEoliO/j?=
 =?us-ascii?Q?rUoRMwWACyhWHl6E05tWhyVs4Xbcse6nrUfJLAntfgJmy+uPWpkKHjkF4ra6?=
 =?us-ascii?Q?r4ZdkJDoBsL7Yti2aMyS2U78cfXnPffEPQ5Yk5bky8m6ZXeYX/Ecpbpe6s/5?=
 =?us-ascii?Q?gkT9pC2eMKZE2msyq2ohSrfxYYsjOGeUG6AgUw0yNZJLI8t+MVXEWlMtma+c?=
 =?us-ascii?Q?df+z/Tcvw68sEY9WhbvGgKNU4E+8O5XiJaIOwasm1DnBHf7o1E1iA3Tisi5t?=
 =?us-ascii?Q?aeZ21Fp0PHoLs/fIQwkbv29Nlu6DKS2TRVXk/ujfk5f5uFU0RwrdMROpHerB?=
 =?us-ascii?Q?aWeZyGGXw6DHz5NPIE7AMceX4g90c/0cpWgahp+OlZWGIL81NBIIMSCdX5kB?=
 =?us-ascii?Q?sVsYjwcI6Zp+Hj8ViGx96vhvR42XShgTjLOnIEalFc1fHFql33KUOmchcncH?=
 =?us-ascii?Q?swCV9tGB+CLbtFaMtbKd2nhx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3246.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ea61b1-60a0-4f6c-4754-08d8ffd5b751
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 06:14:24.0110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /rJycoMBzE0ptCbCJZ8j/djI9QqugZDrUAHNtKCNEDYBWySLRjRwMN5a2Q2bNBKR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3213
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Keith Busch <kbusch@kernel.org>
> Sent: Thursday, April 15, 2021 11:59 AM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-nvme@lists.infradead.org; Chaitanya.Kulkarni@wdc.com;
> gregkh@linuxfoundation.org; hch@infradead.org; stable@vger.kernel.org; S-
> k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
>
> On Thu, Apr 15, 2021 at 03:22:52AM +0000, Liang, Prike wrote:
> > > >
> > > > +rdev =3D pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> > >
> > > Instead of assuming '0', shouldn't you use the domain of the NVMe
> > > PCI device?
> > Now we just add the NVMe shutdown quirk by checking the root complex
> ID instead of adding more and more variables endpoint NVMe device.
>
> I understand what you are doing. I am just suggesting this quirk use the =
RC of
> the device in question rather than assume the RC is in domain 0. I realiz=
e a
> platform will probably align to your assumption. This is just for correct=
ness
> and should look like:
>
> rdev =3D pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus), 0,
> PCI_DEVFN(0, 0));
Thanks, I confirm the device domain also enumerated as 0 by calculating the=
 NVMe controller sys index and will update the patch.
