Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C86454072
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 06:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhKQFzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 00:55:41 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48330 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232082AbhKQFzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 00:55:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ux.HbS2_1637128360;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Ux.HbS2_1637128360)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Nov 2021 13:52:41 +0800
Date:   Wed, 17 Nov 2021 13:52:40 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [5.15 REGRESSION v2] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <YZSYqIU19SUqVyQ/@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        stable@vger.kernel.org
References: <20211111161714.584718-1-agruenba@redhat.com>
 <20211117053330.GU24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211117053330.GU24307@magnolia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 09:33:30PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 11, 2021 at 05:17:14PM +0100, Andreas Gruenbacher wrote:
> > Before commit 740499c78408 ("iomap: fix the iomap_readpage_actor return
> > value for inline data"), when hitting an IOMAP_INLINE extent,
> > iomap_readpage_actor would report having read the entire page.  Since
> > then, it only reports having read the inline data (iomap->length).
> > 
> > This will force iomap_readpage into another iteration, and the
> > filesystem will report an unaligned hole after the IOMAP_INLINE extent.
> > But iomap_readpage_actor (now iomap_readpage_iter) isn't prepared to
> > deal with unaligned extents, it will get things wrong on filesystems
> > with a block size smaller than the page size, and we'll eventually run
> > into the following warning in iomap_iter_advance:
> > 
> >   WARN_ON_ONCE(iter->processed > iomap_length(iter));
> > 
> > Fix that by changing iomap_readpage_iter to return 0 when hitting an
> > inline extent; this will cause iomap_iter to stop immediately.
> 
> I guess this means that we also only support having inline data that
> ends at EOF?  IIRC this is true for the three(?) filesystems that have
> expressed any interest in inline data: yours, ext4, and erofs?

For erofs, confirmed. (also yes in the long run...)

Thanks,
Gao Xiang
