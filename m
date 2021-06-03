Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A8539AA9C
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 21:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFCTDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 15:03:16 -0400
Received: from mail-bn8nam11on2117.outbound.protection.outlook.com ([40.107.236.117]:36065
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229576AbhFCTDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 15:03:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5b0WDViU3QbWlJyMhVhEDm13QhY2yOf/ZYqT/Vs7VNNpGdn8GsJ8+XieVks8182I2loAmCg1LqdG3dulAh3D1BnUoGP4x6RHPD5EOSszeOK8/nkIdJixvayP9ibBfh2gNo/CyWMhUmnpFbVrrxt+yRrBTKSGsVjpo3kSJlpKrLusqNooS/4p+oblsjFWVtjuvWjbEFUR1+R3nLLnYtz9UvOec01U7PjNv4A8eMKpqqOMbLAb2Othqackoz9RXK+iL96qsm2lljsIinjJ4EI5QcCjhcBiCGdXjxO8LpqTbnyAcN4w16NWRbpxm4nRg/eEKnSwQM9l+vLjvViN07xUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD/QxJQQPdA0THscN7h1DufyKdz40ny0nAot6Ze4MuA=;
 b=M49qzu+KmmBQMVBIVpeEVadWQtgSD73Px5DgYWjyPKLFkd+/Q0TKyYjzj5PGoiAXA3VFpNU8tJ/1BkXTbuuh1uagP55Jkx3DS3OJcxNW3AD36rSjFMsS0yWMnqbL2uYY9b4vAEoF1Almd+ZcPu5djpVkQ6+LhgcrNt5PLQL5XyWxgeDXo4ZCNCOeon1z5aqyMXj67gT722btlmegR1TyNpePRLqb2O07zhNK3NN1DtUmq8N1mW3U951WBN1TjIR6Yqp4Y8pQpIJWHIuzQAW0/31b7uNc65jxh7546Z5kAIZ2ErF0Xqo9M0RSr0MZD3H+tkSr5atjORRV6fx/1AKZ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD/QxJQQPdA0THscN7h1DufyKdz40ny0nAot6Ze4MuA=;
 b=Aci1ts8e6awrQNU4nq4zH5YGLqi5/86PT28GN1bRpX5p+a/+A/QxcHkw9zkkyrAcF9Q86hYdMG4f/hMw4PQr46Q3dn9XK7Pdd81kQAy7827aBGLJftQMBWkNWXIQskGVlPqwc0FkRVLnJ5KYNeKj971YXflIxF2+MRv2i2XwWLg=
Received: from DM6PR21MB1513.namprd21.prod.outlook.com (2603:10b6:5:25c::19)
 by DM5PR21MB0634.namprd21.prod.outlook.com (2603:10b6:3:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.5; Thu, 3 Jun
 2021 19:01:27 +0000
Received: from DM6PR21MB1513.namprd21.prod.outlook.com
 ([fe80::c1bb:3431:eedf:cd08]) by DM6PR21MB1513.namprd21.prod.outlook.com
 ([fe80::c1bb:3431:eedf:cd08%9]) with mapi id 15.20.4219.012; Thu, 3 Jun 2021
 19:01:27 +0000
From:   Long Li <longli@microsoft.com>
To:     "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] block: return the correct first bvec when checking for
 gaps
Thread-Topic: [PATCH] block: return the correct first bvec when checking for
 gaps
Thread-Index: AQHXWKjPe/0y7BnaoUqIWYyLD3dggKsCpAZQ
Date:   Thu, 3 Jun 2021 19:01:27 +0000
Message-ID: <DM6PR21MB151319DCEC69835549413643CE3C9@DM6PR21MB1513.namprd21.prod.outlook.com>
References: <1622746005-10785-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1622746005-10785-1-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3661959d-f836-4ba1-9870-4b4753409653;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-03T19:00:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxonhyperv.com; dkim=none (message not signed)
 header.d=none;linuxonhyperv.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [76.22.9.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdd0c1b1-6c14-4dfb-8b6f-08d926c1fdda
x-ms-traffictypediagnostic: DM5PR21MB0634:
x-microsoft-antispam-prvs: <DM5PR21MB06346B99562F0B2D63FDA744CE3C9@DM5PR21MB0634.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:469;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7EH+JS6Qf1QNcRNzlbUo9xFHz3SM+FXyCkGaZq/z/FooYAm6OSmns1AI+7LAxA2hK3dWzvpFY9RGXy6E+B61gv7GZb2sAyq4EovqipORGgKWssa/L5+XJc6EU5K+UZk0L+XYNdLoz3kPggTF9Dq/yT9Wto0GgdE2S+R8T3KcQw8KLpGTY7QjMPAdy7oVD1QJUYSNHmzXW/WtiVhoUOBpGo2T1Tscp2Ztd5xwS6dvP75YVl8jS/anTgNz/y2A1LINI6+81DhryIi7URTFqMu9ZYvRGgRMYXfN4S1XyZzAlZbEH6uskyaLoJLtXXMVxsHiNHt0cpN6ORrXabQ5y7k3rzzEl3IWRWclWdwRAv24StDQXf4X5MJca5xLrmYUnrjkesitxnW6EaW5XQdvbMQbZrhHBNrmQvQb8W8Txr6T8mexPhff7i2WGgy3Eefm39tNY6ddEx+x8sok7b8RQJWAiaOKiacnDfRSTP/zxiJ8Dn5oAl5iif8yLVLHMDIO01mdijrIoZ3BII7umfiRm0AnKqUBWkbBBsiHr2JHi3KURTvukGLXE0StmBMy0LeGAViHoGms4Pz5d5q/Ecwn6gH4miUXoJK9EkhzXU4VGavxYR4XXk9dP1fKF5BrMOrEFGex7blylxs2AKDw81iUfti8pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1513.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(186003)(26005)(5660300002)(83380400001)(8990500004)(8676002)(6506007)(53546011)(82950400001)(2906002)(7696005)(66556008)(64756008)(4326008)(71200400001)(86362001)(38100700002)(9686003)(55016002)(122000001)(66946007)(76116006)(66476007)(66446008)(33656002)(478600001)(316002)(110136005)(54906003)(10290500003)(8936002)(52536014)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SWc+D/Q6QJWG4oAkzzTcs0nDmiyXaT1uwDvkXKAmDlVWxGZ+iatSrwLmfJEK?=
 =?us-ascii?Q?1rF7Szn0bmT9hbkZdxp48x9+7seteKASBajps29H8secq4clSa5BulG/Ex0p?=
 =?us-ascii?Q?4GVXvyANJk2LWRoMaxmi+eLq+VjZcwgwCNUKauZgqPG+rPfe5ohLLDolidXp?=
 =?us-ascii?Q?Y3V46HkmU3XWq0hhoxwqlBQW/MKFNXKIuH3dXvHL9CFNnRqfasQ0DK3g8GZo?=
 =?us-ascii?Q?fdCQ4bUw1xFXdlExtQo8Ls5Ulb1hR/CuPramtYwxqvWQLhKU0CL6KaSoyMjS?=
 =?us-ascii?Q?7SuTF22TE5ir85GLq4bPX+pxyTr9BmjOiYIqlQd6CrauDSBRjb9hs9Dv+8R7?=
 =?us-ascii?Q?I5i3Et3Vj4mOijVeY9+3sKM3drV23gSlxdewz0iEc+sHLHJD7/NgA1KL4qJB?=
 =?us-ascii?Q?4b92EQ66pdhdYWShgj4oqtVcrUT+lXfcyQRwvfJANvWJ9ops0KWL2COEQiNq?=
 =?us-ascii?Q?esZOChosjXDbAD1p67nJF8Q/c0m/vJkRkHhlkBkqLz4DaoVvxHalflHlrIRj?=
 =?us-ascii?Q?Ek6BfeAn+qxCz8QKZkKZ+l6Ww4INac5EjvX6Q5DsNbTnXJtQvLWskuMYYSBv?=
 =?us-ascii?Q?xNilr6QISimBDLqaK8LnXpxvQI5STY26B+TzmcaRE2UzXBx5af043x3xXEEn?=
 =?us-ascii?Q?JJF/lGNiGutJZUvtHUq8OdL2WSk2qxOAm7Dzj+4bjqsLEom+YsZ/umGj9nit?=
 =?us-ascii?Q?X5qkdhmx31i/S3MR7UIHkjvFanURLN4kvNzpJqkBtj8Q4u5AkKZ+il0/m3fY?=
 =?us-ascii?Q?zMGYiLuYHmbbznoTUw5LysZC7j1joNfG7QhvYI6D4bvrB9tTXFaNwxiguhVr?=
 =?us-ascii?Q?OnD3DmbKREoX1d2/wNyLPQ1gADB9WkWUCvGsjH1WCWTT1aRxj291xSCn5j8a?=
 =?us-ascii?Q?vSaye1tWCL2N/q6Uf0tKPfn5839c7xyLj5hx5oQi1r/fU7ev8VGHRz3INW/l?=
 =?us-ascii?Q?ReukwddHB//57xFKYiIZJiymY1dLWBYrcc7q5ddr?=
x-ms-exchange-antispam-messagedata-1: 0ycpuLHYnEbZhTL4CdEBx6Vnhxpu4KYjmB3EnYxgZNHuHtLbpZ9eEu2YAnxX1PFmruXqieGmkEJygiw4FTduv/jX8bEoLehGZtBIEQdv0o5vCo75iGvQujN925ogkMoQAeLa0NNhsJhs4i+ADpJ6q0bSvKtAyq18cR8sexPfcbXYQG/qYjuITL8V40TSyxmLJjljQjg1H8vi7OqIjmsAd3/chloFO2ldKr47Mgoq6H+/2RLrN7A1YIKMmqELsGXiUOwWh36PbYsu8otpeTBNthAl03zBnEslMxOo9Ryp+DDuV9FbRYJlsPZAZTH55V7v7Ng=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1513.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd0c1b1-6c14-4dfb-8b6f-08d926c1fdda
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 19:01:27.8112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ha1OFx6hz0TnziUSsy3UsLiNpR8DjfO2U0EvvHx38AYP+Siht0rmP8RU/0+bE2jfFF+NeKJBnGoPj39gW2z/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0634
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Please discard this patch as it's from a wrong work branch. The patch is no=
t complete. I'll resubmit.

Long

> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Thursday, June 3, 2021 11:47 AM
> To: linux-block@vger.kernel.org
> Cc: Long Li <longli@microsoft.com>; Jens Axboe <axboe@kernel.dk>;
> Johannes Thumshirn <johannes.thumshirn@wdc.com>; Pavel Begunkov
> <asml.silence@gmail.com>; Ming Lei <ming.lei@redhat.com>; Tejun Heo
> <tj@kernel.org>; Matthew Wilcox (Oracle) <willy@infradead.org>; Jeffle Xu
> <jefflexu@linux.alibaba.com>; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org
> Subject: [PATCH] block: return the correct first bvec when checking for g=
aps
>=20
> From: Long Li <longli@microsoft.com>
>=20
> After commit 07173c3ec276 ("block: enable multipage bvecs"), a bvec can
> have multiple pages. But bio_will_gap() still assumes one page bvec while
> checking for merging. This causes data corruption on drivers relying on t=
he
> correct merging on virt_boundary_mask.
>=20
> Fix this by returning the bvec for multi-page bvec.
>=20
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 07173c3ec276 ("block: enable multipage bvecs")
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  include/linux/bio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/bio.h b/include/linux/bio.h index
> a0b4cfdf62a4..e89242a53bbc 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -271,7 +271,7 @@ static inline void bio_clear_flag(struct bio *bio,
> unsigned int bit)
>=20
>  static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *b=
v)  {
> -	*bv =3D bio_iovec(bio);
> +	*bv =3D mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>  }
>=20
>  static inline void bio_get_last_bvec(struct bio *bio, struct bio_vec *bv=
)
> --
> 2.17.1

