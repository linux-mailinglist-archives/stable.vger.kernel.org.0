Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A67521D77
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345570AbiEJPJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345615AbiEJPIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:08:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307132E6A9;
        Tue, 10 May 2022 07:38:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652193507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w3ElTKcPgRcfhSXCODsdQ9SYsvPTENqPkhqSJjkaUnk=;
        b=2FSm4oOqMOc7u7DOArxh7vypRuFLzQJ4f5e7uumNWZk1I+wP6rN1Z+BamxxgNm/HkkJ8dS
        jbuzVvdMTYuHKMYIdn3pJkzvOHvrtKjxkW5KQCOiLLd87+XgT1YCNZ7cZ3D75oQSIjPAbJ
        3MI6F+cGiQbGDDLe0QmgNkbGSBVbUVM5Is/ozOGVwpE47NGGUx6NXo3tJweiXw1f2yIHV9
        f3oKOyk0z/V2PomejDHplZTRKP9rSVl69cpaHnnuluzzxUokX3JCs5rygHZql3fiIvNDkg
        QQKtbUKUOoW1hWOjc4Wij3nCbiFffRmPCss0ja1b96xfU7R1+MpTAUbvCEhisA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652193507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w3ElTKcPgRcfhSXCODsdQ9SYsvPTENqPkhqSJjkaUnk=;
        b=uPf15/pRgDbttbexXqULpEddKepYTDu4nFjxb45VjXxHv5/WFbZRbyE2QG0KSbWW24RYCN
        +ZKev2VYi08SYNDg==
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-arch@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org,
        =?utf-8?B?0JzQsNC60YHQuNC8INCa0YPRgtGP0LLQuNC9?= 
        <maximkabox13@gmail.com>
Subject: Re: [PATCH 1/7] kthread: Don't allocate kthread_struct for init and
 umh
In-Reply-To: <20220506141512.516114-1-ebiederm@xmission.com>
References: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
 <20220506141512.516114-1-ebiederm@xmission.com>
Date:   Tue, 10 May 2022 16:38:27 +0200
Message-ID: <87fslhpi58.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06 2022 at 09:15, Eric W. Biederman wrote:
>  	 * the init task will end up wanting to create kthreads, which, if
>  	 * we schedule it before we create kthreadd, will OOPS.
>  	 */
> -	pid = kernel_thread(kernel_init, NULL, CLONE_FS);
> +	pid = user_mode_thread(kernel_init, NULL, CLONE_FS);

So init does not have PF_KTHREAD set anymore, which causes this to go
sideways with a NULL pointer dereference in get_mm_counter() on next:

 get_mm_counter include/linux/mm.h:1996 [inline]
 get_mm_rss include/linux/mm.h:2049 [inline]
 task_nr_scan_windows.isra.0+0x23/0x120 kernel/sched/fair.c:1123
 task_scan_min kernel/sched/fair.c:1144 [inline]
 task_scan_start+0x6c/0x400 kernel/sched/fair.c:1150
 task_tick_numa kernel/sched/fair.c:2944 [inline]
 task_tick_fair+0xaeb/0xef0 kernel/sched/fair.c:11186
 scheduler_tick+0x20a/0x5e0 kernel/sched/core.c:5380

 https://lore.kernel.org/lkml/0000000000008a9fbb05dea76400@google.com

because the fence in task_tick_numa():

 	if ((curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)
		return;

is not longer sufficient. It needs also to bail if !curr->mm.

I'm worried that there are more of these issues lurking. Haven't looked
yet.

Thanks,

        tglx
