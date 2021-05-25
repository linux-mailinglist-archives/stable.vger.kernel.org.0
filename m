Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC2439004C
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhEYLt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:49:29 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47497 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231641AbhEYLt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 07:49:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621943279; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cwlGGBa1zEHucF6VP8Uur73PV/ShkGQin2rJxDn38o0=;
 b=gYfwB2eRqzjjXxLjHuwlvffHAlLEZg8r1q9yTAdHddy/up8J0+88qb0ottNsvBFUTnsP5c5e
 FdGqad5cYAc7a5Y4UYL8HrlFaXdW6JblY4elF4xaIxsNs2yKchfZ7jLwsbZkjjwB++BfgsQd
 7XtC6CystkP8kptvWtP2MhYsLSM=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60ace3e8c229adfeff00de80 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 May 2021 11:47:52
 GMT
Sender: saiprakash.ranjan=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46949C43460; Tue, 25 May 2021 11:47:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: saiprakash.ranjan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 451E6C433D3;
        Tue, 25 May 2021 11:47:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 25 May 2021 17:17:51 +0530
From:   Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>, coresight@lists.linaro.org,
        Stephen Boyd <swboyd@chromium.org>,
        Denis Nikitin <denik@chromium.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] coresight: tmc-etf: Fix global-out-of-bounds in
 tmc_update_etf_buffer()
In-Reply-To: <dc18845a-73bf-9cbf-6749-6271dcaac9e8@arm.com>
References: <20210505093430.18445-1-saiprakash.ranjan@codeaurora.org>
 <8e0dbf24-af71-9bce-b615-ce7b1d12a720@arm.com>
 <dc18845a-73bf-9cbf-6749-6271dcaac9e8@arm.com>
Message-ID: <ee7abbb2cfebf982addec0a4a18d9512@codeaurora.org>
X-Sender: saiprakash.ranjan@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-05-25 14:24, Suzuki K Poulose wrote:
> Hi Sai
> 
> On 05/05/2021 10:47, Suzuki K Poulose wrote:
>> On 05/05/2021 10:34, Sai Prakash Ranjan wrote:
>>> commit 6f755e85c332 ("coresight: Add helper for inserting 
>>> synchronization
>>> packets") removed trailing '\0' from barrier_pkt array and updated 
>>> the
>>> call sites like etb_update_buffer() to have proper checks for 
>>> barrier_pkt
>>> size before read but missed updating tmc_update_etf_buffer() which 
>>> still
>>> reads barrier_pkt past the array size resulting in KASAN 
>>> out-of-bounds
>>> bug. Fix this by adding a check for barrier_pkt size before accessing
>>> like it is done in etb_update_buffer().
>>> 
>>>   BUG: KASAN: global-out-of-bounds in 
>>> tmc_update_etf_buffer+0x4b8/0x698
>>>   Read of size 4 at addr ffffffd05b7d1030 by task perf/2629
>>> 
>>>   Call trace:
>>>    dump_backtrace+0x0/0x27c
>>>    show_stack+0x20/0x2c
>>>    dump_stack+0x11c/0x188
>>>    print_address_description+0x3c/0x4a4
>>>    __kasan_report+0x140/0x164
>>>    kasan_report+0x10/0x18
>>>    __asan_report_load4_noabort+0x1c/0x24
>>>    tmc_update_etf_buffer+0x4b8/0x698
>>>    etm_event_stop+0x248/0x2d8
>>>    etm_event_del+0x20/0x2c
>>>    event_sched_out+0x214/0x6f0
>>>    group_sched_out+0xd0/0x270
>>>    ctx_sched_out+0x2ec/0x518
>>>    __perf_event_task_sched_out+0x4fc/0xe6c
>>>    __schedule+0x1094/0x16a0
>>>    preempt_schedule_irq+0x88/0x170
>>>    arm64_preempt_schedule_irq+0xf0/0x18c
>>>    el1_irq+0xe8/0x180
>>>    perf_event_exec+0x4d8/0x56c
>>>    setup_new_exec+0x204/0x400
>>>    load_elf_binary+0x72c/0x18c0
>>>    search_binary_handler+0x13c/0x420
>>>    load_script+0x500/0x6c4
>>>    search_binary_handler+0x13c/0x420
>>>    exec_binprm+0x118/0x654
>>>    __do_execve_file+0x77c/0xba4
>>>    __arm64_compat_sys_execve+0x98/0xac
>>>    el0_svc_common+0x1f8/0x5e0
>>>    el0_svc_compat_handler+0x84/0xb0
>>>    el0_svc_compat+0x10/0x50
>>> 
>>>   The buggy address belongs to the variable:
>>>    barrier_pkt+0x10/0x40
>>> 
>>>   Memory state around the buggy address:
>>>    ffffffd05b7d0f00: fa fa fa fa 04 fa fa fa fa fa fa fa 00 00 00 00
>>>    ffffffd05b7d0f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>>   >ffffffd05b7d1000: 00 00 00 00 00 00 fa fa fa fa fa fa 00 00 00 03
>>>                                        ^
>>>    ffffffd05b7d1080: fa fa fa fa 00 02 fa fa fa fa fa fa 03 fa fa fa
>>>    ffffffd05b7d1100: fa fa fa fa 00 00 00 00 05 fa fa fa fa fa fa fa
>>>   ==================================================================
>>> 
>>> Fixes: 6f755e85c332 ("coresight: Add helper for inserting 
>>> synchronization packets")
> 
> I have changed the commit to :
> 
> Fixes: 0c3fc4d5fa26 ("coresight: Add barrier packet for 
> synchronisation")
> 
> Applied.
> 

Sure, thanks Suzuki.

Regards,
Sai

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
