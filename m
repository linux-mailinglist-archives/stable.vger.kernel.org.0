Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1635D9D3
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 10:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242406AbhDMIQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 04:16:37 -0400
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:61792
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242329AbhDMIQg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 04:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abAoN6Ty6+4uligbqvMxvkMDGzEg+LJz+bq5qDFcXsGTSXynwQ0E7tK2RJBTSYOI0ARVmld3ktQJVEe91b8o4JB4TcMZC3xMzPl4JR7UT62dlf1hkgwqNwNYwKc4KFYBPJDHOVCZZ/mFNdDlWyW0r51bB5heus621yPo7kjEoVcNMjG0McuHBb1m9SRTylL/QIQk/LeVVQASZ5Kh+I83T8GfF/Tcsz+AMvKXqRzeINKJM3vAWwCVpYNNmlSJizk12cMS1DfyhD7OtS1esy3vdGHNj/8xhvIoXceFNMqwAJJ6uDy+c2DWCUA3TVtrPntE+aHpt18VpMKAOtAUE5sMEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqydJpXvIBLdbJN6Ii6MT6MBBb1A2Y/qu9hTFTugRIs=;
 b=Fxr6H3VcSYIT425slA4vHpWyiEoq2B8euBO+4yN2Cw8YrVuLcUpGRSTJUAd/kp5sNmSfh0JtJuLys5TQUH/OWjdXuR++SCqlFBbSyfRFbmXfkTTLDXruKGnnkGIqBUHBSayx/CWV4rU33vwNN/ZAhQa1AkT9zi2j36W4WmD4sqeHjFvKNwR7ZRRpOYTrZrVCN0UyvIGvgzvp3292ciriHIMR8gD1dYwCpngIm5OIuv5Rg+gRVKemoGisdXBpzl4hsnZG9zHW/iBNgGyOTWKRZtRd7yMoi3eZ/02V8ktz78tt3QRI6UqT2SNqiuwZTmYdHaP4MTWIQcJvzJLL8Nk1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqydJpXvIBLdbJN6Ii6MT6MBBb1A2Y/qu9hTFTugRIs=;
 b=INRnX50dAIstTrFG7KInwYJmzFl8j7D4ioEfV+CBx05hjqCIgnwwbzOD9Snp/YUI+u0w4fEkeTFeKa4QSSaRRY/mDAU8T6zo87Hp58XZtaK59hHk6DtT+F6/yaeqlvj6ffmnvyjMqVI79iFbI2Rnun5Pb57rnysz7IrRp+Pg5pg=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4997.namprd12.prod.outlook.com (2603:10b6:a03:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 08:16:15 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 08:16:15 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>
Subject: RE: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Topic: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple
 suspend/resume path
Thread-Index: AQHXMCvPNI8o+14yDEWiSRS19TAo8qqx/XaAgAABOTCAAAZ9gIAABB/g
Date:   Tue, 13 Apr 2021 08:16:15 +0000
Message-ID: <BYAPR12MB32386B184F3D822937FAB49BFB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618294221-11528-1-git-send-email-Prike.Liang@amd.com>
 <YHU7M7ThQiAsOCSG@kroah.com>
 <BYAPR12MB3238FAD129CF0E7F0DAAF205FB4F9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <YHVBq9VxHkQt18Gy@kroah.com>
In-Reply-To: <YHVBq9VxHkQt18Gy@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=6062523d-f16c-41e3-99b2-74286150bc30;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-13T07:15:56Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afcf9c73-be62-44e7-8af4-08d8fe546857
x-ms-traffictypediagnostic: BY5PR12MB4997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49978854543809396E8624F9FB4F9@BY5PR12MB4997.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GSkrTE6N4WErbtihyzhXvA7ZFpy333uu8eVYgZAIyTlcKotF/JWx12PXSZL6cqq8OevIATQHJQkG3Hoott+rjRRd6EZqJgfg3LjFgq7iic806f8Gef03rVuSkuFCH5rwrckPMNrLvMVfvfP2dedSm4TehmD0vF+NbFChVgh6ybUDcvNx050/pCIF1Cj2Y9dTi/1IoffoVND2AocipUAZDNcCGtkQ5A8+FME3Ajrh8Xcij0nR2opeiyDGavkuhEVV3Dpof/wlTSoAtwCI0Jd+F1ia60l0yRQrJ7m7AesP52Q1IL5U0Becrxe96ITsU52YBVcbDH6RqK4QlKQzO4a3E+cN5nNcAIeizr98YcTVuCFQ7CaC+VkumVQpldt9USWMe1MBZFI2sEa3+sUDBhscJhwP8n+U504a5KtT2ZerdyGFksk2JZZil+HCVPpIR6vlVWej/3dMbMgk9q5To8FDDiqCxQsvbjaFJk2+q6cYUWs5PTkNHIqWCQZU2h6m0AAO2UmdfqI8U/+2Sa6pQ3WHK1BMJkXRg4Fkx3axovMjEXJGoZsZnOXVKLx0VU1nex2XSyTQEvGbD+QR+hz2amk1FK3gdifIbZdvBhxICRzZTy0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(52536014)(53546011)(66556008)(66946007)(66446008)(83380400001)(66476007)(2906002)(76116006)(86362001)(8676002)(38100700002)(55016002)(64756008)(122000001)(8936002)(33656002)(7696005)(186003)(5660300002)(15650500001)(71200400001)(26005)(54906003)(4326008)(6916009)(9686003)(478600001)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9QELc2Aqp8Bs4K9vh7CfHjM4+Hr6a+hXIECsuDJiQN5XPJ2xd1fRbos5McmW?=
 =?us-ascii?Q?yJiU7nzRV8BY2pDkoDfJDkFidCleoLWFPYUkQU41nKlyZELxYgaziHN9bfzA?=
 =?us-ascii?Q?GYXWQ0cSZLn25LPOH1YmIULprugw1m5/a15HA9ZGSKrB8pWvNsLZTaIxt7gX?=
 =?us-ascii?Q?WpUezgv3ZFWIAl1ORcaARv717fMh38vpDpycHFhdhKu/oZ/nbVwwDeQReZTs?=
 =?us-ascii?Q?09r7Fbkh96/j2SbohB36R0OEpHTKl+5SKyaqlj2axYF04A4Dj+y9zoM/rtlk?=
 =?us-ascii?Q?ErCpxbBukoISRNhzGDfYjWqADuoAIHntA2whGlZGpEIehY3GovSulzwuJXa/?=
 =?us-ascii?Q?be7SRE4O2KpKjGofRxDBEM8KY2FcWUeAEXb5VcVIziaKElnd/wn+gIiSyHET?=
 =?us-ascii?Q?YFq6gKGZhHLh73gW/rKERzSz87E4km47pvmYdeq5iZv6dsbGDKPWiO818HNt?=
 =?us-ascii?Q?E0n0/4jGZZs5YqLo+SFNh5XY98n/DfQJyLXYo34xP2ElSYUKTOLpKUrvGnf7?=
 =?us-ascii?Q?Y2bE1GoXVSARnZy6Zhcv5sEOWOuK81OYTLZghW5JLbAfz2LZ0cmgGEDKvaDX?=
 =?us-ascii?Q?mWObC7lto3CYFLLyfcGppH70C5o0gsX1FCux26WPw71ygk4bv6s1wz3GnVGM?=
 =?us-ascii?Q?4lKhdpCEpIS+HgjaWwNFXDFP2MppWlhpJ2hif2J0Aw2SYw1h3ilzIELrIPvZ?=
 =?us-ascii?Q?ySp7Ofrw5+G5a8A6QEJ1+Nhgk6v5stYjGgQLMwv50yeRUVfigVI1+oniK+y4?=
 =?us-ascii?Q?kiehsHRXmIlPHB9NCh+NZWHR4Db+rQsI+YSYyH0fXfJpEZVrLwkpaEB4e2wv?=
 =?us-ascii?Q?HVEe613yUnQEA0e4gaIkUfYHaAhJwaF3YEqQTcDlBcfSbrlAlKP2/7xeg07F?=
 =?us-ascii?Q?3DBfokc7pFku7ADcN26RArT1n76Edp48MdNxVOaE1A3+DpoD9iTVRRAKsm1M?=
 =?us-ascii?Q?EfN2pdOq8ZY1GTOqDFOMZ/ZcrM993PmgJllleOglMbp32KLw0KrbyjiuuKXo?=
 =?us-ascii?Q?2PJDaLQNESMBmOM+jgiWyLt77tQIz8T99YBcUxaa2i1j3vZX3TuqILcLY8eP?=
 =?us-ascii?Q?Uu52l8fb4jKSYP5H9lr7XPDlOIfhOk4vBMQgeyohpZZqGN2+ysgoZZXkGeDG?=
 =?us-ascii?Q?SoFhuUDwupJOq4CXRExSHWTBXRjQ5iKXE5X3rY2W81prwFmFBLptbyQ+ka7q?=
 =?us-ascii?Q?spqXscc2ZqyWcZDQobhY5HX4oxDc+ADAfUEthLpCKm2C0+q1r3Y/Diq1t2Ip?=
 =?us-ascii?Q?p/rCXj6lH32QJaaJdKIK3tWiV9UHs/e2KOx24VfkQ/J+GZZ+t8crgh+4geby?=
 =?us-ascii?Q?66QoBuydvFUQFuYuO3o+YhD5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afcf9c73-be62-44e7-8af4-08d8fe546857
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 08:16:15.3631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whLuCpiRonPy4c+u0wlUYnaeE3OzYn1AODaTtRDPM7JeT4Zwa+wx2QNKD7NireZt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4997
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 13, 2021 3:01 PM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>;
> stable@vger.kernel.org; Deucher, Alexander
> <Alexander.Deucher@amd.com>; S-k, Shyam-sundar <Shyam-sundar.S-
> k@amd.com>
> Subject: Re: [PATCH] nvme: put some AMD PCIE downstream NVME device to
> simple suspend/resume path
>
> On Tue, Apr 13, 2021 at 06:44:08AM +0000, Liang, Prike wrote:
> > [AMD Public Use]
> >
> > >
> > > On Tue, Apr 13, 2021 at 02:10:21PM +0800, Prike Liang wrote:
> > > > The NVME device pluged in some AMD PCIE root port will resume
> > > > timeout from s2idle which caused by NVME power CFG lost in the SMU
> FW restore.
> > > > This issue can be workaround by using PCIe power set with simple
> > > > suspend/resume process path instead of APST. In the onwards ASIC
> > > > will try do the NVME shutdown save and restore in the BIOS and
> > > > still need PCIe power setting to resume from RTD3 for s2idle.
> > > >
> > > > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > > Cc: <stable@vger.kernel.org> # 5.11+
> > > > ---
> > > >  drivers/nvme/host/pci.c |  5 +++++
> > > >  drivers/pci/quirks.c    | 11 +++++++++++
> > > >  include/linux/pci.h     |  2 ++
> > > >  include/linux/pci_ids.h |  2 ++
> > > >  4 files changed, 20 insertions(+)
> > > >
> > > > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> > > > index 6bad4d4..dd46d9e 100644
> > > > --- a/drivers/nvme/host/pci.c
> > > > +++ b/drivers/nvme/host/pci.c
> > > > @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct
> > > > pci_dev
> > > > *dev)  {
> > > >  struct acpi_device *adev;
> > > >  struct pci_dev *root;
> > > > +struct pci_dev *rdev;
> > > >  acpi_handle handle;
> > > >  acpi_status status;
> > > >  u8 val;
> > > > @@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct
> > > pci_dev *dev)
> > > >  if (!root)
> > > >  return false;
> > > >
> > > > +rdev =3D pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0)); if
> > > > +(rdev->dev_flags &
> > > PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
> > > > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > > > +
> > > >  adev =3D ACPI_COMPANION(&root->dev);  if (!adev)  return false;
> > > > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> > > > 653660e3..b7e19bb 100644
> > > > --- a/drivers/pci/quirks.c
> > > > +++ b/drivers/pci/quirks.c
> > > > @@ -312,6 +312,17 @@ static void quirk_nopciamd(struct pci_dev
> > > > *dev) }  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > > PCI_DEVICE_ID_AMD_8151_0,quirk_nopciamd);
> > > >
> > > > +static void quirk_amd_nvme_fixup(struct pci_dev *dev) { struct
> > > > +pci_dev *rdev;
> > > > +
> > > > +dev->dev_flags |=3D PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
> > > > +pci_info(dev, "AMD simple suspend opt enabled\n");
> > > > +
> > > > +}
> > > > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > > PCI_DEVICE_ID_AMD_CZN_RP,
> > > > +quirk_amd_nvme_fixup);
> > > DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> > > > +PCI_DEVICE_ID_AMD_RN_RP, quirk_amd_nvme_fixup);
> > > > +
> > > >  /* Triton requires workarounds to be used by the drivers */
> > > > static void quirk_triton(struct pci_dev *dev)  { diff --git
> > > > a/include/linux/pci.h b/include/linux/pci.h index 53f4904..a6e1b1b
> > > > 100644
> > > > --- a/include/linux/pci.h
> > > > +++ b/include/linux/pci.h
> > > > @@ -227,6 +227,8 @@ enum pci_dev_flags {
> > > > PCI_DEV_FLAGS_NO_FLR_RESET =3D (__force pci_dev_flags_t) (1 << 10),
> > > >  /* Don't use Relaxed Ordering for TLPs directed at this device */
> > > > PCI_DEV_FLAGS_NO_RELAXED_ORDERING =3D (__force pci_dev_flags_t)
> > > (1 <<
> > > > 11),
> > > > +/* AMD simple suspend opt quirk */
> > > > +PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND =3D (__force
> > > pci_dev_flags_t) (1
> > > > +<< 12),
> > > >  };
> > > >
> > > >  enum pci_irq_reroute_variant {
> > > > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > > > index d8156a5..7f6340c 100644
> > > > --- a/include/linux/pci_ids.h
> > > > +++ b/include/linux/pci_ids.h
> > > > @@ -602,6 +602,8 @@
> > > >  #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS0x780b
> > > >  #define PCI_DEVICE_ID_AMD_HUDSON2_IDE0x780c
> > > >  #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
> > > > +#define PCI_DEVICE_ID_AMD_CZN_RP0x1630 #define
> > > > +PCI_DEVICE_ID_AMD_RN_RP
> > > PCI_DEVICE_ID_AMD_CZN_RP
> > >
> > > If the pci ids are identical, why do you need different entries for i=
t?
> > > Haven't you above just listed the same thing twice in the quirk entry=
?
> > >
> > > thanks,
> > >
> > > greg k-h
> > [Prike] Use the different entries for identifying the RN/CZN respective=
ly and
> that will clearly imply which ASIC need this quirk. Anyway we can use the=
 one
> DID for RN/CZN to avoid the PCI ID retrieved twice.
>
> But look at this patch, you list the same device ids in a quirk entry twi=
ce,
> why???
>
[Prike] The previous thought was that used the device ids name to clarifyin=
g which ASIC need this quirk.
 But that will traverse device ids twice and will remove one of the entry c=
heck.

> PCI device ids should be unique per-device, and not shared with different
> names like this.  Also, why even add them to the .h file, you did read th=
e top
> of it, right?
[Prike]  Thanks point out it and will remove the RN DID definition.
>
> thanks,
>
> greg k-h
[Prike]
