Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6FD338EBB
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCLN0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhCLN0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 08:26:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC21A64F70;
        Fri, 12 Mar 2021 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615555595;
        bh=6+yq/fh98KG2tk+iUkCDYYsnXXXG791saZHy/yFzcic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wahbby+XZCJwMS5jQQBs9/BOKxHu6kyOkcu+UnYfUvPzgBxyx/LOuZSFGn66VST5d
         ybnx9T7M4RL4PTvR4GfP28uFP7o5tN/C8iXBd/7SgoHYAyy860rotxRqveSPj0tWw3
         wXT6p2VhYAxozLI4uDT6ZdhvEb2QxONtMVtTP4ac=
Date:   Fri, 12 Mar 2021 14:26:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     lee.jones@linaro.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 v2 0/3] Backport patch series to update Futex from 4.9
Message-ID: <YEtsCMXN1XeQnkI5@kroah.com>
References: <20210311032600.2326035-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311032600.2326035-1-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 11:25:57AM +0800, Zheng Yejian wrote:
> Changelog for 'v2':
>   Complete commit messages with needed git commit ids as Greg and Lee suggested.
> 
> Lee sent a patchset to update Futex for v4.9, see https://www.spinics.net/lists/stable/msg443081.html,
> Then Xiaoming sent a follow-up patch for it, see https://lore.kernel.org/lkml/20210225093120.GD641347@dell/.
> 
> These 3 patches is directly picked from v4.9,
> and they may also resolve following issues in 4.4.260 which have been reported in v4.9,
> see https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/?h=linux-4.4.y&id=319f66f08de1083c1fe271261665c209009dd65a
>       > /*
>       >  * The task is on the way out. When the futex state is
>       >  * FUTEX_STATE_DEAD, we know that the task has finished
>       >  * the cleanup:
>       >  */
>       > int ret = (p->futex_state = FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
> 
>     Here may be:
>       int ret = (p->futex_state == FUTEX_STATE_DEAD) ? -ESRCH : -EAGAIN;
> 
>       > raw_spin_unlock_irq(&p->pi_lock);
>       > /*
>       >  * If the owner task is between FUTEX_STATE_EXITING and
>       >  * FUTEX_STATE_DEAD then store the task pointer and keep
>       >  * the reference on the task struct. The calling code will
>       >  * drop all locks, wait for the task to reach
>       >  * FUTEX_STATE_DEAD and then drop the refcount. This is
>       >  * required to prevent a live lock when the current task
>       >  * preempted the exiting task between the two states.
>       >  */
>       > if (ret == -EBUSY)
> 
>     And here, the variable "ret" may only be "-ESRCH" or "-EAGAIN", but not "-EBUSY".
> 
>       > 	*exiting = p;
>       > else
>       > 	put_task_struct(p);
> 
> Since 074e7d515783 ("futex: Ensure the correct return value from futex_lock_pi()") has
> been merged in 4.4.260, I send the remain 3 patches.
> 
> Peter Zijlstra (1):
>   futex: Change locking rules
> 
> Thomas Gleixner (2):
>   futex: Cure exit race
>   futex: fix dead code in attach_to_pi_owner()
> 
>  kernel/futex.c | 209 +++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 177 insertions(+), 32 deletions(-)

All now queued up, thanks.

greg k-h
