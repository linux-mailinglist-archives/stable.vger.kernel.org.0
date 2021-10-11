Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C5F428D48
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhJKMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:48:24 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3962 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbhJKMsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:48:24 -0400
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HSdjn3cTYz6H7fg;
        Mon, 11 Oct 2021 20:42:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 14:46:23 +0200
Received: from [10.47.80.142] (10.47.80.142) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 11 Oct
 2021 13:46:22 +0100
Subject: Re: pmu-events/jevents.c:1188:9: warning: implicit declaration of
 function 'free_sys_event_tables' [-Wimplicit-function-declaration]
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>
References: <CA+G9fYvfWNnBEpgzSQrh8AocmJVcTRtRT3uhJCG__js7aEWwjg@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3385c786-625c-6d4d-cf2e-09b0422e9fef@huawei.com>
Date:   Mon, 11 Oct 2021 13:48:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYvfWNnBEpgzSQrh8AocmJVcTRtRT3uhJCG__js7aEWwjg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.142]
X-ClientProxiedBy: lhreml734-chm.china.huawei.com (10.201.108.85) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/2021 13:17, Naresh Kamboju wrote:
> stable-rc 5.10 perf build failed due to these warnings  / errors.
> 

It seems that the Fixes tag was incorrect for commit b94729919db2 ("perf 
jevents: Fix sys_event_tables to be freed like arch_std_events").

It should really have fixed 4689f56796f8, not e9d32c1bf0cd7a98.

Thanks,
John

> metadata:
>      git_describe: v5.10.72-85-g431c7c55f183
>      git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>      git_short_log: 431c7c55f183 (\"Linux 5.10.73-rc1\")
>      target_arch: x86_64
>      toolchain: gcc-11
> 
> pmu-events/jevents.c: In function 'main':
> pmu-events/jevents.c:1188:9: warning: implicit declaration of function
> 'free_sys_event_tables' [-Wimplicit-function-declaration]
>   1188 |         free_sys_event_tables();
>        |         ^~~~~~~~~~~~~~~~~~~~~
> /usr/bin/ld: /home/tuxbuild/.cache/tuxmake/builds/current/pmu-events/jevents-in.o:
> in function `main':
> (.text+0x469e): undefined reference to `free_sys_event_tables'
> /usr/bin/ld: (.text+0x475e): undefined reference to `free_sys_event_tables'
> collect2: error: ld returned 1 exit status
> make[2]: *** [Makefile.perf:649:
> /home/tuxbuild/.cache/tuxmake/builds/current/pmu-events/jevents] Error
> 1
> make[2]: *** Waiting for unfinished jobs....
>    LINK     /home/tuxbuild/.cache/tuxmake/builds/current/plugin_cfg80211.so
>    GEN      /home/tuxbuild/.cache/tuxmake/builds/current/libtraceevent-dynamic-list
> make[1]: *** [Makefile.perf:229: sub-make] Error 2
> make: *** [Makefile:70: all] Error 2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> build link:
> -----------
> https://builds.tuxbuild.com/1zLv2snHfZN8QV01yA9MB8NhUZt/build.log
> 
> build config:
> -------------
> https://builds.tuxbuild.com/1zLv2snHfZN8QV01yA9MB8NhUZt/config
> 

