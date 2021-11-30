Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F481462E8E
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbhK3Iez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239620AbhK3Iew (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 03:34:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B33C061574;
        Tue, 30 Nov 2021 00:31:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 343BDCE177F;
        Tue, 30 Nov 2021 08:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6503C53FC1;
        Tue, 30 Nov 2021 08:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638261089;
        bh=G/bO99DLyVgDYcVZ5AqMf3Q9oOZPja6owwuhR6P4I8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=HLgoXX4dAKKIC1kR5QMAVi5afXrggufevRAEsKAQiC/kzHIELoZyvzBsbMsLDr5Ok
         0fzB6VW9RwWIIa+hdAoFz+OBf2DbVZ3oF2AeP0ay7H7Sr7TxQM4GUehAlHS8wEtdBk
         RtLDv5MI6RXuT4fjSMzoqTcjtoSlyHaDxQ9erGZ2MkdGGgQw27Z/d6B3J2M/Pd2/ya
         hTUIWY4py+5UmpZWkc8XTkbLFhqFl6uJn8UNHHQiJqqlW8QtFeE2sbjsSe65c+Jrty
         FAiRGpcTVEg1dxlhkbmrdqfuRYpTlTV0bD1zmCZXHbLzbhlUuBzGWu1CZRp74U0BV5
         CRPuwngxVFrew==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     john.stultz@linaro.org, mm-commits@vger.kernel.org,
        oleksandr@natalenko.name, sj@kernel.org, stable@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: + timers-implement-usleep_idle_range.patch added to -mm tree
Date:   Tue, 30 Nov 2021 08:31:25 +0000
Message-Id: <20211130083125.14954-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211127235653.NOYYrId5C%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Andrew,

On Sat, 27 Nov 2021 15:56:53 -0800 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Subject: timers: implement usleep_idle_range()
> has been added to the -mm tree.  Its filename is
>      timers-implement-usleep_idle_range.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/timers-implement-usleep_idle_range.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/timers-implement-usleep_idle_range.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: SeongJae Park <sj@kernel.org>
> Subject: timers: implement usleep_idle_range()
> 
> Patch series "mm/damon: Fix fake /proc/loadavg reports", v3.
> 
> This patchset fixes DAMON's fake load report issue.  The first patch makes
> yet another variant of usleep_range() for this fix, and the second patch
> fixes the issue of DAMON by making it using the newly introduced function.
> 
> 
> This patch (of 2):
> 
> Some kernel threads such as DAMON could need to repeatedly sleep in micro
> seconds level.  Because usleep_range() sleeps in uninterruptible state,
> however, such threads would make /proc/loadavg reports fake load.
> 
> To help such cases, this commit implements a variant of usleep_range()
> called usleep_idle_range().  It is same to usleep_range() but sets the
> state of the current task as TASK_IDLE while sleeping.
> 
> Link: https://lkml.kernel.org/r/20211126145015.15862-1-sj@kernel.org
> Link: https://lkml.kernel.org/r/20211126145015.15862-2-sj@kernel.org
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Thank you for picking this patch series.  Could you please also add
'Tested-by:' tags for Oleksandr[1]?

[1] https://lore.kernel.org/linux-mm/51190182.RbnaydPRjS@natalenko.name/


Thanks,
SJ

> ---
> 
>  include/linux/delay.h |   14 +++++++++++++-
>  kernel/time/timer.c   |   16 +++++++++-------
>  2 files changed, 22 insertions(+), 8 deletions(-)
