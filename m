Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D262C03A1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgKWKrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:47:04 -0500
Received: from foss.arm.com ([217.140.110.172]:41544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728690AbgKWKrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 05:47:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CE96101E;
        Mon, 23 Nov 2020 02:47:03 -0800 (PST)
Received: from [10.57.53.209] (unknown [10.57.53.209])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 649513F70D;
        Mon, 23 Nov 2020 02:47:01 -0800 (PST)
Subject: Re: [PATCH] coresight: tmc-etr: Check if page is valid before
 dma_map_page()
To:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>
Cc:     coresight@lists.linaro.org, Stephen Boyd <swboyd@chromium.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mao Jinlong <jinlmao@codeaurora.org>, stable@vger.kernel.org
References: <20201123102133.18979-1-saiprakash.ranjan@codeaurora.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <ad83c4bd-dc24-c412-c5f7-b51ca1f22588@arm.com>
Date:   Mon, 23 Nov 2020 10:46:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123102133.18979-1-saiprakash.ranjan@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 10:21 AM, Sai Prakash Ranjan wrote:
> From: Mao Jinlong <jinlmao@codeaurora.org>
> 
> alloc_pages_node() return should be checked before calling
> dma_map_page() to make sure that valid page is mapped or
> else it can lead to aborts as below:
> 
>   Unable to handle kernel paging request at virtual address ffffffc008000000
>   Mem abort info:
>   <snip>...
>   pc : __dma_inv_area+0x40/0x58
>   lr : dma_direct_map_page+0xd8/0x1c8
> 
>   Call trace:
>    __dma_inv_area
>    tmc_pages_alloc
>    tmc_alloc_data_pages
>    tmc_alloc_sg_table
>    tmc_init_etr_sg_table
>    tmc_alloc_etr_buf
>    tmc_enable_etr_sink_sysfs
>    tmc_enable_etr_sink
>    coresight_enable_path
>    coresight_enable
>    enable_source_store
>    dev_attr_store
>    sysfs_kf_write
> 
> Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mao Jinlong <jinlmao@codeaurora.org>
> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   drivers/hwtracing/coresight/coresight-tmc-etr.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
> index 525f0ecc129c..a31a4d7ae25e 100644
> --- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
> +++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
> @@ -217,6 +217,8 @@ static int tmc_pages_alloc(struct tmc_pages *tmc_pages,
>   		} else {
>   			page = alloc_pages_node(node,
>   						GFP_KERNEL | __GFP_ZERO, 0);
> +			if (!page)
> +				goto err;
>   		}
>   		paddr = dma_map_page(real_dev, page, 0, PAGE_SIZE, dir);
>   		if (dma_mapping_error(real_dev, paddr))
> 
> base-commit: c04e5d7bbf6f92a346d6b36770705e7f034df42d
> 

