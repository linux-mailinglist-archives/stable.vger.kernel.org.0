Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164EB4AAF87
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiBFNoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 08:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbiBFNoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 08:44:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01676C06173B;
        Sun,  6 Feb 2022 05:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=GM+AIngVLb5co1+/1JjleFul0NTmgZBJcvh511LC0FI=; b=ALzcV2fG8HNpzLUkt0hl601RL0
        5sC0XTXDlw4SthUqwIUcyuC6MSt/QbY03gw7NnrH7FQ07LegJsnndDZw7tFPhwScRGLrEEw5RG0R/
        vvDGOvAn5kIKjNiYe5kbjtPa0Um0vyF3Atz4TwrGNZq3XE8w/TJ9A4zis74f7g6MrpPOm3T5V5uqk
        yJns1T9R2eacq/VLvVb89MLSQnJ2o9c49S48pSjze+2lOKbaTbhnjvZqrCulXqrig42/J2+ZPv2x+
        SAz2sAE2R04lK0t4cHNyPXqPZAiFulEpNp+TTHJc+xYboXPDo4ByMjSefohwrc9fQGqSiXut8Xhzp
        ZRZjKKIA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nGhpE-00EF76-3c; Sun, 06 Feb 2022 13:43:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1ADC1300470;
        Sun,  6 Feb 2022 14:43:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D09732CA50E34; Sun,  6 Feb 2022 14:43:29 +0100 (CET)
Date:   Sun, 6 Feb 2022 14:43:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] sched/fair: Fix fault in reweight_entity
Message-ID: <Yf/QgdYhpN8OgChJ@hirez.programming.kicks-ass.net>
References: <20220203161846.1160750-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220203161846.1160750-1-tadeusz.struk@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 03, 2022 at 08:18:46AM -0800, Tadeusz Struk wrote:
> Syzbot found a GPF in reweight_entity. This has been bisected to commit
> 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> 
> There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
> within a thread group that causes a null-ptr-deref in reweight_entity()
> in CFS. The scenario is that the main process spawns number of new
> threads, which then call setpriority(PRIO_PGRP, 0, -20), wait, and exit.
> For each of the new threads the copy_process() gets invoked, which adds
> the new task_struct and calls sched_post_fork() for it.
> 
> In the above scenario there is a possibility that setpriority(PRIO_PGRP)
> and set_one_prio() will be called for a thread in the group that is just
> being created by copy_process(), and for which the sched_post_fork() has
> not been executed yet. This will trigger a null pointer dereference in
> reweight_entity(), as it will try to access the run queue pointer, which
> hasn't been set. This results it a crash as shown below:
> 

> 
> Before the mentioned change the cfs_rq pointer for the task  has been
> set in sched_fork(), which is called much earlier in copy_process(),
> before the new task is added to the thread_group.
> Now it is done in the sched_post_fork(), which is called after that.
> To fix the issue the remove the update_load param from the
> update_load param() function and call reweight_task() only if the task
> flag doesn't have the TASK_NEW flag set.
> 

> Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
> Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
> Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Thanks!
