Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7838A39B567
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFDJAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 05:00:06 -0400
Received: from mail-dm6nam12on2100.outbound.protection.outlook.com ([40.107.243.100]:27105
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230150AbhFDJAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 05:00:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1GolM8LR8Cw/15PAfjDClnGMwouuWca8dH+LpbvYQ8krVf54zVPBAYakzSbS6fpyPE+MDoQSAqAVS3No5Svg/MCBA8t3ghTa+P/EjLFpYfNvRj7TCGuf1SyW8tYslly4TFNwxdtFFPqp8W7pfhoI61hFLlLOAoIeZIROf7ce7OY2+ADJuyYNxW2CVeMjM9Frf5dQ2foPtg6WcrWewrRqY7X4ao1qFiZ1bhToqo0CKe+mCbhJdkv3zzcq8IsoI2t0YarG5LpB2iStd2mFdmo7a12RyzHndnH5le/ChlYTCBXj2xrDWavNKRq+bJve2bYc5U5exPhW5PYlWjmF/aWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8TEFusDweD+XCgqUWjG62ywhA1ssb9gmkWjUyLCNYE=;
 b=jEQKKxfm5oswp0biAZTEt+DZaDaMpMQu95sC0p9aNgFEMX8Z54kaL8QWdJDpmTiRk16WGrM/7WIuu0wokuqpORyIxHxawTLDnkJRSYIWg96/IY9XoQ/4xPSAGrMsulmdiz9ukV4cvw1b3WgQL8Knm3PEmPBzJrdlkCeSdGGw920a0Gd034vcC8qa5d20kedFEbusDo+OE8eKWEUfjg1bY2ZnBKi8hdNMs7L1Su07peMxOvl1x16I3q9ieOPmPph6fvyng5W8P6qIrB3csIUzD5vYDUGYEs7bUjTLjO4aOF09mo/VwjkgCnKOSuhbsRt5GKmRyXjnCMmcXNzYLoO8MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8TEFusDweD+XCgqUWjG62ywhA1ssb9gmkWjUyLCNYE=;
 b=YZCDda8vffWT4xuHf450LXLzbPKuUCOJtyK/ctnLBfnuOLq1wfGc45yaIvuE8kCH+iz3YEMvziebLABzdGk4RSf+gEXVaQ0PLWlfKU8sHkT6/727tX9HwQiGyA99IVv6+AXfHBBLJkfsPuB3LWtxJU5VM2td/xQiQp1VkQX9C7Q=
Received: from BY5PR21MB1506.namprd21.prod.outlook.com (2603:10b6:a03:23d::12)
 by BY5PR21MB1474.namprd21.prod.outlook.com (2603:10b6:a03:21f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.5; Fri, 4 Jun
 2021 08:58:17 +0000
Received: from BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::fda7:afbd:5f96:a099]) by BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::fda7:afbd:5f96:a099%4]) with mapi id 15.20.4219.013; Fri, 4 Jun 2021
 08:58:17 +0000
From:   Long Li <longli@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] block: return the correct bvec when checking for gaps
Thread-Topic: [PATCH] block: return the correct bvec when checking for gaps
Thread-Index: AQHXWMilfqxountagkCztc+hnNyp6KsDFzKAgABFe+CAACu7gIAABVrA
Date:   Fri, 4 Jun 2021 08:58:17 +0000
Message-ID: <BY5PR21MB1506603F61A13C6E09756746CE3B9@BY5PR21MB1506.namprd21.prod.outlook.com>
References: <1622759671-14059-1-git-send-email-longli@linuxonhyperv.com>
 <YLmHi27PT5LAwJji@T590>
 <DM6PR21MB1513F1E0E0DDD017A4ED3B73CE3B9@DM6PR21MB1513.namprd21.prod.outlook.com>
 <YLnmg6EZCmauW0JK@T590>
