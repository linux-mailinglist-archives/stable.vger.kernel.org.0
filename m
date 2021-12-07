Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E9946C117
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 17:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbhLGRAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 12:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhLGRAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 12:00:08 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E960C061574;
        Tue,  7 Dec 2021 08:56:38 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id A57466CDC; Tue,  7 Dec 2021 11:56:37 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org A57466CDC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1638896197;
        bh=xK4Z3eoxTZzUJb93i7scB+xwoUrVmh+NyPstewHD1Fg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R5+9WDwE//NGKXF3yCxOZtWvbI9PICxHpA54NodiCFJ0pvUSOGiBbioBskXfdTvrZ
         ZmU9XNLpm5Vbd24Bc4Jarl1KB0LF5vIxj5ZHN+os+s8lEYwOH4nXVsuH86DQDmcPkT
         5AkNef8INqPcA9xYb4/wXuM3X4Z8V4nC3vGWO1Gk=
Date:   Tue, 7 Dec 2021 11:56:37 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] nfsd: Fix nsfd startup race (again)
Message-ID: <20211207165637.GA15500@fieldses.org>
References: <20211207140039.11392-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207140039.11392-1-alexander.sverdlin@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 03:00:39PM +0100, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Commit bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
> has re-opened rpc_pipefs_event() race against nfsd_net_id registration
> (register_pernet_subsys()) which has been fixed by commit bb7ffbf29e76
> ("nfsd: fix nsfd startup race triggering BUG_ON").
> 
> Restore the order of register_pernet_subsys() vs register_cld_notifier().
> Add WARN_ON() to prevent a future regression.

That makes sense, thanks.  I'll pass it along for 5.16.

--b.

> 
> Crash info:
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000012
> CPU: 8 PID: 345 Comm: mount Not tainted 5.4.144-... #1
> pc : rpc_pipefs_event+0x54/0x120 [nfsd]
> lr : rpc_pipefs_event+0x48/0x120 [nfsd]
> Call trace:
>  rpc_pipefs_event+0x54/0x120 [nfsd]
>  blocking_notifier_call_chain
>  rpc_fill_super
>  get_tree_keyed
>  rpc_fs_get_tree
>  vfs_get_tree
>  do_mount
>  ksys_mount
>  __arm64_sys_mount
>  el0_svc_handler
>  el0_svc
> 
> Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  fs/nfsd/nfs4recover.c |  1 +
>  fs/nfsd/nfsctl.c      | 14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
> index 6fedc49..4d829cf 100644
> --- a/fs/nfsd/nfs4recover.c
> +++ b/fs/nfsd/nfs4recover.c
> @@ -2156,6 +2156,7 @@ static struct notifier_block nfsd4_cld_block = {
>  int
>  register_cld_notifier(void)
>  {
> +	WARN_ON(!nfsd_net_id);
>  	return rpc_pipefs_notifier_register(&nfsd4_cld_block);
>  }
>  
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index af8531c..51a49e0 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -1521,12 +1521,9 @@ static int __init init_nfsd(void)
>  	int retval;
>  	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
>  
> -	retval = register_cld_notifier();
> -	if (retval)
> -		return retval;
>  	retval = nfsd4_init_slabs();
>  	if (retval)
> -		goto out_unregister_notifier;
> +		return retval;
>  	retval = nfsd4_init_pnfs();
>  	if (retval)
>  		goto out_free_slabs;
> @@ -1545,9 +1542,14 @@ static int __init init_nfsd(void)
>  		goto out_free_exports;
>  	retval = register_pernet_subsys(&nfsd_net_ops);
>  	if (retval < 0)
> +		goto out_free_filesystem;
> +	retval = register_cld_notifier();
> +	if (retval)
>  		goto out_free_all;
>  	return 0;
>  out_free_all:
> +	unregister_pernet_subsys(&nfsd_net_ops);
> +out_free_filesystem:
>  	unregister_filesystem(&nfsd_fs_type);
>  out_free_exports:
>  	remove_proc_entry("fs/nfs/exports", NULL);
> @@ -1561,13 +1563,12 @@ static int __init init_nfsd(void)
>  	nfsd4_exit_pnfs();
>  out_free_slabs:
>  	nfsd4_free_slabs();
> -out_unregister_notifier:
> -	unregister_cld_notifier();
>  	return retval;
>  }
>  
>  static void __exit exit_nfsd(void)
>  {
> +	unregister_cld_notifier();
>  	unregister_pernet_subsys(&nfsd_net_ops);
>  	nfsd_drc_slab_free();
>  	remove_proc_entry("fs/nfs/exports", NULL);
> @@ -1577,7 +1578,6 @@ static void __exit exit_nfsd(void)
>  	nfsd4_free_slabs();
>  	nfsd4_exit_pnfs();
>  	unregister_filesystem(&nfsd_fs_type);
> -	unregister_cld_notifier();
>  }
>  
>  MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
> -- 
> 2.10.2
