Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C66CD511
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfJFRcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbfJFRcF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:05 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F13E52133F;
        Sun,  6 Oct 2019 17:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383124;
        bh=y24o64+df+bFr+XImQr+ZOI4HN+DUwtAyK/fL7vJzEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=121vaGNXc5JT+w6LQYymQyiF+FborDuGpo6Ui2V0O43iWVlulxml28rUZ13kv/E4a
         DoNY6rdxiTSf83cnUFu8sVhH6pPl62muoxkHCqy63gRp2TFT6A2hy4tpfwJhFuJOs5
         8TJVRrxgdx+3GePIn8QezPRMNO+sIq8nuisUinns=
Date:   Sun, 6 Oct 2019 10:32:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martijn Coenen <maco@android.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mattias Nissler <mnissler@chromium.org>
Subject: Re: [PATCH 4.9 30/47] ANDROID: binder: remove waitqueue when thread
 exits.
Message-ID: <20191006173202.GA832@sol.localdomain>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martijn Coenen <maco@android.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mattias Nissler <mnissler@chromium.org>
References: <20191006172016.873463083@linuxfoundation.org>
 <20191006172018.480360174@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006172018.480360174@linuxfoundation.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 06, 2019 at 07:21:17PM +0200, Greg Kroah-Hartman wrote:
> From: Martijn Coenen <maco@android.com>
> 
> commit f5cb779ba16334b45ba8946d6bfa6d9834d1527f upstream.
> 
> binder_poll() passes the thread->wait waitqueue that
> can be slept on for work. When a thread that uses
> epoll explicitly exits using BINDER_THREAD_EXIT,
> the waitqueue is freed, but it is never removed
> from the corresponding epoll data structure. When
> the process subsequently exits, the epoll cleanup
> code tries to access the waitlist, which results in
> a use-after-free.
> 
> Prevent this by using POLLFREE when the thread exits.
> 
> Signed-off-by: Martijn Coenen <maco@android.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: stable <stable@vger.kernel.org> # 4.14
> [backport BINDER_LOOPER_STATE_POLL logic as well]
> Signed-off-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/android/binder.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -334,7 +334,8 @@ enum {
>  	BINDER_LOOPER_STATE_EXITED      = 0x04,
>  	BINDER_LOOPER_STATE_INVALID     = 0x08,
>  	BINDER_LOOPER_STATE_WAITING     = 0x10,
> -	BINDER_LOOPER_STATE_NEED_RETURN = 0x20
> +	BINDER_LOOPER_STATE_NEED_RETURN = 0x20,
> +	BINDER_LOOPER_STATE_POLL	= 0x40,
>  };
>  
>  struct binder_thread {
> @@ -2628,6 +2629,18 @@ static int binder_free_thread(struct bin
>  		} else
>  			BUG();
>  	}
> +
> +	/*
> +	 * If this thread used poll, make sure we remove the waitqueue
> +	 * from any epoll data structures holding it with POLLFREE.
> +	 * waitqueue_active() is safe to use here because we're holding
> +	 * the inner lock.
> +	 */
> +	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
> +	    waitqueue_active(&thread->wait)) {
> +		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
> +	}
> +
>  	if (send_reply)
>  		binder_send_failed_reply(send_reply, BR_DEAD_REPLY);
>  	binder_release_work(&thread->todo);
> @@ -2651,6 +2664,8 @@ static unsigned int binder_poll(struct f
>  		return POLLERR;
>  	}
>  
> +	thread->looper |= BINDER_LOOPER_STATE_POLL;
> +
>  	wait_for_proc_work = thread->transaction_stack == NULL &&
>  		list_empty(&thread->todo) && thread->return_error == BR_OK;
>  

Are you sure this backport is correct, given that in 4.9, binder_poll()
sometimes uses proc->wait instead of thread->wait?:

        wait_for_proc_work = thread->transaction_stack == NULL &&
                list_empty(&thread->todo) && thread->return_error == BR_OK;

        binder_unlock(__func__);

        if (wait_for_proc_work) {
                if (binder_has_proc_work(proc, thread))
                        return POLLIN;
                poll_wait(filp, &proc->wait, wait);
                if (binder_has_proc_work(proc, thread))
                        return POLLIN;
        } else {
                if (binder_has_thread_work(thread))
                        return POLLIN;
                poll_wait(filp, &thread->wait, wait);
                if (binder_has_thread_work(thread))
                        return POLLIN;
        }
        return 0;
