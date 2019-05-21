Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A464725741
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 20:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfEUSGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 14:06:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:19875 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbfEUSGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 14:06:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 11:06:48 -0700
X-ExtLoop1: 1
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2019 11:06:47 -0700
Date:   Tue, 21 May 2019 11:07:38 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ext4: Wait for outstanding dio during truncate in
 nojournal mode
Message-ID: <20190521180737.GA31888@iweiny-DESK2.sc.intel.com>
References: <20190521074358.17186-1-jack@suse.cz>
 <20190521074358.17186-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521074358.17186-2-jack@suse.cz>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 09:43:56AM +0200, Jan Kara wrote:
> We didn't wait for outstanding direct IO during truncate in nojournal
> mode (as we skip orphan handling in that case). This can lead to fs
> corruption or stale data exposure if truncate ends up freeing blocks
> and these get reallocated before direct IO finishes. Fix the condition
> determining whether the wait is necessary.
> 
> CC: stable@vger.kernel.org
> Fixes: 1c9114f9c0f1 ("ext4: serialize unlocked dio reads with truncate")
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  fs/ext4/inode.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 82298c63ea6d..9bcb7f2b86dd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5630,20 +5630,17 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  				goto err_out;
>  			}
>  		}
> -		if (!shrink)
> +		if (!shrink) {
>  			pagecache_isize_extended(inode, oldsize, inode->i_size);
> -
> -		/*
> -		 * Blocks are going to be removed from the inode. Wait
> -		 * for dio in flight.  Temporarily disable
> -		 * dioread_nolock to prevent livelock.
> -		 */
> -		if (orphan) {
> -			if (!ext4_should_journal_data(inode)) {
> -				inode_dio_wait(inode);
> -			} else
> -				ext4_wait_for_tail_page_commit(inode);
> +		} else {
> +			/*
> +			 * Blocks are going to be removed from the inode. Wait
> +			 * for dio in flight.
> +			 */
> +			inode_dio_wait(inode);
>  		}
> +		if (orphan && ext4_should_journal_data(inode))
> +			ext4_wait_for_tail_page_commit(inode);
>  		down_write(&EXT4_I(inode)->i_mmap_sem);
>  
>  		rc = ext4_break_layouts(inode);
> -- 
> 2.16.4
> 
