Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA11D4695
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 09:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgEOG7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 02:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgEOG7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 02:59:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22A5E206F1;
        Fri, 15 May 2020 06:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589525956;
        bh=9cSL3vu771NfN0pfXk55qxsvH0Q6psTuls0f4Kl3nyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0nJ5i9FRXXLDiRk9PQvQz2HX7KTJbOK7l4R/yzu2bL+RY5VgFcsP8jUrV62+sOh+
         vBuBclR8xIDNt0FUEpOppB7Dkbxpze2UmF0WLmHw2xD1W2AmMAupw7cWrUXDRgqMoL
         thWwyXkaKoYjxikJ9pWY2j4/71Oe39VxpmrWNRh0=
Date:   Fri, 15 May 2020 08:59:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 5.6 16/62] most: core: use function
 subsys_initcall()
Message-ID: <20200515065914.GB1006524@kroah.com>
References: <20200514185147.19716-1-sashal@kernel.org>
 <20200514185147.19716-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514185147.19716-16-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 02:51:01PM -0400, Sasha Levin wrote:
> From: Christian Gromm <christian.gromm@microchip.com>
> 
> [ Upstream commit 5e56bc06e18dfc8a66180fa369384b36e2ab621a ]
> 
> This patch replaces function module_init() with subsys_initcall().
> It is needed to ensure that the core module of the driver is
> initialized before a component tries to register with the core. This
> leads to a NULL pointer dereference if the driver is configured as
> in-tree.
> 
> Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/r/1587741394-22021-1-git-send-email-christian.gromm@microchip.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/most/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/most/core.c b/drivers/staging/most/core.c
> index 0c4ae6920d77d..409c48c597f2f 100644
> --- a/drivers/staging/most/core.c
> +++ b/drivers/staging/most/core.c
> @@ -1484,7 +1484,7 @@ static void __exit most_exit(void)
>  	ida_destroy(&mdev_id);
>  }
>  
> -module_init(most_init);
> +subsys_initcall(most_init);
>  module_exit(most_exit);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Christian Gromm <christian.gromm@microchip.com>");

This is not needed in 5.6 and older kernels due to the most/core.c code
being in staging for these releases.  It only became an issue when it
moved out of staging.

So please drop this from here and any older trees you might have
selected it for.

thanks,

greg k-h
