Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F4D6FC58
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 11:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfGVJiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 05:38:24 -0400
Received: from verein.lst.de ([213.95.11.211]:58841 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbfGVJiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 05:38:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1925268C4E; Mon, 22 Jul 2019 11:38:23 +0200 (CEST)
Date:   Mon, 22 Jul 2019 11:38:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 2/3] mm/hmm: fix ZONE_DEVICE anon page mapping reuse
Message-ID: <20190722093822.GF29538@lst.de>
References: <20190719192955.30462-1-rcampbell@nvidia.com> <20190719192955.30462-3-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719192955.30462-3-rcampbell@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +		/*
> +		 * When a device_private page is freed, the page->mapping field
> +		 * may still contain a (stale) mapping value. For example, the
> +		 * lower bits of page->mapping may still identify the page as
> +		 * an anonymous page. Ultimately, this entire field is just
> +		 * stale and wrong, and it will cause errors if not cleared.
> +		 * One example is:
> +		 *
> +		 *  migrate_vma_pages()
> +		 *    migrate_vma_insert_page()
> +		 *      page_add_new_anon_rmap()
> +		 *        __page_set_anon_rmap()
> +		 *          ...checks page->mapping, via PageAnon(page) call,
> +		 *            and incorrectly concludes that the page is an
> +		 *            anonymous page. Therefore, it incorrectly,
> +		 *            silently fails to set up the new anon rmap.
> +		 *
> +		 * For other types of ZONE_DEVICE pages, migration is either
> +		 * handled differently or not done at all, so there is no need
> +		 * to clear page->mapping.
> +		 */
> +		if (is_device_private_page(page))
> +			page->mapping = NULL;
> +

Thanks, especially for the long comment.

Reviewed-by: Christoph Hellwig <hch@lst.de>
