Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6229F6FE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 22:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJ2Vhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 17:37:36 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16359 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgJ2Vhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 17:37:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9b34b70000>; Thu, 29 Oct 2020 14:31:35 -0700
Received: from [10.2.173.19] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 29 Oct
 2020 21:31:31 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Yang Shi <shy828301@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/compaction: count pages and stop correctly during page
 isolation.
Date:   Thu, 29 Oct 2020 17:31:28 -0400
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <EC915762-AE2E-4ACB-AB27-E7C95A584A0C@nvidia.com>
In-Reply-To: <CAHbLzkpka7s1DFeXO5dxfGvxZFcTYb9KH0AE_AXuxeFO4q_rtg@mail.gmail.com>
References: <20201029200435.3386066-1-zi.yan@sent.com>
 <CAHbLzkpka7s1DFeXO5dxfGvxZFcTYb9KH0AE_AXuxeFO4q_rtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_E48FB94F-D7BB-40CF-84AB-4F00F503E0BA_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604007095; bh=9ht2UsSGdwrtZKmu61CDCt2PzcmL0GB/I1gfIJxoux8=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=q+Z29RwPkHJ+CN5iOQM7wLYO7vggClhrRlOXbl6MDqZve1cOR7f/HIJxJ+QqCatJL
         boe76OnzwhB/VJeTYtFRrk5Tyo/Qaev+eKGPEr7CX1SUdSXbvPWIRLJOXHCFgPArR9
         0pRKWPcgKW9In3OSj5ZfBLiLzlRbs9Y8ql7teYv3E03ZNGo9gJi8b/fKtS6fZiWotS
         i/ZUoUtr9AK2/9994uwZgsGzgHK/h6iyHDmeFmU/tjItwdbmsNLtXiyOFNqdUdXgU0
         FJmL6vRaxlkYCtg6tVTsm4HxGBvo3b1Fr/9Dn1zrGlSQkKS6cTaqjaehfhPyD+WJEn
         N9UsTnJ8qrkXw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_E48FB94F-D7BB-40CF-84AB-4F00F503E0BA_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 29 Oct 2020, at 17:14, Yang Shi wrote:

> On Thu, Oct 29, 2020 at 1:04 PM Zi Yan <zi.yan@sent.com> wrote:
>>
>> From: Zi Yan <ziy@nvidia.com>
>>
>> In isolate_migratepages_block, when cc->alloc_contig is true, we are
>> able to isolate compound pages, nr_migratepages and nr_isolated did no=
t
>> count compound pages correctly, causing us to isolate more pages than =
we
>> thought. Use thp_nr_pages to count pages. Otherwise, we might be trapp=
ed
>> in too_many_isolated while loop, since the actual isolated pages can g=
o
>> up to COMPACT_CLUSTER_MAX*512=3D16384, where COMPACT_CLUSTER_MAX is 32=
,
>
> Is it that easy to run into? 16384 doesn't seem like too many pages, ju=
st 64MB.

I hit this when I was running oom01 from ltp to test my PUD THP patchset,=
 which
allocates PUD THPs from CMA regions and splits them into PMD THPs due to =
memory
pressure. I am not sure if it is common that in the upstream kernel PMD T=
HPs will
be allocated in CMA regions due to allocation fallback.

>
>> since we stop isolation after cc->nr_migratepages reaches to
>> COMPACT_CLUSTER_MAX.
>>
>> In addition, after we fix the issue above, cc->nr_migratepages could
>> never be equal to COMPACT_CLUSTER_MAX if compound pages are isolated,
>> thus page isolation could not stop as we intended. Change the isolatio=
n
>> stop condition to >=3D.
>
> The fix looks sane to me. Reviewed-by: Yang Shi <shy828301@gmail.com>

Thanks.

>
> Shall you add Fixes tag to commit
> 1da2f328fa643bd72197dfed0c655148af31e4eb? And may cc stable.

Sure.

Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migration =
for CMA allocations=E2=80=9D)

stable cc=E2=80=99ed.

>
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/compaction.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index ee1f8439369e..0683a4999581 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compact_contro=
l *cc, unsigned long low_pfn,
>>
>>  isolate_success:
>>                 list_add(&page->lru, &cc->migratepages);
>> -               cc->nr_migratepages++;
>> -               nr_isolated++;
>> +               cc->nr_migratepages +=3D thp_nr_pages(page);
>> +               nr_isolated +=3D thp_nr_pages(page);
>>
>>                 /*
>>                  * Avoid isolating too much unless this block is being=

>> @@ -1021,7 +1021,7 @@ isolate_migratepages_block(struct compact_contro=
l *cc, unsigned long low_pfn,
>>                  * or a lock is contended. For contention, isolate qui=
ckly to
>>                  * potentially remove one source of contention.
>>                  */
>> -               if (cc->nr_migratepages =3D=3D COMPACT_CLUSTER_MAX &&
>> +               if (cc->nr_migratepages >=3D COMPACT_CLUSTER_MAX &&
>>                     !cc->rescan && !cc->contended) {
>>                         ++low_pfn;
>>                         break;
>> @@ -1132,7 +1132,7 @@ isolate_migratepages_range(struct compact_contro=
l *cc, unsigned long start_pfn,
>>                 if (!pfn)
>>                         break;
>>
>> -               if (cc->nr_migratepages =3D=3D COMPACT_CLUSTER_MAX)
>> +               if (cc->nr_migratepages >=3D COMPACT_CLUSTER_MAX)
>>                         break;
>>         }
>>
>> --
>> 2.28.0
>>
>>


=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_E48FB94F-D7BB-40CF-84AB-4F00F503E0BA_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAl+bNLAPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK7rgP/Rz8YR87KeF/sohMCmYD5ok6r7PE4SoNR+OX
88McrpVRKKHfF5LXSHijoSP2/N+lRT+WcPqcU71sfNKl6nSrN+W0fxL473q2WDv0
MvMBbYAL64ZtyIVQRmehjbmn6CCk0wnE5Ni/c+Ba5p4TOURJn+02weYXAHeFUZ55
1peRto9RkYlD0RiefuhDdn5c3WywXdnu3fwNVq3apkBClggZV1OkvVYyFMaaGsp0
YoMGURsqocZ0dClzDHTfqyXLC9OMbLRdMOfNrf8CBZl4hLlw1KXToX8M89kawl1o
dLQ4GKS1VkhcqmPjcx/Y2lw/qR2+Kk9/5c4X6tdD8XMrEo7QF/oHW3KoPCCMO4s7
Iur1SD/fMWr5MiTRgMu9nMy3GqCo7uL6KYKY/JvzdheQ+qVGY1aSuiBBErdUpn37
JwJLC2RHfi0v+lCIvsorp/ljemo8GkGy1A6jxCc2lUzOHnpQQpHfuxn+ISTTlQE5
+5QlXO/D8oBTTeopCdsBzCAzuaFgnaWU9MlCh8MFplMVPaGDoY7f7PlB1mPBRHV4
MSGzHLgeWC8MbISJEBYS/ALv2rSiLkf4EM5lDwOkqY8C/EKxfgiZn12PgbTRWOC/
GgL3miQ05yKieD6SZOP5EA/tZaS2Loz7amO7+7fbzVLlzh6Qx5TLRnZBXNDkoudL
4QLPIh4P
=E2j7
-----END PGP SIGNATURE-----

--=_MailMate_E48FB94F-D7BB-40CF-84AB-4F00F503E0BA_=--
