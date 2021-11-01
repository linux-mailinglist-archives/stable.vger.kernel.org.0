Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC014421C5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 21:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKAUnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhKAUnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 16:43:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114AC061714;
        Mon,  1 Nov 2021 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GDo38ocU3pLClKl3wyVO90VvxmLoO3CeEoE5GEzkERk=; b=RyJbRA3f+AsVJo0k56Bz2l/1Sy
        hrFjNtQEliiW2GQnf+kHW3bKSW85yzuT9LHZ52az81pke0WekzAxASXhQ7RlasjSXl+KkXHnDebAS
        U02xF4K1cDk5Mdc360fo498yuNvtnmtzMKihBll2bFbQXlzvFRLleNsjipEu1a7NascW/LH5i7e2o
        0y/dPIhJkV2bfvriOV9Eu+d3U6Wa3Lq5ynVnq1lZgG7hNEAqRAlWF3E+bY6n/GPyRueE0eLm8elg6
        7pjQJQerALpUp2VCDs9kGix/k56KtzlMH4+hwsFkz4A5r7MOsqNjThluY4iO8HmgTxNBrjZF1ktlO
        /hdgGrkw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhe4Q-0040Ih-AQ; Mon, 01 Nov 2021 20:38:45 +0000
Date:   Mon, 1 Nov 2021 20:38:18 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYBQOiuq6WHMjOYf@casper.infradead.org>
References: <20211101201312.11589-1-amakhalov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101201312.11589-1-amakhalov@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 01:13:12PM -0700, Alexey Makhalov wrote:
> +++ b/include/linux/gfp.h
> @@ -551,7 +551,8 @@ alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_arr
>  static inline unsigned long
>  alloc_pages_bulk_array_node(gfp_t gfp, int nid, unsigned long nr_pages, struct page **page_array)
>  {
> -	if (nid == NUMA_NO_NODE)
> +	if (nid == NUMA_NO_NODE || (!node_online(nid) &&
> +					!(gfp & __GFP_THISNODE)))
>  		nid = numa_mem_id();
>  
>  	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);

I don't think it's a great idea to push node_online() and the gfp check
into the caller.  Can't we put this check in __alloc_pages_bulk() instead?

