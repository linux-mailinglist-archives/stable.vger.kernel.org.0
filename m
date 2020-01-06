Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB498130AF4
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 01:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgAFAnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 19:43:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:51826 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgAFAnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jan 2020 19:43:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jan 2020 16:43:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,400,1571727600"; 
   d="scan'208";a="394866806"
Received: from unknown (HELO [10.239.196.123]) ([10.239.196.123])
  by orsmga005.jf.intel.com with ESMTP; 05 Jan 2020 16:42:58 -0800
Subject: Re: 4.9.208 regression in perf building
To:     Jiri Olsa <jolsa@redhat.com>, Akemi Yagi <toracat@elrepo.org>
Cc:     Gordan Bobic <gordan@redsleeve.org>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ElRepo <contact@elrepo.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
References: <CAMx4oe38RytiyqWfYb=So8iC6N=8nebqy3DsekiT7A5DGjpe+w@mail.gmail.com>
 <CAMx4oe2JKTsOKg3P324PYRH=0ajOVDaXTLa7p=16Fo9fGiQSpQ@mail.gmail.com>
 <CABA31DrtCwUj-wzPP+dwUP+=jTOHnt8eoS+d+N2yfAn22W19vA@mail.gmail.com>
 <20200105193550.GA177781@krava>
 <CABA31DoxzzoOgQXfLmaF2+msqi9F_sFRBN2thxe7W6+1QmWWgA@mail.gmail.com>
 <20200105222502.GA207350@krava>
From:   "Jin, Yao" <yao.jin@linux.intel.com>
Message-ID: <47d14944-e93f-e392-7d03-acf09bc1a414@linux.intel.com>
Date:   Mon, 6 Jan 2020 08:42:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200105222502.GA207350@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/6/2020 6:25 AM, Jiri Olsa wrote:
> On Sun, Jan 05, 2020 at 12:06:07PM -0800, Akemi Yagi wrote:
>> On Sun, Jan 5, 2020 at 11:36 AM Jiri Olsa <jolsa@redhat.com> wrote:
>>>
>>> On Sun, Jan 05, 2020 at 10:21:25AM -0800, Akemi Yagi wrote:
>>>> Adding Arnaldo and Jiri to the CC list.
>>>>
>>>> On Sun, Jan 5, 2020 at 9:01 AM Gordan Bobic <gordan@redsleeve.org> wrote:
>>>>>
>>>>> It looks like 4.9.208 introduces a build regression for perf:
>>>>>
>>>>> make -f /builddir/build/BUILD/kernel-4.9.208/linux-4.9.208-1.el7.x86_64/tools/build/Makefile.build
>>>>> dir=. obj=perf
>>>>
>>>>>   -c -o builtin-report.o builtin-report.c
>>>>> builtin-report.c: In function ‘report__setup_sample_type’:
>>>>> builtin-report.c:296:6: error: ‘dwarf_callchain_users’ undeclared
>>>>> (first use in this function)
>>>>>    if (dwarf_callchain_users) {
>>>>>        ^
>>>>> builtin-report.c:296:6: note: each undeclared identifier is reported
>>>>> only once for each function it appears in
>>>>> mv: cannot stat ‘./.builtin-report.o.tmp’: No such file or directory
>>>>> make[3]: *** [builtin-report.o] Error 1
>>>>> make[2]: *** [perf-in.o] Error 2
>>>>> make[1]: *** [sub-make] Error 2
>>>>> make: *** [all] Error 2
>>>>>
>>>>> 4,9.207 works fine.
>>>>
>>>> The regression was caused by the following patch:
>>>>
>>>> https://lore.kernel.org/lkml/20191021133834.25998-7-acme@kernel.org/
>>>>
>>>> To fix this, 'dwarf_callchain_users' needs to be declared.
>>>
>>> hum, I see it's declared in callchain.h which is included in builtin-report.c
>>> also I can't see that same stuff like you have on line 296.. what sources are you on?
>>>
>>> could you please check with latest Arnaldo's perf/core?
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
>>>
>>> thanks,
>>> jirka
>>
>> This is kernel 4.4.208 that was released today.
>> 'dwarf_callchain_users' is not declared in this kernel. I'm afraid it
>> was missed when the aforementioned patch was backported.
> 
> so 'dwarf_callchain_users' was introduced with:
>    eabad8c6856f perf unwind: Do not look just at the global callchain_param.record_mode
> 
> which wasn't backported to 4.4.y and it seems it will need more
> dependencies to be applied properly
> 
> however if I revert aforementioned patch:
>    faece3af8072 perf report: Add warning when libunwind not compiled in
> 
> it compiles for me.. actualy I'm not sure why it went to stable,
> it's just user info/warning
> 
> jirka
> 

Yes, agree with Jiri, this patch is only warning for user, but not for 
fixing some issues.

Thanks
Jin Yao
