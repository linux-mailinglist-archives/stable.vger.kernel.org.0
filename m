Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3788C2FF5A4
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 21:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbhAUUQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 15:16:25 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:47056 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbhAUUQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jan 2021 15:16:08 -0500
Received: by mail-lf1-f47.google.com with SMTP id o10so4307671lfl.13;
        Thu, 21 Jan 2021 12:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:cc:references:from:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dVsjvKaCVwralxI5zARSOQQIxlzovaj1ya8SYQBcCCE=;
        b=J6Wq1E/EcLyb7cZ7OVsTDBCxC4yMk1O2t7hb6NPvvMLv0rEHX2r9mIUbcsnBXDCL9d
         f/eZfX4M549U4clI9R2knH98WYbS29Zjj4VTgrstkxrhlDqMky1oL1wkL1U0td1wg2++
         F846LZYZsCYeqI6KkjKnapTmZK1rrEPemy9HI6qYNsYLhXsISabAmuzkuJScCUb2wJer
         DwI6a+xSR5iwtj1DgmgjONoSbffTfxyXj5z9NrYe2fDo/dYFBbLEGAdY26jdNVBZckOa
         NPEaIuiK+/HFsbOJxDWpUV/PlzL+uIxEHI3rUiURjW5WSGeE+5U1jzyL/6fdVQQ+DkKd
         3tgQ==
X-Gm-Message-State: AOAM533WFLsRm+7EpHE0ELmCcvmnriZAqjIDN39k+pXJwc8PwzzXMGlp
        mjMcI2gWr/CQCJNtqAvg+Ec=
X-Google-Smtp-Source: ABdhPJztUOXA2UEP44W6sfFicy+OUij/Vcd2aeJkNJaNKcmlgiV5wLM2KhltZLxQHfRAiYhBuIwy7w==
X-Received: by 2002:a05:6512:20d2:: with SMTP id u18mr28647lfr.47.1611260124380;
        Thu, 21 Jan 2021 12:15:24 -0800 (PST)
Received: from [10.68.32.148] (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.gmail.com with ESMTPSA id m12sm682023lji.110.2021.01.21.12.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 12:15:23 -0800 (PST)
Reply-To: efremov@linux.com
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Gaurav Kohli <gkohli@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Julia Lawall <julia.lawall@inria.fr>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
 <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
 <20210121140951.2a554a5e@gandalf.local.home>
From:   Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
Date:   Thu, 21 Jan 2021 23:15:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121140951.2a554a5e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/21/21 10:09 PM, Steven Rostedt wrote:
> On Thu, 21 Jan 2021 17:30:40 +0300
> Denis Efremov <efremov@linux.com> wrote:
> 
>> Hi,
>>
>> This patch (CVE-2020-27825) was tagged with
>> Fixes: b23d7a5f4a07a ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
>>
>> I'm not an expert here but it seems like b23d7a5f4a07a only refactored
>> ring_buffer_reset_cpu() by introducing reset_disabled_cpu_buffer() without
>> significant changes. Hence, mutex_lock(&buffer->mutex)/mutex_unlock(&buffer->mutex)
>> can be backported further than b23d7a5f4a07a~ and to all LTS kernels. Is
>> b23d7a5f4a07a the actual cause of the bug?
>>
> 
> Ug, that looks to be a mistake. Looking back at the thread about this:
> 
>   https://lore.kernel.org/linux-arm-msm/20200915141304.41fa7c30@gandalf.local.home/

I see from the link that it was planned to backport the patch to LTS kernels:

> Actually we are seeing issue in older kernel like 4.19/4.14/5.4 and there below patch was not 
> present in stable branches:
> Commit b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")

The point is that it's not backported yet. Maybe because of Fixes tag. I've discovered
this while trying to formalize CVE-2020-27825 bug in cvehound
https://github.com/evdenis/cvehound/blob/master/cvehound/cve/CVE-2020-27825.cocci

I think that the backport to the 4.4+ should be something like:

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 547a3a5ac57b..2171b377bbc1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4295,6 +4295,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return;
 
+	mutex_lock(&buffer->mutex);
+
 	atomic_inc(&buffer->resize_disabled);
 	atomic_inc(&cpu_buffer->record_disabled);
 
@@ -4317,6 +4319,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	atomic_dec(&cpu_buffer->record_disabled);
 	atomic_dec(&buffer->resize_disabled);
+
+	mutex_unlock(&buffer->mutex);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 

Thanks,
Denis





