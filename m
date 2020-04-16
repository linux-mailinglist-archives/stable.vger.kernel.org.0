Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71101AB614
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbgDPDGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:06:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E8F2072D;
        Thu, 16 Apr 2020 03:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587006371;
        bh=QdOIPJY37z5Bhj4Kb2AzpT4wuAiIaN//bJlmctjnngc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+jn1KGlBReCwH81hhdMZNqyzRTTQd76zW4AqNmVUjYm/0LPYnxYPO9BMyZFXL6qd
         2OrTAaagXn7eypwapFCvql0WgMUiYaatZnXEqSS4dMmI5XUREauhP0iCCeJmCJMNTo
         hPs1+wJCsdkcNvdPucf23OGskmYON7XN4kqn0KgA=
Date:   Wed, 15 Apr 2020 23:06:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     peterz@infradead.org, mingo@kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] perf/core: Fix event cgroup tracking"
 failed to apply to 5.6-stable tree
Message-ID: <20200416030609.GC1068@sasha-vm>
References: <1586950934055@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1586950934055@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 01:42:14PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.6-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 33238c50451596be86db1505ab65fee5172844d0 Mon Sep 17 00:00:00 2001
>From: Peter Zijlstra <peterz@infradead.org>
>Date: Wed, 18 Mar 2020 20:33:37 +0100
>Subject: [PATCH] perf/core: Fix event cgroup tracking
>
>Song reports that installing cgroup events is broken since:
>
>  db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
>
>The problem being that cgroup events try to track cpuctx->cgrp even
>for disabled events, which is pointless and actively harmful since the
>above commit. Rework the code to have explicit enable/disable hooks
>for cgroup events, such that we can limit cgroup tracking to active
>events.
>
>More specifically, since the above commit disabled events are no
>longer added to their context from the 'right' CPU, and we can't
>access things like the current cgroup for a remote CPU.
>
>Cc: <stable@vger.kernel.org> # v5.5+
>Fixes: db0503e4f675 ("perf/core: Optimize perf_install_in_event()")
>Reported-by: Song Liu <songliubraving@fb.com>
>Tested-by: Song Liu <songliubraving@fb.com>
>Reviewed-by: Song Liu <songliubraving@fb.com>
>Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>Signed-off-by: Ingo Molnar <mingo@kernel.org>
>Link: https://lkml.kernel.org/r/20200318193337.GB20760@hirez.programming.kicks-ass.net

I've also grabbed ab6f824cfdf7 ("perf/core: Unify
{pinned,flexible}_sched_in()") and 2c2366c7548e ("perf/core: Remove
'struct sched_in_data'"), and queued both for 5.6 and 5.5.

-- 
Thanks,
Sasha
