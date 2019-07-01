Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651765B523
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 08:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfGAGgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 02:36:17 -0400
Received: from verein.lst.de ([213.95.11.211]:58608 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfGAGgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 02:36:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E4C2C68C4E; Mon,  1 Jul 2019 08:36:13 +0200 (CEST)
Date:   Mon, 1 Jul 2019 08:36:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix .bi_size overflow
Message-ID: <20190701063613.GA20733@lst.de>
References: <20190701041644.16052-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701041644.16052-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 12:16:44PM +0800, Ming Lei wrote:
> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> bytes.
> 
> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> include very limited pages, and usually at most 256, so the fs bio
> size won't be bigger than 1M bytes most of times.
> 
> Since we support multi-page bvec, in theory one fs bio really can
> be added > 1M pages, especially in case of hugepage, or big writeback
> in case of huge dirty pages. Then there is chance in which .bi_size
> is overflowed.
> 
> Fixes this issue by adding bio_will_full() which checks if the added
> segment may overflow .bi_size.

Can you please just add the argument to bio_full?  bio_will_full sounds
rather odd.

Maybe also add a kerneldoc comment to the new bio_full to explain
it.  Otherwise this looks fine to me.
