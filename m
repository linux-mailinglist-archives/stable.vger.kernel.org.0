Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68C169D36D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjBTSzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjBTSzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:55:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9156F21953
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B162B60EFC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 18:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFB6C4339B;
        Mon, 20 Feb 2023 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676919243;
        bh=hJrpKqTnxI4zyuNbrzixLOkLRSfDcRmONRhYrTAGfBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vzanXum8RleIoRf0tj3Fd+6VhSY6GNDCAHuOfuCHl/QmsDRFmR1lGlIeSdFzQLvu3
         28JqlOLDxHg+zrXFFvdDN6JK0PFmKDIgiFZHCEiv+ry8+8plyRd7dd4IGFwrhqASI8
         2bMbhWBKUuQO24rL7+0sDZRUJvsC+2Tznz0B5jZI=
Date:   Mon, 20 Feb 2023 19:54:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V1] rcu-tasks: Fix build error
Message-ID: <Y/PByBdfz/WPBs2W@kroah.com>
References: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1676916839-32235-1-git-send-email-quic_c_spathi@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:43:59PM +0530, Srinivasarao Pathipati wrote:
> Making show_rcu_tasks_rude_gp_kthread() function as 'inline' to
> fix below compilation error.
> This is applicable to only 5.10 kernels as code got modified
> in latest kernels.
> 
>  In file included from kernel/rcu/update.c:579:0:
>  kernel/rcu/tasks.h:710:13: error: ‘show_rcu_tasks_rude_gp_kthread’ defined but not used [-Werror=unused-function]
>   static void show_rcu_tasks_rude_gp_kthread(void) {}
> 
> Signed-off-by: Srinivasarao Pathipati <quic_c_spathi@quicinc.com>
> ---
>  kernel/rcu/tasks.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index 8b51e6a..53ddb4e 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -707,7 +707,7 @@ static void show_rcu_tasks_rude_gp_kthread(void)
>  #endif /* #ifndef CONFIG_TINY_RCU */
>  
>  #else /* #ifdef CONFIG_TASKS_RUDE_RCU */
> -static void show_rcu_tasks_rude_gp_kthread(void) {}
> +static inline void show_rcu_tasks_rude_gp_kthread(void) {}
>  #endif /* #else #ifdef CONFIG_TASKS_RUDE_RCU */
>  
>  ////////////////////////////////////////////////////////////////////////
> -- 
> 2.7.4
> 

What commit id caused this problem?

And why isn't it an issue in newer kernels, what commit id fixed it and
why can't we just take that instead?

thanks,

greg k-h
