Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602D55082EE
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376454AbiDTH5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 03:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376353AbiDTH5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 03:57:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCB23BFB6;
        Wed, 20 Apr 2022 00:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79EC8B81D57;
        Wed, 20 Apr 2022 07:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37635C385A1;
        Wed, 20 Apr 2022 07:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650441268;
        bh=m7SJlIg5E2sbLVUQXHfM+atL0bL9CBE9VGEBCjYDBYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=shbRd2h+1XWVxCtCQFYLTVN1JLc40NI/8P2gc/nlY1N6zvh7LZ6XF5Bt007nNKVdi
         T10A+G1qYoY9qxbTCHwkIaxtYAR9BEFM5topBWGcAR/d9oHT4o972uquZd/marHEQx
         jh/QJb/sIZ4k9/7JcO6tVj4xNdyRcXDveJ2mfLLnUmXMp0NHFb4xScjuxOjaDjVl6E
         8FdH4yLhauzytLYejaEOcWkzeYCKs7bBII+8uHp0vXU7xnIiI+KtNrQt14j9i4dtSw
         QnCOCggp47eWVzu2B622QBD8wtI55rtgpyxQk6ZH4pr+3QKMypgwKH3lZdVcmCeGWP
         jAxfeGQis/GGQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nh5AJ-0006YM-O9; Wed, 20 Apr 2022 09:54:20 +0200
Date:   Wed, 20 Apr 2022 09:54:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] USB: serial: Fix heap overflow in WHITEHEAT_GET_DTR_RTS
Message-ID: <Yl+8K++wZUJCthMj@hovoldconsulting.com>
References: <20220419041742.4117026-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419041742.4117026-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 09:17:42PM -0700, Kees Cook wrote:
> This looks like it's harmless, as both the source and the destinations are
> currently the same allocation size (4 bytes) and don't use their padding,
> but if anything were to ever be added after the "mcr" member in "struct
> whiteheat_private", it would be overwritten. The structs both have a
> single u8 "mcr" member, but are 4 bytes in padded size. The memcpy()
> destination was explicitly targeting the u8 member (size 1) with the
> length of the whole structure (size 4), triggering the memcpy buffer
> overflow warning:

Ehh... No. The size of a structure with a single u8 is 1, not 4. There's
nothing wrong with the current code even if the use of memcpy for this
is a bit odd.

> In file included from include/linux/string.h:253,
>                  from include/linux/bitmap.h:11,
>                  from include/linux/cpumask.h:12,
>                  from include/linux/smp.h:13,
>                  from include/linux/lockdep.h:14,
>                  from include/linux/spinlock.h:62,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:6,
>                  from include/linux/slab.h:15,
>                  from drivers/usb/serial/whiteheat.c:17:
> In function 'fortify_memcpy_chk',
>     inlined from 'firm_send_command' at drivers/usb/serial/whiteheat.c:587:4:
> include/linux/fortify-string.h:328:25: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
>   328 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So something is confused here.
 
> Expand the memcpy() to the entire structure, though perhaps the correct
> solution is to mark all the USB command structures as "__packed".

Again no, why would you potentially overwrite the whole structure just to
update a single field? This is just wrong.

And the only structure that needs a __packed which doesn't have it
already is the unused struct whiteheat_dump.

> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/202204142318.vDqjjSFn-lkp@intel.com
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/usb/serial/whiteheat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
> index da65d14c9ed5..6e00498843fb 100644
> --- a/drivers/usb/serial/whiteheat.c
> +++ b/drivers/usb/serial/whiteheat.c
> @@ -584,7 +584,7 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
>  		switch (command) {
>  		case WHITEHEAT_GET_DTR_RTS:
>  			info = usb_get_serial_port_data(port);
> -			memcpy(&info->mcr, command_info->result_buffer,
> +			memcpy(info, command_info->result_buffer,
>  					sizeof(struct whiteheat_dr_info));
>  				break;
>  		}

Johan
