Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A810549BDE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbiFMSl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343728AbiFMSlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:41:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99781273;
        Mon, 13 Jun 2022 08:22:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+iBVjx8/AHAUbRGE7LrHv/q6lGjpfpJ0Flfd6rGrPNUcsCwkmgXlwL/5Kw8EfHfl//nXcb4GohcH6M5fcjeqCcPAAOiefCB2tsYOq5+oYqWE/VB1WOpI6IbP2sDV3wc3XJEWw49I47uLdNFkvLo1Yuri6vXCh5E4RDHFrsnfhkO4C8DEbBYg1n26WagjC+QQmLGf9jmdZlc60+6Mb4lN4GCVwjJcUF4q8Aa+Gn6KUC0QZjBlVyiSa8/tMKQHV2qdmfjfGUQ7V09C3r+anZ3+AEAIsT6sE3jEl/OSeKsDbU3jgzk+O+EZX6pBe2a6I1fnJyFo/dy/A6ccF/c/4hpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCQFTfhT14a4PDGahBJX6DvD8uq581nnfi81vWomv4M=;
 b=LYoKUVRH7uR62jImSY7KUvO7DyDQ2ILNNkwvmbw+/emczN85bTtdfr0dbl1kfsLW8T7ac8PxUBaF23k3xLwWyXyfwfcC1Fjv0MBVSUrdhjQJXXI6/2NeacA0O67JDYKzpMhbRsLLKeedyqbyVQS5OXh/6CblcdPwaVY8wMMC/mUrsxtj9SMGcfFk2+tQ4vF7PwM1Bcz8T1nK92c55XnfbeYu81sAnkJnxYDb754fEO6hKg4mLVYU4BPJj8CubzcDZOLm1YE51Z8sErpp+Dw1GYecv7sfkgKlF4ab5UJSnu1CVHFD2kTVYl9uajEHD/BFzvGfPkWOCar9PUi0f7JM5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCQFTfhT14a4PDGahBJX6DvD8uq581nnfi81vWomv4M=;
 b=cZ1vmTCnw+HFA9gOoNTVco9N2FSIjAJUyYCPwHwExwqfwKuTll/DuDXVO9MkVYtlMpj69WsCgTElm16ryuAOJ2kH/CPdZQo0DDLI2zEoR6fOcl+I7UK2NoElG4Y9UpMoBIcfuWwvnXNGYSvEQbg1EUWsGTWK1Hz36GblazUXGUWDRuBvat4lnEs1YRf7a+pf+Ild31QQVwqmrPvm9+sYsl4ro0qu52sL6KDd0vO/qv2PEix7pA1/Q2pfxAxZSC32Xjzu92FjulfL/kjhdwZueudGRX67vBwRBKdwV5JSoYMOqag1H/PylUhSxH5EYSIimj7H9fcizfc8PzplsrSdbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB5744.namprd12.prod.outlook.com (2603:10b6:8:73::18) by
 CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Mon, 13 Jun 2022 15:22:56 +0000
Received: from DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471]) by DS7PR12MB5744.namprd12.prod.outlook.com
 ([fe80::2030:d898:6e2f:3471%7]) with mapi id 15.20.5332.017; Mon, 13 Jun 2022
 15:22:56 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        huanyi.xj@alibaba-inc.com, guoren@kernel.org,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the
 migratetype
Date:   Mon, 13 Jun 2022 11:22:54 -0400
X-Mailer: MailMate (1.14r5898)
Message-ID: <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
In-Reply-To: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
Content-Type: multipart/signed;
 boundary="=_MailMate_1CE0925E-B4FF-407D-AE4B-20DBE557C614_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
