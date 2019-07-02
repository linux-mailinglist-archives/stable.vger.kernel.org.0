Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7A5C6AF
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 03:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfGBBip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 21:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGBBip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 21:38:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB27EC0AF04D;
        Tue,  2 Jul 2019 01:38:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0F59795AF;
        Tue,  2 Jul 2019 01:38:35 +0000 (UTC)
Date:   Tue, 2 Jul 2019 09:38:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH V2] block: fix .bi_size overflow
Message-ID: <20190702013829.GB8356@ming.t460p>
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
 <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
 <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b8dc953-e663-e3d8-b991-9d8dba9270be@kernel.dk>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 02 Jul 2019 01:38:45 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 08:20:13AM -0600, Jens Axboe wrote:
> On 7/1/19 8:14 AM, Jens Axboe wrote:
> > On 7/1/19 8:05 AM, Jens Axboe wrote:
> >> On 7/1/19 1:14 AM, Ming Lei wrote:
> >>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> >>> bytes.
> >>>
> >>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> >>> include very limited pages, and usually at most 256, so the fs bio
> >>> size won't be bigger than 1M bytes most of times.
> >>>
> >>> Since we support multi-page bvec, in theory one fs bio really can
> >>> be added > 1M pages, especially in case of hugepage, or big writeback
> >>> with too many dirty pages. Then there is chance in which .bi_size
> >>> is overflowed.
> >>>
> >>> Fixes this issue by using bio_full() to check if the added segment may
> >>> overflow .bi_size.
> >>
> >> Any objections to queuing this up for 5.3? It's not a new regression
> >> this series.
> > 
> > I took a closer look, and applied for 5.3 and removed the stable tag.
> > We'll need to apply your patch for stable, and I added an adapted
> > one for 5.3. I don't want a huge merge hassle because of this.
> 
> OK, so we still get conflicts with that, due to both the same page
> merge fix, and Christophs 5.3 changes.
> 
> I ended up pulling in 5.2-rc6 in for-5.3/block, which resolves at
> least most of it, and kept the stable tag since now it's possible
> to backport without too much trouble.

Thanks for merging it.

BTW, we need the -stable tag, since Yiding has test case to reproduce
the issue reliably, which just needs one big machine with enough memory,
and fast storage, I guess.

thanks, 
Ming
