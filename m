Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A133374DE8
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 05:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhEFDXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 23:23:37 -0400
Received: from mail-dm6nam08on2046.outbound.protection.outlook.com ([40.107.102.46]:44363
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229725AbhEFDXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 23:23:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Udo2ZNhkUnsGjJ6CjTdGUTbLIEqrZrL2EhFRGojRB3NfOkRcpuLixak91lqSNNRZLvKQFvJEn9fpSS9ncibwttcMhyuKlTGJxb5ibDJAw3rWXZ8c7Y2UEcQO66I6R8Mr6QUDmibYTvPh8TzjlsLBH3U27lnA+7sLw7iHKyH7XolYOMH5LbuKnAP/2/FswlUp3vkQqoUz1jMPY6hza1/n1SmFz3VGwtvcdvdrVaRM9IytoQNXS/IomAEf3Uimoa2f7evMvU2bjF5syX2HlqAAotbzPGfk9KkjFn657N1EImCh3Ko5JXCKZyEcO+vMK2P6y2vNMptju5EHFwPaafTb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrpBLI8bECFiBcFNqCQOQPP5XwU9XbuMVmYh+J/9CEo=;
 b=VXhiLQSbUjn88yxcfxh0JEWt2iinGYqnRoFjSFM3EQu7x79z+BjRssIx2ttB0EeKDAaDEr9soHw2fvhxnCsWOJD4fCtIwca34hLcnLhUthQhDKSpjIyaCBJtitFwTy9ApBuguxG2bzVtCQja6BRWzgjMyoOnVPo6FFz/oBf82L3xKHKKQMLE6f1s4hIi5bovDAap0yrc8cjlQtQYz7E+v721faS+5jeQHzNz3JwKW3U9VRpd8dvhUu4rJtpXD6RJ6DpzVn5JwNYKxuNFLAtxA86gvwwYN4ZW2XfuKottYf3sBg3y2UkUNuYJW3gxZ5ro3+8UMIgLWrY91G+WL9XbCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrpBLI8bECFiBcFNqCQOQPP5XwU9XbuMVmYh+J/9CEo=;
 b=GMRZHWNd6yTxCtCodfW5+G18ACKatzsyHHY81o4TKNFyiBcQgmrLta9xDfzItbHXFFgddRQPuSmGAsNDIP5V7wmBL/FTMP8J5d+mliPYzNRQloZhR9ut/v2KvWNMIrjx1Equ53TEvYvLDhjTYZHbVEdBqRp/Rp2JyKRAuI0GCZY=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3384.namprd12.prod.outlook.com (2603:10b6:a03:d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 6 May
 2021 03:22:35 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::ac06:4fe4:c52f:bdd7%7]) with mapi id 15.20.4087.044; Thu, 6 May 2021
 03:22:35 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Bjorn Helgaas <helgaas@kernel.org>, Keith Busch <kbusch@kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: RE: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Topic: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Index: AQHXMarUZvDSGRepoEyCkC/coFRS7qrNb1+AgAQFGoCAAIFXAIAADuIAgAPkOnA=
Date:   Thu, 6 May 2021 03:22:35 +0000
Message-ID: <BYAPR12MB3238EC0676A8A7AF84270660FB589@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <20210503145702.GC910137@dhcp-10-100-145-180.wdc.com>
 <20210503155018.GA910672@bjorn-Precision-5520>
