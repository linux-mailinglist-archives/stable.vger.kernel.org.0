Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240171F665A
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 13:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgFKLPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 07:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFKLPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 07:15:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36A8220760;
        Thu, 11 Jun 2020 11:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591874112;
        bh=Tv/EbttVwF+5ktI1P8KC8CxCiTWM1gF45NiEJ816fMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pUQ2EzynsfIi8ZloTxB3jORZ4A4P++88hY5FQUpeCQmSQyxcb7GRe/igSj7bjdS6E
         /PGLNDh4qxWKotA3DD8fKksNtUrPixYMi9C04iBTWGEDG0YQsftSr9KyrGiqzibjpi
         FspEMTgLb5uwueQblhIKJv8x3zxuwFIvT7hbS76A=
Date:   Thu, 11 Jun 2020 13:15:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: Suggest make 'user_access_begin()' do 'access_ok()' to stable
 kernel
Message-ID: <20200611111506.GE3802953@kroah.com>
References: <1591811900.26208.17.camel@mtkswgap22>
 <20200610180249.GA5500@kroah.com>
 <1591839462.26208.24.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591839462.26208.24.camel@mtkswgap22>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 09:37:42AM +0800, Miles Chen wrote:
> @@ -2601,7 +2603,17 @@ i915_gem_execbuffer2_ioctl(struct drm_device *dev, void *data,
>  		unsigned int i;
>  
>  		/* Copy the new buffer offsets back to the user's exec list. */
> -		user_access_begin();
> +		/*
> +		 * Note: count * sizeof(*user_exec_list) does not overflow,
> +		 * because we checked 'count' in check_buffer_count().
> +		 *
> +		 * And this range already got effectively checked earlier
> +		 * when we did the "copy_from_user()" above.
> +		 */
> +		if (!user_access_begin(VERIFY_WRITE, user_exec_list,
> +				       count * sizeof(*user_exec_list)))
> +			goto end_user;
> +
>  		for (i = 0; i < args->buffer_count; i++) {
>  			if (!(exec2_list[i].offset & UPDATE))
>  				continue;

No one seems to have test-built this code, it fails here on the 4.14.y
kernel  :(

I'll go fix it up, but please, always at the very least, test build your
patches before sending them out...

thanks,

greg k-h
