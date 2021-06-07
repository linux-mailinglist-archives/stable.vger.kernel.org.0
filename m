Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5888839E60E
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFGSCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 14:02:12 -0400
Received: from mail-mw2nam12on2131.outbound.protection.outlook.com ([40.107.244.131]:37344
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230237AbhFGSCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 14:02:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Idt1mMJj9670TbZA5mFNubcf9ehYy3vnVo1kmEjcthnsvWrkQlQ9JP53d+WTZ9OSLh5U/2SlHtusJZ++75y5ZqxYydS8DVOq1wlF7yxH+kVSxrO8ZWEIvG/lJfXquE2lGcJtx9UORNCz5rz5kir81JeNUuKWvMjZ9+TQOuNjj1SAwrjntwThXj9SeKwRw57LgB9DtnBxvrF978n+1YLHkmsf7QsTmc4Slvj64iMfVGKwAidlSkIYgm2l4EaplHShPZkHjnBIYmhzaVAvvaZWy3ss9idGIWd0he7kFqwd85S1JWZh+aVPsin36SfL7y7L2SSzkjqbjwII/Kmzxx8+kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE6szxpOM3s2De4hYWHO5/rvQl/q67lV4GzPFAK/BQc=;
 b=OIdlYISbVuGIUViagGZ7B0uIC0QcHWPikOwsW1WsJ1+3RhgPQ9YMylomvhY+5PRwTOV6ouSNPmZF5VW/RXSZf/DzM6HLU1AC5T+FVmVk5P8442PFPxIMKs97Upq2hreszdkAnjuLihVo20f0kr7yWFbpXBlKt1jIUzrpYbaFI7/ur0V2Cn2/YUpGBVVsrXuUAlrIhR2ZsTbIPiRYwCoLX4mmJdB5M3Cy7sEd5BOyqnWTm4+wpSdXiilq7M1BwK7S6KloV3YvLhV/JAlGy29VgTuinfPpqBKf4U534buLlOjeY94++T+NceNre770v0NAuq5oPo2sVuwzxM9pmK0gmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE6szxpOM3s2De4hYWHO5/rvQl/q67lV4GzPFAK/BQc=;
 b=CPNqPdWoLboGbsPiXk3MrysA4kv8VN+U7ct6A7WaRtxB/onlVGvrI+Ragy8nn55YncT7GGu1xdJcmTmXYJ36gIj6s5JtIEmfaZnUzPdFUr7SHKMfrtC8xkcChua8reRMit6hPzAuelQG53Rxh9u8Yr+L0gMeV/ts4LIWByNl808=
Received: from BY5PR21MB1506.namprd21.prod.outlook.com (2603:10b6:a03:23d::12)
 by SJ0PR21MB2053.namprd21.prod.outlook.com (2603:10b6:a03:38c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.4; Mon, 7 Jun
 2021 18:00:16 +0000
Received: from BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::29f3:2078:6dd5:33b5]) by BY5PR21MB1506.namprd21.prod.outlook.com
 ([fe80::29f3:2078:6dd5:33b5%9]) with mapi id 15.20.4242.008; Mon, 7 Jun 2021
 18:00:16 +0000
From:   Long Li <longli@microsoft.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Patch v2] block: return the correct bvec when checking for gaps
Thread-Topic: [Patch v2] block: return the correct bvec when checking for gaps
Thread-Index: AQHXWZqgUzHGkML6YUeaSbBJY+ppq6sIJMUAgAC1wFA=
Date:   Mon, 7 Jun 2021 18:00:16 +0000
Message-ID: <BY5PR21MB15062644BF6CC83DD3ADB955CE389@BY5PR21MB1506.namprd21.prod.outlook.com>
References: <1622849839-5407-1-git-send-email-longli@linuxonhyperv.com>
 <YL3GDF5KiM9e69eW@infradead.org>
In-Reply-To: <YL3GDF5KiM9e69eW@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=329f7578-a473-4d52-9b95-d1a4af35ada1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-07T17:59:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none
 header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37ed22f1-216f-489b-f69b-08d929de1b38
