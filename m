Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B8947DE20
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 04:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbhLWDkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 22:40:19 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39430 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242010AbhLWDkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 22:40:19 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3273C1F389;
        Thu, 23 Dec 2021 03:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640230818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqEZj9Ynr/lqpqMDeWnJrddzDJzzUwUUL4YhGemGfck=;
        b=IV/WUm1fBoiYdBwrSp2P/Exxjz7+M8A0KBktN+Q6PINaQSXSJ3M3DkR2oncJhBjshPhLzV
        R2jTbgGqrG4tLzzmxLnfw9LoJN6EcM5+5CHChoURXTyPUOCLLN2fmizTK/CxXehUzerHQo
        d6Afg2nQhOK3N5/6/5uwi3l2A4uEJnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640230818;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqEZj9Ynr/lqpqMDeWnJrddzDJzzUwUUL4YhGemGfck=;
        b=X3qOzB6A00iA3cyRoaZcVJx80gcRq40FRxMPs6Zqn1PAcVLZUCvPkeFfSPtZejBjPWn853
        Fqu58iLot6ZwsJBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1702F13E39;
        Thu, 23 Dec 2021 03:40:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BpsDBaLvw2G2DQAAMHmgww
        (envelope-from <dbueso@suse.de>); Thu, 23 Dec 2021 03:40:18 +0000
MIME-Version: 1.0
Date:   Wed, 22 Dec 2021 19:40:17 -0800
From:   Davidlohr Bueso <dbueso@suse.de>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, unixbhaskar@gmail.com,
        chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org, mhocko@kernel.org,
        willy@infradead.org, vbabka@suse.cz
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
In-Reply-To: <20211222194828.15320-1-manfred@colorfullife.com>
References: <20211222194828.15320-1-manfred@colorfullife.com>
User-Agent: Roundcube Webmail
Message-ID: <a3212f020c7e8e2efbeffbb5e0a02424@suse.de>
X-Sender: dbueso@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cc'ing more mm folks.

On 2021-12-22 11:48, Manfred Spraul wrote:
> One codepath in find_alloc_undo() calls kvfree() while holding a 
> spinlock.
> Since vfree() can sleep this is a bug.

afaict the only other offender is devx_async_cmd_event_destroy_uobj(), 
in drivers/infiniband/hw/mlx5/devx.c. I was expecting to find more, 
actually.

> Previously, the code path used kfree(), and kfree() is safe to be 
> called
> while holding a spinlock.
> 
> Minghao proposed to fix this by updating find_alloc_undo().
> 
> Alternate proposal to fix this: Instead of changing find_alloc_undo(),
> change kvfree() so that the same rules as for kfree() apply:
> Having different rules for kfree() and kvfree() just asks for bugs.

I agree that it is best to have the same atomic semantics across all 
family of calls.

> 
> Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.

I would not expect the added latency to be a big deal unless under 
serious memory pressure, for which case things are already fragile to 
begin with. Furthermore users of kvfree() are already warned that this 
is the slower choice. Feel free to add my:

Acked-by: Davidlohr Bueso <dbueso@suse.de>

> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Reported-by: Minghao Chi <chi.minghao@zte.com.cn>
> Link:
> https://lore.kernel.org/all/20211222081026.484058-1-chi.minghao@zte.com.cn/
> Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo 
> allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  mm/util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 741ba32a43ac..7f9181998835 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
>   * It is slightly more efficient to use kfree() or vfree() if you are 
> certain
>   * that you know which one to use.
>   *
> - * Context: Either preemptible task context or not-NMI interrupt.
> + * Context: Any context except NMI interrupt.
>   */
>  void kvfree(const void *addr)
>  {
>  	if (is_vmalloc_addr(addr))
> -		vfree(addr);
> +		vfree_atomic(addr);
>  	else
>  		kfree(addr);
>  }
