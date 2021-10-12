Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF27B42AB8F
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 20:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhJLSH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 14:07:56 -0400
Received: from mail-oln040093003004.outbound.protection.outlook.com ([40.93.3.4]:33520
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232694AbhJLSHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 14:07:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWzEAS4iVW6lD1x354jIu1MtfIj78fhZCl+9YWQ+2VSuv81X+VyLnTtxubYKaWbs/oeFE8+0cLc4b/5ewcYGLTa6hHQshvb59aSzmEEK8JTJLBmTtZHDBqEXqEpKTdZFAqEf/7Bm5+u10U7K/gpWdZNFUQu/3f12pEz8Y0nVs1mBeAW57WA14DjpPIhh4M/GDsgEOv1pecI/eW0bw8o7D2THcmeRb/U0qd00BL8zXVA6XqW5gayF8KFyIGytzUe8sggeQB32R/pBzCmlJ2QANnOOdDWNzStcyWoN7EvGAAUZNtDZTEB9uqGyYZH9rKUwaPJMrwiVrX+u6I3ObXssOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFx5K3WcPOCAgGfkRkJV5SwmmoVuund2ULwljgnxQZY=;
 b=PTcoFzeKc+tIbeXkxAmo+ngz6JXt+xNOxcyDT54I6anRNRxuwz6xz+xq3AjD3p4b5ER01deOnP+/xDKlS8m3CNbxOsFk/ahraM7H6XcY0qOZykHMHQrc18tWIaiYc8x5gni9O6PGTHAyWgMq8xe5BgPo4gtmgMEQjrD/c3m1FOzCUFMUDFg6gD1K99GrfZyBIVy4thwoXBqEYlqI6F809qMwuVym9A6SVJzWfr6XHGOUaR+0YoRKFz5nt+4WVIiHOsQswFWV1abBwXt+yOwm/gOVY1djkgiHVBHV5JN1VWXMo12y3s4AssUDnrMPrPjZV4Fj1d0It/BttuJYbHwOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFx5K3WcPOCAgGfkRkJV5SwmmoVuund2ULwljgnxQZY=;
 b=CFiH1OkEd7yXkY1BodPaG+r8evvlHdcGcmCUvlkqMfAExk1sazf2e1hWjQKUA7BM72rBTbL079QEWYgXJO1uPuZD++iN7x24y3tqYG12jnEh8WTvq/LcWXcU3L/d6QI+3uCgnNxBvLk2OjHB/J8vOXn/ZBR8WIs/u0SZj0XKjHU=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1309.namprd21.prod.outlook.com (2603:10b6:a03:3fa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.6; Tue, 12 Oct
 2021 18:05:47 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9ee:ca13:3fae:4faa]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9ee:ca13:3fae:4faa%6]) with mapi id 15.20.4628.007; Tue, 12 Oct 2021
 18:05:47 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Long Li <longli@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Topic: [PATCH v3] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Thread-Index: AQHXv4gYaXXuoTkdsESnUMEs4EqppKvPpJjg
Date:   Tue, 12 Oct 2021 18:05:47 +0000
Message-ID: <BYAPR21MB1270CD89180A7979F34682EABFB69@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211008043546.6006-1-decui@microsoft.com>
 <yq1pmsaqjrk.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1pmsaqjrk.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=041eee7f-1f72-4c40-85a8-432aa706f5a5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-12T17:51:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7601d37-d1c9-4743-a64b-08d98daaeadd
