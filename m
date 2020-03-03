Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B91786BB
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 00:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgCCXyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 18:54:36 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39851 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbgCCXyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 18:54:36 -0500
Received: by mail-oi1-f195.google.com with SMTP id r16so231463oie.6
        for <stable@vger.kernel.org>; Tue, 03 Mar 2020 15:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U/AZ7U0KHmcr9QXvwZlQmeLdBD0j8SEt/BJmgUku3Ig=;
        b=BuPLToiByk/bx7Wu2BMsoB3elyNG+L/DRg5LKFbkWa6X6b0EwIvfkdejfsQ5zJmGk7
         aI0NT/6ojh5joNirrWv/cYnjAZKUHbUxjodu3BQBfXaOlnxsaDgcZmgz33RuCyOl41N6
         ApY08xTTc5Pp82cNM848Bd1K7V/F2GoBZFsDbxeHv5jv2aKG5bxfNwFCTKn+zdj/baC1
         lEQ6mtT1ul2femrlG0iGDgfCwSQAkTMRDzBCTCEE5dAOJtPCPZYvK8pQ/mu7/OhBNNsz
         aIcphStoDNK76S5JPz/wdMl7GkLFrbrruHkrHPsu1/oT8QYdMs4VimVxtYIn5KsKOclI
         2Gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/AZ7U0KHmcr9QXvwZlQmeLdBD0j8SEt/BJmgUku3Ig=;
        b=RI6C4ZSmUgpDsyEiZLGqlVYsN05/xskE0H0ghBJxUeumB1SCDlPgD3At7yP9iavAUz
         qHbUYlu2i+WS25mJnRq/krQ4Sr2hTEtbU6b3f1at2qyylNxXLdhsUEPFVP1BD+LzJXum
         gNbUMX/44UGkl8mOgS/HkBnx44uUSRnES2GeEWR8y//aENxCJoc+/07yCrAhS4sYunis
         4eZq9ecsLs5NjFyrg/rfLxlT2lIFTeC4vQKMT4n1ExFecMKLFUyqiQEuzMQXpfyeAQ65
         bWlBMI0lruzi3LQFA9rt9CyvqVVuPvdiEDWc9OvoGtHnUPoEyOrBwfZpHI9AT62Hjp63
         QA9A==
X-Gm-Message-State: ANhLgQ39/Ex7Od7+wfp2AG6RVV8NhlKDwwwl0jj6acGdffErkmkvjz5f
        oebLCQ+1GBFSuhwRZwd0XClJiF3NvUDx4po1V9m12g==
X-Google-Smtp-Source: ADFU+vvMae7IcKXiyLTUwR+cYqi/whefWdi0hnRgoORjgCw4UX0cLXu/XpZOSZnamdQslkSPH1Io7MPYVuJLg92ghas=
X-Received: by 2002:aca:3bc6:: with SMTP id i189mr6540oia.142.1583279675263;
 Tue, 03 Mar 2020 15:54:35 -0800 (PST)
MIME-Version: 1.0
References: <20200303233550.251375-1-guro@fb.com>
In-Reply-To: <20200303233550.251375-1-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 3 Mar 2020 15:54:24 -0800
Message-ID: <CALvZod5c_B3akg75UmzS-0pUAmBL_9-xmztw3gEkVLZMwgPs3g@mail.gmail.com>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various stack implementations
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 3, 2020 at 3:36 PM Roman Gushchin <guro@fb.com> wrote:
>
> Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio
> the space for task stacks can be allocated using __vmalloc_node_range(),
> alloc_pages_node() and kmem_cache_alloc_node(). In the first and the
> second cases page->mem_cgroup pointer is set, but in the third it's
> not: memcg membership of a slab page should be determined using the
> memcg_from_slab_page() function, which looks at
> page->slab_cache->memcg_params.memcg . In this case, using
> mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
> page->mem_cgroup pointer is NULL even for pages charged to a non-root
> memory cgroup.
>
> It can lead to kernel_stack per-memcg counters permanently showing 0
> on some architectures (depending on the configuration).
>
> In order to fix it, let's introduce a mod_memcg_obj_state() helper,
> which takes a pointer to a kernel object as a first argument, uses
> mem_cgroup_from_obj() to get a RCU-protected memcg pointer and
> calls mod_memcg_state(). It allows to handle all possible
> configurations (CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE
> values) without spilling any memcg/kmem specifics into fork.c .
>
> Note: this patch has been first posted as a part of the new slab
> controller patchset. This is a slightly updated version: the fixes
> tag has been added and the commit log was extended by the advice
> of Johannes Weiner. Because it's a fix that makes sense by itself,
> I'm re-posting it as a standalone patch.
>
> Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
> Signed-off-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
