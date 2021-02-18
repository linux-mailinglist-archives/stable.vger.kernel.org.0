Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5015431EDF1
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBRSEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:04:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1455 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhBRR2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 12:28:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602ea3a40006>; Thu, 18 Feb 2021 09:28:04 -0800
Received: from [10.2.58.214] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 17:27:59 +0000
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
Date:   Thu, 18 Feb 2021 12:27:58 -0500
X-Mailer: MailMate (1.14r5757)
Message-ID: <19612088-4856-4BE9-A731-BB903511F352@nvidia.com>
In-Reply-To: <20210218172500.GA4718@ziepe.ca>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
 <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
 <20210218144554.GS2858050@casper.infradead.org>
 <20210218172500.GA4718@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_558FA73B-66C7-4EF3-8577-3AD3907969DF_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613669284; bh=9i8X4BkS+6JMlt9uLwPOgCZEdNoO9x5NgxB0zDcM9zU=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=OdmCK3vPYH0iZUNtOEgsO9l1n48Eh99gQAK6DBapsxOS2PCsZNKmsmbicg7JXpMJg
         eB6zvlgh1jHO0etZ9npkgt5MX2ooUL7+FPl9mBYwD0T1QafkyWzi66oiSfnNqDNUI8
         elekzQ80xiRQHhImZHr9Khol9CQV1iuvF2xZ41Zo6muOl5p5lO8gQLznIsrgB8zLTh
         c/ZUJh3eCH8OvwiIr1IKvkT7uEc1IrEWWVT7Y2oxr9QGZhvP6Gfs3He6zRkcX4KmNj
         0E14XYgIQwU4ZUaMaJ4dvI7nmVjrUu6aIP4VPFFXydATrnXdYsO7UTBPKtedsbKlcZ
         RrUvobJ2HYs/Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_558FA73B-66C7-4EF3-8577-3AD3907969DF_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 18 Feb 2021, at 12:25, Jason Gunthorpe wrote:

> On Thu, Feb 18, 2021 at 02:45:54PM +0000, Matthew Wilcox wrote:
>> On Wed, Feb 17, 2021 at 11:02:52AM -0800, Andrew Morton wrote:
>>> On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.=
com> wrote:
>>>> page structs are not guaranteed to be contiguous for gigantic pages.=
  The
>>>
>>> June 2014.  That's a long lurk time for a bug.  I wonder if some late=
r
>>> commit revealed it.
>>
>> I would suggest that gigantic pages have not seen much use.  Certainly=

>> performance with Intel CPUs on benchmarks that I've been involved with=

>> showed lower performance with 1GB pages than with 2MB pages until quit=
e
>> recently.
>
> I suggested in another thread that maybe it is time to consider
> dropping this "feature"

You mean dropping gigantic page support in hugetlb?

>
> If it has been slightly broken for 7 years it seems a good bet it
> isn't actually being used.
>
> The cost to fix GUP to be compatible with this will hurt normal
> GUP performance - and again, that nobody has hit this bug in GUP
> further suggests the feature isn't used..

A easy fix might be to make gigantic hugetlb page depends on
CONFIG_SPARSEMEM_VMEMMAP, which guarantee all struct pages are contiguous=
=2E


=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_558FA73B-66C7-4EF3-8577-3AD3907969DF_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAmAuo54PHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqK/24QALC+b77e4YBi0DHXfoLMxqHcTGx4G5nnkWoH
jke0UQcm48KZ1zsNRUGaHLo7USjCjbwysuQEqfwOciYE5DwH5bHANtzqdu+MLd83
uilXzQzBuSG1ePUnFFKJSoEV8j8JQDaz+7wFpvn0ZlHgi7HSVHgMup+/s+uGxluO
5FiiYcwRuBjY3wApNCTc+UT908QwAGwKdY5RIDM6CWrVkYIsq7nobQA9F8JIeQ38
bSsdz043bLAMdd5Z/XZoNEBOhk++XGuzs+2C1WY0ptC0vgH/dCE0Vvoo8KV92u3O
MqKOBx518zeWjgRfvA7NuCn63wqHvhMHwSLiosg5Wa9dJ9Na70U0hX9065WvqU72
294yb7wv6GqidGNl0T97hSlagtmBER1zIYm3nZxsKNL9qCnHljTYvyQv+NFYuZcW
Y1tN5INvJwm5qrVju2YEGvC+8lo9RWKUlf8w6mpY55m6Ru/ERRmj6DesPNRr3pSY
ajbRJmCxaOZg3f3Vhy8l4E0WpJpWHJOH8LCvQ2EAFwhDiELmYB3ZXIqje2Cvzikn
MsD1fCzPKFb4UdcvFLhSt2ry8FboJ/LxLa2nXKWBFsONJe67yEa6TzZdkuBELcMN
pFfaOKb64PlNcarGmpTBkxolKP6/W+1oiZFNRnJoPvln+UArPFL0uu0NqK5B03Lc
aGUrtfH4
=mXEE
-----END PGP SIGNATURE-----

--=_MailMate_558FA73B-66C7-4EF3-8577-3AD3907969DF_=--
