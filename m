Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69A336005C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 05:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhDODX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 23:23:27 -0400
Received: from mail-dm6nam10on2047.outbound.protection.outlook.com ([40.107.93.47]:38208
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229649AbhDODXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 23:23:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWEeG7k/y5yQz4R2G19D7OeuJn2eAmUOiJS9oMgrNCd77OZ+q6aMXZmo8Emy+y+O7o2hA3WoNTx/6KYNYIHy3FIX7DZTUitU7FXYUP2FkcQ3OEC9aCbgEQqyIiGkHjtMV3t8ULtzC7PNg9PCQoHCF7U48ZfuxXNnnYxyRhWz1vxWTo9iW3DfOrVLiCQznA1vlbwc/VuuMtgVsI6pzE/jnh/NnzlWyLaEJthF/378hbBydWWkKjjQB1b+J2MRh6b7y3SOQXoUbK18lywEtBv9JQMiy1fona/mL79dg5GHt2wPh0C+1eBp+mdlG3Ve2EwhGchCFdiVC9UdpxoW5z4uMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZGEBqsg800u7DgKV02JTKh/h9ksXDQDxcBhd0Qt4rM=;
 b=W/DfNIMwhdT1cl7KSH9pXn+qoYCQhuRcZ/TbX0Lc4yztycI10wDN50mX5OmbygrI0TYc/SndiG+cKiTCMTib5b5cq48QqYYtbEW2ug9PpUa5sdD5xUjZYPXWoAH5k5Ja01mpX/KGfwr2Rzu2vawff+VFKe9m1kwk7f3ygx9Ot6F6q5iFQpw6/F/jDEiT1MkK15kYU/IE07lO2xOVnWOaAoZg6zR778O7Riu9f+vsMCOjAykXN3Pade/cEBzLyj5Tjgb6b0QojCBs+vZeWE4hsWM/BUszKM3m5hgtzUc+6OXpibSsqljipgzpgX/4gzx6VGNTqFimxdRyAVb5OmkgSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZGEBqsg800u7DgKV02JTKh/h9ksXDQDxcBhd0Qt4rM=;
 b=wM63O6+ZS77eVMAYUziDBenGFFapdz6EnGA+tPM9qW5pmsjBp7YYKEcRdHLYhx4xZxA82C5jnikJtVk74jNB7uZ9ytaGE9uU8BUQxPPEPvda+VVuMX14773wkcCmXuBu6XQIznsQLGTg0RXKwYW3xY73ekftWCAbsHtYCOk7OQ8=
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB3650.namprd12.prod.outlook.com (2603:10b6:a03:1a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 03:22:53 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 03:22:52 +0000
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
Thread-Index: AQHXMQbUyHYou0SCfUyu35B/FPG9paq0MyIAgACQ74A=
Date:   Thu, 15 Apr 2021 03:22:52 +0000
Message-ID: <BYAPR12MB3238609A9A142C8A03AA587DFB4D9@BYAPR12MB3238.namprd12.prod.outlook.com>
References: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
 <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
 <20210414162408.GC2448507@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20210414162408.GC2448507@dhcp-10-100-145-180.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ActionId=33a7fdf7-c4e0-4d4f-9311-8f9e6d3516b7;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_ContentBits=0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Enabled=true;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Method=Privileged;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_Name=Public_0;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SetDate=2021-04-15T01:03:07Z;MSIP_Label_0d814d60-469d-470c-8cb0-58434e2bf457_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
x-originating-ip: [139.227.235.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5982a2c7-327d-4f5a-6e55-08d8ffbdc128
x-ms-traffictypediagnostic: BY5PR12MB3650:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB36508FCF588D02F7CBCDE16AFB4D9@BY5PR12MB3650.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ifv0pNl4KvxHuCgD9MTmE8s/h6ESpFMdR6+LyuxGM2DMjkaaq5nVmBYrlPdmEhMMUcQwovJECWVUmI4p2YLyZcg2tkXy6m/u2zCqt9WrD3a6ckPji/GDyxyg8Fma9I03ckxvUEXZn/vyFHWmM7PpHuRugt6l+bGegkX59VP0zjZTDMjdsZgKFaAClKft6Ap4m6QLZjOHUNLtMS+jhiTI5g/wk+Vm/miqj5QrMxRVRcOMJXxyeflbyyP7dG+K5rj+HYVaTFsN2e+RDW8Wpyy+2hv43Akduh+fFVQ5k8Wb45bEgjO+Xs88ZwcgqcX7SOv7EssqdOe5zUBms5GP05/u9W8RUnZnUXpjtsgJeaF0HF05xbn6t4UTLAerEk4N915Bnh3YGEQQxkTEebvHQGVfwix1ReevmzH2TPldZzcnHMXPozea+j3HKGs10gEfbfP5W+W0XHLK0ov9bREF+J105fhLVPC2tYEbj+hnz4qrxqW1aA2ynX7uz3Y3ZVAxQtDD02VEYoou+EDSpZg+snSEBM273lrUh7wimZ5js0l70lwbhkpxCoy3hC5RN8XFm2+i3wrtJ4FDF3hui0iibk29d953iRpXcha04oPRi2HzOJE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(9686003)(122000001)(83380400001)(8936002)(86362001)(4326008)(6506007)(66946007)(76116006)(6916009)(478600001)(53546011)(54906003)(2906002)(66446008)(64756008)(66556008)(66476007)(15650500001)(55016002)(71200400001)(316002)(52536014)(7696005)(8676002)(5660300002)(26005)(38100700002)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3a85kVSUl8Rq5RV7JPOqewlfPaXZK9t8SbGGGfLmozA6ZYoMYRJtdUbwHB5E?=
 =?us-ascii?Q?1jWekKa2wzlu7XouUQ2JjYXtil2ET1I12xv1V3ItQHFVJU93cFBHokl6m1X5?=
 =?us-ascii?Q?wGm3F+QcyadVJ41L7b7VEGtfP7O1idgsdyP3+qODavsArx9xTEa8PPZcYRNi?=
 =?us-ascii?Q?wRNhfIOvKid3ckdRWX3TAyNtowA1ShW6i2MLRAtG9RySpraJH5BuZZAILjXA?=
 =?us-ascii?Q?9yi1ANBFareaOhqEkifkfJX/yo3k0Rz9hY8389ULCfkAxmmyRZaHSRfc5Loa?=
 =?us-ascii?Q?RvkAnCXXUGoM/Mi+kwG+0Vin1UnbqWIsbwFz/bfqIPxoPlRI/6CsD2K5gm/d?=
 =?us-ascii?Q?fVJqF/japleW/YRZgVQtuAfUKfmvRcMXpXYpaeDQzS23lC3JPWZ+hY48kpN3?=
 =?us-ascii?Q?rwqm80ctgqq6FBMiBVdKvvxF9JlzQiZDaw+KnswGcg1l/Os3MD+PZSKPhVwN?=
 =?us-ascii?Q?MV0kvIoujR+7bBRwldDtRyHSW1CyoqB41hh92cXFyIhouV91v/o3JPQEkEvc?=
 =?us-ascii?Q?AFsiZHGDA97rsCR9KuPimDwvHAxPfRNXvnvysbH5BfBHdGUpb4mY9vr4hirg?=
 =?us-ascii?Q?4vlDflaOvUYXvnbp7mgSRs+/yzd2oCTCoAnUxXlNqXOwqOUKvSnyWdDsD/S4?=
 =?us-ascii?Q?lIPWq5lOFo5mHny6iFyc/gLBjp58AzWX2/0dFui1BYgJSLZfJUyXp7Fengat?=
 =?us-ascii?Q?v+FSF5a7M/5u+n+GW6M7YDrBZoRKO15xyAGI3bFAotDSIfHENuWhVa9L517A?=
 =?us-ascii?Q?UseUEwnp4f56GVTscQfvZXlIusCTdLrtCI1H6CyZbGF6Wx0aF2Gid7WoJNRC?=
 =?us-ascii?Q?RzsfuwNq67nVRZ0nTYq22sp15EkfLhV5k2A2TDhULWCfHdXbx7JhxQiPCU/Y?=
 =?us-ascii?Q?8bHC4cS9b3QFw+PDkX0c4ukMjaSVhbznJb1LZb5Cg0qGgr8lEc9ou8mD6R9b?=
 =?us-ascii?Q?xvsYYpAez9o9Lzy5Wx1Ba3aoowx+hdr83s+7DmU4qowUhpToA2NoXgEzjCuT?=
 =?us-ascii?Q?TyaNnurF4/oV8Wdi8WtreGCU4QqmDlGvl6Bc4VBHOuf8i+3XXQwUKjQoxIqz?=
 =?us-ascii?Q?cLbqya3xhDT/WNe9cst4e+cAqK+e4qsdjJRDhUvv5E40FnG9F1tXeDtXCBRz?=
 =?us-ascii?Q?xysaenY/XXsE+2FhN4TIBsTKnaoXDHpkjEPUEaeXkb0z5tD2hlCmQWDVC6Fi?=
 =?us-ascii?Q?4LSWBM2YTYd2xCsZvUaMJP8itjL97Nxn8KCR7KTKgfYhiIiVOsn5qk6JuyKn?=
 =?us-ascii?Q?6SqBxFLNGk2PG7fY2yGBgTsZNCb2Tr/6kWNYHArSLtq8xPmbRrcwPu3ErvgJ?=
 =?us-ascii?Q?O1SVo/TqwucLNwv00hPp4duN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5982a2c7-327d-4f5a-6e55-08d8ffbdc128
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 03:22:52.5340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y9eqcthDFoHExPDcs1ANmGlMKP63z90YSjd9eGkbiIPfvED3/0QDBcLoHbqVWEiN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3650
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Public Use]

> From: Keith Busch <kbusch@kernel.org>
> Sent: Thursday, April 15, 2021 12:24 AM
> To: Liang, Prike <Prike.Liang@amd.com>
> Cc: linux-nvme@lists.infradead.org; Chaitanya.Kulkarni@wdc.com;
> gregkh@linuxfoundation.org; hch@infradead.org; stable@vger.kernel.org; S-
> k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>
> Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
>
> On Wed, Apr 14, 2021 at 04:18:01PM +0800, Prike Liang wrote:
> > The NVME device pluged in some AMD PCIE root port will resume timeout
> > from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> > This issue can be workaround by using PCIe power set with simple
> > suspend/resume process path instead of APST. In the onwards ASIC will
> > try do the NVME shutdown save and restore in the BIOS and still need
> > PCIe power setting to resume from RTD3 for s2idle.
> >
> > Update the nvme_acpi_storage_d3() _with previously added quirk.
> >
> > Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > [ck: split patches for nvme and pcie]
>
> Chaitanya's Sign-off should be under the annotation explaining what he
> changed, and placed below the original author's sign-off.
>
> > Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> > Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> > Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> > Cc: <stable@vger.kernel.org> # 5.11+
> > ---
>
> It doesn't appear that you're reading Greg's autobot reply. This spot rig=
ht
> here is where you should describe what is different about this patch
> compared to your previous versions.
>
Thanks proposal and will update the author info and patch version.

> >  drivers/nvme/host/pci.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c index
> > 6bad4d4..ce9f42b 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev
> > *dev)  {
> >  struct acpi_device *adev;
> >  struct pci_dev *root;
> > +struct pci_dev *rdev;
> >  acpi_handle handle;
> >  acpi_status status;
> >  u8 val;
> > @@ -2845,6 +2846,12 @@ static bool nvme_acpi_storage_d3(struct
> pci_dev *dev)
> >  if (!root)
> >  return false;
> >
> > +rdev =3D pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
>
> Instead of assuming '0', shouldn't you use the domain of the NVMe PCI
> device?
Now we just add the NVMe shutdown quirk by checking the root complex ID ins=
tead of adding more and more variables endpoint NVMe device.
