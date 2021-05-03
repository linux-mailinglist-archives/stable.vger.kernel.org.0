Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34C37238A
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 01:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhECXVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 19:21:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:54912 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhECXVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 19:21:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9A95B1FE;
        Mon,  3 May 2021 23:20:28 +0000 (UTC)
Date:   Tue, 4 May 2021 01:20:27 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, aaptel@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] cifs: fix regression when mounting shares with
 prefix paths
Message-ID: <20210504012027.6deac39a@suse.de>
In-Reply-To: <20210503145526.9705-1-pc@cjr.nz>
References: <20210430221621.7497-1-pc@cjr.nz>
        <20210503145526.9705-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon,  3 May 2021 11:55:26 -0300, Paulo Alcantara wrote:

> The commit 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> revealed an existing bug when mounting shares that contain a prefix
> path or DFS links.
> 
> cifs_setup_volume_info() requires the @devname to contain the full
> path (UNC + prefix) to update the fs context with the new UNC and
> prepath values, however we were passing only the UNC
> path (old_ctx->UNC) in @device thus discarding any prefix paths.
> 
> Instead of concatenating both old_ctx->{UNC,prepath} and pass it in
> @devname, just keep the dup'ed values of UNC and prepath in
> cifs_sb->ctx after calling smb3_fs_context_dup(), and fix
> smb3_parse_devname() to correctly parse and not leak the new UNC and
> prefix paths.
> 
> Cc: <stable@vger.kernel.org> # v5.11+
> Fixes: 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c     |  8 +-------
>  fs/cifs/connect.c    | 24 ++++++++++++++++++------
>  fs/cifs/fs_context.c |  4 ++++
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 8a6894577697..d7ea9c5fe0f8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -863,13 +863,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>  		goto out;
>  	}
>  
> -	/* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
> -	kfree(cifs_sb->ctx->UNC);
> -	cifs_sb->ctx->UNC = NULL;
> -	kfree(cifs_sb->ctx->prepath);
> -	cifs_sb->ctx->prepath = NULL;
> -
> -	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
> +	rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, NULL);

IIUC, with the new behaviour, this call becomes pretty much an
	if (!cifs_sb->ctx->username)
		root = ERR_PTR(-EINVAL);

So it might be worth simplifying this further. Either way:
Acked-by: David Disseldorp <ddiss@suse.de>

Cheers, David
