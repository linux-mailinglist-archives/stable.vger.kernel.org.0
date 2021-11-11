Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036BE44D26D
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 08:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhKKH15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 02:27:57 -0500
Received: from verein.lst.de ([213.95.11.211]:57241 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhKKH15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Nov 2021 02:27:57 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9298167373; Thu, 11 Nov 2021 08:25:06 +0100 (CET)
Date:   Thu, 11 Nov 2021 08:25:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [5.15 REGRESSION] iomap: Fix inline extent handling in
 iomap_readpage
Message-ID: <20211111072506.GB30478@lst.de>
References: <20211110113842.517426-1-agruenba@redhat.com> <20211110125527.GA25465@lst.de> <CAHc6FU49TnYvrL-FU5oz9th6STuQ=eYokjsD+0QpbkdHedRd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU49TnYvrL-FU5oz9th6STuQ=eYokjsD+0QpbkdHedRd9w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 03:52:01PM +0100, Andreas Gruenbacher wrote:
> Hmm, that doesn't make sense to me: the filesystem doesn't know that
> iomap_readpage will pad to page boundaries. This happens at the iomap
> layer, so the iomap layer should also deal with the consequences.
> We're using different alignment rules here and for direct I/O, so that
> makes fake-aligning the extent size in iomap_begin even more
> questionable.
> 
> "Fixing" the extent size the filesystem returns would also break
> direct I/O. We could add some additional padding code to
> iomap_dio_inline_iter to deal with that, but currently, there's no
> need for that.

The iomap mapping sizes are read-only to iomap for a good reason.  You
can't just break that design.
