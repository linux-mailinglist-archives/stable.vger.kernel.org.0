Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835F8229887
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGVMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 08:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVMts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 08:49:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0CB206C1;
        Wed, 22 Jul 2020 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595422187;
        bh=9bO/CzlUBTjOYs2zyy1HJs8h4p36huP1Q1qYFobCpFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R017QB32BaN0BRff70sDEikYHqmQ4xHZjQF0RpE552UGWlfJwzcxTozos7SDhsCqS
         rGd9v4+sI0Pq/PzqzTI9UM3dH++mUbPzU/YeTRaOQftlGhI6eQze+RtLHuzN+5Na31
         xTUN9qBJBvh1PFeNdGOxcGjKKe+WNOFDJlAG+4UE=
Date:   Wed, 22 Jul 2020 14:49:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, Namhyung Kim <namhyung@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200722124953.GE3155653@kroah.com>
References: <20200720191523.845282610@linuxfoundation.org>
 <CA+G9fYuVJAHyXqPhhqtcdDstKrjb-TLu=d7DZTuQX3YuCsypHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuVJAHyXqPhhqtcdDstKrjb-TLu=d7DZTuQX3YuCsypHA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 02:59:22PM +0530, Naresh Kamboju wrote:
> On Tue, 21 Jul 2020 at 00:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.10 release.
> > There are 243 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions detected on arm and arm64 (Juno-r2)
> We are bisecting this problem and get back to you soon.
> 
> perf test cases failed
>   perf:
>     * Track-with-sched_switch
>     * perf_record_test
>     * perf_report_test
> 
> Bad case:
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.002 MB perf-lava-test.data ]
> 
> when it was pass it prints number of samples like below,
> Good case:
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.004 MB perf-lava-test.data (46 samples) ]
> 
> steps to reproduce:
> # perf record -e cycles -o perf-lava-test.data ls -a  2>&1 | tee perf-record.log
> 
> Link to full test:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.7-oe/build/v5.7.9-244-g7d2e5723ce4a/testrun/2969482/suite/perf/test/perf_record_test/log
> 
> test case:
> https://github.com/Linaro/test-definitions/blob/master/automated/linux/perf/perf.sh

Any hint by bisection as to what this problem is caused by?

thanks,

greg k-h
