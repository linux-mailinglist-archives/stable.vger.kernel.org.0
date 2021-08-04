Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D454B3DFAD8
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 07:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhHDFCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 01:02:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7778 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhHDFCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 01:02:02 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GffjL2rbVzYkv6;
        Wed,  4 Aug 2021 13:01:42 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 13:01:48 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 13:01:47 +0800
Subject: Re: [PATCH v3] lib: Use PFN_PHYS() in devmem_is_allowed()
To:     Liang Wang <wangliang101@huawei.com>, <palmerdabbelt@google.com>,
        <mcgrof@kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <stable@vger.kernel.org>, <wangle6@huawei.com>,
        <kepler.chenxin@huawei.com>, <nixiaoming@huawei.com>
References: <20210731025057.78825-1-wangliang101@huawei.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <668986ec-bdc5-482f-39ed-8e059008016d@huawei.com>
Date:   Wed, 4 Aug 2021 13:01:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210731025057.78825-1-wangliang101@huawei.com>
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


On 2021/7/31 10:50, Liang Wang wrote:
> The physical address may exceed 32 bits on 32-bit systems with
> more than 32 bits of physcial address,use PFN_PHYS() in devmem_is_allowed(),
> or the physical address may overflow and be truncated.
> We found this bug when mapping a high addresses through devmem tool,
> when CONFIG_STRICT_DEVMEM is enabled on the ARM with ARM_LPAE and devmem
> is used to map a high address that is not in the iomem address range,
> an unexpected error indicating no permission is returned.
>
> This bug was initially introduced from v2.6.37, and the function was moved
> to lib when v5.11.
>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
> Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
> Cc: stable@vger.kernel.org # v2.6.37
> Signed-off-by: Liang Wang <wangliang101@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
