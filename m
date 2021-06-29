Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2036E3B74A6
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 16:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbhF2Oud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 10:50:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbhF2Oua (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 10:50:30 -0400
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624978081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=USzGTUL2HeEbXU0u2M46HyI55LygDcxnaLDv/8lEJbQ=;
        b=MzmSFdxGpZaatMM+wjev7sq7KGKFSqFBr7YN6whWeUQTY38DpsCo/5H0leT8hkxfjqk9Ia
        3kWHxs9odymNxJic9sCJlhqV6ZEz6TLymQ/65Eu5dqdVpnLQ9X0P5H8B7HZmzOSDsnm6Te
        uB/clxtADI3GOq06FvomJvaECSht/t7P/XnpwlMjba7/RClFI4gQfO8/1meF9rOp6iwbHl
        eq2m2DcvWnESDjYDPoiTWlTPyC3UBWcQl/ndyVQmP8YzlMOipzx/wzXg9dzNB6k4Qs0zQ1
        FIXu7ipKyXLO8i/jrpAEjP8a3SLB1HvMou+LNH2C2s4h3ciVXCQennTJ6XL+nQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624978081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=USzGTUL2HeEbXU0u2M46HyI55LygDcxnaLDv/8lEJbQ=;
        b=JrQLzDxVj3cb7OxWkgq2qqoQP++4PqWJzfc8YnMKVHmaXp1pnjeKlCwC72PLqTf6FqADRq
        PJEahVfQt6/FeQDQ==
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when handling race in console_unlock()
In-Reply-To: <20210629143341.19284-1-pmladek@suse.com>
References: <20210629143341.19284-1-pmladek@suse.com>
Date:   Tue, 29 Jun 2021 16:54:01 +0206
Message-ID: <87zgv84ti6.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-06-29, Petr Mladek <pmladek@suse.com> wrote:
> The standard printk() tries to flush the message to the console
> immediately. It tries to take the console lock. If the lock is
> already taken then the current owner is responsible for flushing
> even the new message.
>
> There is a small race window between checking whether a new message is
> available and releasing the console lock. It is solved by re-checking
> the state after releasing the console lock. If the check is positive
> then console_unlock() tries to take the lock again and process the new
> message as well.
>
> The commit 996e966640ddea7b535c ("printk: remove logbuf_lock") causes that
> console_seq is not longer read atomically. As a result, the re-check might
> be done with an inconsistent 64-bit index.
>
> Solve it by using the last sequence number that has been checked under
> the console lock. In the worst case, it will take the lock again only
> to realized that the new message has already been proceed. But it
> was possible even before.
>
> Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
> Cc: stable@vger.kernel.org # 5.13
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Reviewed-by: John Ogness <john.ogness@linutronix.de>

Good catch.

John

> ---
>  kernel/printk/printk.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 142a58d124d9..87411084075e 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2545,6 +2545,7 @@ void console_unlock(void)
>  	bool do_cond_resched, retry;
>  	struct printk_info info;
>  	struct printk_record r;
> +	u64 next_seq;
>  
>  	if (console_suspended) {
>  		up_console_sem();
> @@ -2654,8 +2655,10 @@ void console_unlock(void)
>  			cond_resched();
>  	}
>  
> -	console_locked = 0;
> +	/* Get consistent value of the next-to-be-used sequence number. */
> +	next_seq = console_seq;
>  
> +	console_locked = 0;
>  	up_console_sem();
>  
>  	/*
> @@ -2664,7 +2667,7 @@ void console_unlock(void)
>  	 * there's a new owner and the console_unlock() from them will do the
>  	 * flush, no worries.
>  	 */
> -	retry = prb_read_valid(prb, console_seq, NULL);
> +	retry = prb_read_valid(prb, next_seq, NULL);
>  	printk_safe_exit_irqrestore(flags);
>  
>  	if (retry && console_trylock())
> -- 
> 2.26.2
