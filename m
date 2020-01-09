Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2533A135B7A
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 15:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgAIOgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 09:36:19 -0500
Received: from foss.arm.com ([217.140.110.172]:60230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731697AbgAIOgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 09:36:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F6E8328;
        Thu,  9 Jan 2020 06:36:19 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4253F3F534;
        Thu,  9 Jan 2020 06:36:18 -0800 (PST)
Subject: Re: [stable] [PATCH 1/2] coresight: etb10: Do not call
 smp_processor_id from preemptible
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mathieu.poirier@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <20200108110541.318672-1-suzuki.poulose@arm.com>
 <20200109143537.GE1706@sasha-vm>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <a183da32-b933-6ed0-f8b8-703e27d3f15e@arm.com>
Date:   Thu, 9 Jan 2020 14:36:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109143537.GE1706@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/01/2020 14:35, Sasha Levin wrote:
> On Wed, Jan 08, 2020 at 11:05:40AM +0000, Suzuki K Poulose wrote:
>> [ Upstream commit 730766bae3280a25d40ea76a53dc6342e84e6513 ]
>>
>> During a perf session we try to allocate buffers on the "node" associated
>> with the CPU the event is bound to. If it is not bound to a CPU, we
>> use the current CPU node, using smp_processor_id(). However this is 
>> unsafe
>> in a pre-emptible context and could generate the splats as below :
>>
>> BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
>>
>> Use NUMA_NO_NODE hint instead of using the current node for events
>> not bound to CPUs.
>>
>> Fixes: 2997aa4063d97fdb39 ("coresight: etb10: implementing AUX API")
>> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: stable <stable@vger.kernel.org> # v4.9 to v4.19
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Link: 
>> https://lore.kernel.org/r/20190620221237.3536-5-mathieu.poirier@linaro.org 
>>
> 
> I've queued this for 4.9-4.19. There was a simple conflict on 4.9 which
> also had to be resolved.
> 


Thanks Sasha !

Suzuki
