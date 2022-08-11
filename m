Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDAE58FA46
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 11:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiHKJvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 05:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiHKJvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 05:51:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61429083C;
        Thu, 11 Aug 2022 02:51:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 725355CA97;
        Thu, 11 Aug 2022 09:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660211480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pyi5tXCgIAAgTmbe0E04qpY0ZJ3iN840sWWOgFE8VFM=;
        b=tQgcztYLQ6urrHpS46l3l420QtP6Gjra/CECoScv2ZlNAJdBAWabMsrQCdf5ZHXL//WDH8
        fVhmeWQHaIstFmSAjYR61EaOR+ly0UcbGIiFOrtcMVAYz1OYkgJkDfmtHA+T/+364Ga0zU
        NJEwjU9XvxTA+n/51xNNGTqusFO0lAA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52BB81342A;
        Thu, 11 Aug 2022 09:51:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bKdEERjR9GKqeQAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 11 Aug 2022 09:51:20 +0000
Date:   Thu, 11 Aug 2022 11:51:19 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <YvTRFxkmSuDAyVdI@dhcp22.suse.cz>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
 <20220810140030.GA24195@lst.de>
 <YvP9YITH0RpgpblG@dhcp22.suse.cz>
 <20220811092911.GA22246@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811092911.GA22246@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 11-08-22 11:29:11, Christoph Hellwig wrote:
> This is what I think should solve your problem properly:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-pool-sizing

http://git.infradead.org/users/hch/misc.git/commit/a29d77929bf4fc563657b29da1506a12ad0f4610

+unsigned long __init nr_pages_per_zone(int zone_index)
+{
+       return arch_zone_highest_possible_pfn[zone_index] -
+               arch_zone_lowest_possible_pfn[zone_index];
+}
+

this will not consider any gaps in the zone. We have zone_managed_pages
which tells you how many pages there are in the zone which have been
provided to the page allocator which seems like something that would fit
better. And it is also much better than basing it on the global amount
of memory which just doesn't make much sens for constrained zones

Except that it will not work for this case as
+static unsigned long calculate_pool_size(unsigned long zone_pages)
+{
+       unsigned long nr_pages = min_t(unsigned long,
+                                      zone_pages / (SZ_1G / SZ_128K),
+                                      MAX_ORDER_NR_PAGES);
+
+       return max_t(unsigned long, nr_pages << PAGE_SHIFT, SZ_128K);
+}

this will return 128kB, correct?

+               atomic_pool_dma = __dma_atomic_pool_init(
+                               calculate_pool_size(nr_zone_dma_pages),
+                               GFP_DMA);

The DMA zone still has 126kB of usable memory. I think what you
want/need to do something like
	pool_size = calculate_pool_size(nr_zone_dma_pages);
	do {
		atomic_pool_dma = __dma_atomic_pool_init(pool_size),
			GFP_DMA | __GFP_NOWARN);
		if (atomic_pool_dma) {
			break;
		pool_size /= 2;
	} while (pool_size > PAGE_SZIE);
	if (!atomic_pool_dma)
		print_something_useful;

Another option would be to consider NR_FREE_PAGES of the zone but that
would be inherently racy.
-- 
Michal Hocko
SUSE Labs
