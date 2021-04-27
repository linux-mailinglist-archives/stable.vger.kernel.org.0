Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA236C9E1
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhD0Q72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 12:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237720AbhD0Q71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 12:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA6561165;
        Tue, 27 Apr 2021 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619542723;
        bh=wERojalQ9dUWLbKBoiBa7cXRmoy3rgdT4eSYH2cRmew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIETlKK7KKOunXOjbqIpzyBvi8EU4ZAuTAlTLc9pJwDh29Q0TBzwoslu1BNB3LG4A
         EsJWhSxHGJP8aQrOZK3wDbKx6lbZeHBkGEzkS7S0csRsHXiSk1817nIdOk7j4Uz7ZG
         furEgWnId4H6BiyflxCW5pmiYw8YVj8nA3Je7dkM=
Date:   Tue, 27 Apr 2021 18:58:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 181/190] Revert "dm ioctl: harden copy_params()'s
 copy_from_user() from malicious users"
Message-ID: <YIhCwe+FVtgm0LlD@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-182-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421130105.1226686-182-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 03:00:56PM +0200, Greg Kroah-Hartman wrote:
> This reverts commit 800a7340ab7dd667edf95e74d8e4f23a17e87076.
> 
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
> 
> Cc: stable@vger.kernel.org
> Cc: Wenwen Wang <wang6495@umn.edu>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/md/dm-ioctl.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 1ca65b434f1f..820342de92cd 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1747,7 +1747,8 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
>  }
>  
>  static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
> -		       int ioctl_flags, struct dm_ioctl **param, int *param_flags)
> +		       int ioctl_flags,
> +		       struct dm_ioctl **param, int *param_flags)
>  {
>  	struct dm_ioctl *dmi;
>  	int secure_data;
> @@ -1788,13 +1789,18 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>  
>  	*param_flags |= DM_PARAMS_MALLOC;
>  
> -	/* Copy from param_kernel (which was already copied from user) */
> -	memcpy(dmi, param_kernel, minimum_data_size);
> -
> -	if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,
> -			   param_kernel->data_size - minimum_data_size))
> +	if (copy_from_user(dmi, user, param_kernel->data_size))
>  		goto bad;
> +
>  data_copied:
> +	/*
> +	 * Abort if something changed the ioctl data while it was being copied.
> +	 */
> +	if (dmi->data_size != param_kernel->data_size) {
> +		DMERR("rejecting ioctl: data size modified while processing parameters");
> +		goto bad;
> +	}
> +
>  	/* Wipe the user buffer so we do not return it to userspace */
>  	if (secure_data && clear_user(user, param_kernel->data_size))
>  		goto bad;
> -- 
> 2.31.1
> 

Original looks correct, dropping this commit now.

greg k-h
