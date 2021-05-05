Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB27F373808
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 11:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhEEJsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 05:48:47 -0400
Received: from foss.arm.com ([217.140.110.172]:41622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhEEJsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 05:48:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6071D6E;
        Wed,  5 May 2021 02:47:50 -0700 (PDT)
Received: from [10.57.61.145] (unknown [10.57.61.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1652A3F70D;
        Wed,  5 May 2021 02:47:48 -0700 (PDT)
Subject: Re: [PATCH] coresight: tmc-etf: Fix global-out-of-bounds in
 tmc_update_etf_buffer()
To:     Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>
Cc:     coresight@lists.linaro.org, Stephen Boyd <swboyd@chromium.org>,
        Denis Nikitin <denik@chromium.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
References: <20210505093430.18445-1-saiprakash.ranjan@codeaurora.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <8e0dbf24-af71-9bce-b615-ce7b1d12a720@arm.com>
Date:   Wed, 5 May 2021 10:47:47 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210505093430.18445-1-saiprakash.ranjan@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/05/2021 10:34, Sai Prakash Ranjan wrote:
> commit 6f755e85c332 ("coresight: Add helper for inserting synchronization
> packets") removed trailing '\0' from barrier_pkt array and updated the
> call sites like etb_update_buffer() to have proper checks for barrier_pkt
> size before read but missed updating tmc_update_etf_buffer() which still
> reads barrier_pkt past the array size resulting in KASAN out-of-bounds
> bug. Fix this by adding a check for barrier_pkt size before accessing
> like it is done in etb_update_buffer().
> 
>   BUG: KASAN: global-out-of-bounds in tmc_update_etf_buffer+0x4b8/0x698
>   Read of size 4 at addr ffffffd05b7d1030 by task perf/2629
> 
>   Call trace:
>    dump_backtrace+0x0/0x27c
>    show_stack+0x20/0x2c
>    dump_stack+0x11c/0x188
>    print_address_description+0x3c/0x4a4
>    __kasan_report+0x140/0x164
>    kasan_report+0x10/0x18
>    __asan_report_load4_noabort+0x1c/0x24
>    tmc_update_etf_buffer+0x4b8/0x698
>    etm_event_stop+0x248/0x2d8
>    etm_event_del+0x20/0x2c
>    event_sched_out+0x214/0x6f0
>    group_sched_out+0xd0/0x270
>    ctx_sched_out+0x2ec/0x518
>    __perf_event_task_sched_out+0x4fc/0xe6c
>    __schedule+0x1094/0x16a0
>    preempt_schedule_irq+0x88/0x170
>    arm64_preempt_schedule_irq+0xf0/0x18c
>    el1_irq+0xe8/0x180
>    perf_event_exec+0x4d8/0x56c
>    setup_new_exec+0x204/0x400
>    load_elf_binary+0x72c/0x18c0
>    search_binary_handler+0x13c/0x420
>    load_script+0x500/0x6c4
>    search_binary_handler+0x13c/0x420
>    exec_binprm+0x118/0x654
>    __do_execve_file+0x77c/0xba4
>    __arm64_compat_sys_execve+0x98/0xac
>    el0_svc_common+0x1f8/0x5e0
>    el0_svc_compat_handler+0x84/0xb0
>    el0_svc_compat+0x10/0x50
> 
>   The buggy address belongs to the variable:
>    barrier_pkt+0x10/0x40
> 
>   Memory state around the buggy address:
>    ffffffd05b7d0f00: fa fa fa fa 04 fa fa fa fa fa fa fa 00 00 00 00
>    ffffffd05b7d0f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   >ffffffd05b7d1000: 00 00 00 00 00 00 fa fa fa fa fa fa 00 00 00 03
>                                        ^
>    ffffffd05b7d1080: fa fa fa fa 00 02 fa fa fa fa fa fa 03 fa fa fa
>    ffffffd05b7d1100: fa fa fa fa 00 00 00 00 05 fa fa fa fa fa fa fa
>   ==================================================================
> 
> Fixes: 6f755e85c332 ("coresight: Add helper for inserting synchronization packets")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
> ---
>   drivers/hwtracing/coresight/coresight-tmc-etf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> index 45b85edfc690..cd0fb7bfba68 100644
> --- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
> +++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> @@ -530,7 +530,7 @@ static unsigned long tmc_update_etf_buffer(struct coresight_device *csdev,
>   		buf_ptr = buf->data_pages[cur] + offset;
>   		*buf_ptr = readl_relaxed(drvdata->base + TMC_RRD);
>   
> -		if (lost && *barrier) {
> +		if (lost && i < CORESIGHT_BARRIER_PKT_SIZE) {
>   			*buf_ptr = *barrier;
>   			barrier++;
>   		}
> 

Thanks for the fix. I will queue this one after rc1

Thanks
Suzuki

