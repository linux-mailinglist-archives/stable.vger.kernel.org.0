Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CF4441AAE
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 12:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhKALdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 07:33:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43068 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhKALde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 07:33:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D853E1FD6F;
        Mon,  1 Nov 2021 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635766260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3UUqMxIPDMK0aiQm8/1cwt+aYdWWsoYJ8/OZiD9Oxyk=;
        b=TtnckqF8ZZBoXh3Lp1p+e7hBnrZvWGSAEgtPAPgRdKUtB6/Gu3DOu3bex8qhhs1/BY1EfX
        OywNqQTA9p6dTjSp1Roch2MKCGdZ9ZcPDQV2qIua589k67xT1SC+pJwq79X1po50Kz+8g2
        BLZqN6acnoatZoXPc7gHgrH0Y0JAYU0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635766260;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3UUqMxIPDMK0aiQm8/1cwt+aYdWWsoYJ8/OZiD9Oxyk=;
        b=3PLrJ7EyEE0ZeYw0foOVAYPpRJezqEwN/N0Uw1mODnpOtT9TDJeYB7eqaZmH9uyRsAtwtz
        /EnptpFIY0UEHDBg==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 98EC5A3B84;
        Mon,  1 Nov 2021 11:31:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4B3461E0922; Mon,  1 Nov 2021 12:31:00 +0100 (CET)
Date:   Mon, 1 Nov 2021 12:31:00 +0100
From:   Jan Kara <jack@suse.cz>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, Gang He <ghe@suse.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: Fix data corruption on truncate
Message-ID: <20211101113100.GA18487@quack2.suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
 <20211025151332.11301-1-jack@suse.cz>
 <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 28-10-21 15:09:08, Joseph Qi wrote:
> Hi Jan,
> 
> On 10/25/21 11:13 PM, Jan Kara wrote:
> > ocfs2_truncate_file() did unmap invalidate page cache pages before
> > zeroing partial tail cluster and setting i_size. Thus some pages could
> > be left (and likely have left if the cluster zeroing happened) in the
> > page cache beyond i_size after truncate finished letting user possibly
> > see stale data once the file was extended again. Also the tail cluster
> 
> I don't quite understand the case. 
> truncate_inode_pages() will truncate pages from new_i_size to i_size,
> and the following ocfs2_orphan_for_truncate() will zero range and then
> update i_size for inode as well as dinode.
> So once truncate finished, how stale data exposing happens? Or do you
> mean a race case between the above two steps?

Sorry, I was not quite accurate in the above paragraph. There are several
ways how stale pages in the pagecache can cause problems.

1) Because i_size is reduced after truncating page cache, page fault can
happen after truncating page cache and zeroing pages but before reducing i_size.
This will in allow user to arbitrarily modify pages that are used for
writing zeroes into the cluster tail and after file extension these data
will become visible.

2) The tail cluster zeroing in ocfs2_orphan_for_truncate() can actually try
to write zeroed pages above i_size (e.g. if we have 4k blocksize, 64k
clustersize, and do truncate(f, 4k) on a 4k file). This will cause exactly
same problems as already described in commit 5314454ea3f "ocfs2: fix data
corruption after conversion from inline format".

Hope it is clearer now.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