x-ms-traffictypediagnostic: SJ0PR21MB1309:
x-microsoft-antispam-prvs: <SJ0PR21MB13090DD72B38C9EEC6802F5FBFB69@SJ0PR21MB1309.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wsu7HT3nFfIrSHoyhPS5/8ArOwmuLMGjhsMaeHSZGQKQg1kWniTRax3ubGbBMKSAa8P/qwN4FGiv54nlGnaNA07QIiwIR88a6Hh9Ok8R3PwS20C7ChVXlQjjmsvlgfRf9WJD8xhffR9eIl2aOJh59HLMqsXhEo82tNhcO8UQoCKqpuyng+Bm7JMA5SFh6y0sUHZ5v9V/NSonGo5aB3zeOUKqYbc3BKMMX5ZKhEU+C97DW+FhORCfe6iCuuToITRZIEGa+eF/n/AAl8uFEavJ095avT8+nqr7dKG8fl7kM7gHgjf/uZwFPc9wVbST5N8cQXrDeQRrnLF24XhWbBp3ilvhkcQvThPARAKChE/YerjsfEuQ7LI6tPDmSpmvzRAK0jz2LMSKZcHZquNEO8qe2TUE77WVBfIjza+DJ5xwZmXsvnzh7IBQBwwypRlgE2y2Q7I5SdQTaw20cPgHX4wmO3VTEIcCJZeZNtXvpHh9ch73NsOafYzI5F6Rf+J1T95xzpkZA4XGFdV1ixJCIPe/+u1atqAMCP//aTmUYjVNOvo8d/emlbWxOioIAywWyAoQp/iUyUvWKMP9h2Pk1oHcsEa8AowhgGTBWzTWfIaN+Dmc0zrKper4C2hcdwnZ/96yoQFxzk0r8D6uJnzHnpeE37j1aQVfxa06gpqMuIB2d2A1t8XNGeVo+5xuFOhXeloeTpLI872LyipM1UH8hK4wWqzMg9xS/VcyEAIPEOtaTakf0Vy9iZQTdKZbn8pD9uzILaCHhc79yNCKSxXsGuQL//YHB1gaQJgGYFIKEa6jQ6w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(82950400001)(82960400001)(83380400001)(7416002)(38070700005)(186003)(33656002)(66946007)(66476007)(5660300002)(66556008)(2906002)(26005)(71200400001)(8990500004)(86362001)(64756008)(966005)(8676002)(122000001)(54906003)(508600001)(316002)(7696005)(55016002)(6916009)(38100700002)(66446008)(4326008)(76116006)(8936002)(9686003)(10290500003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7m2nuHSMbY+FsifZioqAEmymplGdL57+B8fHX9UjX0uA3xc9q+8n2fWg2hyN?=
 =?us-ascii?Q?jgOmAf8VzGpBrOxWQSa8BE825lKceUSz2kxYwGtQxgv+q7mq1UCiAHo7Bvga?=
 =?us-ascii?Q?94b1OyQ5ty12Jhrmsmjp1C/ZcCKbS7/3BY58UxmUdmMJxK2ryXriNKewZj5a?=
 =?us-ascii?Q?mg9BZIMN4ni8V4g+TRVV2HE2WCTtDnHBSxoX1yvmrK4AyyP53cWTQktEOlgs?=
 =?us-ascii?Q?uzMjBthPR9OZRTK8dGXlTEtNGkbwKUhsS/cYsNSqfV7z+RheYnzyRwwReuX8?=
 =?us-ascii?Q?AwwhxlWb12GKOxTSS6WrAcjUl7vfenQZhZBwwoCLVPCHCDsUEfCviGSa31GZ?=
 =?us-ascii?Q?MVisyxXtVzn7Yps3eGKbV0X9O/oDts+oYX7eUGfvobCOv6eSu7548MuyQjmF?=
 =?us-ascii?Q?hvPIwJ29TTzhMni+R9nYAntfv8OPTc0CUJFWeck+Asux0vESV6y0zYk3b7E2?=
 =?us-ascii?Q?q9uTCHGUUXA8onSljJfOCmIyfxfyqTO2E5kttCnXKfuwHTMMxAYlBU5+6Ty5?=
 =?us-ascii?Q?MUbtCa9/HCuvwwWzG07sQvv+3saZ59dIFfJldtZB22pMXMp+HoaegaUwdsAt?=
 =?us-ascii?Q?f7nHPKbeBTMfNDYUeu4SHfDsl8IMUy6MTFWaZ9J1PG8bXOxfupSu2OSe9hZe?=
 =?us-ascii?Q?iHC+1qHIv8drr0jw8CqzZbaRTyE8vGYLQK4DKorOVxH4S1T04MyHlrKl/S70?=
 =?us-ascii?Q?5omHHTDiRJdkoYWUlkcjbVUJz+pCqANK9j1Hqs/Gxz8LpfahdsdpJz+j0pnV?=
 =?us-ascii?Q?JAinGZ6wuMpGNzxYKIz552P300f2ChGuvVnXnWABCjW8o38BYxqmBSYEcJc4?=
 =?us-ascii?Q?/3FXNXpugaSz6L3Wa8IclAekx+kPY57rprhVv8zXW0qSTOneHKbNpQEKUM4e?=
 =?us-ascii?Q?NNkKc80HrZlxZVA9h9q/TAfb6I3MA8VbEkwkKIGbb60BAGxX5ZH4E5dXkNsF?=
 =?us-ascii?Q?6Y1HJ93q/fD2Cr3/chMKzxq+LYgl1PJVWEsl4UAp5G1RDzpmq+qAok9M9edR?=
 =?us-ascii?Q?3Wsu0D/15T31iwpzX7ss15prG1cuu2iUAytEQIEXfANA4GpvrPEx10yhrjKc?=
 =?us-ascii?Q?XDIkM5S66afKwHGUbnFdtv+YlUvmHlP2oy3w6yogx4BPSsbVHGPv2yLLfcEu?=
 =?us-ascii?Q?7DVD8nalrPVOvmNDfqd8v6mJ2vj0xVXeZVOgMBWHGciX9j47oNjdaoU7Z0yu?=
 =?us-ascii?Q?Gr2y21Rfi5E0wF4zrmcu8U/sv94p25u9tLacv+fBVmRVmG2PdrpVOCt6VeRs?=
 =?us-ascii?Q?RkJZ700WwyDM1UQdvq3Cd3D2zLXOXwhtnKYazN8KYtBLC+uFGcuLW+gz/ZRq?=
 =?us-ascii?Q?SCMvpi4H5eOJ/5LumVc9KEcpYqTZLmky2fBnHJZK6/yaGKFK/AtTiQHUx+Ht?=
 =?us-ascii?Q?Ru+Lz6OnvgZNEw6LNgIUiP5HnbvBNST39dTrYRkOobVmDi1koNrYf3vneX9k?=
 =?us-ascii?Q?EmzObPYF3WdW2IuxczbTKVIZdFeSrAyTxEGBeW6yWodTsW5qLNrCMtuWSDCj?=
 =?us-ascii?Q?jW586xhFlQnBfyDobZ4K3pXn/QxITnzJb8raLm3j/ymRnzdzkH4doUm/BLZV?=
 =?us-ascii?Q?ZsvCNuOww5H4U4vYtZgxIWD0qsDObqqLI/SlQLiNCvKIXpQiEAOdJOzDibhL?=
 =?us-ascii?Q?NFxUHI0PARfqU5QBF1XXheo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7601d37-d1c9-4743-a64b-08d98daaeadd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 18:05:47.2338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNF+oowSsXIZsCO92AiP6gb1IFQcu6GVb24gseU6h+RAXPysSjaMGb70fANB0Ak13HnUkLsGN4zh7g0caVaOFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1309
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Tuesday, October 12, 2021 9:42 AM
>=20
> Dexuan,
>=20
> > After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> > boot because the hv_storvsc driver sets scsi_driver.can_queue to an "in=
t"
> > value that exceeds SHRT_MAX, and hence scsi_add_host_with_dma() sets
> > shost->cmd_per_lun to a negative "short" value.
> >
> > Use min_t(int, ...) to fix the issue.
>=20
> I queued this up as a short term workaround. However, I am hoping that
> the rework of the scaling code in storvsc lands soon.

Thanks, Martin! I know Michael Kelley will improve the netvsc.

Regarding this patch, I'm not sure if it's a "workaround": if it's incorrec=
t to
set a bigger-than-SHRT_MAX scsi_driver.can_queue value, probably we should
change scsi_driver.can_queue from "int" to "u16"? BTW, I guess the "cmd_per=
_lun"
should also be "u16" rather than "short"?

This was discussed in May, and it looks like the conclusion was not clear t=
o me:
https://lwn.net/ml/linux-kernel/457d23a9-deb0-4ee1-fe7f-5a63605d9686@huawei=
.com/

Thanks,
-- Dexuan
