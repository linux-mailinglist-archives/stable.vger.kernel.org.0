Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D71BDEBF8
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 14:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfJUMTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 08:19:06 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42415 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfJUMTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 08:19:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id z12so9903358lfj.9
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JNOM4Pg0n8Q4UqLt3Kh0p/niTCV+End7za47n4/6Ktg=;
        b=UNEfoqJSjHmG0+iNd+CHQt8KffLkhlNrReI8ER0SN3uGr4sAv282oSQFllCK1GufFa
         zhyeCzPVuEfYjLiYUz65wwf4KY0lcSxLiBZfhClN0nM4F+d1yXzwkBXnW56H1nx2orKR
         9lHhBafiS+qfKOKzY/Sz5Y0Vu8kmm9SZea1bw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JNOM4Pg0n8Q4UqLt3Kh0p/niTCV+End7za47n4/6Ktg=;
        b=Cq5cI4nZl9akv6xXTASuBZoJNWcGrOcqcyE716hUsuGCRQA+ItrfD0glWQnl6LZImc
         sFXrTa3ukGcNIOb5LzkWn6x3wjJMuXbTlusBbbSVcLR4FnvtxmlwxK6FR9NOGQ5T3lBV
         mEekZwaMQ1NYW2t7qIlTWj0DvmxxcOEo8V9KyekVZZevYwgzZvpuDqz0fmusp11BfzuH
         gU5bf2khMolOYiy+btcTCnYRtSxMxF+1eYfaLgX1Fnb/Gvg9eHeiMbc6eWbw6igqUd57
         gZWV0vEH4BsRn1MHfYA0IxrqraAwCA/+4jp4R+Advp3w5ioFemg9VXRdSraHMtijMQMK
         KLoA==
X-Gm-Message-State: APjAAAUy0FaLbhzNiW9rYBQkSYFwkUqUCHgWhfOo4H1tN+Fle5rjAB6t
        9WyMdzP5TWsASJFtwTv1ESRFsQ==
X-Google-Smtp-Source: APXvYqwt2eM1kZ85F15jYxbBeCLzCU2TXQeJLonX186jbNS9UUkduoKUyAQHXJVB71RH+jbnqv8GOQ==
X-Received: by 2002:ac2:484e:: with SMTP id 14mr8022102lfy.184.1571660343384;
        Mon, 21 Oct 2019 05:19:03 -0700 (PDT)
Received: from [172.16.11.28] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id r19sm6810718ljd.95.2019.10.21.05.19.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 05:19:02 -0700 (PDT)
Subject: Re: [PATCH v6] taskstats: fix data-race
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org
Cc:     bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        parri.andrea@gmail.com, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <efaecf5d-b528-24ba-1955-e1b190ece98c@rasmusvillemoes.dk>
Date:   Mon, 21 Oct 2019 14:19:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021113327.22365-1-christian.brauner@ubuntu.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/10/2019 13.33, Christian Brauner wrote:
> The first approach used smp_load_acquire() and smp_store_release().
> However, after having discussed this it seems that the data dependency
> for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> Furthermore, the smp_load_acquire() would only manage to order the stats
> check before the thread_group_empty() check. So it seems just using
> READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> up for discussion at least.
> 
> /* v6 */
> - Christian Brauner <christian.brauner@ubuntu.com>:
>   - bring up READ_ONCE()/WRITE_ONCE() approach for discussion
> ---
>  kernel/taskstats.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 13a0f2e6ebc2..111bb4139aa2 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -554,25 +554,29 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
> -	struct taskstats *stats;
> +	struct taskstats *stats_new, *stats;
>  
> -	if (sig->stats || thread_group_empty(tsk))
> -		goto ret;
> +	/* Pairs with WRITE_ONCE() below. */
> +	stats = READ_ONCE(sig->stats);
> +	if (stats || thread_group_empty(tsk))
> +		return stats;
>  
>  	/* No problem if kmem_cache_zalloc() fails */
> -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
>  
>  	spin_lock_irq(&tsk->sighand->siglock);
> -	if (!sig->stats) {
> -		sig->stats = stats;
> -		stats = NULL;
> +	if (!stats) {
> +		stats = stats_new;
> +		/* Pairs with READ_ONCE() above. */
> +		WRITE_ONCE(sig->stats, stats_new);
> +		stats_new = NULL;

No idea about the memory ordering issues, but don't you need to
load/check sig->stats again? Otherwise it seems that two threads might
both see !sig->stats, both allocate a stats_new, and both
unconditionally in turn assign their stats_new to sig->stats. Then the
first assignment ends up becoming a memory leak (and any writes through
that pointer done by the caller end up in /dev/null...)

Rasmus
