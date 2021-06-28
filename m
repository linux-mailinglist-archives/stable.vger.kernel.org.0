Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6933B566E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 02:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhF1Azn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 20:55:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5800 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhF1Azn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 20:55:43 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GCpqh412zzXlsd;
        Mon, 28 Jun 2021 08:48:00 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 08:53:17 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 08:53:16 +0800
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Bin Meng <bmeng.cn@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     <stable@vger.kernel.org>
References: <20210627135117.28641-1-bmeng.cn@gmail.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
Date:   Mon, 28 Jun 2021 08:53:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210627135117.28641-1-bmeng.cn@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi， sorry for the mistake，the bug is fixed by

https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng.wang@huawei.com/

On 2021/6/27 21:51, Bin Meng wrote:
> Commit dd2d082b5760 ("riscv: Cleanup setup_bootmem()") adjusted
> the calling sequence in setup_bootmem(), which invalidates the fix
> commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
> did for 32-bit RISC-V unfortunately.
>
> So now 32-bit RISC-V does not boot again when testing booting kernel
> on QEMU 'virt' with '-m 2G', which was exactly what the original
> commit de043da0b9e7 ("RISC-V: Fix usage of memblock_enforce_memory_limit")
> tried to fix.
>
> Fixes: dd2d082b5760 ("riscv: Cleanup setup_bootmem()")
> Cc: stable@vger.kernel.org # v5.12+
> Signed-off-by: Bin Meng <bmeng.cn@gmail.com>
> ---
>
>   arch/riscv/mm/init.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 4c4c92ce0bb8..9b23b95c50cf 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -123,7 +123,7 @@ void __init setup_bootmem(void)
>   {
>   	phys_addr_t vmlinux_end = __pa_symbol(&_end);
>   	phys_addr_t vmlinux_start = __pa_symbol(&_start);
> -	phys_addr_t dram_end = memblock_end_of_DRAM();
> +	phys_addr_t dram_end;
>   	phys_addr_t max_mapped_addr = __pa(~(ulong)0);
>   
>   #ifdef CONFIG_XIP_KERNEL
> @@ -146,6 +146,8 @@ void __init setup_bootmem(void)
>   #endif
>   	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
>   
> +	dram_end = memblock_end_of_DRAM();
> +
>   	/*
>   	 * memblock allocator is not aware of the fact that last 4K bytes of
>   	 * the addressable memory can not be mapped because of IS_ERR_VALUE
