Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976C339B2BB
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 08:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFDGkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 02:40:33 -0400
Received: from mail-dm6nam12on2124.outbound.protection.outlook.com ([40.107.243.124]:62593
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229826AbhFDGkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 02:40:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyp9buw9GPI0YkPNnpIN+fjoFqfZDY5yPHgu00wSB7reDNhUga6SR+zcHb8aETlxNscwFVaRyHb0CvVjvecRJmC1KnL5QwncLiItb4U2lsHBSpDWoVxrahMU6WNifRz4E52zQT+YRqM7jDvss9yD+icwm+kWmMDz58DHzoQPlwcNIO0n/XR/nrTLrmnvqaHN6/gWuABcNeWGIsb1yQ1nez9WwP9HaH+gftH5/PNkancDlaSsNJL/SNMAnuLLXPHNkZR+fDmqkaQWrJ/5TBrFXKapYmnWtJNfnycFe2GIYDtvOIcmLjy23z6X+1RxTPPuhc68kKM/2EcJg/Jg6ZvDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaS9br27HCBOWqFo8+cbIOAEunHmDH5YGQpQY3Ur0FQ=;
 b=aUkkp4l9jhz80ZjuNJpHKUegyEXk4qidOpbSV/IhKytQM42Sj3CIPuSRpIef01L/NLUGwF0jICTW2+DNWduwhhi7gma14knOK2o6hOMKbN6AEVMb8C4loTlFU2gV/TOczVZ9OMS5erwu/XWPQQBp75uCbuYNsT0ha52qEs/7q/Ijz6qZISwacFEu8cwDDbCRXQ06eSp1cRD5tawq/rdBboqiwsY+0Y9engFaXgZT4SQ51jgEOauxFiaiPJzCEb6lzhyX4QHxt9UCiBilFgjPB4M5JBzcqIZ93snQuqDMdsiqmLlmw97IJ7kvfM1+Gh+x6GZkh0Vqbadt0uqhKufNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaS9br27HCBOWqFo8+cbIOAEunHmDH5YGQpQY3Ur0FQ=;
 b=by0VB5bAF3pOoBOhK9/DPReu9W9NYjS2IKoD4WjlLBBsYQJ9T5HFcLbmp5bJkbShMjgnVGHJyeoXE4ZlkBktMXktRsP8yWqezPvniEr0H7OqJUtYPqS3wF98nYYY/a2zi188MZf9jyE6vHZEh5h2kZO/lWdC3N28VH71sN6eE/c=
Received: from DM6PR21MB1513.namprd21.prod.outlook.com (2603:10b6:5:25c::19)
 by DM5PR2101MB0726.namprd21.prod.outlook.com (2603:10b6:4:7b::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.3; Fri, 4 Jun
 2021 06:38:45 +0000
Received: from DM6PR21MB1513.namprd21.prod.outlook.com
 ([fe80::c1bb:3431:eedf:cd08]) by DM6PR21MB1513.namprd21.prod.outlook.com
 ([fe80::c1bb:3431:eedf:cd08%9]) with mapi id 15.20.4219.012; Fri, 4 Jun 2021
 06:38:45 +0000
From:   Long Li <longli@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
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
Thread-Index: AQHXWMilfqxountagkCztc+hnNyp6KsDFzKAgABFe+A=
Date:   Fri, 4 Jun 2021 06:38:45 +0000
Message-ID: <DM6PR21MB1513F1E0E0DDD017A4ED3B73CE3B9@DM6PR21MB1513.namprd21.prod.outlook.com>
References: <1622759671-14059-1-git-send-email-longli@linuxonhyperv.com>
 <YLmHi27PT5LAwJji@T590>
In-Reply-To: <YLmHi27PT5LAwJji@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a4ce6acc-3402-49db-92e8-e47b30359e32;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-04T06:01:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [76.22.9.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d32adf8d-bc57-406d-5696-08d9272366cd
x-ms-traffictypediagnostic: DM5PR2101MB0726:
x-microsoft-antispam-prvs: <DM5PR2101MB0726E6C8B106C72426C7C1AACE3B9@DM5PR2101MB0726.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: se/RnQx6BKWzISD3vC3ja/aui37+Pxg/rwWIrkvKXYBbcrWUrvIl4IDRIlLf2KJ/duHb/R1O3ROyy2ux6fGhr8NEjvZotkN1g4he6W0j8dyuQZjnEQzURRNTmBxEqnfia+HHqULc/EPbUZMAt0Q7Wxc/vSzjBGLSqpHxKMl0zzHLlb2QBhL07Bnq/IkrFB3B9LYddJk9/Dr+ROG3rYPX7lceYcyYOEvncCQtPPs3jzg42ElUfNNRG9yL9dxAbt20wmz7RwDUyp1VZEkXUAMdMlNIDagRF+jED4YnrC27sZpzTyzxoKinHDbXhSAAXHyrIkPMvzBhW3bKk0KnYugiIiWeuiJxJo88vmOq/7+F/tfIq8S4lPsLGe98Ms0coKogBruuNuceTKkOi2/znctIKk0M8oqkqMkxjSLnvAU9o086adNqyxK2GD3cM4aT6JPpTJ6tlPGisGZ2K+9mKnMaRyVNWOp/MkbMbtO6Ai2RJMgL9DohYybD+mfPQgfXaCmeFzw/2bavfncK5O2pMgfNiJZucyMqDwzB9Ra3gnW1kBgLgC20YCryEc+m9hjND0wq1V4oG0KvoMiJmrg45VUqG3fF1mGDqcWsMHlESlw7NWH8h1rG5qmy5OtSFHOvF+HelLZGZZOMEJXaw+VBR+SCvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1513.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(54906003)(64756008)(26005)(8990500004)(52536014)(66446008)(82960400001)(82950400001)(316002)(66476007)(110136005)(76116006)(38100700002)(66946007)(2906002)(86362001)(5660300002)(122000001)(4326008)(186003)(33656002)(10290500003)(7696005)(478600001)(71200400001)(8936002)(83380400001)(8676002)(9686003)(6506007)(55016002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E7LYOqFhTyIbfIsblWwQJk+j+rDeS0XytwSNh8fQ4Los7Wkc2TT0mtwnSqPW?=
 =?us-ascii?Q?OsdlaCwHMqdugEiMmIeahmv9dtDBGnXNNF8u/RjaNNPkf8h4UlTut8tY1GHo?=
 =?us-ascii?Q?fhSCJCVHDFjDKJNeQjMxTNf6BU8EyjC8VmDgqI1wMDaEJO+bF08JG3bsKuLG?=
 =?us-ascii?Q?xoK7Qmdf6rawXLKN4TAqm/ZIYDz4d2Ha1oJTuwj27Quiv4pckheHV+mJV/rG?=
 =?us-ascii?Q?O1eR/AswINnqxWAC3Wx65sg8aEs+dEpXI/1ICKtjfhj37sTl6i+unBp7X71U?=
 =?us-ascii?Q?GgzWF7H0ubRQ1Ks2fugiVDztTHIJ6ao58h87sYkP+aPXSlk2poFmtLHsbAh3?=
 =?us-ascii?Q?krZARnQx9yliz6mLaPe3a4+fNnphHiVQKvQB8bAWc0oWS/x1GrrgBqnImO3U?=
 =?us-ascii?Q?ipekKCc83PMu55Jyt+/Yh9vIyvCKQyY8QyERZD9IH7hH4AQxoEQo4VtrP0UD?=
 =?us-ascii?Q?eiO4OWGnirTQF4bKHurj6n2uJe9kN/kEZ5c98rFG6ZTsHyq5W/7ZZXw1ERNY?=
 =?us-ascii?Q?+YzAEWnyzq/cvGchdY8zTenbowMipYgKiooVkuTicxotmf3Kb+cSBR0vksc3?=
 =?us-ascii?Q?wCxkhcn6reauhlD6o35Ff1A25kGsA/XPrYy0rAajWm2P+xihqgMPgSY17NE5?=
 =?us-ascii?Q?LvViqDPDuGn+eWOKaIIRzXuQM3cBAQrANYOwvoaeX2W6q8mSHCuaxwHSCZxS?=
 =?us-ascii?Q?zhf1tipT/Wep8ZaFzozqfWJVATYvIscarpY6YnSUrhUq1zFBzx9A4CRt7cZ5?=
 =?us-ascii?Q?iR3DUpnMFruzgTI8/quoLVXkrlE7cVY7mcK1E88QTK9IOLrlykLcW0BZDK98?=
 =?us-ascii?Q?DRBhMCig1N0FcZJxk2yVheNUq+XAEaUi6RViSo+rpWsu6ckyrpjZVeOK6JWR?=
 =?us-ascii?Q?6MfEltYUE30qDCgzPKKpp96NnAQsJ1aSteMo913bCuCa69z3i7jGrderekUI?=
 =?us-ascii?Q?g5F7n10z5ABico5UKoCJb04nQn6Z8j9DfGCVymcZ7Ah+4wDrZzEoB0LsB1iK?=
 =?us-ascii?Q?Vdd5OmH9tMcrzjvb+tE07dITWkG+HO9JR3iFilHY/V8+zMYJcmN1UgNqbMA+?=
 =?us-ascii?Q?8aOcBmxEqPITjTErP/Fdt4pA/ZBgs8pluh/XvHp5GUQeqiTjix61//o3V08H?=
 =?us-ascii?Q?ViPqYTzorZQj5ApFrVK2VHEVUoRNwfspQbKNTvhGVNIJBumNLfHCwvnz1KKl?=
 =?us-ascii?Q?Ry994jVvryyke69frsiyK8jSqxcb/Ouyp4R9f7bWpQPErnPguNm1qDcBxJPD?=
 =?us-ascii?Q?aFEDotAdskOTUbpKNsw4fyTKPirBOTPqhqm4NRX4YlZg8DAqXnwpBpKplNqX?=
 =?us-ascii?Q?qfY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1513.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32adf8d-bc57-406d-5696-08d9272366cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 06:38:45.0960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cKIWWt7w5g208+aFtw4+KgsaFS55i4Txezi3QpUZIwk0DqtxSXY2Wl/umlWhReglb8Wi+urmFXGyo1rNv9eMsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0726
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Subject: Re: [PATCH] block: return the correct bvec when checking for gap=
s
>=20
> Hello Long,
>=20
> On Thu, Jun 03, 2021 at 03:34:31PM -0700, longli@linuxonhyperv.com wrote:
> > From: Long Li <longli@microsoft.com>
> >
> > After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec
> > can have multiple pages. But bio_will_gap() still assumes one page
> > bvec while checking for merging. This causes data corruption on
> > drivers relying on the correct merging on virt_boundary_mask.
>=20
> Can you explain the data corruption a bit?
>=20
> IMO, either single page bvec or multipage bvec should be fine, because
> bio_will_gap() just checks if the last bvec of prev bio and the 1st bvec =
of next
> bio can be merged.

Hi Ming,

When bio_will_gap() calls into biovec_phys_mergeable (), seg_boundary_mask =
(queue_segment_boundary()) is used to test if the two bio_vecs can be merge=
d. This test can succeed if only the 1st page in bvec is used, but at the s=
ame time it can fail if all the pages in bvec are used. In other words, if =
the pages in bvec go across the seg_boundary_mask, the test can potentially=
 succeed if only the 1st page is tested, but can fail if all the pages are =
tested.

Later, when SCSI builds the SG list from BIOs (that calls into __blk_bios_m=
ap_sg), __blk_segment_map_sg_merge() calls biovec_phys_mergeable() doing th=
e same test . This time it may fail if the pages in bvec go across the seg_=
boundary_mask (but tested okay in bio_will_gap() earlier, so those two BIOs=
 were merged). If __blk_segment_map_sg_merge() fails, we end up with a brok=
en SG list for drivers assuming the SG list not having offsets in intermedi=
ate pages.

In practice, usually a duplicate page (because merging fails) is put to the=
 SG list. This page and all the pages afterwards in the SG list end up writ=
ing to the wrong sectors on disk.

Thanks,
Long

>=20
> >
> > Fix this by returning the multi-page bvec for testing gaps for merging.
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
> > -	}
> >
> >  	bio_advance_iter(bio, &iter, iter.bi_size);
>=20
> The patch itself looks fine, given both bio_get_first_bvec() and
> bio_get_last_bvec() are used in bio_will_gap() only.
>=20
>=20
> Thanks,
> Ming

