Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14EA4EC1C7
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345062AbiC3L5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345518AbiC3Lyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1C6285689;
        Wed, 30 Mar 2022 04:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20651B81BBA;
        Wed, 30 Mar 2022 11:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F96BC340F3;
        Wed, 30 Mar 2022 11:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648641071;
        bh=nxIOltSbaG5GUENpJGaaI5NG9vqyMlBWdNn62tdSYpI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCN3nMJVHP7fOrepSPYIMkGHpLJt/To1QsAwCumPKeOqWpTUTVJak536qf7GsUn6w
         8Yg2fXEKXgDM6tDdckGrvlqjonaC8k//0JD2Z4O15h1z82YJ2LRHYQQ6EgNhVM99pv
         m38HZt28ms9cJMDlVfqJnR7heAzRyHQJiJLaE15w=
Date:   Wed, 30 Mar 2022 13:51:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Brennan <stephen.s.brennan@oracle.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux@roeck-us.net
Subject: Re: [PATCH AUTOSEL 5.17 31/66] printk: Add panic_in_progress helper
Message-ID: <YkRELPuydJ5Fn3It@kroah.com>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330114646.1669334-31-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 07:46:10AM -0400, Sasha Levin wrote:
> From: Stephen Brennan <stephen.s.brennan@oracle.com>
> 
> [ Upstream commit 77498617857f68496b360081dde1a492d40c28b2 ]
> 
> This will be used help avoid deadlocks during panics. Although it would
> be better to include this in linux/panic.h, it would require that header
> to include linux/atomic.h as well. On some architectures, this results
> in a circular dependency as well. So instead add the helper directly to
> printk.c.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Link: https://lore.kernel.org/r/20220202171821.179394-2-stephen.s.brennan@oracle.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/printk/printk.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 82abfaf3c2aa..0f8918f5f22a 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -257,6 +257,11 @@ static void __up_console_sem(unsigned long ip)
>  }
>  #define up_console_sem() __up_console_sem(_RET_IP_)
>  
> +static bool panic_in_progress(void)
> +{
> +	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
> +}
> +
>  /*
>   * This is used for debugging the mess that is the VT code by
>   * keeping track if we have the console semaphore held. It's
> -- 
> 2.34.1
> 

All 4 of the printk patches should not need to be backported to stable
kernels, thanks.  Please drop them all.

greg k-h
