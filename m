Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE4F15F90B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgBNVye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387666AbgBNVyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:33 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0823B2168B;
        Fri, 14 Feb 2020 21:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717273;
        bh=hYecJEDTMS4sRitWMiS4XFnCF5z2Aq11PjB0ocf5FBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=efxubQc02cob0OZRWoak22UQRTd1ture8757Wvxpl1sJrxttz+uMoE1OapwO9G/CT
         rPdHFMetp53Bqm3kwxbnxS2qZXXQ3WMJAncji36qMySi33bKGv75PkcEo9jf6eRl2K
         p0mUjGuYet/enBHsH62vYCeNBn1zQ0HWcBivjdh8=
Date:   Fri, 14 Feb 2020 16:48:23 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH AUTOSEL 5.5 456/542] char: hpet: Use flexible-array member
Message-ID: <20200214214823.GD4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-456-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-456-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:47:28AM -0500, Sasha Levin wrote:
> From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
> 
> [ Upstream commit 987f028b8637cfa7658aa456ae73f8f21a7a7f6f ]
> 
> Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
> presence of a "variable length array":
> 
> struct something {
>     int length;
>     u8 data[1];
> };
> 
> struct something *instance;
> 
> instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
> instance->length = size;
> memcpy(instance->data, source, size);
> 
> There is also 0-byte arrays. Both cases pose confusion for things like
> sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
> to declare variable-length types such as the one above is a flexible array
> member[2] which need to be the last member of a structure and empty-sized:
> 
> struct something {
>         int stuff;
>         u8 data[];
> };
> 
> Also, by making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> unadvertenly introduced[3] to the codebase from now on.
> 
> [1] https://github.com/KSPP/linux/issues/21
> [2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Link: https://lore.kernel.org/r/20200120235326.GA29231@embeddedor.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/char/hpet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 9ac6671bb5141..aed2c45f7968c 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -110,7 +110,7 @@ struct hpets {
>  	unsigned long hp_delta;
>  	unsigned int hp_ntimer;
>  	unsigned int hp_which;
> -	struct hpet_dev hp_dev[1];
> +	struct hpet_dev hp_dev[];
>  };
>  
>  static struct hpets *hpets;
> -- 
> 2.20.1
> 

Not needed, please drop from all trees.  Along with the other hpet patch
that fixes the bug this one introduced :)

thanks,

greg k-h
