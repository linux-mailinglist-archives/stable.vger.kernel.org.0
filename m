Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6554374C
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 17:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbiFHPZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 11:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbiFHPYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 11:24:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA8A3630A;
        Wed,  8 Jun 2022 08:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84CB960AE5;
        Wed,  8 Jun 2022 15:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A5CC34116;
        Wed,  8 Jun 2022 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654701661;
        bh=/ROQGghXh1m2272sRzxtVBVC0aG9uGEHUOVtqSnKam4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+ypw518VxI2yHjLj+k9zffr8Lz2ih2QeRphm/bNeBVUOyauhZHLUTBTGvRdArEcX
         eo7GT2Vh3yBYCyL5iqkdC7tE5P6spqck1k5mZCkY695Rpk5FE8avw+KCRB2YfyAm/0
         wGRLQvb7NrZq7pJkp+Znl6h98VlJFFMMAFdZn7YU=
Date:   Wed, 8 Jun 2022 17:20:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     pavel@denx.de, daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()
Message-ID: <YqC+WquFukW84W12@kroah.com>
References: <20220608114049.GC9333@duo.ucw.cz>
 <20220608142538.3215426-1-ytcoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608142538.3215426-1-ytcoode@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 10:25:38PM +0800, Yuntao Wang wrote:
> The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
> the allocated memory for 'smap' is never used, get rid of it.
> 
> Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> Link: https://lore.kernel.org/bpf/20220407130423.798386-1-ytcoode@gmail.com
> ---
> This is the modified version for 5.10, the original patch is:
> 
> [ Upstream commit b45043192b3e481304062938a6561da2ceea46a6 ]
> 
> It would be better if the new patch can be reviewed by someone else.

What is wrong with the version that we have queued up in the 5.10-stable
review queue right now?



> 
>  kernel/bpf/stackmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 4575d2d60cb1..54fdcb78ad19 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -121,8 +121,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
>  		return ERR_PTR(-E2BIG);
>  
>  	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
> -	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
> -	err = bpf_map_charge_init(&mem, cost);
> +	err = bpf_map_charge_init(&mem, cost + n_buckets *
> +				  (value_size + sizeof(struct stack_map_bucket)));

This differs from what we have queued up for 5.4.y and 5.10.y, why?
If you are going to modify the upstream version, you need to document in
great detail what you have changed and why you have changed it.

thanks,

greg k-h
