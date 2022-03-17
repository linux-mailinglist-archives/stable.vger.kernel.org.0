Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4F4DC3EF
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 11:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiCQK1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 06:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiCQK1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 06:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727191DE6E4;
        Thu, 17 Mar 2022 03:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 233ECB81E52;
        Thu, 17 Mar 2022 10:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EC9C340E9;
        Thu, 17 Mar 2022 10:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647512785;
        bh=4qEBcDajlD5kYvfjOkzCEQ/z5kJDytEOC4nMhJy2ciQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Erh4LpH/4hQpxoJX4uPvJ7MlZqxiHCBgFK8CaRoHuUwtQsL9MGX0vYn0WAtnBhFvh
         asfFrzTc5syaQGW/d04P7Vx8O4NRBOaqxmWyia5ot4x3a1f4QGDUMXNGqUn4G1mJTu
         39FM6DENvzHXb37gjs0ZR8NA6v0989KrzpRDwzrw=
Date:   Thu, 17 Mar 2022 11:26:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     liqiong <liqiong@nfschina.com>
Cc:     david@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [PATCH 4.19 STABLE] mm: fix dereference a null pointer
 in migrate[_huge]_page_move_mapping()
Message-ID: <YjMMzqPZ+AfYArZy@kroah.com>
References: <20220217063808.42018-1-liqiong@nfschina.com>
 <20220217115416.55835-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217115416.55835-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 07:54:16PM +0800, liqiong wrote:
> Upstream doesn't use radix tree any more in migrate.c, no need this patch.
> 
> The two functions look up a slot and dereference the pointer,
> If the pointer is null, the kernel would crash and dump.
> 
> The 'numad' service calls 'migrate_pages' periodically. If some slots
> being replaced (Cache Eviction), the radix_tree_lookup_slot() returns
> a null pointer that causes kernel crash.
> 
> "numad":  crash> bt
> [exception RIP: migrate_page_move_mapping+337]
> 
> Introduce pointer checking to avoid dereference a null pointer.
> 
> Cc: <stable@vger.kernel.org> # linux-4.19.y
> Signed-off-by: liqiong <liqiong@nfschina.com>
> ---
>  mm/migrate.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a69b842f95da..76f8dedc0e02 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -472,6 +472,10 @@ int migrate_page_move_mapping(struct address_space *mapping,
>  
>  	pslot = radix_tree_lookup_slot(&mapping->i_pages,
>   					page_index(page));
> +	if (pslot == NULL) {
> +		xa_unlock_irq(&mapping->i_pages);
> +		return -EAGAIN;
> +	}
>  
>  	expected_count += hpage_nr_pages(page) + page_has_private(page);
>  	if (page_count(page) != expected_count ||
> @@ -590,6 +594,10 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
>  	xa_lock_irq(&mapping->i_pages);
>  
>  	pslot = radix_tree_lookup_slot(&mapping->i_pages, page_index(page));
> +	if (pslot == NULL) {
> +		xa_unlock_irq(&mapping->i_pages);
> +		return -EAGAIN;
> +	}
>  
>  	expected_count = 2 + page_has_private(page);
>  	if (page_count(page) != expected_count ||
> -- 
> 2.25.1
> 

Sorry for the delay, now queued up.

greg k-h
