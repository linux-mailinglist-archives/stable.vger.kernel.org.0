Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599AA426010
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 00:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhJGWyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 18:54:00 -0400
Received: from mail-mw2nam10on2119.outbound.protection.outlook.com ([40.107.94.119]:19392
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231825AbhJGWx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 18:53:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLqyzVYedRnIMuvVyKRvy1gvU9Wi0XZKfa96U6A3Vk4bumCf6i0pdifDI3YDwxfoE8nliTyiIxmM1Qydjeh2PR28GdOxMAoaQFrwNgzHnVt2Ypy3VaMTdg43z+6LSBG8R4J42MT+UEYmAnuK6FxanQBQ75ov+q3Epr5SleogMZr3e7Q/OmlJy44FGA+qbRH0mlQwLI7NwK5FTILdvzKSw8D8RRSs3vDO/oPau2/AIWcHP+y+FCGpk46YN41drttlOVb3aZb1oML2EHDf8q1tGSV2ED1wKDXdT8pS8sZXAXlFU9dNYk1ZAFK2AUD04susGBWaNlnAYhQ6DVc+8kF9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WyKWLB1jeex/jzgpTZOT59OH07XxBUpR4b3UhDWOVo=;
 b=CL7zVH9YtHnkFr85ofu6IRqnQ4qSPFWoCAvbgWkFThs7vN19ZR+VtTNG0pDUYOupE7ehyqDo/hwV+GMBSQqkQCL7Hk1/OxCBRxmtr2LkxPpHtQggjJ5CusEbDlxilF+fBqJwayIW6sP5pOOhmlzX6hp9wf3MCz4Rq+afwA90CLFdcGUR4wr4WG6ou00QQmSIB+aGBR6ewX8WPHik40+DvsQ+2gqUCTZs+6/ZfPqOJcxBeyeWg8ItqcsgeHlyTQubBitc7yGiRIJFok379SBzaTBh7C0S2oXjKiuDKXSe9PT3jRgO/kbK9cRtIpTZjFbDRr63qBdfkgOPguhtgq8JSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WyKWLB1jeex/jzgpTZOT59OH07XxBUpR4b3UhDWOVo=;
 b=NP5pZ5/n1TuI3gAKl51o6TmycJDMaaRAoZRz7+XNjZIblfto2iYuIhRAWPVHLDADXE19ndgfjWpVCXmYg9R1WLmMUVLlFqBzW7i3H4h5E9TaJVuUV1Re8Ej3KLUinxtYkIz58bLZU5LW8fSPpYbKVEs+8FKhJ+14QfnSO6zjDAs=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BY5PR21MB1521.namprd21.prod.outlook.com (2603:10b6:a03:23f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.3; Thu, 7 Oct
 2021 22:52:03 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::78b5:7b19:a930:2aac%9]) with mapi id 15.20.4608.005; Thu, 7 Oct 2021
 22:52:03 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     John Garry <john.garry@huawei.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Thread-Index: AQHXu8PKLnlQ4XJtlUuFOqpHNjpFvavIFzfg
Date:   Thu, 7 Oct 2021 22:52:03 +0000
Message-ID: <BYAPR21MB127049F258715B6F33D1B2B0BFB19@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211007174957.2080-1-decui@microsoft.com>
 <8fe3959d-9462-64f6-53d8-ef7036ec0545@huawei.com>
