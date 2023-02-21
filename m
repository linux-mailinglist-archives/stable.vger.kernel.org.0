Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EDA69E79B
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBUSfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 13:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBUSfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 13:35:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CEF305F2;
        Tue, 21 Feb 2023 10:35:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7960EB81049;
        Tue, 21 Feb 2023 18:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44575C433D2;
        Tue, 21 Feb 2023 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677004504;
        bh=dgnjcSUG5w1/UXY20oy7pA67rk5DpCFG+LKqSztlm2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaHaknMQH94f0Ouz7x7+bJIIjbqP/1A+lf0z1r07/7u31jA6NOMhkjW7+NQyvj35e
         r/jQRM84dkmgFx+I10T1+lXThjNBjateNxycYIcs8ndkx+83AY7RtGGDH1RDlxKsfx
         F0ElKYH0Wx72EtvnPAl2tSazAPHRHXzUqgYigzELtugc3AHpiPANpZvByCujdPkOTF
         w0dPFwyDldQNFWCLQNnI2VnKaMG/a15VZoIU6XlPnNlL9JqQDQxANx9QltdGXZU71M
         Dl2ye6B6QBHGkFlvvHhMbYXijeMmxJYK1eg3IOhRUo8lxsPqfw5aljOdgLV50q/zFN
         Y/WQZlhgK3iOA==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Yang <andrew.yang@mediatek.com>
Cc:     SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        wsd_upstream@mediatek.com, casper.lin@mediatek.com,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/paddr: fix pin page problem
Date:   Tue, 21 Feb 2023 18:35:01 +0000
Message-Id: <20230221183501.132024-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230221090313.15396-1-andrew.yang@mediatek.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,


On Tue, 21 Feb 2023 17:03:13 +0800 Andrew Yang <andrew.yang@mediatek.com> wrote:

> From: "andrew.yang" <andrew.yang@mediatek.com>
> 
> damon_get_page() would always increase page _refcount and
> isolate_lru_page() would increase page _refcount if the page's lru
> flag is set.
> 
> If a unevictable page isolated successfully, there will be two more
> _refcount. The one from isolate_lru_page() will be decreased in
> putback_lru_page(), but the other one from damon_get_page() will be
> left behind. This causes a pin page.
> 
> Whatever the case, the _refcount from damon_get_page() should be
> decreased.

Thank you for finding this issue!  I think the David suggested subject[1] is
better, though.

I think we could add below Fixes: and Cc: tags?

Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Cc: <stable@vger.kernel.org> # 5.16.x

> 
> Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
> ---
>  mm/damon/paddr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index e1a4315c4be6..56d8abd08fb1 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -223,8 +223,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r)
>  			putback_lru_page(page);
>  		} else {
>  			list_add(&page->lru, &page_list);
> -			put_page(page);
>  		}
> +		put_page(page);

Seems your patch is not based on mm-unstable tree[2].  Could you please rebase
on it?

Also, let's remove the braces for the single statements[3].

[1] https://lore.kernel.org/damon/1b3e8e88-ed5c-7302-553f-4ddb3400d466@redhat.com/
[2] https://docs.kernel.org/next/mm/damon/maintainer-profile.html#scm-trees
[3] https://docs.kernel.org/process/coding-style.html?highlight=coding+style#placing-braces-and-spaces


Thanks,
SJ

>  	}
>  	applied = reclaim_pages(&page_list);
>  	cond_resched();
> -- 
> 2.18.0
