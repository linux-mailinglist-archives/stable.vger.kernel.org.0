Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18721425A64
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbhJGSMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 14:12:39 -0400
Received: from mail-dm6nam12on2103.outbound.protection.outlook.com ([40.107.243.103]:24161
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233744AbhJGSMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 14:12:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcgsvlMaBW7kGjUe23w+dbHqkkX9SS3MhKMR0iI0b5TEor6lcrnyUwNLzDzqZlr42eNxCkvX+hGldJt6sAjwNgyh1i6Wn0BxxpsxPeKzSWUkqdXp4LIaRiW7X0Drte41MjTGAT54RwiL6wgG8AVgcHfIavcK+e+tVnI6BITpq03rJBLwYTijMuYlbq+xBGBPQcOneyP7i/t2wtVnyucL8wlqmZMtjAJ/QfwKwG9kF2YxluFdwqj2RZgVul2SL6LW7htjClO5Jx5tE8nTLkhVbItAN6MABykZsLvsMWBmIyO5QQA94WfciD5RDcxuvcKW5gjQvBMr/3Nyjfw5CowO0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0wkT1qTRfDGu3xKE2rjhx6eMEnN8wM1yYM6j9UA67I=;
 b=P8fucy5iAXlRSOC9jRRr9OPUEkOX25DSD8TPzhqTUnifD8gDqhHCqqNX76NTy1dEgNqev58MndnnY+u0cQp8caGp3lPP/4u9jdcg7Xc0COruW1NGNwOqmGjnw/9VPu1u4lbGNjTHnF2Uz4mBwJijyXSrHl1R12L4KqVb5E7cvRasKzAGPR27rbbbW3LavEqMoYYN1xFfIxg28Kq+1grmb6chLnBsREklwR2S5CXQCQnjKE4w453kizOw9kaTpeEAyU1MVpZ6NZF/Wo+cdXfOaBJ2z7sECKmSadJxMukhIfNXOqNNA1ml1bnAta4wN1tcY/olZGawa+w2DqJtn5MaJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0wkT1qTRfDGu3xKE2rjhx6eMEnN8wM1yYM6j9UA67I=;
 b=ha7C+NWXeu7Bj/QMgrkOZVFpoW6KNHCv64crHNIPh77lKWLg1INcnOiCN0WKhkkQ4jLhmsr909udTHFCHrvMQX2zkgKb4W5wni9ddxov57vhxifv+CTgHjEVgdMguNH3IfMA+7dk5cWh1+qq0bxRyese2jDjVIfV7RRtc0EyxfA=
Received: from MW2SPR01MB07.namprd21.prod.outlook.com (2603:10b6:302:a::17) by
 MN2PR21MB1264.namprd21.prod.outlook.com (2603:10b6:208:3c::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.3; Thu, 7 Oct 2021 18:10:41 +0000
Received: from MW2SPR01MB07.namprd21.prod.outlook.com
 ([fe80::899d:a1ed:4bd3:1159]) by MW2SPR01MB07.namprd21.prod.outlook.com
 ([fe80::899d:a1ed:4bd3:1159%6]) with mapi id 15.20.4608.003; Thu, 7 Oct 2021
 18:10:41 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Topic: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Index: AQHXu6PWXrep+jsTGkmI6gXJ5xQ91KvH1Wyg
Date:   Thu, 7 Oct 2021 18:10:41 +0000
Message-ID: <MW2SPR01MB07DAED7AFEBFC14D2131EBCAB19@MW2SPR01MB07.namprd21.prod.outlook.com>
References: <20211007174957.2080-1-decui@microsoft.com>
In-Reply-To: <20211007174957.2080-1-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ebd38ab6-8bcd-4a2d-b575-f2a9176ef465;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-07T18:08:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65cec651-36e7-420c-a854-08d989bdc645
x-ms-traffictypediagnostic: MN2PR21MB1264:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1264BBD7954F757B0B0BC8F2CAB19@MN2PR21MB1264.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 274hvsCOls44WoL2/gZnCF8uecuSOsNziPBRTcApF0VY9nD0UJyIMOjRi42CQN/sxgb1o8t6IjgR9rbR9HquGsSV3he/Joed8ID/6W6FZ1LHuuCfFDbqBbJgj9j9SqafnrMtUreQsL0T1P7OuenQppngSX3wR5VoraNjTrWVjqr/XDl/LRGiiAQnycjfbWcezZtYiF6WrcQDdCK/wTjsKky9xR4LYquRtKntnyypdmGIAxogkf37XS8MeHqGDoq3oAxRV151zJ3O6wlYXudcuj90EnZw+wq56pUV4ATz/oLnRm2uH/EExtkWHczS3CD+SEeTfUagdqKZDZ6H+TXK9n+9paQ1eT/o/SeDQctiT4VQxGpTJp++7WzQZJZLSWxjtI2OzXDnS68Wz9JXRslFqBuWtuEpgJiPl3d7oo8RF76MWKGmW2+Acidjtk7cEYOLaRQao+ywzmZDlEkwRxx2FY4WK4Zly7mMYThnHTkvCEYZXEeWuX85slPmXjsbdGIQ3+Fd7dFA2MoHXzQvbL/Ud6xmPfocdVAHwfOTITcJ6xdpCH+lcQtYKawvc47LAmCQnFwC7mVXYGtgLg4Ah+M24E2NL3yfAcGvKK5Ox8OBz0/eRmAemrv/TB/wVxFg9sAZibn4G47KC/oyhqS1Zs9sFGqwRMmQHge2D8IQ7736ZkZ4aXbA8d3Zq9H0+Vu0KvIrzdCuV+vO76NOsmFf6QWT1MvQWto6f0EJOEJ8Rj8YMWCXF5d0fX65/PZZxmhEcstvD67IvC/iXZI4q7D1TqPgY+GhMeSHwGC7GuhjDaz/2EDFoDVYMps3zzQDAXyw+mL5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2SPR01MB07.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(316002)(110136005)(71200400001)(66446008)(66556008)(54906003)(38070700005)(64756008)(66946007)(508600001)(122000001)(5660300002)(53546011)(33656002)(76116006)(966005)(8676002)(38100700002)(83380400001)(8936002)(86362001)(82950400001)(82960400001)(921005)(55016002)(6506007)(4326008)(7696005)(2906002)(8990500004)(10290500003)(186003)(52536014)(6636002)(26005)(7416002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yZYWPGlRLvjO43BeSZOV1XxKnVeG4/Qp5Mek5DV3X0/wcEiZAnS7pja0Eq1n?=
 =?us-ascii?Q?SrFFVdA0FgMO4cZ8M1CcCtbV+9GvTUXQU/BWD8QhqlONdDBf5Q3KY2GcWMcU?=
 =?us-ascii?Q?Khar1MAKVhtPepFASQOq4Vq8cxEgrq50MCbtmXpZ7lbZjRRNx9JOvq2/DTYa?=
 =?us-ascii?Q?WmELb25XbVIP9vCqx/bUGD1fq5xZu9gIy11+ZEkkBnHSCuiuWZxTykITPHjy?=
 =?us-ascii?Q?Ds7TQdLCcPjvGR/1mk8PLm7ZyjZK028dMfR4Oh1V7yXTcKI1AxRpX96MpvKn?=
 =?us-ascii?Q?6WIHDWldiG/sSohwxfW8oTb8mJdi+4dJ/rIqvPslG2sWdVK33MK34XdVGT7u?=
 =?us-ascii?Q?kvvjWBoyfL/yshXz+tReMwmPU2XyeYYAvS2QrPOKrSukCASSNePeIS+VROxg?=
 =?us-ascii?Q?tv/CqRDAlshgYNxPyxjSbNRS9InT+XC70dcA0/TmVfsFM03Yr5CrGai2pGFi?=
 =?us-ascii?Q?f21k5FdoyBfYHHcuoEzIVOmZi7Oqn0V1ykoVXrzaPHXIwfbtqR1yuYI5TXhD?=
 =?us-ascii?Q?7DedUFincH3o/66UrI50sG3qMfyxU9mD/Jl4/KOAeOcq+YTqQ7l2KCMlWPEp?=
 =?us-ascii?Q?6EaFOnGz2vob++4UfzZp0ufZbEKP/Du5An5vXDD/g2NjVhZ35gWAos1LyO/r?=
 =?us-ascii?Q?Gc2Pjsh44CEKneT4cAJceWq1cgCDWiCpGMhUN9KyO4kIzhlZQ8QNmSz29EB0?=
 =?us-ascii?Q?J7lBUwarf4kcGOjxSnH6NLC2Hghc2AP/3bBGz6rlPNIxhJvBS7oeN4YRdm6C?=
 =?us-ascii?Q?DRWAzJMIAnPy9Icz5gNEc3ktEOV8etzhHftwyMUZAaq7CrMeKIIjwmp7NCvB?=
 =?us-ascii?Q?zdTxh4PkD7wraOQrcK1HVaWocB9I3mPB7sD7ifFie/u73T3scowlyPwssT3S?=
 =?us-ascii?Q?oJ6W5rodXpJJUYTutPj4kKyW/FV0hR1GLqO1s55XHmAGnMHdGh/MVRB6h1nK?=
 =?us-ascii?Q?dS5XjOPY0G9wMcevf9Pa1kr3N2M+R/bXjzgV44+rrt8dp3HGOivhfI31Jxpy?=
 =?us-ascii?Q?GdNIT2qlA4qxSpkDhZZcMJLHC2rTdfuCg67fFtHIVsBFlMpsAsI4x8gs9+su?=
 =?us-ascii?Q?y8R2rPCJ3ZuYXyQLXsEhl5g1zvAfSDGgZEtiURoehh5+3iIJnE9G9Ajbf7zw?=
 =?us-ascii?Q?6PlapblmjhAYUltEGJ2aVNaEbz2sqkAMSOzsDEb5KCXssE6imnisiTLL1+hR?=
 =?us-ascii?Q?BiCiVn6DZ9VqsSOlRA2Ph2fZReIba7+4IV5OCaFrXpi+sr4dPL+Xgsui77Sc?=
 =?us-ascii?Q?p4RE3mBHLvhzx8V4S8fp6URmpBsx0dLNMgdJGauQ6DDc155olcC1SKjo6uGg?=
 =?us-ascii?Q?Qxqid7m78HtFvHVbDuKKaCVN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2SPR01MB07.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65cec651-36e7-420c-a854-08d989bdc645
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 18:10:41.7354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4Q9+3/gSpSy/7nKKywZsrIHeYD65sLfM6VL2C0NcgCrdr9Xpp/Vuxp9QZKOg46kDTok3aAHuiI5ne4xI6QHiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1264
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Thursday, October 7, 2021 1:50 PM
> To: KY Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; Haiyang Zhang <haiyangz@microsoft.com>;
> ming.lei@redhat.com; bvanassche@acm.org; john.garry@huawei.com; linux-
> scsi@vger.kernel.org; linux-hyperv@vger.kernel.org; Long Li
> <longli@microsoft.com>; Michael Kelley <mikelley@microsoft.com>
> Cc: linux-kernel@vger.kernel.org; Dexuan Cui <decui@microsoft.com>;
> stable@vger.kernel.org
> Subject: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in
> scsi_add_host_with_dma()
>=20
> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
> negative number (the below numbers may differ in different kernel
> versions):
> in drivers/scsi/storvsc_drv.c, 	storvsc_drv_init() sets
> 'max_outstanding_req_per_channel' to 352, and storvsc_probe() sets
> 'max_sub_channels' to (416 - 1) / 4 =3D 103 and sets scsi_driver.can_queu=
e
> to
> 352 * (103 + 1) * (100 - 10) / 100 =3D 32947, which exceeds SHRT_MAX.
>=20
> Use min_t(int, ...) to fix the issue.
>=20
> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at
> can_queue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>=20
> v1 tried to fix the issue by changing the storvsc driver:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flwn.n=
e
> t%2Fml%2Flinux-
> kernel%2FBYAPR21MB1270BBC14D5F1AE69FC31A16BFB09%40BYAPR21MB1270.namprd21
> .prod.outlook.com%2F&amp;data=3D04%7C01%7Chaiyangz%40microsoft.com%7C366e=
6
> d0bf755492c631c08d989baf4b9%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7
> C637692258384408217%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoi
> V2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DRbNgx1aBBBzfHC3=
p
> EdKyBZWaaQIQXS3U%2FItEQUe4NfQ%3D&amp;reserved=3D0
>=20
> v2 directly fixes the scsi core change instead as Michael Kelley and
> John Garry suggested (refer to the above link).
>=20
>  drivers/scsi/hosts.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 3f6f14f0cafb..24b72ee4246f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,
> struct device *dev,
>  		goto fail;
>  	}
>=20
> -	shost->cmd_per_lun =3D min_t(short, shost->cmd_per_lun,
> +	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
> +	shost->cmd_per_lun =3D min_t(int, shost->cmd_per_lun,
>  				   shost->can_queue);

Since shost->can_queue is int, the min_t type should also be int (the
longer type of the two vars).

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

