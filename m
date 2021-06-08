Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A76D39FCF7
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhFHRB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231278AbhFHRBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 13:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D1A6127A;
        Tue,  8 Jun 2021 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623171602;
        bh=MGTjEsbHHtQ5dXtofP3PqcBOvTNIU67ENC6BugNi1F8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v8mk4S6at4juVJukoktzocO5mEU8lY0hCl4ezQZ2/uy9uCYd21pb/M/W32T/BVPbv
         x1r8DQzg42LeqrR339UVxu2lw+lpbZ6KjqUbh6yBz+Xr3ASpjMbPF8Y3LtxP8YGXnN
         TbO5dTAzYEgP7rtiKAomXdj142Ah2KqKt9gQ8I6o=
Date:   Tue, 8 Jun 2021 19:00:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Wei <yang.wei@linux.alibaba.com>
Cc:     stable@vger.kernel.org, Yang Wei <albin.yangwei@alibaba-inc.com>
Subject: Re: [PATCH v2 4.14] sched/fair: Optimize select_idle_cpu
Message-ID: <YL+iEJ+zKXaRpZbh@kroah.com>
References: <1623074283-34764-1-git-send-email-yang.wei@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623074283-34764-1-git-send-email-yang.wei@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 07, 2021 at 09:58:03PM +0800, Yang Wei wrote:
> From: Cheng Jian <cj.chengjian@huawei.com>
> 
> commit 60588bfa223ff675b95f866249f90616613fbe31 upstream.
> 
> select_idle_cpu() will scan the LLC domain for idle CPUs,
> it's always expensive. so the next commit :
> 
>     1ad3aaf3fcd2 ("sched/core: Implement new approach to scale select_idle_cpu()")
> 
> introduces a way to limit how many CPUs we scan.
> 
> But it consume some CPUs out of 'nr' that are not allowed
> for the task and thus waste our attempts. The function
> always return nr_cpumask_bits, and we can't find a CPU
> which our task is allowed to run.
> 
> Cpumask may be too big, similar to select_idle_core(), use
> per_cpu_ptr 'select_idle_mask' to prevent stack overflow.
> 
> Fixes: 1ad3aaf3fcd2 ("sched/core: Implement new approach to scale select_idle_cpu()")
> Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
> Link: https://lkml.kernel.org/r/20191213024530.28052-1-cj.chengjian@huawei.com
> Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
> Tested-by: Yang Wei <yang.wei@linux.alibaba.com>
> ---
>  kernel/sched/fair.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Both now queued up, thanks.

greg k-h
