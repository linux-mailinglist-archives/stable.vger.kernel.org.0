Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE12435E5AE
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 19:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbhDMRya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 13:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345824AbhDMRyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 13:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B65461249;
        Tue, 13 Apr 2021 17:53:58 +0000 (UTC)
Date:   Tue, 13 Apr 2021 19:53:55 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Rodrigo Campos <rodrigo@kinvolk.io>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Sargun Dhillon <sargun@sargun.me>,
        Mauricio =?utf-8?Q?V=C3=A1squez?= Bernal <mauricio@kinvolk.io>,
        Alban Crequy <alban@kinvolk.io>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] seccomp: Always "goto wait" if the list is empty
Message-ID: <20210413175355.kttgdouoyiykug5i@wittgenstein>
References: <20210413160151.3301-1-rodrigo@kinvolk.io>
 <20210413160151.3301-2-rodrigo@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210413160151.3301-2-rodrigo@kinvolk.io>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 06:01:51PM +0200, Rodrigo Campos wrote:
> It is possible for the thread with the seccomp filter attached (target)
> to be waken up by an addfd message, but the list be empty. This happens
> when the addfd ioctl on the other side (seccomp agent) is interrupted by
> a signal such as SIGURG. In that case, the target erroneously and
> prematurely returns from the syscall to userspace even though the
> seccomp agent didn't ask for it.
> 
> This happens in the following scenario:
> 
> seccomp_notify_addfd()                                           | seccomp_do_user_notification()
>                                                                  |
>                                                                  |  err = wait_for_completion_interruptible(&n.ready);
>  complete(&knotif->ready);                                       |
>  ret = wait_for_completion_interruptible(&kaddfd.completion);    |
>  // interrupted                                                  |
>                                                                  |
>  mutex_lock(&filter->notify_lock);                               |
>  list_del(&kaddfd.list);                                         |
>  mutex_unlock(&filter->notify_lock);                             |
>                                                                  |  mutex_lock(&match->notify_lock);
>                                                                  |  // This is false, addfd is false
>                                                                  |  if (addfd && n.state != SECCOMP_NOTIFY_REPLIED)
>                                                                  |
>                                                                  |  ret = n.val;
>                                                                  |  err = n.error;
>                                                                  |  flags = n.flags;
> 
> So, the process blocked in seccomp_do_user_notification() will see a
> response. As n is 0 initialized and wasn't set, it will see a 0 as
> return value from the syscall.
> 
> The seccomp agent, when retrying the interrupted syscall, will see an
> ENOENT error as the notification no longer exists (it was already
> answered by this bug).
> 
> This patch fixes the issue by splitting the if in two parts: if we were
> woken up and the state is not replied, we will always do a "goto wait".
> And if that happens and there is an addfd element on the list, we will
> add the fd before "goto wait".
> 
> This issue is present since 5.9, when addfd was added.
> 
> Fixes: 7cf97b1254550
> Cc: stable@vger.kernel.org # 5.9+
> Signed-off-by: Rodrigo Campos <rodrigo@kinvolk.io>
> ---

So the agent will see the return value from
wait_for_completion_interruptible() and know that the addfd wasn't
successful and the target will notice that no addfd request has actually
been added and essentially try again. Seems like a decent fix and can be
backported cleanly. I assume seccomp testsuite passes.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
