Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C939229FA75
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 02:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJ3BUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 21:20:20 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15554 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3BUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 21:20:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9b6a590000>; Thu, 29 Oct 2020 18:20:25 -0700
Received: from [10.2.173.19] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 01:20:19 +0000
From:   Zi Yan <ziy@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Yang Shi <shy828301@gmail.com>, Linux MM <linux-mm@kvack.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/compaction: count pages and stop correctly during page
 isolation.
Date:   Thu, 29 Oct 2020 21:20:16 -0400
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <7DC14FB8-8DA4-4DB4-BB0B-3409CA8D6DD9@nvidia.com>
In-Reply-To: <20201029172822.da31fa5ab34c3a795361768f@linux-foundation.org>
References: <20201029200435.3386066-1-zi.yan@sent.com>
 <CAHbLzkpka7s1DFeXO5dxfGvxZFcTYb9KH0AE_AXuxeFO4q_rtg@mail.gmail.com>
 <EC915762-AE2E-4ACB-AB27-E7C95A584A0C@nvidia.com>
 <20201029172822.da31fa5ab34c3a795361768f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
        boundary="=_MailMate_F7AF6098-5787-4D04-BE62-9B2642263752_=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604020825; bh=mvZsLVM6tlK6PbjaUtfB4jNu8ApWwcVhlCkzmZmnkzk=;
        h=From:To:CC:Subject:Date:X-Mailer:Message-ID:In-Reply-To:
         References:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=PVbfUvLB+69Tb4HT5qcDP0k+dYwzMNRTqvuiIWEdPmfliK/0EI6jcQ1DTL67sHRTt
         IMZnAeq0hse4NS9cdN3B4CLJhcAnGVaKOSa5hpXcKdwzZc91Fi7qPt8PNIfIBmSPM/
         rvrNbLTnjK9EUYeqpNWGF8djdyrilOya5k0NYz5cxMGPIPsdhDa/xSwUP+YIr+P0H7
         vR+C1SA8quFRODqoU9REMd9m1X59xztMXalWsJYkjemWwSM120HkDMhMZRmjEbZYrA
         7fqca2gBYwixOno0NEJWUx9IBINwzpuZGzTf+MEv44z/OWJq6CoUIKev3Tekl8ZrX2
         K6YeXpD5WfhGA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=_MailMate_F7AF6098-5787-4D04-BE62-9B2642263752_=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 29 Oct 2020, at 20:28, Andrew Morton wrote:

> On Thu, 29 Oct 2020 17:31:28 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>>>
>>> Shall you add Fixes tag to commit
>>> 1da2f328fa643bd72197dfed0c655148af31e4eb? And may cc stable.
>>
>> Sure.
>>
>> Fixes: 1da2f328fa64 (=E2=80=9Cmm,thp,compaction,cma: allow THP migrati=
on for CMA allocations=E2=80=9D)
>>
>> stable cc'ed.
>
> A think a cc:stable really requires a description of the end-user
> visible effects of the bug.  Could you please provide that?

Sure.

For example, in a system with 16GB memory and an 8GB CMA region reserved =
by hugetlb_cma,
if we first allocate 10GB THPs and mlock them (so some THPs are allocated=
 in the CMA
region and mlocked), reserving 6 1GB hugetlb pages via
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages will get stuck =
(looping
in too_many_isolated function) until we kill either task. With the patch =
applied,
oom will kill the application with 10GB THPs and let hugetlb page reserva=
tion finish.

=E2=80=94
Best Regards,
Yan Zi

--=_MailMate_F7AF6098-5787-4D04-BE62-9B2642263752_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEEh7yFAW3gwjwQ4C9anbJR82th+ooFAl+balAPHHppeUBudmlk
aWEuY29tAAoJEJ2yUfNrYfqKM68P/0+QGFqt++5awuTrfb0Lct/UGOPe0oz/k7Qy
uVG1tVaiWcUKjl3qHvt0twOPjslKMzV/CqxJ418XzqnM5w3oMOi5g1WSmABAQyyA
B+4D3D+rpgN5gep7V+DXxbHIecmBXHsmVw0wcCShgQwkO5BYAed3fduPNiSRSYRb
JUVXyBkyzg9mTV1pFXIdXoYrfy/iy8OTUceRUfmUGr/Sjx8tgLuxFx73iGG0kDPK
UZHUi8DZ1BMrOJ6wJb9H1WbFOyIZhsk6BwsvFm/8OinOTuckLo1ikXOXkdDU70fS
tMC8C2HuLLt5UFBpa7XYfDhk2CwlAM1BEtb1z1Q6eeLQnTNUH34wOEDJlRmnwLkO
VBC+B0wKthSWDhaTmqfwxB+Hg2Ve87gKcgSiyjTq8i+MdPQVuXSOY27AApFetQby
Vqt9VJXMzgOnkBnT31L9ITEEz9Ciy29OtA3tZ8cfLTidNlNiPCR7UiNqz7fRKfbh
8oqstMbxl5H6/yXlMRb1ZcIj9KW6xY75pH0TfYo4aVDsggCgXqadUTqk9GIsJTOj
nJETE6WzSdTU17nDFF5gUWsoUZSC6AHbJcpFRnXAjoGdd26rrzaW+H6lShCIL3pZ
2hXBD1vGU9BMV0LSuQQxIzo8LyynzrmfYabUSiUbdI2JesIcvMz/cYlqSeNzEzZF
Oo8hV/Xn
=2Vrc
-----END PGP SIGNATURE-----

--=_MailMate_F7AF6098-5787-4D04-BE62-9B2642263752_=--
