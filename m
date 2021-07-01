Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53CD3B8BE8
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 04:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238584AbhGACLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 22:11:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5947 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbhGACLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 22:11:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GFhPS3Wgtz76Rf;
        Thu,  1 Jul 2021 10:05:16 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 10:08:38 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 10:08:38 +0800
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Bin Meng <bmeng.cn@gmail.com>
CC:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
References: <20210627135117.28641-1-bmeng.cn@gmail.com>
 <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
 <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com>
 <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
 <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <94a92009-ce49-bbe4-794c-0631520e4c3d@huawei.com>
Date:   Thu, 1 Jul 2021 10:08:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/6/30 19:58, Bin Meng wrote:
> On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>>
>>> On 2021/6/28 9:15, Bin Meng wrote:
>>>> On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>>>> Hi， sorry for the mistake，the bug is fixed by
>>>>>
>>>>> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng.wang@huawei.com/
>>>> What are we on the patch you mentioned?
>>>>
>>>> I don't see it applied in the linux/master.
>>>>
>>>> Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
>>>> because 32-bit is broken since v5.12.
>>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/+/c9811e379b211c67ba29fb09d6f644dd44cfcff2
>>>
>>> it's on Palmer' riscv-next.
>> Not sure riscv-next is for which release? This is a regression and
>> should be on 5.13.
>>
>>> Hi Palmer, should I resend or could you help me to add the fixes tag?
> Your patch mixed 2 things (fix plus one feature) together, so it is
> not proper to back port your patch.

"mem=" will change the range of memblock, so the fix part must be included.


>
> Here is my 2 cents:
>
> 1. Drop your patch from riscv-next
> 2. Apply my patch as it is a simple fix to previous commit. This
> allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
> 3. Rebase your patch against mine, and resend v2
>
> Let me know if this makes sense.

It is not a big problem for me, but I have no right abourt riscv-next,

let's wait Palmer's advise.

>
> Regards,
> Bin
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
