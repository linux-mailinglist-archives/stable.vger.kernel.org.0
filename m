Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A849478C8A
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhLQNmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:42:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:33360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhLQNmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:42:20 -0500
Date:   Fri, 17 Dec 2021 14:42:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639748539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y9t3us+BAk9470BAEhbmBUCeSGzoYQ7LS0Tsk6tNMXY=;
        b=c+B1b8JaAQoEvO43R2R6bRsFgYeE3YSp4vWxLWZU3xOfdlAnmEwte/hjSx468Vzm0HkCDz
        q2i/IKbJIBh4zDPJlBheB0HkXsMzAjUtPN1rJQ4xTkZbH5bQjpiDVv7iRPUIUm3emapHxT
        2r6+FqO40r2sIjedtNWxyreM0Q9O93AsrpUWq8DDZ2rtJfQSDQ/tWNXtMeXgziBSzDUQ10
        YqpplUEJpihQRUYa93/LM5Bcobz/hdcywuTg85FDtEP+eqlRGnI4CopwSm1LgMVxvrS2WB
        xsxtUn3WcghLnJXWh6qe47sWtvMcSZGUPKzGCeWfiA0AG5D3vAQAr1JRmY+yPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639748539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y9t3us+BAk9470BAEhbmBUCeSGzoYQ7LS0Tsk6tNMXY=;
        b=1HvD9OCjzb8K+rydxGcStwI2YQMC5j6haYHY0xcYDRhOJ1YQEyCNoR2KH/4TvnUcxcWBW4
        xLUEs8YOC5oMUUBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     song@kernel.org, masahiroy@kernel.org, williams@redhat.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org, linux-raid@vger.kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v3] lib/raid6: Reduce high latency by using migrate
 instead of preempt
Message-ID: <YbyTuRWkB0gYbn7x@linutronix.de>
References: <20211217021610.12801-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211217021610.12801-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-12-17 10:16:10 [+0800], Yajun Deng wrote:
> We found an abnormally high latency when executing modprobe raid6_pq, the
> latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
> 67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.
> 
> How to reproduce:
>  - Install cyclictest
>      sudo apt install rt-tests
>  - Run cyclictest example in one terminal
>      sudo cyclictest -S -p 95 -d 0 -i 1000 -D 24h -m
>  - Modprobe raid6_pq in another terminal
>      sudo modprobe raid6_pq
> 
> This is caused by ksoftirqd fail to scheduled due to disable preemption,
> this time is too long and unreasonable.
> 
> Reduce high latency by using migrate_disabl()/emigrate_enable() instead of
> preempt_disable()/preempt_enable(), the latency won't greater than 100us.
> 
> This patch beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no
> effect for CONFIG_PREEMPT_VOLUNTARY=y.

Why does it matter? This is only during boot-up/ module loading or do I
miss something? 
The delay is a jiffy so it depends on CONFIG_HZ. You do benchmark for
the best algorithm and if you get preempted during that period then your
results may be wrong and you make a bad selection.

You can either enable one algorithm and or disable
CONFIG_RAID6_PQ_BENCHMARK. I don't see the need for this patch not to
mention the stable tree.

Sebastian
