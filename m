Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7D78034E
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 02:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390665AbfHCAA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 20:00:59 -0400
Received: from cmta18.telus.net ([209.171.16.91]:37697 "EHLO cmta18.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392586AbfHCAA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 20:00:59 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id thTihsw9n7TgTthTjhTKWb; Fri, 02 Aug 2019 18:00:57 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564790457; bh=F7V2+VOnHcn4fwkSv3TDF+F7RNbW/H8xyC92UEWKRsA=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=CdVDYEfk7QJlV0gtGvNT85cgLKsjA2t90Yb7Nc1WY6rSD+vadt4kysBxKbLrDIY1Z
         Jg0z9h6xrsXhUhFsGHV6DsDf+21kXUnccX5iUjF3g7XM9T8Zj0rqg5GDJvA583Rda8
         QIUk5CHMyMlpNmlXzTQx94ZA9ch9bIkuv7KEXHgScSzeePOwkkE0l7PWwh90NHsHry
         7SXSpIx4Po+5rgQ2clD4UaLeBD0VRs0RyEtKNvE/DpFfwOrOI+062T7/Yf+uZ8QPbk
         m0kOEbG8tanKt9FJ81bHlv1OhA52qLKVTNrgfJi4vxaiEBCAumTeQqloghBKPeNf3j
         YLDYf/sP089dg==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=e6N4tph/ c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=IkcTkHD0fZMA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=aatUQebYAAAA:8 a=EKkws6boqHGLJ_gLzfMA:9 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=AjGcO6oz07-iQ99wixmX:22 a=7715FyvI7WU-l6oqrZBK:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>
Cc:     "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Doug Smythies'" <doug.smythies@gmail.com>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org> <CAJZ5v0g=zXWps29EiFJBPozyw4b9z0YOhtU-UV6hfyu8NbVKNw@mail.gmail.com>
In-Reply-To: <CAJZ5v0g=zXWps29EiFJBPozyw4b9z0YOhtU-UV6hfyu8NbVKNw@mail.gmail.com>
Subject: RE: [PATCH V3 1/2] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Fri, 2 Aug 2019 17:00:52 -0700
Message-ID: <000701d5498e$85bf7b40$913e71c0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVJEl0/y7b0nLfcROucUfHaff8dzAAegK7Q
X-CMAE-Envelope: MS4wfP0b9oNOCGiMJ+jjHYWyvLDFO6aTm0NLjTpKkuh8/Ay5GQANsLiWSUW1s+gZhY6+Cql9wTcEuYPZkoXdoCdlU15YNiWXQkkZoBD/1r7xcFGXHbmIiUtP
 conQucH9aVp2Q981TbV3u/20CUth4gFX5vKTAS4XaUmul8IgKDC15tvPNmNsQlZFibpNjx/2vB0+cklD62aRb8Ly5nAA685oFCAfH89u/1iXG2MVpe8zSolL
 w6SFdfdtCiHZ1wzbYEDkyB/NjF29WISYLOO5wn5C6wkg2n6Q5dtyo4e1rrQVtHVQLpAq8Pj/EVE7qq8Vm+GrLJZNfuXkiJxrDNdZAdIpIJu93DZcdYxV2Tyq
 8cF6zABqjLllOl8t1SWDIXXT83NIwNzq3NH06ua0aUUErb/bPpOSOwtVI++t3KJ0necZ9SljjCf37ugs28zt3zaN/+MIOZ/4VBxNAEN+DNrJ4yCmG5c=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.08.02 02:12 Rafael J. Wysocki wrote:
> On Fri, Aug 2, 2019 at 7:44 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>
>> To avoid reducing the frequency of a CPU prematurely, we skip reducing
>> the frequency if the CPU had been busy recently.
>>
>> This should not be done when the limits of the policy are changed, for
>> example due to thermal throttling. We should always get the frequency
>> within the new limits as soon as possible.
>>
>> Trying to fix this by using only one flag, i.e. need_freq_update, can
>> lead to a race condition where the flag gets cleared without forcing us
>> to change the frequency at least once. And so this patch introduces
>>  another flag to avoid that race condition.
>>
>> Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
>> Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
>> Reported-by: Doug Smythies <doug.smythies@gmail.com>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>> V2->V3:
>> - Updated commit log.
>>
>> V1->V2:
>> - Fixed the race condition using a different flag.
>>
>> @Doug: I haven't changed the code since you last tested these. Your
>> Tested-by tag can be useful while applying the patches. Thanks.

Tested-by: Doug Smythies <dsmythies@telus.net>
For acpi-cpufreq/schedutil only (which we already know).

I tested including Rafael's suggested change.
I.E.

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 592ff72..ae3ec77 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -441,7 +441,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
        struct sugov_policy *sg_policy = sg_cpu->sg_policy;
        unsigned long util, max;
        unsigned int next_f;
-       bool busy = false;
+       bool busy;

        sugov_iowait_boost(sg_cpu, time, flags);
        sg_cpu->last_update = time;
@@ -452,8 +452,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
                return;

        /* Limits may have changed, don't skip frequency update */
-       if (!sg_policy->need_freq_update)
-               busy = sugov_cpu_is_busy(sg_cpu);
+       busy = !sg_policy->need_freq_update && sugov_cpu_is_busy(sg_cpu);

        util = sugov_get_util(sg_cpu);
        max = sg_cpu->max;

... Doug


