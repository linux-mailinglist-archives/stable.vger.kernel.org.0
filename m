Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31555B548
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 08:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfGAGqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 02:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfGAGqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 02:46:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8221981F18;
        Mon,  1 Jul 2019 06:46:50 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B92131001B2E;
        Mon,  1 Jul 2019 06:46:35 +0000 (UTC)
Date:   Mon, 1 Jul 2019 14:46:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] block: fix .bi_size overflow
Message-ID: <20190701064628.GC16809@ming.t460p>
References: <20190701041644.16052-1-ming.lei@redhat.com>
 <20190701063613.GA20733@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701063613.GA20733@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 01 Jul 2019 06:46:55 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 08:36:13AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2019 at 12:16:44PM +0800, Ming Lei wrote:
> > 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
> > bytes.
> > 
> > Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
> > include very limited pages, and usually at most 256, so the fs bio
> > size won't be bigger than 1M bytes most of times.
> > 
> > Since we support multi-page bvec, in theory one fs bio really can
> > be added > 1M pages, especially in case of hugepage, or big writeback
> > in case of huge dirty pages. Then there is chance in which .bi_size
> > is overflowed.
> > 
> > Fixes this issue by adding bio_will_full() which checks if the added
> > segment may overflow .bi_size.
> 
> Can you please just add the argument to bio_full?  bio_will_full sounds
> rather odd.

OK.

> 
> Maybe also add a kerneldoc comment to the new bio_full to explain
> it.  Otherwise this looks fine to me.

Fine.


Thanks,
Ming
