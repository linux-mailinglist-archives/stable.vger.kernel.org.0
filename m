Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC7C47C2DE
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhLUPfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 10:35:51 -0500
Received: from mail-eus2azon11021018.outbound.protection.outlook.com ([52.101.57.18]:36983
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234178AbhLUPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Dec 2021 10:35:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlcNiV7KbuWtYK8ajp8/ephLZuZHR6QfpiB366eQt74VMB+6AxBtojeHDUkCNFJKhVz7vAsHwOB14Gg+IGOHctIYap5lIY6EESx+zPPKnymunmeNYtc2LPrOZUNyUH8qLc1UUvaATuX05e1iXSbAzUjeQ6mBjyYfBNLf2n9lfOnR01CdyqnK4cAHyP0OBOA6S2nZhnV1NAdL9NOVrG4MlLfSTC733tNAFVOGFzrt9cDT87dPf5LGl8RHhOOX/TKftoq+HEca35Dx5Q1yh+IZ8jtGNIJnN/+qnreQ9Td4VqFEtMfiEPP8nsNRzJIjDHTH3fMMArNEQr3P/zu/GKR1pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXPVTkgHfZ8GvlZRsufLaack/DO3zp/l8+d6BYzrcfY=;
 b=TgnTeYgqf6oDiByVg4LGFlqKvzGpFQpMawWyH2zQKEdniyRw4gdxx95sWnh5U2JpWixcoxXqoicNrsuIATb6e2Eor8fkqVn13j+Hf1vx85vH2XKw7RsyYTI6eNTu/Q+yOB2HyV7QcKg9AS9xR5AeS89BJieWxAt25Dki303gjqAfJkPo3KWJTyTKUuOCBhJP41Fjf3XCCxiAtOEKhuYpVwCN9U/5uyGP7Rw1b2QmukDZg4lkZnb6I5KUp/MXE6OzxDL/OywxjaIs7eos8j3AVPdGQuEhSSVBVWjlPqsZPNNtwlQgkqq2TX+x/hSmIytqrrA7m9eWDIMRSW8Lg9UAaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXPVTkgHfZ8GvlZRsufLaack/DO3zp/l8+d6BYzrcfY=;
 b=eiAw2nDeW+UMt6IsEnN9uVPNC8uVcAu950UViz3PFZBSJJLHOu2P+InOkFCSnewUtpxxEaxZ1U+DhiBGoG8oDVEnc0ScNM6WFuWPg/sim0YVucdobp027mDtlHGo5+jo+BqJC0ibhtdpoMUaTwoMU0HbULd50tykmwAafyuUvmk=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by BN6PR21MB2091.namprd21.prod.outlook.com (2603:10b6:404:bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.10; Tue, 21 Dec
 2021 15:35:45 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::e9ea:fc3b:df77:af3e%6]) with mapi id 15.20.4823.005; Tue, 21 Dec 2021
 15:35:45 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.15 20/29] block: reduce
 kblockd_mod_delayed_work_on() CPU consumption
Thread-Topic: [PATCH AUTOSEL 5.15 20/29] block: reduce
 kblockd_mod_delayed_work_on() CPU consumption
Thread-Index: AQHX9g5edfkckv4QgUmJOg5yB7IFi6w9E2DQ
Date:   Tue, 21 Dec 2021 15:35:44 +0000
Message-ID: <MWHPR21MB1593141494C76CF5A0BDDB11D77C9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20211221015751.116328-1-sashal@kernel.org>
 <20211221015751.116328-20-sashal@kernel.org>
