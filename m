Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99115769B5
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 00:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiGOWLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 18:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiGOWLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 18:11:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F4E9B9EB;
        Fri, 15 Jul 2022 15:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7141DB82EB3;
        Fri, 15 Jul 2022 22:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50143C3411E;
        Fri, 15 Jul 2022 22:06:09 +0000 (UTC)
Date:   Fri, 15 Jul 2022 18:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     <stable@vger.kernel.org>, <paulmck@linux.vnet.ibm.com>,
        <josh@joshtriplett.org>, <mathieu.desnoyers@efficios.com>,
        <jiangshanlai@gmail.com>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>, <xukuohai@huawei.com>
Subject: Re: [PATCH 4.19] rcu/tree: Mark functions as notrace
Message-ID: <20220715180607.4509fb86@gandalf.local.home>
In-Reply-To: <20220713102009.126339-1-zhengyejian1@huawei.com>
References: <20220713102009.126339-1-zhengyejian1@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 Jul 2022 18:20:09 +0800
Zheng Yejian <zhengyejian1@huawei.com> wrote:

> This patch and problem analysis is based on v4.19 LTS, but v5.4 LTS
> and below seem to be involved.
> 
> Hulk Robot reports a softlockup problem, see following logs:
>   [   41.463870] watchdog: BUG: soft lockup - CPU#0 stuck for 22s!  [ksoftirqd/0:9]

This detects something that is spinning with preemption disabled but
interrupts enabled.

> Look into above call stack, there is a recursive call in
> 'ftrace_graph_call', and the direct cause of above recursion is that
> 'rcu_dynticks_curr_cpu_in_eqs' is traced, see following snippet:
>     __read_once_size_nocheck.constprop.0
>       ftrace_graph_call    <-- 1. first call
>         ......
>           rcu_dynticks_curr_cpu_in_eqs
>             ftrace_graph_call    <-- 2. recursive call here!!!

This is not the bug. That code can handle a recursion:

ftrace_graph_call is assembly that is converted to call

void prepare_ftrace_return(unsigned long ip, unsigned long *parent,
			   unsigned long frame_pointer)
{
 [..]

	bit = ftrace_test_recursion_trylock(ip, *parent);
	if (bit < 0)
		return;

This will stop the code as "bit" will be < 0 on the second call to
ftrace_graph_call. If it was a real recursion issue, it would crash the
machine when the recursion runs out of stack space.

> 
> Comparing with mainline kernel, commit ff5c4f5cad33 ("rcu/tree:
> Mark the idle relevant functions noinstr") mark related functions as
> 'noinstr' which implies notrace, noinline and sticks things in the
> .noinstr.text section.
> Link: https://lore.kernel.org/all/20200416114706.625340212@infradead.org/
> 
> But we cannot directly backport that commit, because there seems to be
> many prepatches. Instead, marking the functions as 'notrace' where it is
> 'noinstr' in that commit and mark 'rcu_dynticks_curr_cpu_in_eqs' as
> inline look like it resolves the problem.

That will not fix your problem.

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>

Can you reproduce this consistently without this patch, and then not so
with this patch?

Or are you just assuming that this fixes a bug because you observed a
recursion?

Please explain to me why this would cause the hang?

-- Steve