In-Reply-To: <8fe3959d-9462-64f6-53d8-ef7036ec0545@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a89762ee-9c49-43fb-a81d-ed78e06f3d50;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-07T22:05:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0df7953-a4d0-4859-1ed3-08d989e5146c
x-ms-traffictypediagnostic: BY5PR21MB1521:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR21MB1521750D622E8ECDD32717DCBFB19@BY5PR21MB1521.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9hLqyGENLZEOix9W9QKrvqdAaxRyOvFrbDz0N/3VQwby5b9OzuDDfAKD5ivrm7abk1h2troa6Nmf9/aGPamkAHAGf6FI46WL/4xDq2cscqEyrsMfu++fYuZ1N3CFIRQT8oytMQ8oydoqAWr7EAKTwA/Vb+Z6xsPzjr+MjYSmvMiF9JWqmkJIF70f0dBN9Cc247CGlNS+a2quL6kGTVRiZGW1kyD4tV8Dz2+/DovF6OUJqoSQm7A6KQRfdgV8wVID3iMrRh0kHMhG2vnA9LLGsxggnyIkhOT3OEK0c0iHY4TEmgSgbz5VTQJs/tF0H0NtpydX3U1Vkmxi6Y8i2HQgndcCeEfNvKmoScFUXbOiCKD3foArgKap88bUsFrAQrg0D8+IcAaXVUpf1gu/BFEmwBLJwD0PgY6+00P2ETXMKguXNKFGsxphv6EnNFjF5emnsDxhFBxfArambO7rhkIZfX4I3VDuS2VzaWYv3Tb6SW0o5PMs2WP5WUXsGD31EN7nMwL9gYh2YZdukX7u8dj/CfczkzmRA9LZv0qwyYI/jRecqkTtvT+7tnei1IJms2gOStgRiHg4ApYrbSvm7xFPPE+d5vTZrNod7uq6rQSwQCwiML//EzwixmbUDgnVWi51CwD/1FQZepusQSqaMFuXNnvvhoBhVsLWbAWufbT5SsfbO59rJ8L5Hn7pHO0nKIHYdInB8MsLzdTqQPkJx3GD8u8nRqhcyQ69Tf+01SjQo+o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66476007)(38100700002)(122000001)(82950400001)(8936002)(7696005)(33656002)(66556008)(66446008)(64756008)(38070700005)(4326008)(66946007)(83380400001)(8676002)(55016002)(53546011)(7416002)(9686003)(71200400001)(8990500004)(52536014)(6506007)(82960400001)(10290500003)(26005)(921005)(54906003)(110136005)(2906002)(186003)(86362001)(6636002)(5660300002)(316002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NIrGOafIwLCuRe1wbAb7QisLbiLJoMuFeoXj7AKRMKHzoHHnGVytcvCfilbM?=
 =?us-ascii?Q?9qK93FpD1QEtHRLjYtViiAGq5FbcnSuHMTg+Id4WLYgujaz15CVFCfCxFrHM?=
 =?us-ascii?Q?VF/GCCoVuszn1DV/hkox6F5wkEiOUBBn6WsQG1805S1Bxemmfhcjb8/nJU2d?=
 =?us-ascii?Q?kUZJjIG/aMVrvPyAbKCFrnes58PCz6Yb+R8GUQv76fWuZdphKUPqmiyMAKyk?=
 =?us-ascii?Q?yRm5kR2n4EdVk+Asgxj+IAUf52Scfz+HWIOQIyH4FeaG/JfCSMcDJ7kP038b?=
 =?us-ascii?Q?EMxYKlT+FWLQZHsXqxT4VE0FGlc7piqXnWA5PE7Gt0YurwcbVt0ktb5GjjTi?=
 =?us-ascii?Q?W2+NAO7eoTh6u/2uF6VIYjB2NY12dN5MQOCu+XYAhbIg8QRqcPA9hNEoTOi+?=
 =?us-ascii?Q?CI7AfrJRVG+6tIdnttK1IaSxjGu/Mf/M+m3apeFaMm0IW6XONJQ8W1wqqXZZ?=
 =?us-ascii?Q?qJxvTaIVUskH1xS/trv4CDr5FUMtK4FYMpP7OLDp7vn0GY5TyULGTUeINJIF?=
 =?us-ascii?Q?MXLesTqX7kLrmxEEjBlupTteJE66GT5UUiJm2ly3VS+ocqoTgQAFNfI34DKG?=
 =?us-ascii?Q?S+khQtBBF5wH5+6suDrAKTzUg7zxkotxEjuQbX+eAtyFC7oX45rWl4PRCqQX?=
 =?us-ascii?Q?guH/fs0kisrF7Za1sL8BqpbtQGntwZtwvTbtENk4/16BUrrp7beS2Ad3QeCn?=
 =?us-ascii?Q?FjCvNvXMHXbCyZMCQqHBZQi4whmEWq51qjoxJVAdG2pUpyt55/C1L9o3lk9m?=
 =?us-ascii?Q?JrTKFJEG1RB9n12fEzSBqzP1u0xN0GjtiSoKt653rluLJUITZlXyma4RVIwe?=
 =?us-ascii?Q?I21tosY4XyquabLuaNhb0rs61d+EMm7L31HrhJCIqoTSgnEYnUPE0BZiq4Jk?=
 =?us-ascii?Q?nxZX/n0cF2/Yylizl2mKKfGh8FpxChp6ckPtNwD47Bhrp+YGyy8Kd7s8jnKz?=
 =?us-ascii?Q?E6ZITMOYy1mcW6nZkLIzzY7+l60qKluxepSUz+aoTY34TSkZXANvknAPQBLo?=
 =?us-ascii?Q?C4091sAAU8NeunZ2mZA2NXj9BN2pbJLMesjwaaX74tzcM2t5uom+TbtrIDvt?=
 =?us-ascii?Q?N1c5TOCDJqpBgtyn3wlPwsvDXOn2jU3qBPNYVGmdYCLnK8R1KQ3XPtjNjtBJ?=
 =?us-ascii?Q?IS94eP6//OF3NDC4fEr/vpiUBQbfWZD0Xvv4R7s0+jb/ZSY+Y/M5SIfJJXdT?=
 =?us-ascii?Q?jWZdUXAuux8WNyCc9Q2ZTo/cLolg+5c3dSxPN/X/xxJGx/0CU6KtdvFT/L6X?=
 =?us-ascii?Q?WuDbRrJbd6+3niLEJpNBl/5MUgtZKnERWPlZAyQ+IipNO+ncphvLoIbJWNti?=
 =?us-ascii?Q?HaC/r+kuMqS1ogy+PZjWmP1m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0df7953-a4d0-4859-1ed3-08d989e5146c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 22:52:03.1242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7QCssjHWlGKlzu7bO1ZmvmokoaRvIgzPb+SwQe43cx0CRVQc/FNY3euRVEzzaPz5/GGQaE0s8SZuFjSyEtzDeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1521
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: John Garry <john.garry@huawei.com>
> Sent: Thursday, October 7, 2021 2:42 PM
>=20
> On 07/10/2021 18:49, Dexuan Cui wrote:
> > After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> > boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
> > negative number (the below numbers may differ in different kernel versi=
ons):
> > in drivers/scsi/storvsc_drv.c, 	storvsc_drv_init() sets
> > 'max_outstanding_req_per_channel' to 352, and storvsc_probe() sets
> > 'max_sub_channels' to (416 - 1) / 4 =3D 103 and sets scsi_driver.can_qu=
eue to
> > 352 * (103 + 1) * (100 - 10) / 100 =3D 32947, which exceeds SHRT_MAX.
>=20
> I think that you just need to mention that if can_queue exceeds
> SHRT_MAX, then there is a data truncation issue.

I just hoped the explanation how the too big 'can_queue' value is generated=
 is helpful.

OK, I think I can change the commit log to:
=20
After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
boot because the hv_storvsc driver sets scsi_driver.can_queue to an "int"
value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
shost->cmd_per_lun to a negative "short" number.=20

Use min_t(int, ...) to fix the issue.

> It looks ok, I'd just like to test it a bit more.
>=20
> Thanks,
> John

Thanks! I'll post v3 with the above commit log, and I look forward to your =
review/test.

> > v2 directly fixes the scsi core change instead as Michael Kelley and
> > John Garry suggested (refer to the above link).
>=20
> To be fair, it was Michael's suggestion
=20
Yeah. Michael always gives good suggstions when reviewing patches. :-)
