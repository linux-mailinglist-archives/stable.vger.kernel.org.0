Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE20C31EDF4
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBRSEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:04:55 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3368 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbhBRRly (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:41:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602ea6b00001>; Thu, 18 Feb 2021 09:41:04 -0800
Received: from [10.2.58.214] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 17:40:59 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct
 assumption
Date:   Thu, 18 Feb 2021 12:40:58 -0500
X-Mailer: MailMate (1.14r5757)
Message-ID: <DD0DAFA7-DFD7-4AB7-B89D-CE09F82B04A5@nvidia.com>
In-Reply-To: <20210218173200.GA2643399@ziepe.ca>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
 <19612088-4856-4BE9-A731-BB903511F352@nvidia.com>
 <20210218173200.GA2643399@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_9672FF2B-52FE-4CA2-9097-E065627201D6_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613670064; bh=qWYZkAwpt/HcHkeBf1Pde8huVd2T36KQs23OXt2Oa4M=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=DhirbqqmCN2UHWdzHBUuKlsFuS8lNlq3de9yK6IaF9E2Gcu5ARhMfV+fCmUj/7K4Q
         YQs1kF/W0dbgbuEbDodiUPFq/DQHuLwHZyZuEVZqutMuMdTSWJb0lt0aEQWK+eE+Gr
         apKImC52aPxSLLWjYEWC5WkKxxQGLLZHH9xOjVMhbD/I9AVPM6CwJa5zhMpg51RzZ1
         SyrG/ZmZRjR3V68RAOla7Juk9kz40K79MwFsNDlvdd90oitKcKQ7cJ5eCvM0/2pq6q
         GNuuIPmBFexExW1ojJoEM7PxMGpiMw4yLRUYyWZwPSxuhK2ZNS7Or33z6V6WDw75o1
         DRu8ak1vpr/+g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_9672FF2B-52FE-4CA2-9097-E065627201D6_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 18 Feb 2021, at 12:32, Jason Gunthorpe wrote:

> On Thu, Feb 18, 2021 at 12:27:58PM -0500, Zi Yan wrote:
>> On 18 Feb 2021, at 12:25, Jason Gunthorpe wrote:
>>
>>> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>>>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracl=
e.com> wrote:
>>>>>> page structs are not guaranteed to be contiguous for gigantic page=
s.  The
>>>>>
>>>>> June 2014.  That's a long lurk time for a bug.  I wonder if some la=
ter
>>>>> commit revealed it.
>>>>
>>>> I would suggest that gigantic pages have not seen much use.  Certain=
ly
>>>> performance with Intel CPUs on benchmarks that I've been involved wi=
th
>>>> showed lower performance with 1GB pages than with 2MB pages until qu=
ite
>>>> recently.
>>>
>>> I suggested in another thread that maybe it is time to consider
>>> dropping this "feature"
>>
>> You mean dropping gigantic page support in hugetlb?
>
> No, I mean dropping support for arches that want to do:
>
>    tail_page !=3D head_page + tail_page_nr
>
> because they can't allocate the required page array either virtually
> or physically contiguously.
>
> It seems like quite a burden on the core mm for a very niche, and
> maybe even non-existant, case.
>
> It was originally done for PPC, can these PPC systems use VMEMMAP now?
>
>>> The cost to fix GUP to be compatible with this will hurt normal
>>> GUP performance - and again, that nobody has hit this bug in GUP
>>> further suggests the feature isn't used..
>>
>> A easy fix might be to make gigantic hugetlb page depends on
>> CONFIG_SPARSEMEM_VMEMMAP, which guarantee all struct pages are contigu=
ous.
>
> Yes, exactly.

I actually have a question on CONFIG_SPARSEMEM_VMEMMAP. Can we assume
PFN_A - PFN_B =3D=3D struct_page_A - struct_page_B, meaning all struct pa=
ges
are ordered based on physical addresses? I just wonder for two PFN ranges=
,
e.g., [0 - 128MB], [128MB - 256MB], if it is possible to first online
[128MB - 256MB] then [0 - 128MB] and the struct pages of [128MB - 256MB]
are in front of [0 - 128MB] in the vmemmap due to online ordering.


=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_9672FF2B-52FE-4CA2-9097-E065627201D6_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmAupqoPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKfTEP/24G+3DlCRGKIQ6Z6pFwpTnIeGiEsfOlpmoh
Z839+9t3dqyyxmPurnIA9p6bRqA0rSi50GM/S89WZCTu3bE9foYuFIfH4mO9hEih
k5oTbYN1ZeqgGb6AcnW66oNQMWG/XaCnwXbUMZHZQFJpv6S/6faKQr3BhqXPxRvp
lTfU4FTXmuRkbLudu1wShDs1Vfyp2gJYipQ+pRFQ7bB+NDlcltgbc4OYPxCE6Z6L
9BdDccewpeT1vxTethwaRviv+ODykQiXmeOw96QZC4Whetq4R1mBm38bC7qDiluQ
Rwrm95x/JR1zVfL28MoisrSW/CVOMMv/hUAp1sW8doOc/gVvB/XM2In0t+aqCYCd
MVxsu3IRiRAJhWC0JVHo8eUnrBQj0MMITKUafbwkp5/aZvW3HRTuRlS1Z2hfVeab
ndzuKHcWo6ywHAHnHR+kns/Chmolu3SMvTQURWHWp7c9cO6l8vN6MZAM9wF2qbro
derwXpdthcmAAdyQF/ZNk9fSaRn7ZrIkqIzb9Dz0cu7bUWDLuGQN+NntpAyKr7iD
mrAraPk5xLxpOVUaFtynwHnLziK+0Kmy54SDooRacDT7TYU+7s6t/YDoUFa/qUD0
QDeqSKnuaeFHc+fBq7cjDgyNOsOF5HPL8RvS8rX4oG5PaSpLgYZKZNDXMtvRURPF
AyuyJfXl
=HzBR
-----END PGP SIGNATURE-----

--=_MailMate_9672FF2B-52FE-4CA2-9097-E065627201D6_=--
