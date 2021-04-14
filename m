Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573E535EF60
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 10:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350033AbhDNIRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 04:17:21 -0400
Received: from mail-bn8nam12on2051.outbound.protection.outlook.com ([40.107.237.51]:14805
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350031AbhDNIRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 04:17:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuKXfLnRaqOgNzL39vkEb6fbHRHnXFv10V6ijq2dndjzOvxDTcbX9EeNSdUH4tXqe3+sDl9+7BRuGt08ltMZCcF9EP51U7NypNv7/yVEaYarEBjvA+sTu3tUKAHd/5mz1dQ0hCs15aNu1N0sd+nOGcvBEoZJKj1Y6cs05QJG4sJJ5OfAFe0E1Ya335zJccIxxwYqIPgKWbkMF9BEGb88qgpMr0I/m+mx9N5G4KbgisWwmTo6muRXqh/KjusMV1NzDkFrrhDKaB1VFzg5GmhdGsT4Jw+cYhsZm/sjaWzstOZkWlB7CJ3+3Qubi9DC5jdtQrVgZiFxmUa/8A2Np2iuoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guBE4lkEGhFERwEkMT5c6BUu1AnJVztvUfsNwX07q80=;
 b=GsK9mhl7uzqAbm2CNjeI4aat+aw22igjQ6G0lt1KKRG1S8jDtyNA5lEPep89yJjgDdD4yHT0cievf0MqaOWp9DtLOV0NqXnbWJhHWJP5CnO0DH5pBO/zUQi6880c25r2xx9A2XoVYkKSIpDqe0F24ZmrBx/8pjM5OxamIoEucconTNRKMbBOQ+mauK9HM2jeV7kx7zx8wHoe8EyTQ+vmw4CCEJyipS1IwdjHxThdWDdw5dCm4FHEsfatl1cHl2q5SJ1EhR6DLTLo80Wn/W8thSEJmGiUP1jEvLJO4dL1JoyHHyFr5YVmjVy8ltP40iTo/YvSVm1GT5av2LC+JJVNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guBE4lkEGhFERwEkMT5c6BUu1AnJVztvUfsNwX07q80=;
 b=NTgeK1UHSZRN5m6lgWukRdtF3Vlu5bXL9yTbS2yUqLa0oKfqF+PDxyNW+6bMFK+vDwHnXMoSfhf5VlwV1FKts5hrKQ7F2fSXfr8ePqFp2J1kPHqUR261QIw9rPjw0ofsj+rMLgjFVuQNTiz+K+dEOLygJfxxELmXuAmxUbovXD8=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Wed, 14 Apr
 2021 08:16:57 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 08:16:56 +0000
From:   "Liang, Prike" <Prike.Liang@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Chaitanya.Kulkarni@wdc.com" <Chaitanya.Kulkarni@wdc.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "# 5 . 11+" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Topic: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Thread-Index: AQHXMPZWugAdfwQ9zE+MP2pwxe1wgaqzj+0AgAAGbLCAAAz3gIAAB47w
Date:   Wed, 14 Apr 2021 08:16:56 +0000
Message-ID: <BYAPR12MB32385C216CB10413287836F5FB4E9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618381200-14856-1-git-send-email-Prike.Liang@amd.com>
 <1618381200-14856-2-git-send-email-Prike.Liang@amd.com>
 <YHaOJDm3GCZ8baAV@kroah.com>
 <BYAPR12MB3238544752DD86202469CA1EFB4E9@BYAPR12MB3238.namprd12.prod.outlook.com>
 <YHaeZ/auMUYGSy1K@kroah.com>
In-Reply-To: <YHaeZ/auMUYGSy1K@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=d412200b-bb3d-45b5-93a9-1976d907db43;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-14T08:16:08Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=amd.com;
x-originating-ip: [180.167.199.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0bc19cf-0c50-4cf7-f827-08d8ff1dab74
x-ms-traffictypediagnostic: BY5PR12MB4164:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4164D2225A14E8B13A986833FB4E9@BY5PR12MB4164.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9YmwrCJH0jVRgnsERiIhn0/GtgsH9j/dqVpjV6qasWPKkrS7nDQAcII5vb6VZU6q4RiNyIEy+2X6G+A4IcEUmvMOzcZ7nH5qNvunAHnE7llqi4CCCHuQpZOji4iUSsM97WQMRQ6/Xuo3IvwBVqKZHcTB4P4pz7m+QRUA2VDxXg+waAG4SrC3HdOTQvVvmDhXvtDiMndz2Rpn6ZPOBf0NVtafqNh8tMdG5XaXFDeRJJIE0RlARR7BJFZ6ChtRCdqTV6oJ+BzWHzRknuOtkVme26iWL5HV0weQj05oK6n/VtVaOqA02WwIOaS5SZXc/ow7J/YJdgpVObP4VD+t8GmNis+uFNJurwRSMPwS1hiZIXIaypxbF+INyeKvMsiGLoUTIT+eRYoKMhX0tDQ/zPk48pTaISNwuAaqMgSb2pL5YbdNYUzIz/mETqfH9TJCX7lq4caNb01tfwKjToJJIS16m1aYhwwGrGw9hzX9gYOtNACjyDWkuCLiy57e+4r7fGyNtMsDZY4R/N6RqJtu1jM/MSnlAD2be8CjAXyJTG6C5w3plsRqJIPElu05EcRD+SKTUxk+hVrF+P3sN3o/zh7FEs9hTqq5j5P0nAEFCuGcNCg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(376002)(366004)(346002)(186003)(66446008)(76116006)(66476007)(478600001)(66556008)(64756008)(8936002)(4326008)(9686003)(316002)(54906003)(7696005)(8676002)(83380400001)(26005)(38100700002)(2906002)(33656002)(55016002)(122000001)(15650500001)(6916009)(5660300002)(86362001)(6506007)(53546011)(52536014)(71200400001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XeyHkizjVjSs8nzdQDd41W5ErQPND8XxEzL7nJIlNrJnzAYA2GKG+9u5liXA?=
 =?us-ascii?Q?YVY14MbdvfwQ+fhlm7zi347x33SQF05UpW1wrQcT2Zg9h34LIweiwCG8pgBl?=
 =?us-ascii?Q?FVn22wIP1oUQq3jx1nJa2j9Jh1TyDC2ylcHsbRlG3mYYBo+/HZ+Ivh/97rB0?=
 =?us-ascii?Q?dzd8lhaV0ZbKn6y15TsWAPisZW9Bz/kAvZPPVjReFr37xQZUNyuj5QeGXVDA?=
 =?us-ascii?Q?Iv6qt0Zy0VXU6VAPbm9WYMQiXhSvr8ecEFOK54GvPMBk3YcQstWspJd+bfzS?=
 =?us-ascii?Q?FQuufrJ7Nr8uJOrJECBUQH2njXG6wWmaBo4Gu10KEFnRwwePxLxJ0ujdU+7o?=
 =?us-ascii?Q?mupUA2ZLu7PShF6P6nwKkmSGkCr1VqI5inNkNKLfusHwh+oB2EvFAfD6ttiK?=
 =?us-ascii?Q?3y9gv6GkGvmEZBhct4alw2zoIPmYukTOgwyC5+1bl76Jfv803e+IhZSseTOM?=
 =?us-ascii?Q?w5OODepnv0nDJub9D4T40KcJpZpxij/WO8B65mcj02QpeQKsmZf05tZGufrv?=
 =?us-ascii?Q?H99C96NAi+V13GE8+r8EcJmGCFuurFJDQT8gmOdQKd8l7EGaB8N5YWSXc9XS?=
 =?us-ascii?Q?sqD1OHzjMaxmARFjivbPMfANYMxdaNGEidDEHh0GlHPvk84VPHarZ0XeYNKj?=
 =?us-ascii?Q?a9l1u29mPolfddtxFGF2KjVfJHefTJmP6YLf6AopjpSCNMwBLSq6/SXBWhKE?=
 =?us-ascii?Q?3jGsiVgSgb/zwem1l4xTsWbKWbXQ5uwrJfxY84hXAdGDj7leRyWBnpYDNDD+?=
 =?us-ascii?Q?BlCgZ6zOKotFAMrk//bY2wznJPZV9bU8JPXfsHHvGUPaKMRPpyy8iYa6FgQJ?=
 =?us-ascii?Q?u7ALLEqoPNmHgkbO5Jtzi6uuZNoC/zeHGOcdk8xODNDfLhtVTVvQI5zkGlsD?=
 =?us-ascii?Q?5RxvIRxmpl2m+fLGcfJvS7wrQ/e+hALGBOqOI8jCLS9zu7X7XPWmGruuHtN5?=
 =?us-ascii?Q?HITJyOc51NsZwHpYJIXsKrINVHnr0QIzWOzvjOLehZv6pvuoYLiHMJGVZshV?=
 =?us-ascii?Q?fheqzPY8A2XCAdTppoExe3QYoYqnoG45MFmmukBYzEB4iszPgdPSR8askbZX?=
 =?us-ascii?Q?8hLMtSbWxUbpTy8Xy15jPePIJgAOC1WROad45abRiqdyXsmt2HWU/Qfvl0rr?=
 =?us-ascii?Q?cMIxH4VQ0vS93yVuNN37tEqsrZgNR/6c79X3DO2qI56EfRskDP0JsLEtvn8r?=
 =?us-ascii?Q?4anz2bEhJEgmQ+aGArTcaD9ydK3SXmvxq3622eqwm3oQy7AmPi9Shb/rGHkR?=
 =?us-ascii?Q?F2VaWs7xdVkq2C/QndA80FoycgvH0FjgYtgTWQYb43BdMp549T0KGIyswkue?=
 =?us-ascii?Q?QHnqBvBE4LLyLADLRGXSWXVF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bc19cf-0c50-4cf7-f827-08d8ff1dab74
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2021 08:16:56.6340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NDCjc1EJ3kcy0UttflnYMg5V5G/VboL4nkiQ4bViXiXu5KPT7W/5cP4d4OHd7SOR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4164
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, April 14, 2021 3:49 PM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> Chaitanya.Kulkarni@wdc.com; hch@infradead.org; S-k, Shyam-sundar
> <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; # 5 . 11+ <stable@vger.kernel.org>
> Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
>
> On Wed, Apr 14, 2021 at 07:13:15AM +0000, Liang, Prike wrote:
> > [AMD Public Use]
> >
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Wednesday, April 14, 2021 2:40 PM
> > > To: Liang, Prike <Prike.Liang@amd.com>
> > > Cc: linux-nvme@lists.infradead.org; kbusch@kernel.org;
> > > Chaitanya.Kulkarni@wdc.com; hch@infradead.org; S-k, Shyam-sundar
> > > <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> > > <Alexander.Deucher@amd.com>; # 5 . 11+ <stable@vger.kernel.org>
> > > Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for
> > > suspend/resume
> > >
> > > On Wed, Apr 14, 2021 at 02:20:00PM +0800, Prike Liang wrote:
> > > > The NVME device pluged in some AMD PCIE root port will resume
> > > > timeout from s2idle which caused by NVME power CFG lost in the SMU
> FW restore.
> > > > This issue can be workaround by using PCIe power set with simple
> > > > suspend/resume process path instead of APST. In the onwards ASIC
> > > > will try do the NVME shutdown save and restore in the BIOS and
> > > > still need PCIe power setting to resume from RTD3 for s2idle.
> > > >
> > > > Update the nvme_acpi_storage_d3() _with previously added quirk.
> > > >
> > > > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > > [ck: split patches for nvme and pcie]
> > > > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > > > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > > > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > > > Cc: <stable@vger.kernel.org> # 5.11+
> > > > ---
> > > >  drivers/nvme/host/pci.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> > > > index
> > > > 6bad4d4..5a9a192 100644
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
> > > > +(rdev && (rdev->dev_flags &
> > > PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND))
> > > > +return NVME_QUIRK_SIMPLE_SUSPEND;
> > > > +
> > > >  adev =3D ACPI_COMPANION(&root->dev);  if (!adev)  return false;
> > > > --
> > > > 2.7.4
> > > >
> > >
> > > This is still broken, why resend it?
> > Sorry can't get how come the reference count leaked, could you help giv=
e
> more detail about this.
>
> Please read the documentation for the call you are making here.  For once=
, it
> is actually written down what needs to be done :)
Thanks, get it now and will update the patch.

