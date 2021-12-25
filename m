Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF28547F4A5
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 23:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhLYW6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 17:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhLYW6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 17:58:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA75C061401;
        Sat, 25 Dec 2021 14:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jwyn7J+5HFBWS8k5TLrBn4kjmRBNmjy0LNtn6dt0gQQ=; b=jMGiaPSBzB2N/vNCwVxThESdyG
        0Km4bTq+EYMi0Mky9AHHz8cNRt+dHAg6KgVATJsAmXX1cATNJM4bSSAzrtDlXWo9qg2BjfKp81hJm
        oin5+4GT2NeGycfra81v5V5GL2coTH5OGsrVIjT15Q/ogUa3lmPPyOsFmeKbxASqq6TsVKheDvx8w
        OxIuby3T0U4mZaMt9eN0uRtwrM8KEf6r2f1FpXvmpggmgsqmZ6swhXiviq++I8y9TFNcFgcsR00X3
        2bJEV70NFPpa7YjVB97bIF5Xl6RVFEUHqfxWlAjYzbrzplFWPScqWh5MqMjSSsCNpP6yI6fBu/9mD
        4AGVMxKw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n1Fzh-006952-W0; Sat, 25 Dec 2021 22:58:30 +0000
Date:   Sat, 25 Dec 2021 22:58:29 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Uladzislau Rezki <urezki@gmail.com>
Cc:     Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, stable@vger.kernel.org
Subject: Re: [PATCH] mm/util.c: Make kvfree() safe for calling while holding
 spinlocks
Message-ID: <YceiFXyoGcgPaLeJ@casper.infradead.org>
References: <20211222194828.15320-1-manfred@colorfullife.com>
 <Ycdo1PHC9KDD8eGD@pc638.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ycdo1PHC9KDD8eGD@pc638.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 25, 2021 at 07:54:12PM +0100, Uladzislau Rezki wrote:
> +static void drain_vmap_area(struct work_struct *work)
> +{
> +	if (mutex_trylock(&vmap_purge_lock)) {
> +		__purge_vmap_area_lazy(ULONG_MAX, 0);
> +		mutex_unlock(&vmap_purge_lock);
> +	}
> +}
> +
> +static DECLARE_WORK(drain_vmap_area_work, drain_vmap_area);

Presuambly if the worker fails to get the mutex, it should reschedule
itself?  And should it even trylock or just always lock?

This kind of ties into something I've been wondering about -- we have
a number of places in the kernel which cache 'freed' vmalloc allocations
in order to speed up future allocations of the same size.  Kind of like
slab.  Would we be better off trying to cache frequent allocations
inside vmalloc instead of always purging them?

