Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D6E4A886D
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348934AbiBCQOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbiBCQOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:14:45 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C4CC06173B
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:14:45 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq9-20020a17090af98900b001b8262fe2d5so4237246pjb.0
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 08:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wwptH0NwA9F4hOq9blkkboSBFwlQPyanOSd1yGsHK+Q=;
        b=zRDntak0+QyTIre1pp+NGE+uPvJykLkpLCUvgZY26o4CUWqRcpXSh2BpL/R3EFeQUD
         XB4dVMbljPPnLR148xBQPMe/jmwKFSkzZJ5kJ92k0yHO7ufDst/Y7eT3K88eUm5zueG4
         yt9mOO8DRI3h/VSE+F19s0cUG47BTKC7k1ebhirVv2kFxm+UDLccgoW1eHPN3lJkCq5k
         h6mIz4x4Bta9v1MdYIbeoD4R9nktlADVTVy8bHo5tVC7fDL45+7Q9lXqyMZUkM1SvHH8
         tib4q0Pipaoxr3PblfJImsNYxC0LXnkeS8bN8zhmG24U6I62BNq2HU5+G0EwNEunxem8
         h+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wwptH0NwA9F4hOq9blkkboSBFwlQPyanOSd1yGsHK+Q=;
        b=Jb7e6pau5GoqM82EMrqTpKa/WVE5U3aszD7ZjZ4+jyYbQLcn7KANP0CHWPISJuBPy3
         GbLA/RYNwv2h/f7dJ9yO7HUWf1qSYLRllHplSroxQqamWJ89VFeP5DDcV1p+y3sAIow5
         +d/xnWBbaH4iXdCeaLviuJhJw6E+1JZOhPVHIkpP0ys2GcAFgyBtdVM6VG5ryYMZG69n
         bgGoZPyztAhL47Lv1yFgaboEic6Sg0PpxjGK3hYKXO/ZxJ8gdL4dIo2G+1hsk3bAetYd
         JnTDTKRQPmc6v/dnJn7h2FgyX+copJaInBu1kI3K3kCETdNCSCyMTLAU+OGN/H8PAn0l
         lqLw==
X-Gm-Message-State: AOAM533JhctCeh1X58/pDlniK4h2eOgbIi1nV0tL4Fii3eoRvr+g7pJr
        tTQwttq3u8dc/8ZVglEIKivPoQ==
X-Google-Smtp-Source: ABdhPJwB08J2vz0A0gbW0syrGNAlGpamxTzbQJm0c85kqCEQcEjYBCXX1xJIuDp/JFaktfVeqm8xkg==
X-Received: by 2002:a17:90a:31c5:: with SMTP id j5mr14715146pjf.200.1643904883250;
        Thu, 03 Feb 2022 08:14:43 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id bj7sm9991089pjb.9.2022.02.03.08.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 08:14:42 -0800 (PST)
Message-ID: <b95078f2-180a-e691-d10b-f19a87575274@linaro.org>
Date:   Thu, 3 Feb 2022 08:14:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4] sched/fair: Fix fault in reweight_entity
Content-Language: en-US
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>, peterz@infradead.org
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
References: <20220125193403.778497-1-tadeusz.struk@linaro.org>
 <20220127205623.1258029-1-tadeusz.struk@linaro.org>
 <dc241a1f-74c2-3db6-e932-04b653e469bb@arm.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <dc241a1f-74c2-3db6-e932-04b653e469bb@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/22 01:40, Dietmar Eggemann wrote:
>> -static void set_load_weight(struct task_struct *p, bool update_load)
>> +static void set_load_weight(struct task_struct *p)
>>   {
>>   	int prio = p->static_prio - MAX_RT_PRIO;
>>   	struct load_weight *load = &p->se.load;
>> +	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
> nit-pick: reverse fir tree order
> 
> cat Documentation/process/maintainer-tip.rst | grep -A 10 "Variable
> declarations"
> 
> I was able to recreate the initial issue with the reproducer on arm64
> Juno-r0 with CONFIG_CGROUP_SCHED=y .
> 
> Reviewed-by: Dietmar Eggemann<dietmar.eggemann@arm.com>

Thanks for reviewing. I will send a v5 soon.

-- 
Thanks,
Tadeusz
