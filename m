Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4B361A0D
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 08:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhDPGve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 02:51:34 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:10401
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235140AbhDPGvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 02:51:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHL9PLen7eNifAnvTio1dXQg/9GWzrhg6DB9dQ3uwDSOECjxW66GpS9Grn61bYVIfpyqgBykEFDo7mPskAhXAvTL67zaTwSVJW9tdqPNc21steTmkxyasxGJ3isTPZBuBS8Zvw5XL1i1NjPsxd53ZxSwPffx4woW7q0Sop2wUiyjl5Zo+6IkcX8lAhdGkUtDbZneBZYKhgc/1icIkqbP6TBz8Dxr6TCO/w4nFhCwr/k0uCWLEDtow9duV1hHe5oV0ggBX3y3f4VixR5DnMokhCleMDVhzDG0QhukJ75EJAZ+bLOrErx23f0o9I2eeaSP0HUfGiRn1EUMiGr+GPRsUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQYdRPS/kb7P8we656IWo+F0jK6dx7buJhAe1gtvxV4=;
 b=BegN2qKvuUuyy6QwkjbIIY/MBkAvwoprrL4eZaubloWSHxpm/KQ11bjuCosT2IZP9OIlvLXvF1RVlhPk8v6a9qDAqhv3DvxD8EDFLOqE8oZuObmdnQgBp47ew6oDPAu8GXYFn1MvuzKdc4Cz52tDmtkDLNwp0OuRvMTRkGTAVdlE0y+sXqGss6H8Yv4j7+etSufS8eZFVVcRiCMgNg0XP/F2pvzV+DtZCDhuXy3f+cdgfZa9gn8qRsRATX7mBxM2qPQRuR+lWxNFc8y3e9KBQ/Lu0LYxlQRQP6a2+iqlrjNK4sozn1LjT0V719ErZVMEWCHD2a1xsx67MQvchIAlIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQYdRPS/kb7P8we656IWo+F0jK6dx7buJhAe1gtvxV4=;
 b=RCoLnWE3DJmGL2b5UKfNsbALeYSjy39+0lWFz4kZ7Wn3NOTwOAqur4lv8ijbJjzIBj1+EnWECFgeWrGUNL7SmVr2gJiyTro6lbZtJlO7v4b8HzgFyUP3z6lltORsxCEA9xW2alW8OUof0Gvqf8EW7Ofoc0P1fbDSj0aVEoT2WGs=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB3875.namprd12.prod.outlook.com (2603:10b6:a03:1ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 16 Apr
 2021 06:51:06 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 06:51:06 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Keith Busch <kbusch@kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Subject: RE: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Topic: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Thread-Index: AQHXMarUZvDSGRepoEyCkC/coFRS7qq1PS+AgAALBBCAAOEEAIAAi+hA
Date:   Fri, 16 Apr 2021 06:51:06 +0000
Message-ID: <BYAPR12MB3238528F1D91A921FF1201EAFB4C9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
 <20210415082057.GA1973565@infradead.org>
 <BYAPR12MB3238E0366477A6CDE7AC9B94FB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <20210415222544.GA2760247@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20210415222544.GA2760247@dhcp-10-100-145-180.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=49c085b7-60d1-40d1-9a57-65845413fdab;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-16T06:46:38Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a361e0bd-a9ce-491f-6eb5-08d900a40274
x-ms-traffictypediagnostic: BY5PR12MB3875:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB387531B8A00DA3BC2E6970D0FB4C9@BY5PR12MB3875.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZHY7P/9pgKZWZHPAiFX3kChMYb/J0Al7/kh4ADdvCB7bx30JB8LBNdAbBjPnWNpjfjFhWquk15/OU/bXno0JIX+FKH8ib8D+qpDssDPHx0RaadzhDfcNmU3a5UtOathuiYNjr+Vudo0Y7Ol156GFzhfpLrGJECfZBISte8SNF51zLziIXyuFG1ZquSApI7JUvPymc0pCufu/D1BIhBJa/np+svaGYOpYlZNQD/Ssb2cv01r3kUXknIHN+BmQVDsnAQ/Bww+rXjOPdg5gqya9C+KYO42WseK+hCoiqNTaB3XcC96XDPdbqDp7QhLSL5CQIywT1H/3ha2u2wuUmvbLoUOJcjfET3BT49pq4WpC2M5LPm6SdIdT6sWuJtmKx3+L1U2asw/swvKGXgWYAjtyMUV6h4Xn0ib04sC1cUnmVYvTOP9xrQJNSes1dgggSJHD4Qi4UzyGXhYp59B/2z256NVx3uxG1dv/nroUA5LCXqTF8EeavNeNIg4LwHolV5Vdr5OhqYl5Dnh7OaHvBOr6UoiUqOSXl2J2VMl8C2hAxpDkApGYw+eBIi7XL8+Ca7nQvDenfBuWNZSm4cTQ98RKM4lfHlMPNRNveAMYj9Qfk80=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(26005)(54906003)(4326008)(53546011)(66946007)(52536014)(478600001)(7696005)(6506007)(8936002)(122000001)(64756008)(66556008)(55016002)(66446008)(76116006)(66476007)(2906002)(38100700002)(6916009)(316002)(33656002)(83380400001)(71200400001)(5660300002)(9686003)(86362001)(8676002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iYWXGMY8gpxLnyoUsK0wAJJK1GGfG1t534fxbIcyE82XhAoCuEVRJgBKX1Yx?=
 =?us-ascii?Q?reiC8/I3IwCaEucBalTtjIM6dVIcGWcTENPKfISmd7yF/1snu4PP5TZ6MfOz?=
 =?us-ascii?Q?GX5Y6puzP7YF2fNIMveHtvk0jKUmS+M/bglxP67qlGDEeoSlWt6WQcsF2v74?=
 =?us-ascii?Q?8ty0UPgYc8HmHknHHxmgjCXW+tjARcPWd5Do7F7jHEZftCxx2DUFYQWy4+M0?=
 =?us-ascii?Q?659zmgH7rXmWjBVzd4FGHoF9QdXKrLjf9l2g4njTbabTXH2ikLvRhFHbhrj+?=
 =?us-ascii?Q?D7pjFM/0Dy3w4iu4Ka2nS0y2DW+kEqauliTXvXfnuXM3xyyHbbWxEBgquUjm?=
 =?us-ascii?Q?wdZoS10MbukLt748E4IgsIxjxmLoETATnqbirycjGVhIF8nNcIPWpx1dAokz?=
 =?us-ascii?Q?mwkyutj0+d42UkAziP4RDob1im5Zrp3js8EH/E1qQ3OS65dY1I/vB2bpzeX4?=
 =?us-ascii?Q?59ZoH8gqnAyCX7PWgES/epq7Ys4zdIvwd+gHexBEWMpWmch9ZJu2+68qqAY/?=
 =?us-ascii?Q?tRg+MzxCMHF9nJ5/l29gGbMgNSKqJcOLdPeBb0fH6aHRObOc/CbHMUjApfLt?=
 =?us-ascii?Q?Kroy0Hx5cQv0hoC4OqXnjrqDJCLavbKuQh6CCyykKqJxF0DJrQlaMrOHaBfV?=
 =?us-ascii?Q?WuEQsJD2i9/+H7sOrFaVafNquLa6FGoiZm89GF1XCZmlJGksOYoRDhYBmLo0?=
 =?us-ascii?Q?8gGg1zUDtwfKX4TYH/pPewxUctqevIci8ycD01h+JcXK41LJnrqaxQYin6tN?=
 =?us-ascii?Q?dkoMh+7zsffYsqAJyePkpxZfMGuZ1i/Y+22Y52GkuX9RKCUIpuhBuDYU/fQ9?=
 =?us-ascii?Q?6W0WN/Z/J6ytUgU71n5RQjkPkuKB4h30Xr/MBcdgWGODt9Je/7h6HT55qYmm?=
 =?us-ascii?Q?sVU2Ro4kz3+p2xdhHDQaU3B06DR6B+tPgUAQSnAKq9RVydXoR7YhunR76vSi?=
 =?us-ascii?Q?HmowAdKuJ/50z8a6jgv6ui4U+j5YnsVLh+VTbpbhsA/7ZK6d9zfgeZ9i2C8U?=
 =?us-ascii?Q?n5ykyQsUZhalPac79sIPpQWQi1UMc+M27wsJMqxY7I8Q8I9LU+S+rcZfOMto?=
 =?us-ascii?Q?nwn/LQuOMDbtQnikT0dvWwJb3ryW2cpDAZ5FY88TO9joUJXckyqxxlGubLH7?=
 =?us-ascii?Q?xupM6J7DELAu35+tORoGF3rjwXhRuUDp8isXAhpPpuA/XFelSAlLa4XByMlV?=
 =?us-ascii?Q?QTs2MbcfSohlyeIhgcLdppmEqIJ266eT1mqbR6kUBO5FlsjLNvU84V30SqyR?=
 =?us-ascii?Q?3RS8zeqwEYW7vr2qBNTsqcEV70X3Abitu9StQAlC1ASwS2qEcs8QQB/jEHCV?=
 =?us-ascii?Q?CnIIjq72eKGCPKGkRLAjuUax?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a361e0bd-a9ce-491f-6eb5-08d900a40274
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 06:51:06.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sD2tx0FNfCmaVbeguRuQuWWw3F3wTFpLid9OUYK61flFAZp31fe5Rfsy5m/oNpA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3875
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Keith Busch <kbusch@kernel.org>
> Sent: Friday, April 16, 2021 6:26 AM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: Christoph Hellwig <hch@infradead.org>; linux-nvme@lists.infradead.org=
;
> Chaitanya.Kulkarni@wdc.com; gregkh@linuxfoundation.org;
> stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>
> Subject: Re: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
>
> On Thu, Apr 15, 2021 at 09:41:53AM +0000, Liang, Prike wrote:
> > > From: Christoph Hellwig <hch@infradead.org>
> >
> > > I'd also much prefer if the flag is used on every pci_dev that is
> > > affected by the broken behavior rather than requiring another lookup =
in
> the driver.
> > Sorry can't get the meaning, could you give more detail how to implemen=
t
> this?
>
> The suggestion is child devices of the pci bus inherit the quirk so drive=
rs don't
> need to look up the parent device that requires it.
>
> That makes sense for a couple reasons. For one, your hard-coded 0:0.0
> probably aligns to actual implementations, but I did't find a spec requir=
ement
> that the host bridge occupy that BDf, so not having to look up a fixed lo=
cation
> is more flexible.
>
> If I understand the suggestion correctly, I think it's probably easier to=
 thread
> the quirk through the pci_bus->bus_flags. Does the below
> (untested) make sense?
>
Thanks Busch for elaborate clarification. The PCIe RC bus flag can pass to =
NVMe device successfully and it works well for this case. I will update the=
 patch accordingly.
> ---
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> d47bb18b976a..022ff6cf202f 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -2834,6 +2834,9 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> *dev)
>  acpi_status status;
>  u8 val;
>
> +if (dev->bus->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> +return true;
> +
>  /*
>   * Look for _DSD property specifying that the storage device on the
> port
>   * must use D3 to support deep platform power savings during diff --
> git a/drivers/pci/probe.c b/drivers/pci/probe.c index
> 953f15abc850..34ba691ec545 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -558,10 +558,13 @@ static struct pci_bus *pci_alloc_bus(struct pci_bus
> *parent)
>  INIT_LIST_HEAD(&b->resources);
>  b->max_bus_speed =3D PCI_SPEED_UNKNOWN;
>  b->cur_bus_speed =3D PCI_SPEED_UNKNOWN;
> +if (parent) {
>  #ifdef CONFIG_PCI_DOMAINS_GENERIC
> -if (parent)
>  b->domain_nr =3D parent->domain_nr;
>  #endif
> +if (parent->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
> +b->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> +}
>  return b;
>  }
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> 653660e3ba9e..e8f74661138a 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -312,6 +312,14 @@ static void quirk_nopciamd(struct pci_dev *dev)  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> PCI_DEVICE_ID_AMD_8151_0,quirk_nopciamd);
>
> +static void quirk_amd_s2i_fixup(struct pci_dev *dev) {
> +dev->bus->bus_flags |=3D PCI_BUS_FLAGS_DISABLE_ON_S2I;
> +pci_info(dev, "AMD simple suspend opt enabled\n");
> +
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1630,
> +quirk_amd_s2i_fixup);
> +
>  /* Triton requires workarounds to be used by the drivers */  static void
> quirk_triton(struct pci_dev *dev)  { diff --git a/include/linux/pci.h
> b/include/linux/pci.h index 86c799c97b77..7072e2ec88a2 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -240,6 +240,8 @@ enum pci_bus_flags {
>  PCI_BUS_FLAGS_NO_MMRBC=3D (__force pci_bus_flags_t) 2,
>  PCI_BUS_FLAGS_NO_AERSID=3D (__force pci_bus_flags_t) 4,
>  PCI_BUS_FLAGS_NO_EXTCFG=3D (__force pci_bus_flags_t) 8,
> +/* Driver must pci_disable_device() for suspend-to-idle */
> +PCI_BUS_FLAGS_DISABLE_ON_S2I=3D (__force pci_bus_flags_t) 16,
>  };
>
>  /* Values from Link Status register, PCIe r3.1, sec 7.8.8 */
> --
