Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00D285003
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJFQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 12:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFQi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Oct 2020 12:38:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3787206D4;
        Tue,  6 Oct 2020 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602002309;
        bh=0fRyHS7MrgItrw+4TpYkdDYhQfYc2e4sUg/MYj4Yf+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKgav8ZerXuhxitQ4uh3jTqJxc0TlHrK5bQRZ1BhF2838ZS3fCzKwvw/WIBg5WnCX
         zcBPDeFvIszqA6jc0U64c+A7Rx4SUP2z7neSpS+SmJVCgJcN9VWP7OPdmh34lkPc6S
         3LdQf1UmoIUAMyN9Tw8KwSo+mCr3fzY5Jo88Sx68=
Date:   Tue, 6 Oct 2020 18:39:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] drm/syncobj: Fix drm_syncobj_handle_to_fd
 refcount leak
Message-ID: <20201006163914.GA36638@kroah.com>
References: <20201006135228.113259-2-gprocida@google.com>
 <20201006162000.1146391-1-gprocida@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006162000.1146391-1-gprocida@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 06, 2020 at 05:20:00PM +0100, Giuliano Procida wrote:
> Commit 5fb252cad61f20ae5d5a8b199f6cc4faf6f418e1, a cherry-pick of
> upstream commit e7cdf5c82f1773c3386b93bbcf13b9bfff29fa31, introduced a
> refcount imbalance and thus a struct drm_syncobj object leak which can
> be triggered with DRM_IOCTL_SYNCOBJ_HANDLE_TO_FD.
> 
> The function drm_syncobj_handle_to_fd first calls drm_syncobj_find
> which increments the refcount of the object on success. In all of the
> drm_syncobj_handle_to_fd error paths, the refcount is decremented, but
> in the success path the refcount should remain at +1 as the struct
> drm_syncobj now belongs to the newly opened file. Instead, the
> refcount was incremented again to +2.
> 
> Fixes: 5fb252cad61f ("drm/syncobj: Stop reusing the same struct file for all syncobj -> fd")
> Signed-off-by: Giuliano Procida <gprocida@google.com>
> ---
>  drivers/gpu/drm/drm_syncobj.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_syncobj.c b/drivers/gpu/drm/drm_syncobj.c
> index 889c95d4feec..3f71bc3d93fe 100644
> --- a/drivers/gpu/drm/drm_syncobj.c
> +++ b/drivers/gpu/drm/drm_syncobj.c
> @@ -355,7 +355,6 @@ static int drm_syncobj_handle_to_fd(struct drm_file *file_private,
>  		return PTR_ERR(file);
>  	}
>  
> -	drm_syncobj_get(syncobj);
>  	fd_install(fd, file);
>  
>  	*p_fd = fd;
> -- 
> 2.28.0.806.g8561365e88-goog
> 

Thanks, that worked, now queued up!

greg k-h
