Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2C7195108
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 07:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgC0G1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 02:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbgC0G1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 02:27:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B8C20705;
        Fri, 27 Mar 2020 06:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585290467;
        bh=Dpbh2qTT1euTuHgN4OP1pIfySN+NtQkwvFBKRFehaMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCdgY7C7ixPhqUHVLx5UNeQ4K8PpEGG4l803HIGGCDbMDNTOjj0wp/zLL4tAyce/R
         3cfoXBZRVeQOvGRwa0NcSbYATpzgiiC3+mOjJo4p5k1TWM5x749AHeKLOJLIF4XXl8
         z0bG18wzMiXaQhRR7mriwbxcqpELgABhLde+gtE0=
Date:   Fri, 27 Mar 2020 07:27:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        syzbot+8da9175e28eadcb203ce@syzkaller.appspotmail.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH AUTOSEL 5.5 27/28] tty: fix compat TIOCGSERIAL leaking
 uninitialized memory
Message-ID: <20200327062744.GC1601217@kroah.com>
References: <20200326232357.7516-1-sashal@kernel.org>
 <20200326232357.7516-27-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326232357.7516-27-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 07:23:56PM -0400, Sasha Levin wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> [ Upstream commit 17329563a97df3ba474eca5037c1336e46e14ff8 ]
> 
> Commit 77654350306a ("take compat TIOC[SG]SERIAL treatment into
> tty_compat_ioctl()") changed the compat version of TIOCGSERIAL to start
> copying a whole 'serial_struct32' to userspace rather than individual
> fields, but failed to initialize all padding and fields -- namely the
> hole after the 'iomem_reg_shift' field, and the 'reserved' field.
> 
> Fix this by initializing the struct to zero.
> 
> [v2: use sizeof, and convert the adjacent line for consistency.]
> 
> Reported-by: syzbot+8da9175e28eadcb203ce@syzkaller.appspotmail.com
> Fixes: 77654350306a ("take compat TIOC[SG]SERIAL treatment into tty_compat_ioctl()")
> Cc: <stable@vger.kernel.org> # v4.20+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Jiri Slaby <jslaby@suse.cz>
> Link: https://lore.kernel.org/r/20200224182044.234553-2-ebiggers@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/tty_io.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index d9f54c7d94f29..186e08a81b986 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -2734,7 +2734,9 @@ static int compat_tty_tiocgserial(struct tty_struct *tty,
>  	struct serial_struct32 v32;
>  	struct serial_struct v;
>  	int err;
> -	memset(&v, 0, sizeof(struct serial_struct));
> +
> +	memset(&v, 0, sizeof(v));
> +	memset(&v32, 0, sizeof(v32));
>  
>  	if (!tty->ops->set_serial)
>  		return -ENOTTY;
> -- 
> 2.20.1
> 

This is already in 5.4.28 and 5.5.12, so no need to add it again :)
