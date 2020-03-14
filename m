Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384051858E2
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 03:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgCOCYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Mar 2020 22:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbgCOCYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Mar 2020 22:24:14 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA26C20769;
        Sat, 14 Mar 2020 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584195218;
        bh=L8RVgnEKozf2OQmJw+t4fLoFpdLCp+7AYN1Vu6zk8jI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=J9KePryMs/Tjku3Wl1SbfaWgXJPSj4xCe8II/IHJVxv1EXwo7ibqNlbfFRyg7BEBd
         lW3WES75XwiXVgX18Y0x1r/WJNIZId6ZZi3JB5YQ4UDas9DuXELcmS6c9iGvbWYtNT
         7OU2PPAuD6SZkHxRXCilHudSIgPzhE/YUO3N2ocg=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A8DE035226D7; Sat, 14 Mar 2020 07:13:38 -0700 (PDT)
Date:   Sat, 14 Mar 2020 07:13:38 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     chris@chris-wilson.co.uk, David.Laight@ACULAB.COM,
        elver@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, stable@vger.kernel.org
Subject: Re: + list-prevent-compiler-reloads-inside-safe-list-iteration.patch
 added to -mm tree
Message-ID: <20200314141338.GM3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
 <20200312025809.80ZDC8y7j%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312025809.80ZDC8y7j%akpm@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 07:58:09PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
> has been added to the -mm tree.  Its filename is
>      list-prevent-compiler-reloads-inside-safe-list-iteration.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/list-prevent-compiler-reloads-inside-safe-list-iteration.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/list-prevent-compiler-reloads-inside-safe-list-iteration.patch
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
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
> 
> Instruct the compiler to read the next element in the list iteration
> once, and that it is not allowed to reload the value from the stale
> element later. This is important as during the course of the safe
> iteration, the stale element may be poisoned (unbeknownst to the
> compiler).
> 
> This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
> list elements during list_for_each_entry_safe() and friends.
> 
> Link: http://lkml.kernel.org/r/20200310092119.14965-1-chris@chris-wilson.co.uk
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

One possible concern is that we are overloading the suffix "_safe()",
but that looks better to me than yet another explosion of this API.
It would be good to have uses, of course.

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
> 
>  include/linux/list.h |   50 +++++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 14 deletions(-)
> 
> --- a/include/linux/list.h~list-prevent-compiler-reloads-inside-safe-list-iteration
> +++ a/include/linux/list.h
> @@ -537,6 +537,17 @@ static inline void list_splice_tail_init
>  	list_entry((pos)->member.next, typeof(*(pos)), member)
>  
>  /**
> + * list_next_entry_safe - get the next element in list [once]
> + * @pos:	the type * to cursor
> + * @member:	the name of the list_head within the struct.
> + *
> + * Like list_next_entry() but prevents the compiler from reloading the
> + * next element.
> + */
> +#define list_next_entry_safe(pos, member) \
> +	list_entry(READ_ONCE((pos)->member.next), typeof(*(pos)), member)
> +
> +/**
>   * list_prev_entry - get the prev element in list
>   * @pos:	the type * to cursor
>   * @member:	the name of the list_head within the struct.
> @@ -545,6 +556,17 @@ static inline void list_splice_tail_init
>  	list_entry((pos)->member.prev, typeof(*(pos)), member)
>  
>  /**
> + * list_prev_entry_safe - get the prev element in list [once]
> + * @pos:	the type * to cursor
> + * @member:	the name of the list_head within the struct.
> + *
> + * Like list_prev_entry() but prevents the compiler from reloading the
> + * previous element.
> + */
> +#define list_prev_entry_safe(pos, member) \
> +	list_entry(READ_ONCE((pos)->member.prev), typeof(*(pos)), member)
> +
> +/**
>   * list_for_each	-	iterate over a list
>   * @pos:	the &struct list_head to use as a loop cursor.
>   * @head:	the head for your list.
> @@ -686,9 +708,9 @@ static inline void list_splice_tail_init
>   */
>  #define list_for_each_entry_safe(pos, n, head, member)			\
>  	for (pos = list_first_entry(head, typeof(*pos), member),	\
> -		n = list_next_entry(pos, member);			\
> +		n = list_next_entry_safe(pos, member);			\
>  	     &pos->member != (head); 					\
> -	     pos = n, n = list_next_entry(n, member))
> +	     pos = n, n = list_next_entry_safe(n, member))
>  
>  /**
>   * list_for_each_entry_safe_continue - continue list iteration safe against removal
> @@ -700,11 +722,11 @@ static inline void list_splice_tail_init
>   * Iterate over list of given type, continuing after current point,
>   * safe against removal of list entry.
>   */
> -#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
> -	for (pos = list_next_entry(pos, member), 				\
> -		n = list_next_entry(pos, member);				\
> -	     &pos->member != (head);						\
> -	     pos = n, n = list_next_entry(n, member))
> +#define list_for_each_entry_safe_continue(pos, n, head, member) 	\
> +	for (pos = list_next_entry(pos, member), 			\
> +		n = list_next_entry_safe(pos, member);			\
> +	     &pos->member != (head);					\
> +	     pos = n, n = list_next_entry_safe(n, member))
>  
>  /**
>   * list_for_each_entry_safe_from - iterate over list from current point safe against removal
> @@ -716,10 +738,10 @@ static inline void list_splice_tail_init
>   * Iterate over list of given type from current point, safe against
>   * removal of list entry.
>   */
> -#define list_for_each_entry_safe_from(pos, n, head, member) 			\
> -	for (n = list_next_entry(pos, member);					\
> -	     &pos->member != (head);						\
> -	     pos = n, n = list_next_entry(n, member))
> +#define list_for_each_entry_safe_from(pos, n, head, member) 		\
> +	for (n = list_next_entry_safe(pos, member);			\
> +	     &pos->member != (head);					\
> +	     pos = n, n = list_next_entry_safe(n, member))
>  
>  /**
>   * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
> @@ -733,9 +755,9 @@ static inline void list_splice_tail_init
>   */
>  #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
>  	for (pos = list_last_entry(head, typeof(*pos), member),		\
> -		n = list_prev_entry(pos, member);			\
> +		n = list_prev_entry_safe(pos, member);			\
>  	     &pos->member != (head); 					\
> -	     pos = n, n = list_prev_entry(n, member))
> +	     pos = n, n = list_prev_entry_safe(n, member))
>  
>  /**
>   * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
> @@ -750,7 +772,7 @@ static inline void list_splice_tail_init
>   * completing the current iteration of the loop body.
>   */
>  #define list_safe_reset_next(pos, n, member)				\
> -	n = list_next_entry(pos, member)
> +	n = list_next_entry_safe(pos, member)
>  
>  /*
>   * Double linked lists with a single pointer list head.
> _
> 
> Patches currently in -mm which might be from chris@chris-wilson.co.uk are
> 
> list-prevent-compiler-reloads-inside-safe-list-iteration.patch
> 
