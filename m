Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABAF2469
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 02:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfKGBn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 20:43:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727924AbfKGBn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 20:43:26 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA71dC5m017520;
        Wed, 6 Nov 2019 17:43:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=g1RVVzA6kKDl/n0lk6ChVaXtGbN75yt943enRfho8kM=;
 b=KAGzK6kndaTVMVEBq9i8E5Psi9yr4cd4nvNukFcjh3Ov10J8lmVSe1vp+h0zWZePOKFF
 9kHAZANSyANI5EeKx7krl7g6PpFo2/hY5CLakTxLUz6Sx8RUFuEIL4wIah3ftdb/nznS
 ojkAwBvNVm1HjSjrMYJXz4xpb5PvVFtMAjo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2jf2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 Nov 2019 17:43:17 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 17:43:16 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 17:43:16 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Nov 2019 17:43:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR7hNTz3ypXUHddmPyDPjCSK3IaKmyWeZ7NwSa0q7Ne11pi4j0QqXd4XIcarIAQLkIvgc/gPcWGvOl6Bg+L3QZERKocjYAoCFTCQNlLHp85kuNH5SHBwDWenIh2YEese2GYWArN2JtTGsoDpMv1VJf8Fu1ZCm/iiPLn8srZIfr0+z9eLoL+ks2ihQDlP79pndds/bRTFsi3WbBmYPqPNytuce0Xgu4Sd84w5u+sHntghhEpcdnVIW9EN23z4S1OcOZFQ0uAY51XaIwp+mO5jFXrPraG4Kmn+/BQO1UeY/WtyPq0ClnkttHQOtQCNKCeXfqnUATvw5L4E26ZoZ2Hwfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1RVVzA6kKDl/n0lk6ChVaXtGbN75yt943enRfho8kM=;
 b=ZJgO0tQnzz5FIwXV61+46Zea2zDyu8rS37mDAdCS/EG+5yQEQ+ROOO/PezBU2pBWG3AAZRQVDKtf6RmE7J3/LofNlHKrTZ4VqoIpJsaf6+9aTTLbn+CCvQIjA+OzY2ztaySKIA1WrH4dCwuXoiAr6XqdQNNYBEQxqh4yq3MSsiZctKBYs8GtyGnqdVqExnJLDmTI6XaZTAnoXa3HzxciLgAjYFD019wljMGGfRr7O0zp5SHX/HahUHLcviQpKnop4qW1AHf37VrkhrZWDGf3QSuOH3Xa+X7ARCbdxPODJhR1u84JV9lJKrRcIxehUdthf/s5vqUpzhQjhl8d6iiZLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1RVVzA6kKDl/n0lk6ChVaXtGbN75yt943enRfho8kM=;
 b=U8tRi9pEMMz3d1P9i0ABQHFan1zy7P/fNqQb+MBKnVH7GmHj77xboqZvYF8TvvoM9nCo2N+f/G59CABACAtJP21Inxl7Rrbigef9bmH7nwb8tTPRAMGpFFg4QxeOMT7U+9jC+WfZ+z+f7gTvDPL9mphb/t4abvUIP6BZiwjrRnQ=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3121.namprd15.prod.outlook.com (20.178.221.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 01:43:14 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::3056:945b:e60e:e2e0%6]) with mapi id 15.20.2430.023; Thu, 7 Nov 2019
 01:43:14 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Topic: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/Kd+2NkAgAARtACAAATxgA==
Date:   Thu, 7 Nov 2019 01:43:14 +0000
Message-ID: <20191107014307.GA1158@castle.dhcp.thefacebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191107002204.GA96548@cmpxchg.org>
 <CALvZod5=g230Lwnjh7qXyLkoknZJpOiv-nLJ4XYC9rSSzL=e6w@mail.gmail.com>
In-Reply-To: <CALvZod5=g230Lwnjh7qXyLkoknZJpOiv-nLJ4XYC9rSSzL=e6w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0013.namprd16.prod.outlook.com (2603:10b6:907::26)
 To BN8PR15MB2626.namprd15.prod.outlook.com (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1716]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b10c3a4a-6a29-4b0c-c787-08d76323daeb
