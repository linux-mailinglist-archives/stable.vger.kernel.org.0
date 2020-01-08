Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17CD133FCD
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgAHLAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:00:39 -0500
Received: from foss.arm.com ([217.140.110.172]:42304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgAHLAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:00:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2868030E;
        Wed,  8 Jan 2020 03:00:39 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76E0C3F703;
        Wed,  8 Jan 2020 03:00:38 -0800 (PST)
Subject: Re: [PATCH 4.19 102/115] coresight: tmc-etf: Do not call
 smp_processor_id from preemptible
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200107205240.283674026@linuxfoundation.org>
 <20200107205308.269793829@linuxfoundation.org>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <a4c7d0ef-41c5-4c77-6f45-1cc5d153a5c9@arm.com>
Date:   Wed, 8 Jan 2020 11:00:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107205308.269793829@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/01/2020 20:55, Greg Kroah-Hartman wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit 024c1fd9dbcc1d8a847f1311f999d35783921b7f ]
> 
> During a perf session we try to allocate buffers on the "node" associated
> with the CPU the event is bound to. If it is not bound to a CPU, we
> use the current CPU node, using smp_processor_id(). However this is unsafe
> in a pre-emptible context and could generate the splats as below :
> 
>   BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
>   caller is tmc_alloc_etf_buffer+0x5c/0x60

> Fixes: 2e499bbc1a929ac ("coresight: tmc: implementing TMC-ETF AUX space API")
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: stable <stable@vger.kernel.org> # 4.7+
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20190620221237.3536-4-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/hwtracing/coresight/coresight-tmc-etf.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> index e31061308e19..4644ac5582cf 100644
> --- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
> +++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
> @@ -304,9 +304,7 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev, int cpu,
>   	int node;
>   	struct cs_buffers *buf;
>   
> -	if (cpu == -1)
> -		cpu = smp_processor_id();
> -	node = cpu_to_node(cpu);
> +	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);

This will break the build on v4.19 to v4.9 as event was not available to
the routine. So please drop this one for now. I will post a backport
separately.

Suzuki
