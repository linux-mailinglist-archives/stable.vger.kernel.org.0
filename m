Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCB299353
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787119AbgJZREv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:04:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:55604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775764AbgJZREU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 13:04:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D236AE1C;
        Mon, 26 Oct 2020 17:04:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D20C2DA6E2; Mon, 26 Oct 2020 18:02:44 +0100 (CET)
Date:   Mon, 26 Oct 2020 18:02:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net,
        viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com,
        mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH 5/7] btrfs: Promote to unsigned long long before shifting
Message-ID: <20201026170244.GQ6756@twin.jikos.cz>
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
 <20201004180428.14494-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004180428.14494-6-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 04, 2020 at 07:04:26PM +0100, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this shift will overflow for files larger than 4GB.
> 
> Cc: stable@vger.kernel.org
> Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/btrfs/ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ac45f022b495..4d3b7e4ae53a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1277,7 +1277,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
>  	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
>  
>  	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
> -			start_index << PAGE_SHIFT,
> +			(loff_t)start_index << PAGE_SHIFT,

> -				start_index << PAGE_SHIFT,
> +				(loff_t)start_index << PAGE_SHIFT,

> -			start_index << PAGE_SHIFT,
> +			(loff_t)start_index << PAGE_SHIFT,

As this repeats 3 times I've added a variable. Patch added to misc-next,
thanks.