In-Reply-To: <YLnmg6EZCmauW0JK@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3ff342b1-51d5-491f-9b97-991d49e47f66;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-04T08:57:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [76.22.9.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a2eaf67-6269-4d77-bcf2-08d92736e552
x-ms-traffictypediagnostic: BY5PR21MB1474:
x-microsoft-antispam-prvs: <BY5PR21MB1474EB78F80F460EB143C8B3CE3B9@BY5PR21MB1474.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X5x6kSIk4mZigcAfUxh5rlqMz8FhvIKGu+l8NTt+7t13VbHMnSBVKcywOwlOmJ8C2NaH2b+Z6Nx9oITXR9PSj26AvvOzfM4kce7vbb+AzMWbQEpng851QTbxt5GsmFUyd8z9dSnB6nLaM3xM+WDjddPYd1fLUlhmyUkHQALl27fwgAv9Fho/BJ7yX3AAO/J4bNJd9c/6WjGNp98CzhoL1ql4A7u++DS1KLDJzXyWcjJGq0xxABXOe0kqOuQQcJSljM4Jctp3oOHTVH6cFjbnRdY0x4gqOQ03AJ9zHidftsePZ7PUgDRYqHv4S2cHy+sQIrIHt/4ZgCkHjSCnXGw2ANafIgzTM9NbitUKy5bLzx/sIXwaWrslc/M0InzJvn9Egni31Rg6DfQE6RC8ll9fwN0Gks0Yd6eciam0TDhATmU8HtMFK96Vv+cHt0J55Pj9YhG/uG9gAhJYweMlxZQQHQnVbCdZGSwTkeJbSq86PW4Mg8UFKiG7VzvXkmGbbSSZb7FFy3SNtXpszDRCP5pZkgUMPoOq7mbw+WhhKjhcahKKtHLdOVibtskvOuvIymPZp03ePW54Wi8dbM5YMHzdCkpY+WKzMh78mkniDtUtwd35l4NmCPtb/ZiFYWBDAeVLnwGRBpZkiV9dPMqrDIlEsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1506.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(478600001)(2906002)(186003)(26005)(6506007)(5660300002)(86362001)(7696005)(64756008)(66476007)(8936002)(66556008)(33656002)(8676002)(76116006)(52536014)(66946007)(66446008)(83380400001)(82950400001)(82960400001)(71200400001)(54906003)(316002)(6916009)(8990500004)(38100700002)(9686003)(122000001)(7416002)(4326008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MCAWVkUqJXzDG5NFVIGM3JIk4B/Rh1PvjhQmazko8sGl86DI2NNZyZIyGqdQ?=
 =?us-ascii?Q?5Ujv7lFH7pX64tl7C7a7V/ZUlfQBv1uxL4t75SNvRdZuxU8yXgBhk6FRNUPP?=
 =?us-ascii?Q?80RRh9tKVnttZ+Rtnye/glwVlWHkn6988vqk3pRr0sDEbGTCz6LCd+CvDm0D?=
 =?us-ascii?Q?RoXdhkyPFcW+3/6G9LRK5FRfMbuFfnoiZDHmC4bpggxz8UeV0Hc/N/z5Cy1e?=
 =?us-ascii?Q?Jr5iIVmI8q8zsE/Eu6eCUDiBcmcZIkVAJ/ZeoaYg4FzThs/fxti3RO+U2Wqd?=
 =?us-ascii?Q?6KM8xo2FV89D+poJ4enecc0ntzdvEQd1YoFHnfGO7sUPzFI1oNoaIUjQozct?=
 =?us-ascii?Q?/sQDWRKToceXJdXAwqnbo0aDqqMy4pcbuBedNQjZn1sKCktvgEVDUNiMUQ2u?=
 =?us-ascii?Q?geYmksPiCuIpQwTmluN4WWT2n0uIzPaT+Cq1RMRFu+2lll4Qg45L0la+hbKk?=
 =?us-ascii?Q?0WQB0SF96LiktK0g6QyK785UrSDJXAtTa4n+8VCx6mrnNnmCHjV7ZQiiyys0?=
 =?us-ascii?Q?MOeVzVfg6bmIw171F+amdM2Y576JfCKD100tOwff/sVB44ucodwmyO4Hn4Uc?=
 =?us-ascii?Q?1K1HerM3kPH2G9ejGKzWD1qdmAqOF2usCnm5iBFiyokBloQcalJaFGxDFSnV?=
 =?us-ascii?Q?QqIh2ZrVW1KKUH/1qXq0wI+2Sa4x7X2yPfL4y8Z683jsIuQMzS0XqUVyfeEu?=
 =?us-ascii?Q?JbYNZTncjm4cnCA92OARR8MhJO3Xk4imrpjvWtxwx4DyL5QUuPufA/DB8259?=
 =?us-ascii?Q?aBO0UWg219vgVegnVRrYYFFAJYEZbttnXWRoGOZCfA3y6kBuIl2z0dC6qoF/?=
 =?us-ascii?Q?2yTzYNNJnhMKZCVh1PmLEnlGmh9i96Ps965pSg2TJN6ZQIbrqloAUXAQyAJG?=
 =?us-ascii?Q?Ts+k19KDK7Kob6jIX1OZ7/GJ9JcdAZo9HTD8sPB47qMA1n1gOfN2D3ImkPhr?=
 =?us-ascii?Q?T3mSmMVAWCZ7u8tf8UnhaVcOI7y72IglLeBj1nhaWYADBKwyFA3f3IWtVaJx?=
 =?us-ascii?Q?i3WiMPiDqSsjDde5jCO7a5Hq48ZBjJTo0JlBzamY0KAwiclhifBE11UQ11ex?=
 =?us-ascii?Q?lBT+uh8oDocT7YUiww5gzcPQOFV7EVBOJ/7yECywoSpKcZ9HNHTsfVJnsPMD?=
 =?us-ascii?Q?mWPQtdsZVP7b3zAan3R9D2Q409tJxzOJOACO0nWJjGqr1Mc4HQLojg/I/nTm?=
 =?us-ascii?Q?j4sGcNK1dc3rEnMMGdkQGVkJ+5Gr/S2R98FvQQEO1RdKuYtA5nNeZ6p9p2S7?=
 =?us-ascii?Q?JtMnzn9ZOWWe1qBh7VSs5tr13qfOjUGVu2Fjv+TTuaLc9kgo4u9Pb0Jna7/P?=
 =?us-ascii?Q?+88=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1506.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2eaf67-6269-4d77-bcf2-08d92736e552
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 08:58:17.7573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IMCHbfjWVMzSzDQwqUPyCKyWnmyIYASQCfRsvyEKafvmg3J+1o0xDr1rfs86XoEEkv2ig7yKmAlwoxe2xD6Dfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1474
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: Re: [PATCH] block: return the correct bvec when checking for gap=
s
>=20
> On Fri, Jun 04, 2021 at 06:38:45AM +0000, Long Li wrote:
> > > Subject: Re: [PATCH] block: return the correct bvec when checking
> > > for gaps
> > >
> > > Hello Long,
> > >
> > > On Thu, Jun 03, 2021 at 03:34:31PM -0700, longli@linuxonhyperv.com
> wrote:
> > > > From: Long Li <longli@microsoft.com>
> > > >
> > > > After commit 07173c3ec276 ("block: enable multipage bvecs"), a
> > > > bvec can have multiple pages. But bio_will_gap() still assumes one
> > > > page bvec while checking for merging. This causes data corruption
> > > > on drivers relying on the correct merging on virt_boundary_mask.
> > >
> > > Can you explain the data corruption a bit?
> > >
> > > IMO, either single page bvec or multipage bvec should be fine,
> > > because
> > > bio_will_gap() just checks if the last bvec of prev bio and the 1st
> > > bvec of next bio can be merged.
> >
> > Hi Ming,
> >
> > When bio_will_gap() calls into biovec_phys_mergeable (),
> seg_boundary_mask (queue_segment_boundary()) is used to test if the two
> bio_vecs can be merged. This test can succeed if only the 1st page in bve=
c is
> used, but at the same time it can fail if all the pages in bvec are used.=
 In other
> words, if the pages in bvec go across the seg_boundary_mask, the test can
> potentially succeed if only the 1st page is tested, but can fail if all t=
he pages
> are tested.
> >
> > Later, when SCSI builds the SG list from BIOs (that calls into
> __blk_bios_map_sg), __blk_segment_map_sg_merge() calls
> biovec_phys_mergeable() doing the same test . This time it may fail if th=
e
> pages in bvec go across the seg_boundary_mask (but tested okay in
> bio_will_gap() earlier, so those two BIOs were merged). If
> __blk_segment_map_sg_merge() fails, we end up with a broken SG list for
> drivers assuming the SG list not having offsets in intermediate pages.
> >
>=20
> OK, the reason is that both bio_will_gap() and
> __blk_segment_map_sg_merge() have to use same approach to check if
> two bvecs from two bios can be mergeable.
>=20
> Now __blk_segment_map_sg_merge() won't merge the 1st bvec of next bio
> into previous bio if the 1st bvec of next bio crosses segment boundary, s=
o
> bio_will_gap() has to take same way to check if the two bvecs can be merg=
ed.
>=20
> Please add the segment boundary and map SG list story in commit log, then
> the patch looks fine.

Sure, I will send v2.

Long


>=20
>=20
> Thanks,
> Ming

