Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC49CFBD6
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfJHODk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:03:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbfJHODj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:03:39 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98DhLxq007486;
        Tue, 8 Oct 2019 07:03:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ygj/qBAngFAbRnUgmvBjtSCsZk9JgLbFjt632L485F8=;
 b=XNTZkLkA4JSshF3XmUp7wTB8aBy/Beg2Hdy04fIeIZ981HfVQheifoKM5pYtpiVNLwEC
 vrP952J3ZON/FVz/lucLM3rPw8VQqBA/PnWimd9wWuBkwE+/3do7W/mfKdIO5yCC8ROh
 eR3RyTi4dKGcpbrlaWMiI95nJEb6T6wRcdc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgpq9h833-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Oct 2019 07:03:20 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 07:03:18 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 07:03:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 07:03:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwJ3P8NV57Jtspr/ZuDkecVRaWfCj8rPpsSA9rWsAR0/IQoCEawaq2hLtH3A0zwj2+ae+kgM8KEw4gWHgG1qk7uYLoikj+Vfpp08nl8AQ0yxdkIfo0oFQVUPxFm4VMGq/tqec8RfaUb7qhp7ZLFhI945y7rbWEU4b/6DxZSCjObfbaZ1CsBVtLDfr5S/qOlGFJoUWlUVV7JQuOZJJ9Sx46CLOjrvj+IJZVWPyKOtwtDecAABkMTjHsCaIe5SxghvNZHntMsrQYGxEqlRNEgvXEfUlaVOug2DAu835iEFnW0Y9vhi8WtYTzrxDB9ZrB1eii9jQQbzWXZraqWh0jxBcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygj/qBAngFAbRnUgmvBjtSCsZk9JgLbFjt632L485F8=;
 b=SOqIHZ3LfgUG0exjVpK1FFZ/dGKRwOFC8dy9O3+K+YRqwZGOC0yBw+3QckwAUurHQddOrQHtkwKk0QMfWIqbbrW0wyCxbPfNf/JbgWXspMqALHrYLkO1eMdzz3JA43Auf46lwM8JBq/KOc6NyM4GFATSyxAb2PRj5fI45R/aaEVbarz9vvp4LUi6nUqFPoiE5iefP0uRhh4oB7y/n2xWZdwHWbM2bml9n+nwvZJzWTWJ7NOtEv7cS8Cs6Xdg2qOsw/Xn+dksO9o39e2Alm54Z54f7Rfu68xXc90aaZLxcM+CI4rR9fwhVuG1O2Ft5RTkCZ/NjHdzsvogR5uC2nsv6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygj/qBAngFAbRnUgmvBjtSCsZk9JgLbFjt632L485F8=;
 b=E9gkVAfn/Clqy1SPV0Y8cVZO0pX564L/E7LVJquQ235HfD/S7cMnvWVbGzFW+7aXnhTqLc3n2QnoH+Sqy3KdwK+X8mMDtwykJ9+Ivng5mhrfXBoLoSOWNKcK7noVHnyWbirVFSAwRrGHJoAmw7DwBGKDghroE1c4lT6ULcbnEsA=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1409.namprd15.prod.outlook.com (10.172.150.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 14:03:16 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::453a:b6a0:9b4c:649d]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::453a:b6a0:9b4c:649d%10]) with mapi id 15.20.2327.025; Tue, 8 Oct 2019
 14:03:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     open list <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf/core: fix corner case in perf_rotate_context()
Thread-Topic: [PATCH] perf/core: fix corner case in perf_rotate_context()
Thread-Index: AQHVebXeTwCJT6mWNUStetO5rZ1Qe6dQhCMAgABKsQA=
Date:   Tue, 8 Oct 2019 14:03:15 +0000
Message-ID: <B46BBDE5-B5D6-426D-984D-96A3BAE283DB@fb.com>
References: <20191003064317.3961135-1-songliubraving@fb.com>
 <20191008093554.GK2294@hirez.programming.kicks-ass.net>
