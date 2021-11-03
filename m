Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C94444E2
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 16:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhKCPt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 11:49:27 -0400
Received: from verein.lst.de ([213.95.11.211]:59923 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232125AbhKCPt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 11:49:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1BB3468C4E; Wed,  3 Nov 2021 16:46:45 +0100 (CET)
Date:   Wed, 3 Nov 2021 16:46:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] bcache: Revert "bcache: use bvec_virt"
Message-ID: <20211103154644.GA30686@lst.de>
References: <20211103151041.70516-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103151041.70516-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 11:10:41PM +0800, Coly Li wrote:
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 93b67b8d31c3..88c573eeb598 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -378,7 +378,7 @@ static void do_btree_node_write(struct btree *b)
>  		struct bvec_iter_all iter_all;
>  
>  		bio_for_each_segment_all(bv, b->bio, iter_all) {
> -			memcpy(bvec_virt(bv), addr, PAGE_SIZE);
> +			memcpy(page_address(bv->bv_page), addr, PAGE_SIZE);

How could there be an offset?  bch_bio_alloc_pages allocates a
fresh page for each vec, and bio_for_each_segment_all iterates page
by page.  IFF there is an offset there is proble in the surrounding
code as bch_bio_alloc_pages assumes that it is called on a freshly
allocate and initialized bio.