In-Reply-To: <20210503155018.GA910672@bjorn-Precision-5520>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=ea4ef123-ae11-4910-8235-29cde4a038cc;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-05-06T03:17:18Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77d61698-7ed6-4a17-5c87-08d9103e3163
x-ms-traffictypediagnostic: BYAPR12MB3384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3384FC2076D1BCA6D1DABF0EFB589@BYAPR12MB3384.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQr9wH8FNBMmJb6GOM/rNqpOlXOiw81ixGRHNrhHt9w3F4gxez5VCEZ3Of+17fB3x4CGcV1PBGpkTx6mZwxgAchpQLaGlFJAQE2EAcz74w1eS5FAPzQtIkvgahMv4qgRDlcIHXFkDaLtmROLBto0TndjoDrA4Ss7adi5yCVpn/PJzU9W6+zlRi/BbcKmb8JUHFQ/ygyCrdn8wIMfVwqdzNBDFyQT64qRJeK6XZhOVl8ygXa2epf6tjdzN/iWR8FBLCJgUBX9eBUyjEnmC8kpYppEe0k11nIAfcCok0HUAh6Fpeov/m+jIG9ndgR9mZh0e6HKDs2WiE0aaEF4Uu4H3lBtn8RMp3jOSxD9b7dFWsPh9V/CMA3A7BFnFPlHZNOb1VxVM9GsUUg9tgale8JV74WCqHV+xWWaZDk716uTdDgsiYVmSICSXjum2o/SyCuazjG/zhO8Qvi0xCbMN5RlkHllaxmXfhChbzDCKRsn79LkAE25et841JI9GwYS+K3ppRj78pzTYIDas7qBo/P40wybmAyWH8fYkRJM/sbTlFys5bTWxMKKl7nvsCHslV89DRcPZvqhIc9H/KbA+gDYAN81+pL0hwoxe7cnHLyQfiU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(53546011)(6506007)(76116006)(66556008)(64756008)(83380400001)(66946007)(71200400001)(66446008)(66476007)(52536014)(478600001)(26005)(4326008)(5660300002)(55016002)(186003)(9686003)(110136005)(8676002)(316002)(122000001)(86362001)(7696005)(8936002)(38100700002)(33656002)(54906003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YBeap9HwhYbNpzThK/Xls1cOU46eUN57zd9TkPRBcHiZ/ZAlNF4SxEhh1NPF?=
 =?us-ascii?Q?Sft1Llkt63vM6iYyaF4MlMwzBwyT7SB+Jx2JlhRE9jM82wsHzCiSt8N1K3ip?=
 =?us-ascii?Q?frrVfQp5JdQanx/OBE5L1K4aywIaaJ+RFaLwL7rD/UPwas1AmMeQ+xNdKGxn?=
 =?us-ascii?Q?jB/jKG9omOjOs6/ZUycrdz/XCXgqddLURtOaoqsJdRldIXaB8rAyPQN9MgOU?=
 =?us-ascii?Q?w64i/coH+QNEesj5oNhHvxhGTjbQf8r70Beka2RWv9Z943LgMeuL8yJM+dW2?=
 =?us-ascii?Q?qgJnku/ha8CGobYPEg0vDKdY/TgBrtmb0SKSntWx4fRPUKwgFByHKWnCaOmM?=
 =?us-ascii?Q?pAGDIkljMnWYYxIgwmoJgFS5fxHRAhfAPhujQiqIRfF4HEkRuPb4gYsnKzQn?=
 =?us-ascii?Q?4smuq6ARjpqFxj4XrP/kJsV/zboYHgI1d1QppSkNgNY0sf4ECMhQONUfWiga?=
 =?us-ascii?Q?oEIGD1kPO2Fh8w0B5Yx+4hvBh9BrNZd8H1m8zQCOkaoaIHtvPQAmh9SVkhyL?=
 =?us-ascii?Q?Am1OnDE5Eu+wiFfh5PmmUv9qHz8ISC8/w2rBmwu9CD/J4gOPF+n9N67o21mY?=
 =?us-ascii?Q?T1Ew/1r4AbVnQPbjLK6YH31DVePzZpKHw8w+fp30zpQnCoBNvnDHspxSxMKr?=
 =?us-ascii?Q?rwlZNRZ5Vr6lCkY1MFu26Fvzh2J+oM4aRFDYkhEaWpGXQP8bgWKxerVWMLOw?=
 =?us-ascii?Q?gQZaT9P7BLRFKipTFnP4mCxM3RnSjDj1CSgsfo6VlLgobH5ymff4/tW6utfy?=
 =?us-ascii?Q?euHlb+RQSFfWcCw6EAynhS+tOTzpP+Nz44i5vmXiAk91yIFcSuNtx72FNz5v?=
 =?us-ascii?Q?knITRQ4QAvTaLHa7HCVqCsHSaNtIdYnidG5AbvBDUiVjZZvV7Sx0f1mmAxVN?=
 =?us-ascii?Q?h9RjgShciH+O86yaGfa4RULQmKjdkjc/4kgHyhIsoIWCQu6kTC6NMcwkWdIi?=
 =?us-ascii?Q?1vlgSabuCVql/ATZ+Q1FMfAfI9Ln6IJEGFOtgAxgabCAx+mbSfh8SScx8WFy?=
 =?us-ascii?Q?qexfalRRd5oAxYX3S+ga74Al24agxMOEQFXtzDq1QN273H5uVLpzCjt8hAas?=
 =?us-ascii?Q?ECwsYU/ppz7XW4/O5f9RQU7lglrj3G6yjky6ONT6vPUbkGJ2VGFqujxldDLf?=
 =?us-ascii?Q?veUu+8ppapmDwAXMO0BZrPeEQ83YMIUhEOIjUo5b7ubSa+A1xgNR8s4HhY3P?=
 =?us-ascii?Q?H8uIsNm+o+F6Us8sW3iFtSS5sP2J7JphfWzSBsrQ2xBa6jRQUd1Q7SQB/Iay?=
 =?us-ascii?Q?vz0XnnHKgiiGGTMPXgvEBAb/E/Tj8rZRL4F4KVymT/ggyDgb3u3uVjhBrIXU?=
 =?us-ascii?Q?25oLlfT6jnOTJdv3NsVFedIK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d61698-7ed6-4a17-5c87-08d9103e3163
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2021 03:22:35.1208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: teMlW+QzDz8D9jwIbmd0HzAhWDBXODeM95fF7u81d5N56+dgWQOSN55/4VcSp3Ws
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3384
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Monday, May 3, 2021 11:50 PM
> To: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>; Liang, Prike
> <Prike.Liang@amd.com>; linux-nvme@lists.infradead.org;
> Chaitanya.Kulkarni@wdc.com; gregkh@linuxfoundation.org;
> stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>; linux-pci@vger.kernel.org; Rafael J. Wysocki
> <rjw@rjwysocki.net>
> Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> On Mon, May 03, 2021 at 07:57:02AM -0700, Keith Busch wrote:
> > On Mon, May 03, 2021 at 08:14:07AM +0100, Christoph Hellwig wrote:
> > > On Fri, Apr 30, 2021 at 12:50:49PM -0500, Bjorn Helgaas wrote:
> > > > Patch 2/2 only uses PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND in
> the
> > > > nvme driver, so AFAICT there is no reason for the PCI core to keep
> > > > track of the flag for you.
> > > >
> > > > I see below that Christoph suggests it needs to be in the PCI
> > > > core, but the reason needs to be explained in the commit log.
> > >
> > > As far as I can tell this has nothing to do with NVMe except for the
> > > fact that right now it mostly hits NVMe as the nvme drivers is one
> > > of the few drivers not always doing a full device shutdown when the
> > > system goes into the S3 power state.  But various x86 platforms now
> > > randomly power done the link in that case.
> >
> > Right, and the v5 of this series uses a generic name for the PCI quirk
> > without mentioning "NVME".
>
> It'd be nice if somebody would figure out how to cc: linux-pci on these
> patches.
Thank you for your review. Sorry miss that and now linux-pci has been added=
 to the v5 patch.
