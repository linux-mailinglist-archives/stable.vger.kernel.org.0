Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B133233C
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCIKkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhCIKkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:40:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFF964F20;
        Tue,  9 Mar 2021 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615286418;
        bh=iOalXEzWHBjoGsz8t2YH106CrmE2CuAK5/gjfNHS+wM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsH+NoaF4f8nOM0SyC8jrHu7lPRtwbLGJTmHMoccizBjeRsCsFL1yw6zXp682h+Ki
         vr3MXWAwpY+//RzGPAYb6Nbk4FA+ppwUyLUzv2lCUHBf0iD3reuQk2JAG054aHWlue
         ujOsg+5gtyKeYyd17QHaqDmG+OyhCcL+VU5WQBbc=
Date:   Tue, 9 Mar 2021 11:40:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     lee.jones@linaro.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 1/3] futex: Change locking rules
Message-ID: <YEdQkLfQR9HRobUA@kroah.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
 <20210309030605.3295183-2-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309030605.3295183-2-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 11:06:03AM +0800, Zheng Yejian wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Currently futex-pi relies on hb->lock to serialize everything. But hb->lock
> creates another set of problems, especially priority inversions on RT where
> hb->lock becomes a rt_mutex itself.
> 
> The rt_mutex::wait_lock is the most obvious protection for keeping the
> futex user space value and the kernel internal pi_state in sync.
> 
> Rework and document the locking so rt_mutex::wait_lock is held accross all
> operations which modify the user space value and the pi state.
> 
> This allows to invoke rt_mutex_unlock() (including deboost) without holding
> hb->lock as a next step.
> 
> Nothing yet relies on the new locking rules.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: juri.lelli@arm.com
> Cc: bigeasy@linutronix.de
> Cc: xlpang@redhat.com
> Cc: rostedt@goodmis.org
> Cc: mathieu.desnoyers@efficios.com
> Cc: jdesfossez@efficios.com
> Cc: dvhart@infradead.org
> Cc: bristot@redhat.com
> Link: http://lkml.kernel.org/r/20170322104151.751993333@infradead.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [Lee: Back-ported in support of a previous futex back-port attempt]
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/futex.c | 138 +++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 112 insertions(+), 26 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
