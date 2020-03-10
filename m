Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6588B17F66E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJLh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:37:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgCJLh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:37:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A23024655;
        Tue, 10 Mar 2020 11:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840275;
        bh=Cx2LRnFxdyWMsx83KnJim7N0cA4g5Eqn+DXRBSQizuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WJR+e7zoYWePMgjkaTYbUroZ2eHMIpOOfQfot1RK5iffhtHGcix1K2v9381Qs4wEI
         56YMlfN9o9f8yr/4lK7MZUsrt0aZgVv+7Ghej3hyU/DwTGsCPIMdwFAaSvt1RSL9cv
         IP8E9Sbq9wBBxz8NgfKmhqa2QOT053W87Mg6C7b8=
Date:   Tue, 10 Mar 2020 12:37:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4.y/4.9.y] NFS: fix highmem leak exist in
 nfs_readdir_xdr_to_array
Message-ID: <20200310113753.GA3106483@kroah.com>
References: <20200310100219.5421-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310100219.5421-1-yangerkun@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 06:02:19PM +0800, yangerkun wrote:
> The patch 'e22dea67d2f7 ("NFS: Fix memory leaks and corruption in
> readdir")' in 4.4.y/4.9.y will introduce a highmem leak.
> Actually, nfs_readdir_get_array has did what we want to do. No need to
> call kmap again.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/nfs/dir.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index c2665d920cf8..2517fcd423b6 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -678,8 +678,6 @@ int nfs_readdir_xdr_to_array(nfs_readdir_descriptor_t *desc, struct page *page,
>  		goto out_label_free;
>  	}
>  
> -	array = kmap(page);
> -
>  	status = nfs_readdir_alloc_pages(pages, array_size);
>  	if (status < 0)
>  		goto out_release_array;
> -- 
> 2.17.2
> 

Can you resend and cc: the NFS developers and maintainers on this
change?  I need their ack to be able to apply it.

thanks,

greg k-h

