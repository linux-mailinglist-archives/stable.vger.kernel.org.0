Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0E383139
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhEQOf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:35:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:42578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239505AbhEQOcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:32:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621261864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xYuVntA3/R/ZCitOay3lqoXYi06Ia6ssKRAW0I+ZVEQ=;
        b=onF0H9B9bQCdRewBj3vytxij9z4KTsIYSNxSqcecKyQPRdrOAi3efgEfmkDESl/9FsDWVo
        6+qrRVNjhH/qaue35jXNjD2juuBvyrIgFtkt2fBMIAQAMnidxKaXFBXxmaXC4bwdlogYh9
        E+4coHG6PiyCc5dDwMBVb6U+ubsV3Ac=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 03E4EB275;
        Mon, 17 May 2021 14:31:03 +0000 (UTC)
Date:   Mon, 17 May 2021 16:30:56 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 123/363] watchdog: cleanup handling of false
 positives
Message-ID: <YKJ+INpik2i9IhZN@alley>
References: <20210517140302.508966430@linuxfoundation.org>
 <20210517140306.783130885@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140306.783130885@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 2021-05-17 15:59:49, Greg Kroah-Hartman wrote:
> From: Petr Mladek <pmladek@suse.com>
> 
> [ Upstream commit 9bf3bc949f8aeefeacea4b1198db833b722a8e27 ]
> 
> Commit d6ad3e286d2c ("softlockup: Add sched_clock_tick() to avoid kernel
> warning on kgdb resume") introduced touch_softlockup_watchdog_sync().

[...]

> Make the code more straightforward:
> 
> 1. Always call kvm_check_and_clear_guest_paused() at the very
>    beginning to handle PVCLOCK_GUEST_STOPPED. It touches the watchdog
>    when the quest did sleep.
> 
> 2. Handle the situation when the watchdog has been touched
>    (SOFTLOCKUP_DELAY_REPORT is set).
> 
>    Call sched_clock_tick() when touch_*sync() variant was used. It makes
>    sure that the timestamp will be up to date even when it has been
>    touched in atomic context or quest did sleep.
> 
> As a result, kvm_check_and_clear_guest_paused() is called on a single
> location.  And the right timestamp is always set when returning from the
> timer callback.
> 
> Link: https://lkml.kernel.org/r/20210311122130.6788-7-pmladek@suse.com

Please, remove this patch from the stable backport. It might
cause false softlockup reports, see
https://lore.kernel.org/r/20210517140612.222750-1-senozhatsky@chromium.org

Best Regards,
Petr