x-ms-traffictypediagnostic: SJ0PR21MB2053:
x-microsoft-antispam-prvs: <SJ0PR21MB205357C0B85E45627F047FA5CE389@SJ0PR21MB2053.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hPgYU1qLU8SJjLYXOxAX/R+APKWhJyCDHbcWMBhauaRr+PzTJ7GxWvCfuXOAoiWKCrMpkeM/6DjLiU0D9wZNXrJJky4tLcD/vKUQqZzfiJ/LgvuNjMC83gWqmhC2G1uJGY/1tmEchPm16y+3lIg/M+EA+YYQ553zGge147utTsiyPM2XduiLf4iddrGZLB6ZBrGYq9wKqyOHkcABidWXUcwSZN96+IYYPITstCoYJy/UpMpemUUUXjnuv3eoUuNfCmnyL7uaPViUr4Xz/Inlo1B9fu4adiE9GNJFIqXOeXQLzfJ/L60onQMsY8pB+37XGjJwuCpGQoQHFWrBRDIszKd07ipv9sTHsmK+/ResVXTcsnA9cuKxLtMxUJWnjkFHSbWQSFZHooQ60M0+fOvM3u4pD1qE0Imha+g+iVUGB3gY4t37sQEve+sT+2+B+sNyPmcYsRW+oqCRGg7H/Yjl1zgNoh3Dhlb9jLp0DsjR0NyML877P3hnzu4oY5w8JUytW6i+neDdE2KPP1ucRWGBW9FNg8qQlWKuO2NdBp74fUpRuKNb7KHk+O85vU5zdYGR4NO6OtvlWEemtYZnB2RbxCDqDIvTaZ3Ht1E0MJQRhNXaUGtf2dJZHxI2i3WcKppRF0a7stubQxkEMjMfrk9Uaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1506.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(6506007)(478600001)(38100700002)(4326008)(8936002)(52536014)(55016002)(122000001)(10290500003)(66556008)(66446008)(86362001)(82950400001)(33656002)(82960400001)(8676002)(7696005)(186003)(66946007)(2906002)(76116006)(5660300002)(110136005)(54906003)(316002)(83380400001)(8990500004)(9686003)(7416002)(64756008)(26005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X6XvnoaBUUZ/G5mTiX2tAaJleZQP8a80w7Sz7qzgpTQoyZ1qNsYxIVkXtLXM?=
 =?us-ascii?Q?3Rv7pqRGgoOnB0J827Ckx2MTk3UQTmY9D91qrU0v20+bHaDPZDCBU57r6DUG?=
 =?us-ascii?Q?OSTajluQm+9oeU8aSC2QZ6fx0DOMzrcLuQa/uUvTJNf3ja5MIY8uSPH96V9n?=
 =?us-ascii?Q?mHqFeFgUkphKg73D7rtK2QaLpHnN0fo6SkL+XRMaS4uxuJsBJNvTcsHLWT+O?=
 =?us-ascii?Q?R+VpWfG+gHXPBCiOshX3jFg4Q0slrYtp+FVmJPi7YrurozrB6Nxgr9huR593?=
 =?us-ascii?Q?BrFzAavk5QGfLv1kDztQ8lCdQ5MNqtd0bxJLv3G3k2iSOPY1darAAlicrbVs?=
 =?us-ascii?Q?6GPM3yLyjgVxGOtpCOK1xB/rwJi6QYtKfPBNctJ7YQLGG9jofsamUXQyw+/m?=
 =?us-ascii?Q?aUXakoxAfvf9ZjrxIJ6rnjn3ZXeApj+oCLKsqm38lf5N3tHxlB6tzImyvLMw?=
 =?us-ascii?Q?9tNgS8qW6Ntdqm+IhVQsqQpzvUZBn8j/ayqj82tOwr+46zvYVi69dh0IIRWS?=
 =?us-ascii?Q?oIOaAJaSY6T58eoC50xoI9rFMZQ2+UchyMAa91bq9r9P4CHre/JRoCVPbBGJ?=
 =?us-ascii?Q?sTlmboOJiWFaH2t7VVOFn0lZy4DdYtjZDdtnP5J06SA0KwqYOeyHe/A1XLnf?=
 =?us-ascii?Q?C/6A3+l4BoERXTl/CqsVoAQFRO8WnHMUpZlG/2elS6QRnD76t2gYOCoWOqrb?=
 =?us-ascii?Q?ecXRg1j5wbY2jqFatETUZY6BV/d2FLBarE/oR5saUQbX5MrrApJWKDl+xDVk?=
 =?us-ascii?Q?cGrXBsyYNfgDVt1D/IHeAMW92SdOuFXdTbR6my4SHDqITM/QTanXZCc3lwcX?=
 =?us-ascii?Q?RIAKJgxcA8KvynQS5xfuhtd1n73kVOkm1sWmkXaQDTUy0tmBDpYmXePSFHEl?=
 =?us-ascii?Q?R+VETp/rWiH4uylnOQChRhU/XnRpm9lqdJhBNMuMzejuXjIRmSZnBIq5v+4T?=
 =?us-ascii?Q?5+ts/nIPnBIxP1TP3gf719PbmRDQ0JacyxpyMCvntCA8CMVbPDrRev293+7v?=
 =?us-ascii?Q?id9DNzqo3oNwlv99IqJzXf78PAiPPLv0lX6bgr67TvE5nj+DcjfJgPIWKRpZ?=
 =?us-ascii?Q?8WgyAkdXZLrC7SPiieUV2uf5lCsHa+cZem2dZ3KTbN/EwgbQbzh2YeFNRWf/?=
 =?us-ascii?Q?Z4lZ6UBE4xkOTSVtjzUjaCNpZBmEW/nISbwYx6xyhFLvVEFqapfqEThec34h?=
 =?us-ascii?Q?WRraEen3ngE3aGVCPgVF/9FfWZtyuOcxwaVysUQPreyni0MEh+8tc2sl0vnX?=
 =?us-ascii?Q?obZ5414yS+1bcBqyybMPaHmoHuVgJcjg38l/gBJF6qkD7QMpX0HsA0TcnHQp?=
 =?us-ascii?Q?gfY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1506.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ed22f1-216f-489b-f69b-08d929de1b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 18:00:16.4617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 07mB+rgdnXNA+McitYuqBiVZfZdBBF2xpLsCY6/ltYWQjjx25cZRk7Dssf2E4Lcgk8ZxM645X3BwznO3mFt5Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: Re: [Patch v2] block: return the correct bvec when checking for =
gaps
>=20
> On Fri, Jun 04, 2021 at 04:37:19PM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec
> > can have multiple pages. But bio_will_gap() still assumes one page
> > bvec while checking for merging. If the pages in the bvec go across
> > the seg_boundary_mask, this check for merging can potentially succeed
> > if only the 1st page is tested, and can fail if all the pages are teste=
d.
> >
> > Later, when SCSI builds the SG list the same check for merging is done
> > in
> > __blk_segment_map_sg_merge() with all the pages in the bvec tested.
> > This time the check may fail if the pages in bvec go across the
> > seg_boundary_mask (but tested okay in bio_will_gap() earlier, so those
> > BIOs were merged). If this check fails, we end up with a broken SG
> > list for drivers assuming the SG list not having offsets in intermediat=
e pages.
> > This results in incorrect pages written to the disk.
> >
> > Fix this by returning the multi-page bvec when testing gaps for merging=
.
> >
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: Ming Lei <ming.lei@redhat.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > Fixes: 07173c3ec276 ("block: enable multipage bvecs")
> > Signed-off-by: Long Li <longli@microsoft.com>
> > ---
> > Change from v1: add commit details on how data corruption happens
> >
> >  include/linux/bio.h | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/bio.h b/include/linux/bio.h index
> > a0b4cfdf62a4..6b2f609ccfbf 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -44,9 +44,6 @@ static inline unsigned int bio_max_segs(unsigned int
> nr_segs)
> >  #define bio_offset(bio)		bio_iter_offset((bio), (bio)->bi_iter)
> >  #define bio_iovec(bio)		bio_iter_iovec((bio), (bio)->bi_iter)
> >
> > -#define bio_multiple_segments(bio)				\
> > -	((bio)->bi_iter.bi_size !=3D bio_iovec(bio).bv_len)
> > -
> >  #define bvec_iter_sectors(iter)	((iter).bi_size >> 9)
> >  #define bvec_iter_end_sector(iter) ((iter).bi_sector +
> > bvec_iter_sectors((iter)))
> >
> > @@ -271,7 +268,7 @@ static inline void bio_clear_flag(struct bio *bio,
> > unsigned int bit)
> >
> >  static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec
> > *bv)  {
> > -	*bv =3D bio_iovec(bio);
> > +	*bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> >  }
> >
> >  static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec
> > *bv) @@ -279,10 +276,10 @@ static inline void bio_get_last_bvec(struct
> bio *bio, struct bio_vec *bv)
> >  	struct bvec_iter iter =3D bio->bi_iter;
> >  	int idx;
> >
> > -	if (unlikely(!bio_multiple_segments(bio))) {
> > -		*bv =3D bio_iovec(bio);
> > +	/* this bio has only one bvec */
> > +	*bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> > +	if (bv->bv_len =3D=3D bio->bi_iter.bi_size)
> >  		return;
>=20
> Nit: I'd move the comment a bit as the current placement confused me at
> first.  Also maybe use bio_get_first_bvec here to make it even more
> obvious:
>=20
> 	bio_get_first_bvec(bio, bv);
> 	if (bv->bv_len =3D=3D bio->bi_iter.bi_size)
> 		return;		/* this bio only has a single bvec */

Thanks! I'll send v3 with those changes.
