Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91725B648
	for <lists+stable@lfdr.de>; Thu,  3 Sep 2020 00:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBWCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 18:02:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19894 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBWCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 18:02:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5016550000>; Wed, 02 Sep 2020 15:01:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 02 Sep 2020 15:02:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 02 Sep 2020 15:02:44 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 22:02:43 +0000
Subject: Re: [PATCH v2 1/7] mm/thp: fix __split_huge_pmd_locked() for
 migration PMD
To:     Zi Yan <ziy@nvidia.com>
CC:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Alistair Popple" <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ben Skeggs <bskeggs@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>
References: <20200902165830.5367-1-rcampbell@nvidia.com>
 <20200902165830.5367-2-rcampbell@nvidia.com>
 <78B69571-13C6-4BF5-8478-6AAA4AB2C287@nvidia.com>
From:   Ralph Campbell <rcampbell@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <171f31cd-91e5-5c74-a68a-ec7cbd9bb450@nvidia.com>
Date:   Wed, 2 Sep 2020 15:02:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <78B69571-13C6-4BF5-8478-6AAA4AB2C287@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599084117; bh=kkuRtxf1vezbhGt7LWXFhp9w3lxcVmX2TYTJjhJna0A=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=PYlXhRotiQZLfTXQ3wUKaNi2lAIqWGmhDdY0PnXG5Z+lN/QCMYFo0RG5cTDV6WwFH
         CnfNo7aO+sfSX2fI+lJwU6aarLglAM/a5KXmMrCwp2e1o9Baq4M81nd71iUwdUgx//
         uZ/a2+LKxSXP2G1SaaWWxXeK+62Cc8u3wUAa1bnCoMsdwDkTq4p9UjZ7iM9A35rRXq
         JIFyutr6uKQ66rQKeR1y+8M4g0+cnTjIYBu59SdC1oEOjQqwNU4m4C6gP6n5Hhq5ba
         bJJgl8MHVyNQvB3qHhrFcZXNGUdYAp0il6xrP4DrP96t1panNvmqFIm5/Wpc+h4Dk6
         GwYzA74WFlDOQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/2/20 2:47 PM, Zi Yan wrote:
> On 2 Sep 2020, at 12:58, Ralph Campbell wrote:
>=20
>> A migrating transparent huge page has to already be unmapped. Otherwise,
>> the page could be modified while it is being copied to a new page and
>> data could be lost. The function __split_huge_pmd() checks for a PMD
>> migration entry before calling __split_huge_pmd_locked() leading one to
>> think that __split_huge_pmd_locked() can handle splitting a migrating PM=
D.
>> However, the code always increments the page->_mapcount and adjusts the
>> memory control group accounting assuming the page is mapped.
>> Also, if the PMD entry is a migration PMD entry, the call to
>> is_huge_zero_pmd(*pmd) is incorrect because it calls pmd_pfn(pmd) instea=
d
>> of migration_entry_to_pfn(pmd_to_swp_entry(pmd)).
>> Fix these problems by checking for a PMD migration entry.
>>
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>=20
> Thanks for the fix. You can add Reviewed-by: Zi Yan <ziy@nvidia.com>
>=20
> I think you also want to add the Fixes tag and cc stable.
>=20
> Fixes 84c3fc4e9c56 (=E2=80=9Cmm: thp: check pmd migration entry in common=
 path=E2=80=9D)
> cc: stable@vger.kernel.org # 4.14+

Thanks, I'll add these.
