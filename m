Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB65A6D0EFF
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjC3Tmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC3Tmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9479DD512;
        Thu, 30 Mar 2023 12:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2683C61E6A;
        Thu, 30 Mar 2023 19:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C5BC433EF;
        Thu, 30 Mar 2023 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680205351;
        bh=iPgK2kOckPrF6unVEy275h6GDVcw1kRGlfXOTst5ZVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NOvAnDj6uwG3zv+/jw9mhedjmVjiRMDTTpEyyjbs2B+tSyu7hIIyugZ6KkBcT8Ok7
         IB9AaOVV6ozNS8YNlfaoL3Seeq0+1L4g0SD1+WqKuS1zHrudhTwcwpQadO6e8V2P5b
         YNwypio5hR9fQr+yNi3v2LkaFWlCjXaYVLxnRRM0=
Date:   Thu, 30 Mar 2023 12:42:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Fix memory leak on mm_init error handling
Message-Id: <20230330124230.9f3d4f63374eb15a3b990ff8@linux-foundation.org>
In-Reply-To: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
References: <20230330133822.66271-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 30 Mar 2023 09:38:22 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> introduces a memory leak by missing a call to destroy_context() when a
> percpu_counter fails to allocate.
> 
> Before introducing the per-cpu counter allocations, init_new_context()
> was the last call that could fail in mm_init(), and thus there was no
> need to ever invoke destroy_context() in the error paths. Adding the
> following percpu counter allocations adds error paths after
> init_new_context(), which means its associated destroy_context() needs
> to be called when percpu counters fail to allocate.
> 
> ...
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1171,6 +1171,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>  fail_pcpu:
>  	while (i > 0)
>  		percpu_counter_destroy(&mm->rss_stat[--i]);
> +	destroy_context(mm);
>  fail_nocontext:
>  	mm_free_pgd(mm);
>  fail_nopgd:

Is there really a leak?  I wasn't able to find a version of
init_new_context() which performs allocation.

