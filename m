Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65059299240
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 17:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775692AbgJZQXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 12:23:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:45150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775605AbgJZQXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 12:23:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8CA9CAB8F;
        Mon, 26 Oct 2020 16:23:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 06C89DA6E2; Mon, 26 Oct 2020 17:21:39 +0100 (CET)
Date:   Mon, 26 Oct 2020 17:21:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: Promote to unsigned long long before
 multiplying
Message-ID: <20201026162139.GO6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
References: <20201004180428.14494-1-willy@infradead.org>
 <20201004180428.14494-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004180428.14494-8-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 04, 2020 at 07:04:28PM +0100, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, these shifts will overflow for files larger than 4GB.
> Add helper functions to avoid this problem coming back.
> 
> Cc: stable@vger.kernel.org
> Fixes: 73ff61dbe5ed ("Btrfs: fix device replace of a missing RAID 5/6 device")
> Fixes: be50a8ddaae1 ("Btrfs: Simplify scrub_setup_recheck_block()'s argument")
> Fixes: ff023aac3119 ("Btrfs: add code to scrub to copy read data to another disk")
> Fixes: b5d67f64f9bc ("Btrfs: change scrub to support big blocks")
> Fixes: a2de733c78fa ("btrfs: scrub")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/btrfs/scrub.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 354ab9985a34..ccbaf9c6e87a 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1262,12 +1262,17 @@ static inline void scrub_stripe_index_and_offset(u64 logical, u64 map_type,
>  	}
>  }
>  
> +static u64 sblock_length(struct scrub_block *sblock)
> +{
> +	return (u64)sblock->page_count * PAGE_SIZE;

page_count will be 32 at most, the type is int and this will never
overflow. The value is usualy number of pages in the arrays scrub_bio::pagev or
scrub_block::pagev bounded by SCRUB_PAGES_PER_WR_BIO (32) or
SCRUB_MAX_PAGES_PER_BLOCK (16).  The scrub code does not use mappings
and it reads raw blocks to own pages and does the checksum verification.
