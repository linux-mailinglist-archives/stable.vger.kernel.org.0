Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5285015F913
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388398AbgBNVyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388314AbgBNVyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:43 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8341E222C4;
        Fri, 14 Feb 2020 21:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717282;
        bh=D5P4kvvPGXWzS41Um5m7v8Cms+3z0uV0f+EbWgL/Wac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BB12WRc3qPtAPbIc12JSTy1L7iFcbp9ZU7UL830LMJffofRJI2Bz9tmaW0OAfA7g0
         rbxk1RVn4X6tWo1wAeMx0EMhLGzKlEOmvfJxIJiruvNP7+xIEuo86hKDvZciEiCWry
         +71k6EfbhLtyIMVmeayjhVab7J+TvD0OmIKuyPpE=
Date:   Fri, 14 Feb 2020 16:51:34 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Engraf <david.engraf@sysgo.com>,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.5 222/542] Revert "tty/serial: atmel: fix out
 of range clock divider handling"
Message-ID: <20200214215134.GK4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-222-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-222-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:43:34AM -0500, Sasha Levin wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [ Upstream commit 6dbd54e4154dfe386b3333687de15be239576617 ]
> 
> This reverts commit 751d0017334db9c4d68a8909c59f662a6ecbcec6.
> 
> The wrong commit got added to the tty-next tree, the correct one is in
> the tty-linus branch.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: David Engraf <david.engraf@sysgo.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/tty/serial/atmel_serial.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 1ba9bc667e136..ab4d4a0b36497 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -2270,6 +2270,9 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
>  		mode |= ATMEL_US_USMODE_NORMAL;
>  	}
>  
> +	/* set the mode, clock divisor, parity, stop bits and data size */
> +	atmel_uart_writel(port, ATMEL_US_MR, mode);
> +
>  	/*
>  	 * Set the baud rate:
>  	 * Fractional baudrate allows to setup output frequency more
> -- 
> 2.20.1
> 

Are you sure this is correct to be added?  This was the result of some
fun merge problems, I don't think it's needed anywhere else...

greg k-h