In-Reply-To: <20191008093554.GK2294@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::e9f0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 996387ad-dae4-4968-235c-08d74bf843cf
x-ms-traffictypediagnostic: BN6PR15MB1409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR15MB14099787D542D38640332BE3B39A0@BN6PR15MB1409.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(346002)(366004)(396003)(199004)(189003)(4326008)(486006)(5660300002)(102836004)(2906002)(6486002)(305945005)(71200400001)(71190400001)(50226002)(6116002)(8676002)(14444005)(476003)(2616005)(256004)(8936002)(7736002)(446003)(11346002)(86362001)(81166006)(81156014)(66556008)(66476007)(66946007)(33656002)(64756008)(46003)(6512007)(229853002)(6506007)(76176011)(66446008)(53546011)(91956017)(25786009)(36756003)(6436002)(76116006)(99286004)(6916009)(6246003)(316002)(478600001)(14454004)(54906003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1409;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrNq2EQiHfL81CRhoFX6LHJWigPosORzWVyT7SkCGrMk+TAAr/o433CBaig6lf0Lp5GDbkC7g/74xjfrybSymNIWwTaxPqQJzVqrGpt4YzRl6jva54zNc4ATRzsNCKLwPhVWpSmz6Hyphdc6WNAAtA+pFrD84YclG/TjAzhdF73/PH1JmyzcNfn6V5RJJi6pHdyP1c8iYHD3qpIdbHLKGq5Iy7YQKXZ6Q4GB+RhAurjc67F0XfTSY8XNOgUfV/ZTFh3kxAdVfKGrkLeJTixudFOxO9rMmYTvYV3/5I0qs68Xg8ueR6cJw01PtyNOf6wSFpXUKxPki6lntZ1l66MQhaEjM5optNhHtX54KP0O8WtwTd793wmBb1hoDPeyTcvryoXrRZjZIH8I3EzBHuaxOpbRkRvEQqBbHeZZuo1aq4M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AEDB5E05175EA3429B0B91222FC4FCA4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 996387ad-dae4-4968-235c-08d74bf843cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 14:03:15.6526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BttBRPrLV3glGBNHE4mhYdCuSdjfNEzTwVjtK3r4cuS1cstLmSeE2LxTdcDRlemhEhikOwxEBHFZoi/exwPQsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1409
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_05:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080131
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 8, 2019, at 2:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Wed, Oct 02, 2019 at 11:43:17PM -0700, Song Liu wrote:
>> This is a rare corner case, but it does happen:
>>=20
>> In perf_rotate_context(), when the first cpu flexible event fail to
>> schedule, cpu_rotate is 1, while cpu_event is NULL.
>=20
> You're failing to explain how we get here in the first place.

On Intel CPU, it could be trigger by something like:

perf stat -e ref-cycles:D,ref-cycles,cycles -C 5 -I 1000

I will add this to v2.=20

>=20
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 4655adbbae10..50021735f367 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -3775,6 +3775,13 @@ static void rotate_ctx(struct perf_event_context =
*ctx, struct perf_event *event)
>> 	if (ctx->rotate_disable)
>> 		return;
>>=20
>> +	/* if no event specified, try to rotate the first event */
>> +	if (!event)
>> +		event =3D rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
>> +				      typeof(*event), group_node);
>> +	if (!event)
>> +		return;
>> +
>> 	perf_event_groups_delete(&ctx->flexible_groups, event);
>> 	perf_event_groups_insert(&ctx->flexible_groups, event);
>> }
>=20
> I don't think that is a very nice solution; would not something simpler
> like this be sufficient? (although possible we should rename that
> function now).

Yes, this is much cleaner. Thanks!

Let me submit v2 based on this.=20

Thanks,
Song

>=20
> And it needs more comments.
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4655adbbae10..772a9854eb3a 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3782,8 +3797,17 @@ static void rotate_ctx(struct perf_event_context *=
ctx, struct perf_event *event)
> static inline struct perf_event *
> ctx_first_active(struct perf_event_context *ctx)
> {
> -	return list_first_entry_or_null(&ctx->flexible_active,
> -					struct perf_event, active_list);
> +	struct perf_event *event;
> +
> +	event =3D list_first_entry_or_null(&ctx->flexible_active,
> +					 struct perf_event, active_list);
> +
> +	if (!event) {
> +		event =3D rb_entry_safe(rb_first(&ctx->flexible_groups.tree),
> +				      typeof(*event), group_node);
> +	}
> +
> +	return event;
> }
>=20
> static bool perf_rotate_context(struct perf_cpu_context *cpuctx)


