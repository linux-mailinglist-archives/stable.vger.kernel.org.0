Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09175272
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfGYPUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 11:20:12 -0400
Received: from cmta17.telus.net ([209.171.16.90]:56487 "EHLO cmta17.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388843AbfGYPUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 11:20:09 -0400
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id qfXGhGxCSzEP4qfXIhjKhV; Thu, 25 Jul 2019 09:20:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1564068006; bh=Yj6Fbdz6cjL7+b5dzv3RJ6R+eBunjGaQmRvWeERhOWY=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=sYk8HlfLRIcUdWq2AcujYgfp2zGYgb1gr3Hw/FRHIZIAb9bPc2hnHs+A88dWYtAuW
         rUtabzSLw0Kf9abWS8i6SXX9QdgP8EfoviktUvyjP9OHCvKKxVoxPgP5f6ib9pODUh
         d21y/L7sed8S9iHkbfJ6naK+4e8tGanpqst8fI7fnIpvapYdXiy1j7J1EJOAKtwdO5
         Qwc1E9skOSyMNjgWt5yyJFBuOYutZtdp71JRycamNjelJHXPYSo/JEPE98dZ/IxUQ1
         YZzIEf6+YLaU0N0mgwLOVKktEx7XuKA+jPLzB1YoBNVtvjYh0Iwc0BN/TJIDba52qz
         +rR3OtXi2cHgg==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=cYmsUULM c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=KKAkSRfTAAAA:8 a=gu6fZOg2AAAA:8 a=_GkJrRlwnCL7A2mvMCAA:9
 a=CjuIK1q_8ugA:10 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
 a=cvBusfyB2V15izCimMoJ:22 a=2RSlZUUhi9gRBrsHwhhZ:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rafael J. Wysocki'" <rafael@kernel.org>
Cc:     "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Linux PM'" <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        "'Joel Fernandes'" <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net> <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org> <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7> <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com> <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
In-Reply-To: <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Thu, 25 Jul 2019 08:20:01 -0700
Message-ID: <000c01d542fc$703ff850$50bfe8f0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVCFQVr1phaD+P6Sq6kW1+vmsbdwQAm2IYQ
X-CMAE-Envelope: MS4wfLaRfd1rcOoDWaHnU5xIUUcYswZjdnsvzSocGsFvBURZhWQjg5H3b8U2RJUu1tOGE5yQvC4520ORyxtygI2C7uH2qFUMWZ1Dnrjhmh14hfVSj7vVKSvv
 pA57riQC4hXWfAFtM/q/e4dgvtdW+jmJ6vHz4AwZCteGAsf8iGpj51/1bs5ck+Aj7QwYbk5IJWJ7Kjcf/SJugOMKBoeD2hL8IYHbZkcXC+d64KJz3LZjraYR
 /ftFdHFIayhdJlpzWgtGryp0qv6rq1ZlC83yAaldADbAiWlKvjJtpTkc1bt85O58bvO0HpsJIL18wB7NH+XTw4WHT6gRdRAx/9RHO4X1+z63yqtIKxNmpyjZ
 bMFHfrCeAmUpiJuulm0Jz+/FGF2QSwAGgEPYE09iCGBVSqK66//MGK281SWN0GqMW5mKWqZuamKe6ZU4qXI/s/YxmqkpKStsKfFBLj6lBrxoBoQjQ7A=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I am having trouble keeping up.
Here is what I have so far:

On 2019.07.24 04:43 Viresh Kumar wrote:
> On 23-07-19, 12:27, Rafael J. Wysocki wrote:
>> On Tue, Jul 23, 2019 at 11:15 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:

>>> Though there is one difference between intel_cpufreq and acpi_cpufreq,
>>> intel_cpufreq has fast_switch_possible=true and so it uses slightly
>>> different path in schedutil. I tried to look from that perspective as
>>> well but couldn't find anything wrong.
>> 
>> acpi-cpufreq should use fast switching on the Doug's system too.
>
> Ah okay.
>
>>> If you still find intel_cpufreq to be broken, even with this patch,

It is.

>>> please set fast_switch_possible=false instead of true in
>>> __intel_pstate_cpu_init() and try tests again. That shall make it very
>>> much similar to acpi-cpufreq driver.
>> 
>> I wonder if this helps.

It does not help.

>> Even so, we want fast switching to be used by intel_cpufreq.

>
> With both using fast switching it shouldn't make any difference.

>> Anyway, it looks like the change reverted by the Doug's patch
>> introduced a race condition that had not been present before.  Namely,
>> need_freq_update is cleared in get_next_freq() when it is set _or_
>> when the new freq is different from the cached one, so in the latter
>> case if it happens to be set by sugov_limits() after evaluating
>> sugov_should_update_freq() (which returned 'true' for timing reasons),
>> that update will be lost now. [Previously the update would not be
>> lost, because the clearing of need_freq_update depended only on its
>> current value.] Where it matters is that in the "need_freq_update set"
>> case, the "premature frequency reduction avoidance" should not be
>> applied (as you noticed and hence the $subject patch).
>> 
>> However, even with the $subject patch, need_freq_update may still be
>> set by sugov_limits() after the check added by it and then cleared by
>> get_next_freq(), so it doesn't really eliminate the problem.
>> 
>> IMO eliminating would require invalidating next_freq this way or
>> another when need_freq_update is set in sugov_should_update_freq(),
>> which was done before commit ecd2884291261e3fddbc7651ee11a20d596bb514.
>
> Hmm, so to avoid locking in fast path we need two variable group to
> protect against this kind of issues. I still don't want to override
> next_freq with a special meaning as it can cause hidden bugs, we have
> seen that earlier.
>
> What about something like this then ?

I tried the patch ("patch2"). It did not fix the issue.

To summarize, all kernel 5.2 based, all intel_cpufreq driver and schedutil governor:

Test: Does a busy system respond to maximum CPU clock frequency reduction?

stock, unaltered: No.
revert ecd2884291261e3fddbc7651ee11a20d596bb514: Yes
viresh patch: No.
fast_switch edit: No.
viresh patch2: No.

References (and procedures used):
https://marc.info/?l=linux-pm&m=156346478429147&w=2
https://marc.info/?l=linux-kernel&m=156343125319461&w=2

... Doug


