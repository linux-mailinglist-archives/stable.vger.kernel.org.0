Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBF3FF9B2
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 06:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhICEzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 00:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhICEzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 00:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC00360FDA;
        Fri,  3 Sep 2021 04:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630644861;
        bh=XcGS03r5L+2ydQe3JiVk+2cZepmLcjyDuWSv1JJIBYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rH82qb8b7J3NHUq6DjiOYlnzVrtNhs3XKk5+bLNn9fy7xpy7FMOk7zagzV9BRfSZx
         Me4UyU4eRbrbg7Zd4v9k7YLypblWEWRAbvGDMzLCKj9nzcW9zDTjZnkubNESs3FhSf
         pI6tzY/1hla9lF0dVjBKcl6u5Iei4QxzO/Paac4Q=
Date:   Fri, 3 Sep 2021 06:54:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     ocfs2-devel@oss.oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: drop acl cache for directories too
Message-ID: <YTGqekh95kH5U5F1@kroah.com>
References: <20210903012631.6099-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903012631.6099-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 06:26:31PM -0700, Wengang Wang wrote:
> ocfs2_data_convert_worker() is currently dropping any cached acl info
> for FILE before down-converting meta lock. It should also drop for DIRECTORY.
> Otherwise the second acl lookup returns the cached one (from VFS layer) which
> could be already stale.
> 
> The problem we are seeing is that the acl changes on one node doesn't get
> refreshed on other nodes in the following case:
> 
>   Node 1                    Node 2
> --------------            ----------------
> getfacl dir1
> 
> 			  getfacl dir1    <-- this is OK
> 
> setfacl -m u:user1:rwX dir1
> getfacl dir1   <-- see the change for user1
> 
> 			  getfacl dir1    <-- can't see change for user1
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 50a863fc1779..207ec61569ea 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3933,7 +3933,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		oi = OCFS2_I(inode);
>  		oi->ip_dir_lock_gen++;
>  		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
> -		goto out;
> +		goto out_forget;
>  	}
>  
>  	if (!S_ISREG(inode->i_mode))
> @@ -3964,6 +3964,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		filemap_fdatawait(mapping);
>  	}
>  
> +out_forget:
>  	forget_all_cached_acls(inode);
>  
>  out:
> -- 
> 2.21.0 (Apple Git-122.2)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
