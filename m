Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8F4442B1F
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 10:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBJ6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 05:58:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33628 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhKBJ6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 05:58:18 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D0E1921952;
        Tue,  2 Nov 2021 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635846942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VcihiUBuO4mpJlsL32+jPlNaMG6eXyrjB3Aakt80OJk=;
        b=mljTWiaFYxanSmpvIvwfQL4ZJBobWiiRpX/MR6lF7oRTmvhxlLk55Rp4+1L2pSdkpXW24x
        ud9/St59UP48IaihvIJCnSUHjkEFKpEF84VeVr1ONevu0rTNavQ7FS+sRp65pUGAjUS9KB
        1TJxReoU5LtUyY1PYiygyG1drjbvexU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635846942;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VcihiUBuO4mpJlsL32+jPlNaMG6eXyrjB3Aakt80OJk=;
        b=o49ioBYA5tHQwucO3LaVQM+C3gPQ2oJzmknWU83qJhd3jpGK+hYte31iGjeWXUbAIL8J7F
        CLnX2LLwqNzZptAg==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id A8D72A3B84;
        Tue,  2 Nov 2021 09:55:42 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 628361E0A2B; Tue,  2 Nov 2021 10:55:42 +0100 (CET)
Date:   Tue, 2 Nov 2021 10:55:42 +0100
From:   Jan Kara <jack@suse.cz>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, Gang He <ghe@suse.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ocfs2: Fix data corruption on truncate
Message-ID: <20211102095542.GB12774@quack2.suse.cz>
References: <20211025150008.29002-1-jack@suse.cz>
 <20211025151332.11301-1-jack@suse.cz>
 <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
 <20211101113100.GA18487@quack2.suse.cz>
 <beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 02-11-21 10:36:42, Joseph Qi wrote:
> On 11/1/21 7:31 PM, Jan Kara wrote:
> > On Thu 28-10-21 15:09:08, Joseph Qi wrote:
> >> Hi Jan,
> >>
> >> On 10/25/21 11:13 PM, Jan Kara wrote:
> >>> ocfs2_truncate_file() did unmap invalidate page cache pages before
> >>> zeroing partial tail cluster and setting i_size. Thus some pages could
> >>> be left (and likely have left if the cluster zeroing happened) in the
> >>> page cache beyond i_size after truncate finished letting user possibly
> >>> see stale data once the file was extended again. Also the tail cluster
> >>
> >> I don't quite understand the case. 
> >> truncate_inode_pages() will truncate pages from new_i_size to i_size,
> >> and the following ocfs2_orphan_for_truncate() will zero range and then
> >> update i_size for inode as well as dinode.
> >> So once truncate finished, how stale data exposing happens? Or do you
> >> mean a race case between the above two steps?
> > 
> > Sorry, I was not quite accurate in the above paragraph. There are several
> > ways how stale pages in the pagecache can cause problems.
> > 
> > 1) Because i_size is reduced after truncating page cache, page fault can
> > happen after truncating page cache and zeroing pages but before reducing i_size.
> > This will in allow user to arbitrarily modify pages that are used for
> > writing zeroes into the cluster tail and after file extension these data
> > will become visible.
> > 
> > 2) The tail cluster zeroing in ocfs2_orphan_for_truncate() can actually try
> > to write zeroed pages above i_size (e.g. if we have 4k blocksize, 64k
> > clustersize, and do truncate(f, 4k) on a 4k file). This will cause exactly
> > same problems as already described in commit 5314454ea3f "ocfs2: fix data
> > corruption after conversion from inline format".
> > 
> > Hope it is clearer now.
> > 
> So the core reason is ocfs2_zero_range_for_truncate() grabs pages and
> then zero, right?

Well, that is the part that makes things easy to reproduce.

> I think an alternative way is using zeroout instead of zero pages, which
> won't grab pages again.

That would certainly reduce the likelyhood of problems but it is always
problematic to first truncate page cache and only then update i_size.
For OCFS2 racing page faults can recreate pages in the page cache before
i_size is reduced and thus cause "interesting" problems.

> Anyway, I'm also fine with your way since it is simple.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks!

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
