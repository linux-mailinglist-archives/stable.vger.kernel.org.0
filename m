Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A1F9D4EE
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 19:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfHZRas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 13:30:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2877 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729245AbfHZRar (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 13:30:47 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d6417480002>; Mon, 26 Aug 2019 10:30:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 26 Aug 2019 10:30:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 26 Aug 2019 10:30:47 -0700
Received: from rcampbell-dev.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Aug
 2019 17:30:46 +0000
Subject: Re: [PATCH] mm/migrate: initialize pud_entry in migrate_vma()
To:     Vlastimil Babka <vbabka@suse.cz>, <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20190719233225.12243-1-rcampbell@nvidia.com>
 <0d639edf-9f96-c170-4920-d64c2891d35d@suse.cz>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <dcadcd98-e9b4-2b4e-8a9f-5a1ef0ece0d5@nvidia.com>
Date:   Mon, 26 Aug 2019 10:30:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0d639edf-9f96-c170-4920-d64c2891d35d@suse.cz>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1566840648; bh=wgJD6Csy/s6yr4UYxieJmYbxqUj/d5mbZ6ONdDZ3WhI=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aLr5JbFymgRG9vRzfe1Hbp8+2BZTFtY3t76OzLIP/HV/mKdZMv0dk32Dopf8kv8Mf
         I+2RnPrashuxzsKe5d1FnGYg2LOfele0EkIwTR2oO3orHb0fHC8RLRhxknZ1d0e+b3
         f/2Wvm2zEzppEMeE2AXrz/MKsv40syocN2kkWTJzszN7ZVL6rfKoWD9/eOBb2i2GSL
         JPnrXWl+DT0LO9nYpoKT7pbyVgtEH+5HcMl5VwDXY3V89x4IyZC/HDyVGnNxWVHqu/
         YBuiO2c9y0J7uyZPIzSGUTdodU/os6UGzZXKG3UGaQ7asTj3p4P1KUFOUlX2M+EveK
         ED/Jpu20djarQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/26/19 8:11 AM, Vlastimil Babka wrote:
> On 7/20/19 1:32 AM, Ralph Campbell wrote:
>> When CONFIG_MIGRATE_VMA_HELPER is enabled, migrate_vma() calls
>> migrate_vma_collect() which initializes a struct mm_walk but
>> didn't initialize mm_walk.pud_entry. (Found by code inspection)
>> Use a C structure initialization to make sure it is set to NULL.
>>
>> Fixes: 8763cb45ab967 ("mm/migrate: new memory migration helper for use w=
ith
>> device memory")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>=20
> So this bug can manifest by some garbage address on stack being called, r=
ight? I
> wonder, how comes it didn't actually happen yet?

Right.
Probably because HMM isn't widely being used in production yet.

>=20
>> ---
>>   mm/migrate.c | 17 +++++++----------
>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 515718392b24..a42858d8e00b 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -2340,16 +2340,13 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>   static void migrate_vma_collect(struct migrate_vma *migrate)
>>   {
>>   	struct mmu_notifier_range range;
>> -	struct mm_walk mm_walk;
>> -
>> -	mm_walk.pmd_entry =3D migrate_vma_collect_pmd;
>> -	mm_walk.pte_entry =3D NULL;
>> -	mm_walk.pte_hole =3D migrate_vma_collect_hole;
>> -	mm_walk.hugetlb_entry =3D NULL;
>> -	mm_walk.test_walk =3D NULL;
>> -	mm_walk.vma =3D migrate->vma;
>> -	mm_walk.mm =3D migrate->vma->vm_mm;
>> -	mm_walk.private =3D migrate;
>> +	struct mm_walk mm_walk =3D {
>> +		.pmd_entry =3D migrate_vma_collect_pmd,
>> +		.pte_hole =3D migrate_vma_collect_hole,
>> +		.vma =3D migrate->vma,
>> +		.mm =3D migrate->vma->vm_mm,
>> +		.private =3D migrate,
>> +	};
>>  =20
>>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm_walk.mm=
,
>>   				migrate->start,
>>
>=20
