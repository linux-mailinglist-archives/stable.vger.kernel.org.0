Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143CF45D9DD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 13:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348908AbhKYMUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 07:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241229AbhKYMSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 07:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C70461059;
        Thu, 25 Nov 2021 12:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637842533;
        bh=uEqGHPfzJaVjnN6E+ChIXI7R5xlqHtRUDyOWmJ3VNmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X6Ygs4zkqMtURBYWuQQ4+t5/N/WWbQWheGkvKm9SSqLzLC89R0lysM/4dGq4KCdMR
         eaBkxnjgy5y6nEx7YP+W4/AY3YaZIBtbpqud8rFULcEr9uKVgL25T39XilyKH+SURb
         AjbluGVF7xbjFkDUpTfOkLZ5F9ALVEM1BeLlzQqI=
Date:   Thu, 25 Nov 2021 13:15:28 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     devel@driverdev.osuosl.org, arve@android.com,
        stable@vger.kernel.org, riandrews@android.com, labbott@redhat.com,
        sumit.semwal@linaro.org
Subject: Re: [PATCH 1/1] staging: ion: Prevent incorrect reference counting
 behavour
Message-ID: <YZ9+YPc7w9Z4xotR@kroah.com>
References: <20211125120234.67987-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125120234.67987-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 12:02:34PM +0000, Lee Jones wrote:
> Supply additional checks in order to prevent unexpected results.
> 
> Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/staging/android/ion/ion.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 806e9b30b9dc8..30f359faba575 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -509,6 +509,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
>  	void *vaddr;
>  
>  	if (handle->kmap_cnt) {
> +		if (handle->kmap_cnt + 1 < handle->kmap_cnt)

What about using the nice helpers in overflow.h for this?

> +			return ERR_PTR(-EOVERFLOW);
> +
>  		handle->kmap_cnt++;
>  		return buffer->vaddr;
>  	}
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog

What stable kernel branch(es) is this for?

thanks,

greg k-h
