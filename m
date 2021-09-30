Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FA841DC1D
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 16:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351836AbhI3OSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 10:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240149AbhI3OSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 10:18:04 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97018C06176A;
        Thu, 30 Sep 2021 07:16:21 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id BB434703F; Thu, 30 Sep 2021 10:16:20 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org BB434703F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1633011380;
        bh=d+zTKb1U2WCtpOSHtjtEGCRkMq8DHSFqEIy3a/LI1Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXmkX3d58WdggHN44Xy7qNKKfXsKmNHyNMvAAPA2YwcCJioKbVi4kGKwpMhnz/Fom
         HHTj+Y056Rsqk6sfgEFNHAy33Y9XbGQYPkNOjDtp3qgXi2VXh5KDXGZ+LwWR7CvwZx
         yQ55umNNVGHORlMHWXZ363pgwhycuzpc+yVZGbig=
Date:   Thu, 30 Sep 2021 10:16:20 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     "Ho, Patrick" <Patrick.Ho@netapp.com>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
 init_nfsd()
Message-ID: <20210930141620.GA9422@fieldses.org>
References: <SJ0PR06MB8327D188504E0F367C8B4E53F4AA9@SJ0PR06MB8327.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR06MB8327D188504E0F367C8B4E53F4AA9@SJ0PR06MB8327.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 03:48:42AM +0000, Ho, Patrick wrote:
> >From 7417896fcc7aea645fa0b89f39fa55979251dca3 Mon Sep 17 00:00:00 2001
> From: Patrick Ho <Patrick.Ho@netapp.com>
> Date: Sat, 21 Aug 2021 02:56:26 -0400
> Subject: [PATCH] nfsd: fix error handling of register_pernet_subsys() in
>  init_nfsd()
> 
> init_nfsd() should not unregister pernet subsys if the register fails
> but should instead unwind from the last successful operation which is
> register_filesystem().
> 
> Unregistering a failed register_pernet_subsys() call can result in
> a kernel GPF as revealed by programmatically injecting an error in
> register_pernet_subsys().
> 
> Verified the fix handled failure gracefully with no lingering nfsd
> entry in /proc/filesystems.  This change was introduced by the commit
> bd5ae9288d64 ("nfsd: register pernet ops last, unregister first"),
> the original error handling logic was correct.

Whoops, thanks for catching this.  I assume Chuck will pick it up.

Acked-by: J. Bruce Fields <bfields@redhat.com>

--b.

> 
> Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
> Cc: stable@vger.kernel.org
> Signed-off-by: Patrick Ho <Patrick.Ho@netapp.com>
> ---
>  fs/nfsd/nfsctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index c2c3d9077dc5..09ae1a0873d0 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -1545,7 +1545,7 @@ static int __init init_nfsd(void)
>  		goto out_free_all;
>  	return 0;
>  out_free_all:
> -	unregister_pernet_subsys(&nfsd_net_ops);
> +	unregister_filesystem(&nfsd_fs_type);
>  out_free_exports:
>  	remove_proc_entry("fs/nfs/exports", NULL);
>  	remove_proc_entry("fs/nfs", NULL);
> -- 
> 2.17.1