x-ms-traffictypediagnostic: BN8PR15MB3121:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB31219716CFED0987E7273848BE780@BN8PR15MB3121.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(396003)(346002)(376002)(199004)(189003)(86362001)(8936002)(4326008)(8676002)(5660300002)(71200400001)(305945005)(6116002)(81166006)(14454004)(66946007)(316002)(64756008)(1076003)(54906003)(66556008)(229853002)(66446008)(66476007)(71190400001)(46003)(33656002)(186003)(446003)(6436002)(6916009)(486006)(6246003)(476003)(256004)(99286004)(11346002)(6486002)(81156014)(6506007)(53546011)(76176011)(2906002)(386003)(7736002)(25786009)(478600001)(52116002)(102836004)(9686003)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3121;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FpcXEqc3WTEWNaInBWX/cQaCziujdOwcd2N6exj1/SnFbRaMlcnFMNxk3JMmhTCP4Of0VfhCMMW0ZeyyFNMXmJ/naLaVEQS5xrShDQx5DFFdKPYapgZuDjG8orPi3YtVABJ9rdr1z/GcEY9UClIQG9EDjd7Z74cYiEq0dGty65qk26mZl/KZnr4FCDiSjaGV233/SPQ7Pu+0YXiZ2xpDd//Os2TNi8j18xaZdr3HsogglAdRq9Ianqo5yPI9g6iSBsl5xHLQBqzx+d7FoueN55FeOWk/xi2xNgy4DzsvTRq6mm/IbYb8A/kVgMjuD2EGz4QjfEhsh70boXqCrBJ8o3w2yUWWHg/Xp7eLVm0VSBxZeCXlLT/8UZ0elOwLGS7iOE89j49hpVltjBNRlpIFHIQc+bBEUexm9Sg0W45P+SJkPP5TM8G++e+RP3MtgAdR
Content-Type: text/plain; charset="us-ascii"
Content-ID: <86BDE64FADE7B2479B2A0C428D08A077@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b10c3a4a-6a29-4b0c-c787-08d76323daeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 01:43:14.6263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w9Cb2xK1vubVfzJHTg8nRq99UJ95zrJUegfSM2NwFG1YC00s8VKso0YkHzaRa3gQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3121
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070016
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 05:25:26PM -0800, Shakeel Butt wrote:
> On Wed, Nov 6, 2019 at 4:22 PM Johannes Weiner <hannes@cmpxchg.org> wrote=
:
> >
> > On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin wrote:
> > > We've encountered a rcu stall in get_mem_cgroup_from_mm():
> > >
> > >  rcu: INFO: rcu_sched self-detected stall on CPU
> > >  rcu: 33-....: (21000 ticks this GP) idle=3D6c6/1/0x4000000000000002 =
softirq=3D35441/35441 fqs=3D5017
> > >  (t=3D21031 jiffies g=3D324821 q=3D95837) NMI backtrace for cpu 33
> > >  <...>
> > >  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
> > >  <...>
> > >  __memcg_kmem_charge+0x55/0x140
> > >  __alloc_pages_nodemask+0x267/0x320
> > >  pipe_write+0x1ad/0x400
> > >  new_sync_write+0x127/0x1c0
> > >  __kernel_write+0x4f/0xf0
> > >  dump_emit+0x91/0xc0
> > >  writenote+0xa0/0xc0
> > >  elf_core_dump+0x11af/0x1430
> > >  do_coredump+0xc65/0xee0
> > >  ? unix_stream_sendmsg+0x37d/0x3b0
> > >  get_signal+0x132/0x7c0
> > >  do_signal+0x36/0x640
> > >  ? recalc_sigpending+0x17/0x50
> > >  exit_to_usermode_loop+0x61/0xd0
> > >  do_syscall_64+0xd4/0x100
> > >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > >
> > > The problem is caused by an exiting task which is associated with
> > > an offline memcg. We're iterating over and over in the
> > > do {} while (!css_tryget_online()) loop, but obviously the memcg won'=
t
> > > become online and the exiting task won't be migrated to a live memcg.
> > >
> > > Let's fix it by switching from css_tryget_online() to css_tryget().
> > >
> > > As css_tryget_online() cannot guarantee that the memcg won't go
> > > offline, the check is usually useless, except some rare cases
> > > when for example it determines if something should be presented
> > > to a user.
> > >
> > > A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
> > > css_tryget() instead of css_tryget_online() in task_get_css()").
> > >
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: stable@vger.kernel.org
> > > Cc: Tejun Heo <tj@kernel.org>
> >
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >
> > The bug aside, it doesn't matter whether the cgroup is online for the
> > callers. It used to matter when offlining needed to evacuate all
> > charges from the memcg, and so needed to prevent new ones from showing
> > up, but we don't care now.
>=20
> Should get_mem_cgroup_from_current() and get_mem_cgroup_from_page() be
> switched to css_tryget() as well then?

In those case it can't cause a rcu stall, so it's not a so urgent.
But you are right, we should probably do the same here. I'll look
at all remaining callers and prepare the patchset.

I'll also probably rename it to css_tryget_if_online() to make obvious
that it doesn't hold the cgroup from being onlined.

Thanks!
