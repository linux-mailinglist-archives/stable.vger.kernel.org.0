Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6535C3CA192
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbhGOPlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 11:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbhGOPlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 11:41:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87786C061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 08:38:57 -0700 (PDT)
From:   John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626363534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lcE2zEAc7VzB+goAcsRtZSLQbSb/GdlSMKRDcd6Dmd0=;
        b=AF/e3xTR8tHf+wZPkKABoJsFnhWIgLFeVPwYkK0AYqgYMQLx2aR+8mxRw0CitMbrlAYSbT
        mGb3t+NAnAw8rHeNaegU3Au2TUSS+PKFSXAko0u+yw1sAeJzdKz9W+OKeJbeWoTmJl1vDW
        nv2qi2BP6O5dZNOT407dB01rxUJDUkxTer6lkICeYQUyfP35oRXv84CkkFiryDVefUkw5z
        fc910RJ7IhuZ4tpc631R8TFXyTrKl7pg1qguwTVadM3xByojGOCfO8t3FM+KJr7zyXg126
        wseoKjhj7zh0jv4zTDzbtj3tZjd0axRzOXETH5j+f0nS6sKVUg1f1LOturipHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626363534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lcE2zEAc7VzB+goAcsRtZSLQbSb/GdlSMKRDcd6Dmd0=;
        b=acChgCsUUF7wZml+x1gBV7cWbon7aGexAIxu81MS5u8x0Ht/HtTH6U3jnrfrxguQaV+o8/
        4kfvHklv6XY64LBQ==
To:     kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH tglx/in-place v1 03/21] printk/console: Check consistent sequence number when handling race in console_unlock()
In-Reply-To: <20210715152930.22959-4-john.ogness@linutronix.de>
References: <20210715152930.22959-1-john.ogness@linutronix.de> <20210715152930.22959-4-john.ogness@linutronix.de>
Date:   Thu, 15 Jul 2021 17:44:54 +0206
Message-ID: <87r1fzziwh.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Sorry, the email I am replying to was sent by accident. (I forgot to
suppress CC with git send-email.) Please disregard it.

John Ogness

On 2021-07-15, John Ogness <john.ogness@linutronix.de> wrote:
> From: Petr Mladek <pmladek@suse.com>
>
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
> The variable next_seq is marked as __maybe_unused to call down compiler
> warning when CONFIG_PRINTK is not defined.
>
> Fixes: commit 996e966640ddea7b535c ("printk: remove logbuf_lock")
> Reported-by: kernel test robot <lkp@intel.com>  # unused next_seq warning
> Cc: stable@vger.kernel.org # 5.13
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: John Ogness <john.ogness@linutronix.de>
> Link: https://lore.kernel.org/r/20210702150657.26760-1-pmladek@suse.com
> ---
>  kernel/printk/printk.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 142a58d124d9..6dad7da8f383 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2545,6 +2545,7 @@ void console_unlock(void)
>  	bool do_cond_resched, retry;
>  	struct printk_info info;
>  	struct printk_record r;
> +	u64 __maybe_unused next_seq;
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
> 2.20.1
