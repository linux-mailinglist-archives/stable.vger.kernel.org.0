Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7E37C566
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhELPju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234879AbhELPeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:34:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E86561971;
        Wed, 12 May 2021 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620832649;
        bh=udW/PLZ5iZPSNRhPqLGSKInIoq9dtLr6gVmuhkHoe3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uw346nuZgdXAjMrtIW7Wl1wjoU/XEuK3mQaevlbO7TxfuHuON94vksTuQ6X2qc0p8
         NTXevC0ntw3PztvtTBceiK3fJcsYNfPixJLctn1nIY69kb2bP/Km8unlNGpPwhhoTF
         bAt2eXWwnZ3SO4PHibR+soP14e0UTAMrhZehMK8mhXgGJ+PGbDrOGmqxnUL6nlCC8x
         osG7SL+Ph2Rpa5dRHSTwDfOLbsW1gFlQ4RFYWeHprAnP+sV+m77qSk6CxDcUzcW9cL
         lMZE+/p9gvmn+QsXu+ESR8SVVuH/lVVDzaMx/E2VudSrZqxhgTexr4YvmT+mN6HIj/
         tlo9UYdVcKagA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lgqc8-0005RE-54; Wed, 12 May 2021 17:17:32 +0200
Date:   Wed, 12 May 2021 17:17:32 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 245/530] tty: actually undefine superseded ASYNC
 flags
Message-ID: <YJvxjC5qyyRmLSyB@hovoldconsulting.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144827.885941093@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144827.885941093@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 04:45:55PM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit d09845e98a05850a8094ea8fd6dd09a8e6824fff ]
> 
> Some kernel-internal ASYNC flags have been superseded by tty-port flags
> and should no longer be used by kernel drivers.
> 
> Fix the misspelled "__KERNEL__" compile guards which failed their sole
> purpose to break out-of-tree drivers that have not yet been updated.
> 
> Fixes: 5c0517fefc92 ("tty: core: Undefine ASYNC_* flags superceded by TTY_PORT* flags")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20210407095208.31838-2-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't think this should be backported to any stable tree and the
stable tag was left out on purpose.

> ---
>  include/uapi/linux/tty_flags.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
> index 900a32e63424..6a3ac496a56c 100644
> --- a/include/uapi/linux/tty_flags.h
> +++ b/include/uapi/linux/tty_flags.h
> @@ -39,7 +39,7 @@
>   * WARNING: These flags are no longer used and have been superceded by the
>   *	    TTY_PORT_ flags in the iflags field (and not userspace-visible)
>   */
> -#ifndef _KERNEL_
> +#ifndef __KERNEL__
>  #define ASYNCB_INITIALIZED	31 /* Serial port was initialized */
>  #define ASYNCB_SUSPENDED	30 /* Serial port is suspended */
>  #define ASYNCB_NORMAL_ACTIVE	29 /* Normal device is active */
> @@ -81,7 +81,7 @@
>  #define ASYNC_SPD_WARP		(ASYNC_SPD_HI|ASYNC_SPD_SHI)
>  #define ASYNC_SPD_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI|ASYNC_SPD_SHI)
>  
> -#ifndef _KERNEL_
> +#ifndef __KERNEL__
>  /* These flags are no longer used (and were always masked from userspace) */
>  #define ASYNC_INITIALIZED	(1U << ASYNCB_INITIALIZED)
>  #define ASYNC_NORMAL_ACTIVE	(1U << ASYNCB_NORMAL_ACTIVE)

Johan
