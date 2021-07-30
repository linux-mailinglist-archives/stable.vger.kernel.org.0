Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10933DB42A
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 09:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbhG3HES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 03:04:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13215 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbhG3HEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 03:04:13 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GbdX03z0yz1CQdl;
        Fri, 30 Jul 2021 14:58:08 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 15:04:06 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 15:04:05 +0800
Subject: Re: [PATCH v2] lib: Use PFN_PHYS() in devmem_is_allowed()
To:     Liang Wang <wangliang101@huawei.com>, <palmerdabbelt@google.com>,
        <mcgrof@kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <stable@vger.kernel.org>, <wangle6@huawei.com>,
        <kepler.chenxin@huawei.com>, <nixiaoming@huawei.com>
References: <20210730064915.56249-1-wangliang101@huawei.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <12e37243-0cdb-6765-c3ef-c98fd291591c@huawei.com>
Date:   Fri, 30 Jul 2021 15:04:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210730064915.56249-1-wangliang101@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/7/30 14:49, Liang Wang wrote:
> The physical address may exceed 32 bits on ARM(when ARM_LPAE enabled),
> use PFN_PHYS() in devmem_is_allowed(), or the physical address may
> overflow and be truncated.
>
> This bug was initially introduced from v2.6.37, and the function was moved
> to lib when v5.10.
>
> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
> Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
> Cc: stable@vger.kernel.org # v2.6.37
> Signed-off-by: Liang Wang <wangliang101@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v2: update subject and changelog
>   lib/devmem_is_allowed.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/devmem_is_allowed.c b/lib/devmem_is_allowed.c
> index c0d67c541849..60be9e24bd57 100644
> --- a/lib/devmem_is_allowed.c
> +++ b/lib/devmem_is_allowed.c
> @@ -19,7 +19,7 @@
>    */
>   int devmem_is_allowed(unsigned long pfn)
>   {
> -	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
> +	if (iomem_is_exclusive(PFN_PHYS(pfn)))
>   		return 0;
>   	if (!page_is_ram(pfn))
>   		return 1;
