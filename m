Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFB6186F29
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 16:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbgCPPux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 11:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731900AbgCPPux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 11:50:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E9220679;
        Mon, 16 Mar 2020 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584373853;
        bh=rbANWY1l0rPJbHJS6XacrnBBTbXWqQLGIjQWBVITRKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ScanIYxm72MMOCqWKOeJVo+71P/02XsbhqjZtCeo8mZHxhRJ5faRrg95pSKfRBvP4
         lQB/qPC/kvFExVkfMoFjCCfyXupfAJLHw8I5ya/mcWhl9qeiIeO4GogcrEnsdkLNty
         tAE1FrRXHH1XWaCatzKN5qpSGkD25tkDoUTzRJks=
Date:   Mon, 16 Mar 2020 16:50:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19, 4.14, 4.9, 4.4 2/2] efi: Add a sanity check to
 efivar_store_raw()
Message-ID: <20200316155051.GA28536@kroah.com>
References: <20200316131938.31453-1-vdronov@redhat.com>
 <20200316131938.31453-3-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316131938.31453-3-vdronov@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 02:19:38PM +0100, Vladis Dronov wrote:
> commit d6c066fda90d578aacdf19771a027ed484a79825 upstream.
> 
> Add a sanity check to efivar_store_raw() the same way
> efivar_{attr,size,data}_read() and efivar_show_raw() have it.
> 
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
> Link: https://lore.kernel.org/r/20200308080859.21568-25-ardb@kernel.org
> ---
>  drivers/firmware/efi/efivars.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index c8688490f148..1c65f5ac4368 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -272,6 +272,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
>  	u8 *data;
>  	int err;
>  
> +	if (!entry || !buf)
> +		return -EINVAL;
> +
>  	if (is_compat()) {
>  		struct compat_efi_variable *compat;
>  
> -- 
> 2.20.1
> 

Now queued up, thanks.

greg k-h
