Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2876759D6
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 17:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjATQXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 11:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjATQXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 11:23:52 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556E18B33C;
        Fri, 20 Jan 2023 08:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OdOOh6S7JZ6WpzcIu6Ln2+FzF5CWHFaOfQ2iqywhwqI=; b=TM6dW0xDnyF6VGq8WKjA3Eo/Ue
        zzkbVqz0xRBQgzhqREEYsphkVV+fzqkNO7S0Su5Y4ldyJP5bsak2yUhRxSG4z1JbybhLm9wjUV/yj
        VpsjhOFAMgVyoWO4sCAxAYVgaIP/u7PSiICLrEAeThiBbMBdKl1XOmMIZi1DTutXKVADDH4hxIY1A
        MvO1ZoBw1u+Rzt5ArKpOZHCB2gjlI95XDFjW7zqvi66k0EbTz22vmD11mu2bosfJRCoEGCtxg3OMG
        22N/nMk0wI3De4ZBtOYVHClVrVxVGCDGqlVh16/RjRaw8Hi/yehAh2oWumn+ylotRG/myot+LpwMU
        njDdNDbw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pIuA1-000jM7-19;
        Fri, 20 Jan 2023 16:22:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D681A300033;
        Fri, 20 Jan 2023 17:23:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BC92A20DC0E8E; Fri, 20 Jan 2023 17:23:02 +0100 (CET)
Date:   Fri, 20 Jan 2023 17:23:02 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
Cc:     mingo@redhat.com, will@kernel.org, longman@redhat.com,
        boqun.feng@gmail.com, akpm@osdl.org, arjan@linux.intel.com,
        tglx@linutronix.de, joel@joelfernandes.org, paulmck@kernel.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <Y8q/5hgXrvOp6vku@hirez.programming.kicks-ass.net>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 20, 2023 at 02:55:25PM +0100, Hernan Ponce de Leon wrote:
> From: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> 
> Following the defition of data race in
> tools/memory-model/linux-kernel.cat the dartagnan tool
> https://github.com/hernanponcedeleon/Dat3M
> reported a race between mark_rt_mutex_waiters and rt_mutex_cmpxchg_release.
> 
> Commit 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
> later removed in commit d0aa7a70bf03 ("futex_requeue_pi optimization")
> and reverted in commit bd197234b0a6
> ("Revert "futex_requeue_pi optimization"")
> 
> The original commit introduced the data race.
> 
> Cc: stable@vger.kernel.org # v2.6.18.x
> Fixes: 23f78d4a03c5 ("[PATCH] pi-futex: rt mutex core")
> Signed-off-by: Hernan Ponce de Leon <hernanl.leon@huawei.com>
> ---
>  kernel/locking/rtmutex.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index 010cf4e6d0b8..7ed9472edd48 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -235,7 +235,7 @@ static __always_inline void mark_rt_mutex_waiters(struct rt_mutex_base *lock)
>  	unsigned long owner, *p = (unsigned long *) &lock->owner;
>  
>  	do {
> -		owner = *p;
> +		owner = READ_ONCE(*p);
>  	} while (cmpxchg_relaxed(p, owner,
>  				 owner | RT_MUTEX_HAS_WAITERS) != owner);
>  

Can't we replace the whole of that function with:

	set_bit(0, (unsigned long *)&lock->owner);

?
