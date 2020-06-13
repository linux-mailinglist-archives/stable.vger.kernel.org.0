Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA001F8564
	for <lists+stable@lfdr.de>; Sat, 13 Jun 2020 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgFMVUf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 13 Jun 2020 17:20:35 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:33166 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgFMVUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jun 2020 17:20:35 -0400
Received: from himel (121.253.33.171.ip.orionnet.ru [171.33.253.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPSA id 927FE8217A3;
        Sun, 14 Jun 2020 04:20:27 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Arseny Solokha <asolokha@kb.kras.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Yan <yanaijie@huawei.com>,
        <linuxppc-dev@lists.ozlabs.org>, Scott Wood <oss@buserror.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] powerpc/fsl_booke/32: fix build with CONFIG_RANDOMIZE_BASE
References: <20200613162801.1946619-1-asolokha@kb.kras.ru>
        <754d31be-730b-8f18-4ead-ba2f303650d0@csgroup.eu>
Date:   Sun, 14 Jun 2020 04:20:25 +0700
In-Reply-To: <754d31be-730b-8f18-4ead-ba2f303650d0@csgroup.eu> (Christophe
        Leroy's message of "Sat, 13 Jun 2020 19:28:19 +0200")
Message-ID: <87imfupsrq.fsf@himel>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Le 13/06/2020 à 18:28, Arseny Solokha a écrit :
>> Building the current 5.8 kernel for a e500 machine with
>> CONFIG_RANDOMIZE_BASE set yields the following failure:
>>
>>    arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
>>    arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit declaration
>> of function 'flush_icache_range'; did you mean 'flush_tlb_range'?
>> [-Werror=implicit-function-declaration]
>>
>> Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.
>>
>> The issue dates back to the introduction of that file and probably went
>> unnoticed because there's no in-tree defconfig with CONFIG_RANDOMIZE_BASE
>> set.
>
> I don't get this problem with mpc85xx_defconfig + RELOCATABLE +
> RANDOMIZE_BASE.

Ah, OK. So the critical difference between mpc85xx_defconfig and our custom
config is that the former sets CONFIG_BLOCK while ours doesn't. Then we have the
following dependence chain:

arch/powerpc/mm/nohash/kaslr_booke.c
  include/linux/swap.h
    include/linux/memcontrol.h
      include/linux/writeback.h
        include/linux/blk-cgroup.h
          include/linux/blkdev.h

          #ifdef CONFIG_BLOCK
          #include <linux/pagemap.h>
          #endif

          include/linux/pagemap.h
            include/linux/highmem.h
              arch/powerpc/include/asm/cacheflush.h

and that's how the latter doesn't get included in
arch/powerpc/mm/nohash/kaslr_booke.c, because in our config CONFIG_BLOCK is not
defined in the first place.

Arseny

> Christophe
>
>>
>> Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
>> ---
>>   arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
>> index 4a75f2d9bf0e..bce0e5349978 100644
>> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
>> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/memblock.h>
>>   #include <linux/libfdt.h>
>>   #include <linux/crash_core.h>
>> +#include <asm/cacheflush.h>
>>   #include <asm/pgalloc.h>
>>   #include <asm/prom.h>
>>   #include <asm/kdump.h>
>>
