Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2692B340E4
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfFDH5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:57:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727011AbfFDH5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:57:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 651CDAE21;
        Tue,  4 Jun 2019 07:57:51 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0F6A11E3C24; Tue,  4 Jun 2019 09:57:51 +0200 (CEST)
Date:   Tue, 4 Jun 2019 09:57:51 +0200
From:   Jan Kara <jack@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ext4 <linux-ext4@vger.kernel.org>,
        Ted Tso <tytso@mit.edu>, Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] ext4: Fix stale data exposure when read races with
 hole punch
Message-ID: <20190604075751.GK27933@quack2.suse.cz>
References: <20190603132155.20600-1-jack@suse.cz>
 <20190603132155.20600-3-jack@suse.cz>
 <CAOQ4uxgn7_tY35KVE6c-na2skXtxXhrM8-2wRNUe2CtmYACZrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgn7_tY35KVE6c-na2skXtxXhrM8-2wRNUe2CtmYACZrg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 03-06-19 19:33:50, Amir Goldstein wrote:
> On Mon, Jun 3, 2019 at 4:22 PM Jan Kara <jack@suse.cz> wrote:
> >
> > Hole puching currently evicts pages from page cache and then goes on to
> > remove blocks from the inode. This happens under both i_mmap_sem and
> > i_rwsem held exclusively which provides appropriate serialization with
> > racing page faults. However there is currently nothing that prevents
> > ordinary read(2) from racing with the hole punch and instantiating page
> > cache page after hole punching has evicted page cache but before it has
> > removed blocks from the inode. This page cache page will be mapping soon
> > to be freed block and that can lead to returning stale data to userspace
> > or even filesystem corruption.
> >
> > Fix the problem by protecting reads as well as readahead requests with
> > i_mmap_sem.
> >
> 
> So ->write_iter() does not take  i_mmap_sem right?
> and therefore mixed randrw workload is not expected to regress heavily
> because of this change?

Yes. i_mmap_sem is taken in exclusive mode only for truncate, punch hole,
and similar operations removing blocks from file. So reads will now be more
serialized with such operations. But not with writes. There may be some
regression still visible due to the fact that although readers won't block
one another or with writers, they'll still contend on updating the cacheline
with i_mmap_sem and that's going to be visible for cache hot readers
running from multiple NUMA nodes.

> Did you test performance diff?

No, not really. But I'll queue up some test to see the difference.

> Here [1] I posted results of fio test that did x5 worse in xfs vs.
> ext4, but I've seen much worse cases.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
