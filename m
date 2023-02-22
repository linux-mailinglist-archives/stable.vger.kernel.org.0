Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB869FAF1
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 19:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBVS1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 13:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBVS1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 13:27:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7AA39CC5;
        Wed, 22 Feb 2023 10:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C06CB8164A;
        Wed, 22 Feb 2023 18:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424DBC433EF;
        Wed, 22 Feb 2023 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677090416;
        bh=xBFAtQy7H9IEzhN6tiCIgW4YKmQxOgfi228DV4+IAOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyy8EWcwUoDh5Qjanib5yUoXbwdJ3E933glFTOrgDTICp8tQxuZZkdBWdCGE3GP5L
         IxTfwN+Fh1JdZsKTXuH3jKRJEB9zy2LO/NH1jbTZ7E/EOY4q1FNVRzyJjAoBxvmdDu
         MVV+eDn0AMPxdnL8Q0FRbrW2+coXXNG5QDtWh3vppgE5oVBaBvMuflomt+yJYgElsD
         MlPWYQGEs//RgjLSUiJywp5dwIEHNFErsiKFuvoqUa/G+n4gVnIs1G6MkBP917I6I1
         Ekzw/9EtI+E+SdRK5UvkWyfFnnXBWppvc+L5Lm48S6NxOuPYko2N/twjqZwm5QpX26
         VmfP0U9PyOClQ==
From:   SeongJae Park <sj@kernel.org>
Cc:     SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        wsd_upstream@mediatek.com, casper.li@mediatek.com,
        "andrew . yang" <andrew.yang@mediatek.com>, stable@vger.kernel.org,
        damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3] mm/damon/paddr: fix missing folio_put()
Date:   Wed, 22 Feb 2023 18:26:53 +0000
Message-Id: <20230222182653.156921-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230222064223.6735-1-andrew.yang@mediatek.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,


Thank you for revising this patch!

> From: "andrew.yang" <andrew.yang@mediatek.com>
> 
> damon_get_folio() would always increase folio _refcount and
> folio_isolate_lru() would increase folio _refcount if the folio's lru
> flag is set.
> 
> If an unevictable folio isolated successfully, there will be two more
> _refcount. The one from folio_isolate_lru() will be decreased in
> folio_puback_lru(), but the other one from damon_get_folio() will be
> left behind. This causes a pin page.
> 
> Whatever the case, the _refcount from damon_get_folio() should be
> decreased.
> 
> Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
> Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
> Cc: <stable@vger.kernel.org> # 5.16.x

Reviewed-by: SeongJae Park <sj@kernel.org>

This may not cleanly applicable on 6.1.y and 6.2.y.  I would post backports
once this is merged in the mainline, unless others do earlier than me.


Thanks,
SJ

> ---
> v3:
>   add fixes tag and cc stable
> v2:
>   according to David's suggestion
>     1. revise subject
>   according to SeongJae's suggestions
>     1. rebase to mm-unstable tree 
>     2. remove braces for th single statements
> ---
>  mm/damon/paddr.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 607bb69e526c..6c655d9b5639 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -250,12 +250,11 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
>  			folio_put(folio);
>  			continue;
>  		}
> -		if (folio_test_unevictable(folio)) {
> +		if (folio_test_unevictable(folio))
>  			folio_putback_lru(folio);
> -		} else {
> +		else
>  			list_add(&folio->lru, &folio_list);
> -			folio_put(folio);
> -		}
> +		folio_put(folio);
>  	}
>  	applied = reclaim_pages(&folio_list);
>  	cond_resched();
> -- 
> 2.18.0
> 
> 
