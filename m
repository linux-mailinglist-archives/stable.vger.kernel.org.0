Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFBB957F12
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 11:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0JQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 05:16:20 -0400
Received: from foss.arm.com ([217.140.110.172]:49784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0JQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 05:16:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D4DA2B;
        Thu, 27 Jun 2019 02:16:19 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C58C3F718;
        Thu, 27 Jun 2019 02:16:18 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] coresight: etm4x: use explicit barriers on
 enable/disable
To:     andrew.murray@arm.com, mathieu.poirier@linaro.org,
        alexander.shishkin@linux.intel.com
Cc:     linux-arm-kernel@lists.infradead.org, mike.leach@linaro.org,
        Sudeep.Holla@arm.com, coresight@lists.linaro.org,
        stable@vger.kernel.org
References: <20190627083525.37463-1-andrew.murray@arm.com>
 <20190627083525.37463-3-andrew.murray@arm.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <adf74525-faa7-0fd6-7ea9-6377e782b4b6@arm.com>
Date:   Thu, 27 Jun 2019 10:16:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190627083525.37463-3-andrew.murray@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On 27/06/2019 09:35, Andrew Murray wrote:
> Synchronization is recommended before disabling the trace registers
> to prevent any start or stop points being speculative at the point
> of disabling the unit (section 7.3.77 of ARM IHI 0064D).
> 
> Synchronization is also recommended after programming the trace
> registers to ensure all updates are committed prior to normal code
> resuming (section 4.3.7 of ARM IHI 0064D).
> 
> Let's ensure these syncronization points are present in the code
> and clearly commented.

Please could you also mention why we switched from mb() ?

> 
> Note that we could rely on the barriers in CS_LOCK and
> coresight_disclaim_device_unlocked or the context switch to user
> space - however coresight may be of use in the kernel.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> CC: stable@vger.kernel.org



> ---
>   drivers/hwtracing/coresight/coresight-etm4x.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
> index c89190d464ab..68e8e3954cef 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.c
> @@ -188,6 +188,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
>   		dev_err(etm_dev,
>   			"timeout while waiting for Idle Trace Status\n");
>   
> +	/* As recommended by 4.3.7 of ARM IHI 0064D */

nit: It would be good to mention the "section name" to help the reader
find the same on a different version of the document. Also within the same
version, this is listed in the subsection:
"Synchronization when using the memory-mapped interface"

Please could you update the comment to reflect the same ?

> +	dsb(sy);
> +	isb();
> +
>   done:
>   	CS_LOCK(drvdata->base);
>   
> @@ -454,7 +458,8 @@ static void etm4_disable_hw(void *info)
>   	control &= ~0x1;
>   
>   	/* make sure everything completes before disabling */
> -	mb();
> +	/* As recommended by 7.3.77 of ARM IHI 0064D */

Nit: This refers to completely unrelated section. Shouldn't this be the same
as above ?

With the above fixed:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
