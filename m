Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCBF133FD1
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgAHLBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 06:01:43 -0500
Received: from foss.arm.com ([217.140.110.172]:42322 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgAHLBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 06:01:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AABF830E;
        Wed,  8 Jan 2020 03:01:42 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 073603F703;
        Wed,  8 Jan 2020 03:01:41 -0800 (PST)
Subject: Re: [PATCH 4.19 103/115] coresight: etb10: Do not call
 smp_processor_id from preemptible
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200107205240.283674026@linuxfoundation.org>
 <20200107205308.383005810@linuxfoundation.org>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <a3f27cf7-f3dc-7829-873b-591a91d8a28a@arm.com>
Date:   Wed, 8 Jan 2020 11:01:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107205308.383005810@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,

On 07/01/2020 20:55, Greg Kroah-Hartman wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit 730766bae3280a25d40ea76a53dc6342e84e6513 ]
> 
> During a perf session we try to allocate buffers on the "node" associated
> with the CPU the event is bound to. If it is not bound to a CPU, we
> use the current CPU node, using smp_processor_id(). However this is unsafe
> in a pre-emptible context and could generate the splats as below :
> 

>   BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
> 
> Use NUMA_NO_NODE hint instead of using the current node for events
> not bound to CPUs.
> 
> Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: stable <stable@vger.kernel.org> # 4.6+
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Link: https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/hwtracing/coresight/coresight-etb10.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etb10.c b/drivers/hwtracing/coresight/coresight-etb10.c
> index 0dad8626bcfb..0a59bf3af40b 100644
> --- a/drivers/hwtracing/coresight/coresight-etb10.c
> +++ b/drivers/hwtracing/coresight/coresight-etb10.c
> @@ -275,9 +275,7 @@ static void *etb_alloc_buffer(struct coresight_device *csdev, int cpu,
>   	int node;
>   	struct cs_buffers *buf;
>   
> -	if (cpu == -1)
> -		cpu = smp_processor_id();
> -	node = cpu_to_node(cpu);
> +	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);

Please drop this patch too, from the list as it will break the build
with undefined "event" variable. I will post a backport soon.

Suzuki
