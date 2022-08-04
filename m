Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8F589933
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 10:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbiHDIVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237494AbiHDIVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 04:21:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A08C57235
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 01:21:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE0C2B82444
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 08:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02660C433D6;
        Thu,  4 Aug 2022 08:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659601257;
        bh=Deo3rX62CbuUbNBTnppRVqSkKwlV4V6XACZiRZGW5Rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SpYg2q3B9nU4wm5JY0sLuTCAtY0mbXg1FEtglHfrpJgxzZb5mFflroT0UTkt9ZYKl
         3bmTfrxafwfY64BMXdXWviomXb+d4FKLNLlMcWkunLeOaJBQ77GQrTKZZ4/RNYHMGE
         W5u/drcykRjR2On1OVCTNH9Oy/jwRz7uP0mM3Lwk=
Date:   Thu, 4 Aug 2022 10:20:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chen Jun <chenjun102@huawei.com>
Cc:     stable@vger.kernel.org, xuqiang36@huawei.com
Subject: Re: [PATCH stable 4.14 1/1] printk: Export is_console_locked
Message-ID: <YuuBZnYkRSF61TsM@kroah.com>
References: <20220804070025.122783-1-chenjun102@huawei.com>
 <20220804070025.122783-2-chenjun102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804070025.122783-2-chenjun102@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 07:00:25AM +0000, Chen Jun wrote:
> From: Hans de Goede <hdegoede@redhat.com>
> 
> commit d48de54a9dab5370edd2e991f78cc7996cf5483e upstream
> 
> This is a preparation patch for adding a number of WARN_CONSOLE_UNLOCKED()
> calls to the fbcon code, which may be built as a module (event though
> usually it is not).
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Acked-by: Petr Mladek <pmladek@suse.com>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Chen Jun <chenjun102@huawei.com>
> ---
>  kernel/printk/printk.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 11173d0b51bc..ad4772869d48 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2259,6 +2259,7 @@ int is_console_locked(void)
>  {
>  	return console_locked;
>  }
> +EXPORT_SYMBOL(is_console_locked);
>  
>  /*
>   * Check if we have any console that is capable of printing while cpu is
> -- 
> 2.17.1
> 

This patch makes no sense on it's own, please make it part of a larger
series that requires it.

Also, for some reason you didn't cc: all of the people involved in the
change, which is a bit odd.

thanks,

greg k-h
