Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B52592CCF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 12:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241736AbiHOIQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 04:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiHOIPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 04:15:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DBF639E;
        Mon, 15 Aug 2022 01:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=8Ewz/NjlMw51NrevL6mP6tY09Paxwi5mAgndnXxIDBg=; b=l0fFEmCLMSXx9W2xsG+a7cIUXK
        Wa/U1dxWGmmtRQ5aP1D0E55ZzWtF6se5QPpXFADHuyFZtEG3qBMDdpkI+44S5+lVHDWZcKopE57Se
        zrPO8UKMLMRtUEbhd9j7+c7i23fyo6IFAtuVZbStiVxy6d23p2e5UKD/JzJYxta7Pp82UN1ql/a7W
        TIzHyUpthpkFuErAFlCh6t/LcHzj95hJgoxf+JHTb5I/REVOqnFVxVzE8xzp1FqjnKw9WEdIJCrvI
        +gH1SqrnnhhXpNMYwRAXxJU2pwyEgnZ+CaKBZR53RQsf6NvwKPp/+wbSG3EttTq+F6dPmJRHPH8Mr
        RGFVfGfA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oNVFk-002cVb-B6; Mon, 15 Aug 2022 08:15:16 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3D37B980153; Mon, 15 Aug 2022 10:15:15 +0200 (CEST)
Date:   Mon, 15 Aug 2022 10:15:15 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li Hua <hucool.lihua@huawei.com>
Cc:     mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -next] sched/cputime: Fix the bug of reading time
 backward from /proc/stat
Message-ID: <YvoAk1pnU4gZcFJ1@worktop.programming.kicks-ass.net>
References: <20220813000102.42051-1-hucool.lihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813000102.42051-1-hucool.lihua@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 13, 2022 at 08:01:02AM +0800, Li Hua wrote:
> The problem that the statistical time goes backward, the value read first is 319, and the value read again is 318. As follows：
> first：
> cat /proc/stat |  grep cpu1
> cpu1    319    0    496    41665    0    0    0    0    0    0
> then：
> cat /proc/stat |  grep cpu1
> cpu1    318    0    497    41674    0    0    0    0    0    0
> 
> Time goes back, which is counterintuitive.
> 
> After debug this, The problem is caused by the implementation of kcpustat_cpu_fetch_vtime. As follows：
> 
>                               CPU0                                                                          CPU1
> First:
> show_stat():
>     ->kcpustat_cpu_fetch()
>         ->kcpustat_cpu_fetch_vtime()
>             ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu) + vtime->utime + delta;              rq->curr is in user mod
>              ---> When CPU1 rq->curr running on userspace, need add utime and delta
>                                                                                              --->  rq->curr->vtime->utime is less than 1 tick
> Then:
> show_stat():
>     ->kcpustat_cpu_fetch()
>         ->kcpustat_cpu_fetch_vtime()
>             ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu);                                     rq->curr is in kernel mod
>             ---> When CPU1 rq->curr running on kernel space, just got kcpustat

This is unreadable, what?!?