X-ClientProxiedBy: MN2PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:208:134::36) To DS7PR12MB5744.namprd12.prod.outlook.com
 (2603:10b6:8:73::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6abcf5a2-b946-42f0-2f11-08da4d5097d5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4232:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4232476B5B1A7598BC642480C2AB9@CH2PR12MB4232.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KWrdVInLQYoIgrVOIyqQkX24H22YCEOnLnNxNCPSlCXA3RPy+bHSMkypR9O4qCMyFQR5Mp3BwhQ+zN+O3D6O034U362Bt8SZD9s/ctvJyiR20cZDkWjlOYKi6vahvGqL8Zn4jxb1lB1LQpl4857KL1y6aAuaCI+xh4N/ksfbNFqWkT4ZXDmv1JpXMc/4hGnL6kyJB8/EXVfFDkIz3l6wwnmYg11HypP/eruSCzic9hHcNqZgMsJPGt4f7a5wiS0vebCdoXCefk0mOeefKuyNIFPWihSYANnjj6TtPrqR4TL78MjT3NMt11o0l96JSK+yP55li3lbdi9Ji/wqZBEm1WEGq17YMC/OMIsq3C1h1kJX6Fr/fIBeBBrul0d5X8RTcIqZV09dV/mGvg778fqtpw5vqPmh5fQjPMPaSRtYqJvDLJiJsqEB9bH8XLxT5pom/hN1x9qs9saPb4MZSycNmLDv4SNp3nIQ7GUXgtDXYDCrueup/uo+t++jNY2x5iseuNVhyz0ER3lrfFWxUHhg6ySzPMHpisPnzGAkyv1dUtNMOC+5GdA4CB4RwqNKQRhXAoRpkhKdMHXcaAPdqv+iy4TXu6DUfu7RjFnVigSHh1f/Qs8Y7NlKp19gjKNiZqPs+RpDAM5cZmC6U/cqbChqXzH8+WmI+P4wov9lBcDWCb8p1m1iyi+eMF1iHQNLdTNOv4i0Qp9byOkm3zEvpdoh80NA+bS1mR/WUhedf2A5H8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB5744.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8936002)(6486002)(6512007)(2906002)(38100700002)(33656002)(8676002)(66556008)(86362001)(508600001)(6506007)(186003)(5660300002)(235185007)(7416002)(26005)(2616005)(83380400001)(15650500001)(21480400003)(36756003)(53546011)(6916009)(316002)(66946007)(4326008)(66476007)(45980500001)(72826004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kXVmGcaMQY6N+Qb+g0WSAQA62R3R8plAar6JZZ9U4m41t3CEqLt2A3oBVCgz?=
 =?us-ascii?Q?kEHgENrgcdgSG+Re/W5IGqqE4HiBq09xp0mEqxVCqHxN1rNiNIUyxpkiyKIa?=
 =?us-ascii?Q?thYpuTJp1IR/DoYA99TX71WAJ3BeBau0JNLjcjCzAP6Rt8ZsD5IFAWxAhOhB?=
 =?us-ascii?Q?QpLkCmT7Zqp9IVaN5nqoHX7yjNTiKjb/tsEhvHzn33pNQPp1MzCbj8tYIqCg?=
 =?us-ascii?Q?OWTeSLoAav7naeJuvZypY3+x7fy7dzEiUi9fEU2+16yl8bIwPMj2cRXLNPpH?=
 =?us-ascii?Q?tls2GnV1rPRe26ix2qvF2LMSg7U6dUpvWGKo78W1BzUluKqqUK26BvjeOzxK?=
 =?us-ascii?Q?t6pwRdSbw2/RBNTYC4F0rgaImqFOlbmS9m24Em1f807NtKFBQS9BflvDqbTh?=
 =?us-ascii?Q?obHYVpdppJOt1L8OHOAVzBv6LRfJH6FkAEpfuGR9g9Z8xxemVqBaUL1lEVcR?=
 =?us-ascii?Q?5oKe/+6GLk5xXusYOVH8+TgUcLkB+ZU803SHEjQ2M00QCbwr3jHKh2LrQLGW?=
 =?us-ascii?Q?NX4l3t0dxFohxrfYymhpqyIthz8gjpEC8NpxKFuiZqiqZSeTw3mMYod7zIsV?=
 =?us-ascii?Q?v2zln8R050njGshiTGyZP6B/3lQIXHvEZxXXHH5bb5NjIO8RIE+Kd0kTyRwD?=
 =?us-ascii?Q?D13E5eqpT6Sb3kFFg/YFBK3Fbixpp8G0zllSpfiaIGBMuQJB22St/9oDQeKJ?=
 =?us-ascii?Q?q5THzFlNCF3DJ/723umvjco3i6jGoIT2eTYo0TJAdbtnLZhEgPrxzd52Cjun?=
 =?us-ascii?Q?djLq2UVkrRK+TUWAoymQtyBgQck/x+irnlAjpvqBqmXA1MZythiRIV47+Jjx?=
 =?us-ascii?Q?wignQEdB0flRNUDpr75OzNG5xV6cwZl34enZqLszaHDKp9lZv/YB9xzMSDQ+?=
 =?us-ascii?Q?F7LbkwJCoBjIrSUbu2Y7+0C1uuZB+JGON+WcXiQMJALkGpJd1PyKkbp6ZHU7?=
 =?us-ascii?Q?pnmnAJiiy/bhr3lS2ycuEOOhXKvj5nAvQw+RZiypewCmb6v2TNM5brTmrzKy?=
 =?us-ascii?Q?6i5iv1jv0qGdEfaaCE4WVDi2rWnpsp7z91nXjgXh++izH7zPikK3LfYCVWrn?=
 =?us-ascii?Q?d1v/sfbFsZJBOJ4EXHHJXDuSFkxtXsu7jQm2vbRv4zR7X8c4semk3CIbqR20?=
 =?us-ascii?Q?IBw0WtN0LWrRN3ISDcPUlgQ0Qm7Up8Pf/XiOrNMbw9QoTqLmHL75nVJfnh9a?=
 =?us-ascii?Q?iRpfPJ8bZXqI+dtNuLhrq1mtaOi7BFETIccCPlckkIHLS0QyXhg0VWnO82vh?=
 =?us-ascii?Q?tI8SPvxP28WJsGfboPjljgxIMTCERyK/VtY+hr571x3pIge/AACv3bJuUSgp?=
 =?us-ascii?Q?rccwq49WGPFMfIQxzbuUqyA2jlSYNPNQVdKl6RHwL1jZ6SM8S1DE8mmhQFjd?=
 =?us-ascii?Q?Leum+bfjgLP2g1NFOfuCPjlAJEl97hIfTlDjZEbPV9LYfHaB8FVjdKoxFm7b?=
 =?us-ascii?Q?tHkIsnRa+RRTGbOTZnAW5QXAhr5Z6EzyCnF/Mxca/JZYXMSrrlqoAB9R3TyJ?=
 =?us-ascii?Q?fJ//O2CK9TfTHNvo2fNmwFIxQFIwH0AJI/tQkvXoREBT/n2WuRipGUDyW/GA?=
 =?us-ascii?Q?Zh1Nkj3RwD3iwCJNX/qHhvePWbalZVBTQ7pPNWvb5Xx+s1bElE+wP3nrqKDd?=
 =?us-ascii?Q?F/GO3yACVaepJCwRbsPc7dE0yoTs7mV0vmYZgZfk5F29XQ6hcGV6vcGBypHN?=
 =?us-ascii?Q?of9e/SWNWpWvdpSii2OV873q/qlxgwtJbN4n1QEXuk1/srFCuDR8j6EusdS9?=
 =?us-ascii?Q?erXgL2Ulag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abcf5a2-b946-42f0-2f11-08da4d5097d5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB5744.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:22:56.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24GY/AVEoElhBBcXo2jk56lk5DU2SgL2gQGkI4coACPXRarLvZKoFYWJ2VWwcIGC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_1CE0925E-B4FF-407D-AE4B-20DBE557C614_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Xianting,

Thanks for your patch.

On 13 Jun 2022, at 9:10, Xianting Tian wrote:

> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its m=
igratetype.")
> added buddy check code. But unfortunately, this fix isn't backported to=

> linux-5.17.y and the former stable branches. The reason is it added wro=
ng
> fixes message:
>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackab=
le
> 			   pageblocks with others")

No, the Fixes tag is right. The commit above does need to validate buddy.=


> Actually, this issue is involved by commit:
>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between isola=
ted and other pageblocks")
>
> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is =
512,
> but it got buddy PFN 0 for PFN 0x2000:
>      0 =3D 0x2000 ^ (1 << 12)
> With the illegal buddy PFN 0, it got an illegal buddy page, which cause=
d
> crash in __get_pfnblock_flags_mask().

It seems that the RISC-V arch reveals a similar bug from d9dddbf55667.
Basically, this bug will only happen when PFN=3D0x2000 is merging up and
there are some isolated pageblocks.

BTW, what does first reserved 2MB imply? All 4KB pages from first 2MB are=

set to PageReserved?

>
> With the patch, it can avoid the calling of get_pageblock_migratetype()=
 if
> it isn't buddy page.

You might miss the __find_buddy_pfn() caller in unset_migratetype_isolate=
()
from mm/page_isolation.c, if you are talking about linux-5.17.y and forme=
r
version. There, page_is_buddy() is also not called and is_migrate_isolate=
_page()
is called, which calls get_pageblock_migratetype() too.

>
> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated a=
nd other pageblocks")
> Cc: stable@vger.kernel.org
> Reported-by: zjb194813@alibaba-inc.com
> Reported-by: tianhu.hh@alibaba-inc.com
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  mm/page_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b1caa1c6c887..5b423caa68fd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *p=
age,
>
>  			buddy_pfn =3D __find_buddy_pfn(pfn, order);
>  			buddy =3D page + (buddy_pfn - pfn);
> +
> +			if (!page_is_buddy(page, buddy, order))
> +				goto done_merging;
>  			buddy_mt =3D get_pageblock_migratetype(buddy);
>
>  			if (migratetype !=3D buddy_mt
> -- =

> 2.17.1

--
Best Regards,
Yan, Zi
--=_MailMate_1CE0925E-B4FF-407D-AE4B-20DBE557C614_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmKnVk4PHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhURRYQAIpv3JXGEvCl33BmpJY2qRrIPwHBwPfiKTko
FiU0ddUF2Tj14mmyNHQ2IgkhrshWuuCfPNyfAFtC7yW08Nzl5hncqsmOVQH+sIwK
lmGnwgu/qTRwwer86SFItFdPDT3EMxKj79dcCnv5MRjPmoiy20vGDxHs5PTDbd6V
g9/KoQ+jzGrBfwgairhibJ5zK3pnjqTkzdc4rWXLiKqgQNCt5bCZXDhJFTMRbCUL
dzauu5SjFWh2d7V/PUbxRP+sfakLmeY3qxQn4cuWzpTvgVn/Nw0AkI+eSwjHr6Fe
BE+KSl2KwSOAU09rkPYiXg5TW1RjCPpV+KPfuX+myakEQqfZrwxdL58W+SwVImMT
5SSzshgKZRvSStarwtpuqwwua9Egdi825r9r+pwZndJdLvBgBGQxA8sJ+zfMwSQo
WsVoYtOT1O7fA4omtQWmkSbpQD/y9z7BhAyv9WUXCrBeFGgZ3bT/Vh0QWMrUS2Lk
vj7iaK+cgwLqsAaUsgEv9sLnAlTy5DFOBbSJsAR5UkK3iY3L+B7hFRrzn6Qb/YIq
bJtXHW9j/KiV+hbGJzkHXb1mU+9fOJtTfkBsR+j3AgvDrH6HVhoFOTOEkEUHaPBo
a2t4y7/Ff/Bnw9PmxBLbDxAaGl5+RpUELrx1RPBL7kq9gMLbkmHuA0VGGH3oCiFD
50Y40rrJ
=LY47
-----END PGP SIGNATURE-----

--=_MailMate_1CE0925E-B4FF-407D-AE4B-20DBE557C614_=--
