Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE4E6A68FE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 09:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCAIjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 03:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCAIjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 03:39:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1978688;
        Wed,  1 Mar 2023 00:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0459E6124D;
        Wed,  1 Mar 2023 08:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D27AC433D2;
        Wed,  1 Mar 2023 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677659988;
        bh=7QrITpaZU3kn9dpEhLJ17MGGgkznJxYNhP7TuOD6FKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m19V7SMtLBgZFm0gcfSjVcv3Mi07dJijAxRNzfulhvO06DKnsz7icLUb1oxkfAenc
         18tlinGWWGekAjPZIA0C7JcioS8UJqeMrl4O3X5H79f3lzIe6IXmKk4X4PKY3KxSg/
         0eylGSMqJhrsbuJFbXxIGyw1ffilMjpBWz9XHTzQ=
Date:   Wed, 1 Mar 2023 09:39:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com, stable@vger.kernel.org
Subject: Re: [PATCH] serial: core: fix broken console after suspend
Message-ID: <Y/8PUdEwskXuWZHA@kroah.com>
References: <20230301075751.43839-1-lma@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301075751.43839-1-lma@semihalf.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 08:57:51AM +0100, Lukasz Majczak wrote:
> Re-enable the console device after suspending, causes its cflags,
> ispeed and ospeed to be set anew, basing on the values stored in
> uport->cons. The issue is that these values are set only once,
> when parsing console parameters after boot (see uart_set_options()),
> next after configuring a port in uart_port_startup() these parameteres
> (cflags, ispeed and ospeed) are copied to termios structure and
> the orginal one (stored in uport->cons) are cleared, but there is no place
> in code where those fields are checked against 0.
> When kernel calls uart_resume_port() and setups console, it copies cflags,
> ispeed and ospeed values from uart->cons,but those are alread cleared.
> The efect is that console is broken.
> This patch address this by preserving the cflags, ispeed and
> ospeed fields in uart->cons during uart_port_startup().
> 
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/tty/serial/serial_core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 2bd32c8ece39..394a05c09d87 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>  			tty->termios.c_cflag = uport->cons->cflag;
>  			tty->termios.c_ispeed = uport->cons->ispeed;
>  			tty->termios.c_ospeed = uport->cons->ospeed;
> -			uport->cons->cflag = 0;
> -			uport->cons->ispeed = 0;
> -			uport->cons->ospeed = 0;
>  		}
>  		/*
>  		 * Initialise the hardware port settings.
> -- 
> 2.39.2.722.g9855ee24e9-goog
> 

What commit id does this fix?

thanks,

greg k-h
