Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA791332341
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCIKlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:41:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230143AbhCIKlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:41:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CB6B6521B;
        Tue,  9 Mar 2021 10:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615286482;
        bh=0vcK7y3pg32LzAy/Oy1g5ZJAPur+E4E/yNHNiENuqoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uui1rd72lDfdcH8xo6n21l2pitJ41GOwvkOoveiXNE/Jc8AzwAA6WKS/2I/X0h9ZN
         7hiBdXWtbIxxMidZ2QHBuxBBvMvbaguF5EVfCoibqVE+ntR/egtfSZo+Z8APC3DlHu
         r7jHUpE65Ku27MzZXqTerKpzSUESUGCKyAGiEb8A=
Date:   Tue, 9 Mar 2021 11:41:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     lee.jones@linaro.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com, nixiaoming@huawei.com
Subject: Re: [PATCH 4.4 0/3] Backport patch series to update Futex from 4.9
Message-ID: <YEdQz4AxVRoabTW4@kroah.com>
References: <20210309030605.3295183-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309030605.3295183-1-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 11:06:02AM +0800, Zheng Yejian wrote:
> Lee sent a patchset to update Futex for 4.9, see https://www.spinics.net/lists/stable/msg443081.html,
> Then Xiaoming sent a follow-up patch for it, see https://lore.kernel.org/lkml/20210225093120.GD641347@dell/.
> 
> These patchsets may also resolve following issues in 4.4.260 which have been reported in 4.9,
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

There already are 2 futex patches in the 4.4.y stable queue, do those
not resolve these issues for you?

If not, please resend this series with the needed git commit ids added to
them.

thanks,

greg k-h
