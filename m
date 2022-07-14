Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BDD57534B
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiGNQrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiGNQqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:46:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69A6BC19;
        Thu, 14 Jul 2022 09:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA3A62054;
        Thu, 14 Jul 2022 16:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C01FC34114;
        Thu, 14 Jul 2022 16:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657817069;
        bh=iM0sHba9YtLd8lM6n792MFUeeIeWthKKRCzYAJSsaiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USWNvHsK5uZ9X+4GaAJNb0zO9c3mkeZ86qiWdqvOkTD44X3QZKGFcMEUyEIeLfA+v
         YJPHd/yQYytXaHZv8jbcb+tVdV1nnLM89TJ2LaFpb2AYkZ0g3e9cF+BXLF8uP2AXz7
         7YaV7oPnUHP5yNHgtGSENcQC1QWRAntFMiRRXXXgFV+KU9LzFSczBWiqhomPo+DDzt
         GO+JG3l9jawbqON4ewGl8EKpghvT9dwxqJNtIFFPTwt+2hwjgaA/g26HIs96iz74W+
         DeZYARD50imniZKQFLyh6j1Bh83dVykm9MgjMiqZgppEGJCeXyu83pS9QKfC7gaMZV
         a5C7y/75wGXjw==
From:   SeongJae Park <sj@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     sj@kernel.org, akpm@linux-foundation.org, damon@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/reclaim: fix potential memory leak in damon_reclaim_init()
Date:   Thu, 14 Jul 2022 16:44:27 +0000
Message-Id: <20220714164427.157184-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714063746.2343549-1-niejianglei2021@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Jianglei,

On Thu, 14 Jul 2022 14:37:46 +0800 Jianglei Nie <niejianglei2021@163.com> wrote:

> damon_reclaim_init() allocates a memory chunk for ctx with
> damon_new_ctx(). When damon_select_ops() fails, ctx is not released, which
> will lead to a memory leak.
> 
> We should release the ctx with damon_destroy_ctx() when damon_select_ops()
> fails to fix the memory leak.

Thank you for this patch!

I think below tags would be better to be added.

Fixes: 4d69c3457821 ("mm/damon/reclaim: use damon_select_ops() instead of damon_{v,p}a_set_operations()")
Cc: <stable@vger.kernel.org> # 5.18.x

> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

> ---
>  mm/damon/reclaim.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 4b07c29effe9..0b3c7396cb90 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -441,8 +441,10 @@ static int __init damon_reclaim_init(void)
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
> +	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
> +		damon_destroy_ctx(ctx);
>  		return -EINVAL;
> +	}
>  
>  	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
>  	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
> -- 
> 2.25.1
