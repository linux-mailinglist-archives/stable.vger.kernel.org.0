Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D985131EFAF
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhBRTVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13219 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhBRSu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 13:50:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602eb6e70001>; Thu, 18 Feb 2021 10:50:16 -0800
Received: from [10.2.58.214] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 18:50:10 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
Date:   Thu, 18 Feb 2021 13:50:08 -0500
X-Mailer: MailMate (1.14r5757)
Message-ID: <5228DB96-045E-450C-97E9-43DFCB905C79@nvidia.com>
In-Reply-To: <8722e295-43b1-95e9-9420-025e552e37f4@oracle.com>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
 <19612088-4856-4BE9-A731-BB903511F352@nvidia.com>
 <20210218173200.GA2643399@ziepe.ca>
 <DD0DAFA7-DFD7-4AB7-B89D-CE09F82B04A5@nvidia.com>
 <8722e295-43b1-95e9-9420-025e552e37f4@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_B55AD31F-576B-4A75-9372-98B6137F20A4_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613674216; bh=f5hvomHmAdLJdx+MKO4Il1bouoKEa2Lah7+OFibT5mQ=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=hyVHETiyQY275mrdx3fDlwRzIA/Qe0Xvfs3Xzp/+VVapsAyw1NaGDpOW5RWMvigPQ
         9cfTZoZSsGxW92duCknj+z8xlTj/pNamRb2099Uv5HsRC6FWIanUtE8CJDr/athrCe
         oMRiS9L2S6gyi4qCXoviHnTQl5+ZnhWjZOm3GNO71mknENjvp/jWSmk56++KUVrg0Q
         y/JTPIW/mhzy/FDGUig69ukLGttqMRSZUarFo+u6TshLSGFcwUS1lLiohfXdHZcFts
         n8M5aJ6C15Zx84iHeg63JiNY1AFfBhhOWVJDASMA5jtADpruhCjemtLL7bF7aAmWQN
         B0Udh05Gdd7eQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_B55AD31F-576B-4A75-9372-98B6137F20A4_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 18 Feb 2021, at 12:51, Mike Kravetz wrote:

> On 2/18/21 9:40 AM, Zi Yan wrote:
>> On 18 Feb 2021, at 12:32, Jason Gunthorpe wrote:
>>
>>> On Thu, Feb 18, 2021 at 12:27:58PM -0500, Zi Yan wrote:
>>>> On 18 Feb 2021, at 12:25, Jason Gunthorpe wrote:
>>>>
>>>>> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>>>>>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>>>>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@ora=
cle.com> wrote:
>>>>>>>> page structs are not guaranteed to be contiguous for gigantic pa=
ges.  The
>>>>>>>
>>>>>>> June 2014.  That's a long lurk time for a bug.  I wonder if some =
later
>>>>>>> commit revealed it.
>>>>>>
>>>>>> I would suggest that gigantic pages have not seen much use.  Certa=
inly
>>>>>> performance with Intel CPUs on benchmarks that I've been involved =
with
>>>>>> showed lower performance with 1GB pages than with 2MB pages until =
quite
>>>>>> recently.
>>>>>
>>>>> I suggested in another thread that maybe it is time to consider
>>>>> dropping this "feature"
>>>>
>>>> You mean dropping gigantic page support in hugetlb?
>>>
>>> No, I mean dropping support for arches that want to do:
>>>
>>>    tail_page !=3D head_page + tail_page_nr
>>>
>>> because they can't allocate the required page array either virtually
>>> or physically contiguously.
>>>
>>> It seems like quite a burden on the core mm for a very niche, and
>>> maybe even non-existant, case.
>>>
>>> It was originally done for PPC, can these PPC systems use VMEMMAP now=
?
>>>
>>>>> The cost to fix GUP to be compatible with this will hurt normal
>>>>> GUP performance - and again, that nobody has hit this bug in GUP
>>>>> further suggests the feature isn't used..
>>>>
>>>> A easy fix might be to make gigantic hugetlb page depends on
>>>> CONFIG_SPARSEMEM_VMEMMAP, which guarantee all struct pages are conti=
guous.
>>>
>>> Yes, exactly.
>>
>> I actually have a question on CONFIG_SPARSEMEM_VMEMMAP. Can we assume
>> PFN_A - PFN_B =3D=3D struct_page_A - struct_page_B, meaning all struct=
 pages
>> are ordered based on physical addresses? I just wonder for two PFN ran=
ges,
>> e.g., [0 - 128MB], [128MB - 256MB], if it is possible to first online
>> [128MB - 256MB] then [0 - 128MB] and the struct pages of [128MB - 256M=
B]
>> are in front of [0 - 128MB] in the vmemmap due to online ordering.
>
> I have not looked at the code which does the onlining and vmemmap setup=
=2E
> But, these definitions make me believe it is true:
>
> #elif defined(CONFIG_SPARSEMEM_VMEMMAP)
>
> /* memmap is virtually contiguous.  */
> #define __pfn_to_page(pfn)      (vmemmap + (pfn))
> #define __page_to_pfn(page)     (unsigned long)((page) - vmemmap)

Makes sense. Thank you for checking.

I guess making gigantic page depends on CONFIG_SPARSEMEM_VMEMMAP might
be a good way of simplifying code and avoiding future bugs unless
there is an arch really needs gigantic page and cannot have VMEMMAP.

=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_B55AD31F-576B-4A75-9372-98B6137F20A4_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmAutuAPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK/+0P/3wQ76ZanDdOtD/LZ3Ngx+nkzMIluH9/vP+h
P1hsldOiC1TV2hmCCSGJzJUxWf5Zrd2I+JzVjMfZIPTCPTZA5IG7fTBa8UvwGpPB
X1EcJpVnsjy2MDpWQCl4YtTqtLx2BBmRa8aRm1fjMKCwnoabDmF78DTNylNuydjE
Og1FrQf32CWIWvM5+D4T0hYIcSITBp/BEdHLYc1Gd3DQRh+8wtmO2NttR78ISb/6
qRu6BdTMECp+jR7ym+mQoY9ee7Y6DB45hx/xA52jrfqPDjZgRHNaASKUSxmtaaQ1
2iysjWeSXKiuCK8tbgMhlgmKul7whNzYIdNFtVHJGsTBvbd01j/1h4yZ9cidle+m
DnRZtvZ9iRxTAphUcblhPuDzUqTwxHJUXSabwLopsy5IhFHfwqF1+6g9F6f5JJ+6
CBnnqWklaHhN73uDKve/q4aNoH8/oCYBcoXQVXzxqpCq7WSJJha5gyJDluiTrHYI
5a43C1AdocJKj3NdcsO2keNcnLFTrLaLZm9IJ9pjILOhFVll/07lTvga2jwKctsy
UH0W5e/MJjnezht4wr9pAMmoQrwF8yogvwwHk/fC3YxcEn1Jnh7e7k4zmG3YofES
fUqs/n1Q0gQxVqB+BX0u4r55jP15rU8+QyCGx2axmZpKIyRuLft/jYYSSc83IVHd
l+5WOGuE
=4baT
-----END PGP SIGNATURE-----

--=_MailMate_B55AD31F-576B-4A75-9372-98B6137F20A4_=--