In-Reply-To: <20211221015751.116328-20-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e26ed0d3-9e61-45aa-b928-9a93370526ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-21T15:30:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0bfaa82-fd9d-4097-28a8-08d9c4978df9
x-ms-traffictypediagnostic: BN6PR21MB2091:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN6PR21MB20915C8964B6738971F520AED77C9@BN6PR21MB2091.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXKeAAdU4GrtolLtKh/SqUlPRvys7BjJWAoVyxyxEX7w4vIh4IYK1HkycPiTdH3L5v+tNqSoE+ib74HxgMBwWQSbJ6TGHH06qqB0AFI23d9dkAQvQ6qwylvSnCEL6bF/vqY4MElgI0nwiKYdAe9u8T3wuXXgbDzojptTto/W8RK8y1bJuGF6IACpr1aTU4zvK11nfbcIjxTnUVRF3PUw4c86DMq81AbzIiDHwpI0bZU3U/ZfKMTY1Mt/FIPcvEWg2oRLfR3gzC40a8kMJbg2zrjmfNJQmxtUjrUoo4M/KQySvkG0ygPes1s2GFQw9YNqcWGTI7EDfpnISGBQNw3K+CsPCEyqupLB+LgAmB/NtHTYArJ5dUYTih696QIWq4cxkfOdCUsicrgK3OnLjd/da82oQUUYQm2E7rCVe2T96eP1zd+RXEn1BqhDnTfxrgoDUhfpdl8H+7Ex/KaPsdKn13+G7Q1eHFkt3xuX+Ie3X0BMuSSs4tBTyJnoFaqEduX0B1yJJinz0LFj3k5gD9vTEMS/VdRD1ZtpUF+zeC/dctDmcGe4mlIsvpo04NytbuPtxs2l84QooVv3LxpNmN0MhOInc5BblsVwmHk8J3WvSAZfoTa2HnrPPDuK+cQ+Pfg9uPvTel8HbCenow1Q1bE5zzprb9vAG1BZD1IcFsDKgmWXIC/M84Xzi2Cx8f27dh+mfOAChM1ziQNZAT0/h+k5LlxhoMm014MaQqL4pTDlQHLMP4qExYxjs4x/+s/FVc4P5/3fip4awdTRTbmi5HzNWEuflos+F9/EssDle9FHlrveCU0+qhhafSCGz2r1UqTljzWjveFZnpUG6N3IrbpYTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66556008)(8936002)(64756008)(66476007)(38070700005)(4326008)(10290500003)(83380400001)(6506007)(66446008)(26005)(71200400001)(508600001)(966005)(55016003)(86362001)(9686003)(316002)(7696005)(186003)(54906003)(110136005)(76116006)(66946007)(5660300002)(38100700002)(122000001)(2906002)(82960400001)(82950400001)(8990500004)(52536014)(33656002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GvkMkVHihKUltlhh7rPMJ0DGu/UxKOUfmr1mfv6Ds+F6MXa6S0VglVa+QP7y?=
 =?us-ascii?Q?EguVPvgxsNgWNK+mBgvqcnXfkaf7SKVHOmRfVuDpK/+XyLwWGBh3R3ZZNQKX?=
 =?us-ascii?Q?ec+s7v5UuPa662oXNHLahi+Ajuz7XIUXqbJB71jW1oBKRjwkHdn0iCBdFKMu?=
 =?us-ascii?Q?CPCWTl6G3b8tnQOgUo5em6WOZbD7X4Zd/1sa+da56NQGUc1f/dOoa04K2Li0?=
 =?us-ascii?Q?4AIJHR8ICYoQMw5/oxtQSIS65O+2ORutzrNLHZ7alUxlkaOelAIPIiQdEL4v?=
 =?us-ascii?Q?QhSQUaQVGRvHixVg7W2t/Jj5G89fc5F3rS4r4OAluZo8m0Dx8DY7/DBq6vcl?=
 =?us-ascii?Q?e3DDjeFf8iZQCDSbPCeTOa6FgNtCpRt93hemVgTdOQFpBcZWc+o82WMCYkW1?=
 =?us-ascii?Q?LIXuMEubqOQVBcyh9ljTDDRZCEbz1ZhB9nQ99znEPBoZZZd5gEgRjvut+RNT?=
 =?us-ascii?Q?GKzup1dZ+knTEH+jYlfsTwhaBtaBiFzETWxF0J+Rb7HoFh7H2POaC7GUdM1v?=
 =?us-ascii?Q?U2vdjE+kATRIfNxDfeEzDLd36K0xSqce4QLffqvLX3P5jvv4D+r4oRE4mGI0?=
 =?us-ascii?Q?gaRdGQRDN8sIH8sAkH6f/9AIu0XDGEiDCaSEI3vVFvOmZr/E2P/awSL/k8df?=
 =?us-ascii?Q?TwsKKOwtI+CXddZJXgfdTaiXEsNH3M89kjvlvpv8uJgD/3seKXJ/t4ta2Zgr?=
 =?us-ascii?Q?5AOOptpx79EYtihIVuuvC8/qZeYT3BkcphOsRpsfbp7qO0ko75in6STpHL2a?=
 =?us-ascii?Q?XMbI7itJnWpPmt1obB9GMRHWCctIg7QoluXKdO5IxmeOxX+NYW4fvVc1uXdl?=
 =?us-ascii?Q?PRqeptuX4etI9bbkHBM6Q4gZtaKOJRR1WgZ4otCuXEFVZG9we3hFJ0HtARZT?=
 =?us-ascii?Q?2dFx3SzhpYlk1En2k/dHeEyKHjWwnqgd6SJ4FUDYwp2pLrG+of1mP/5im79Y?=
 =?us-ascii?Q?cO2x8Vj0+Ryj6Y6GA7hivSEStV8BHLoFt1UgLwRtlgyeMNVriHQKJljDnONF?=
 =?us-ascii?Q?ZUuhdb+FuOKMuT90OTKwEA+XbwAIGPWdqNmtwqHPsjdJploWrH2vnKO0WH3A?=
 =?us-ascii?Q?njNIkE500o/vGekrY4mzxqtEeYck6zARDnLziN8b/l9Q+vIO+ZMHdfgS/vhF?=
 =?us-ascii?Q?QfBuTxuilOYXJsvlS3PsZIHo6IskWMp3sJJ1GakhCnCLvrz4MJXRgn39t69f?=
 =?us-ascii?Q?m2o2ZSI+lwAWy5bAu7soRKDlOpiFxnvKWifUPYwTj0yYIZcYONeZfUcc520r?=
 =?us-ascii?Q?Pn5ojSNezXq2LmMWuUtxO5dKc5l4mN3XisI+ZRdEHCMtqwv6JDqT1R2IiF5a?=
 =?us-ascii?Q?WbnXhDn894u9EjXveJxWDKRrm+LmCPNWX9jab8a359exY9BcGmUp6GNbNFwE?=
 =?us-ascii?Q?Uyvm0R/Xm2cFqfwspWjJZXz3xdUPpsCkQxQdEHdICwBStgZ4pgYyv0nJzNgM?=
 =?us-ascii?Q?5itvsc4gc5wo5Frk3JUm4t6z/9ltjAa4x3IDkfKab/RM1ccwwldx3g5lldlP?=
 =?us-ascii?Q?C+ZP6AejR9XNEPcIEsaxNz/W0xkmJnbisrvFUJV2HIphXU2MkptEGgdbdo/A?=
 =?us-ascii?Q?OGc3UOMeYM46uSsbrnK/4Bv8TOirdFCzczOyObkmGnFB2OO5GhdEdPovKegL?=
 =?us-ascii?Q?eeGtSn4C9EECIRp8LCV1tD+sguFSOfmnZlgH00xvRGtYNu/DfN4t0VykqpOZ?=
 =?us-ascii?Q?uyqiwQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bfaa82-fd9d-4097-28a8-08d9c4978df9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 15:35:45.0208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u4zDfeBHhjs7qQ1DvdSra3/xaiPjZfnhwuLRKmWCl7jBvmVTsy0yL4VuybST3AFb+h67n3iAvuT3dmpoaii9kPhWXuzhZxEVC4NCzPHX1wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB2091
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org> Sent: Monday, December 20, 2021 5:58 =
PM
>=20
> From: Jens Axboe <axboe@kernel.dk>
>=20
> [ Upstream commit cb2ac2912a9ca7d3d26291c511939a41361d2d83 ]
>=20
> Dexuan reports that he's seeing spikes of very heavy CPU utilization when
> running 24 disks and using the 'none' scheduler. This happens off the
> sched restart path, because SCSI requires the queue to be restarted async=
,
> and hence we're hammering on mod_delayed_work_on() to ensure that the wor=
k
> item gets run appropriately.
>=20
> Avoid hammering on the timer and just use queue_work_on() if no delay
> has been specified.
>=20
> Reported-and-tested-by: Dexuan Cui <decui@microsoft.com>
> Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F474=
00BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  block/blk-core.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index c2d912d0c976c..a728434fcff87 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1625,6 +1625,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>  int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>  				unsigned long delay)
>  {
> +	if (!delay)
> +		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
>  	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
>  }
>  EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
> --
> 2.34.1

Sasha -- there are reports of this patch causing performance problems.  See=
 https://lore.kernel.org/lkml/1639853092.524jxfaem2.none@localhost/.
I would suggest *not* backporting it to any of the stable branches until th=
e
issues are fully sorted out.

Michael
