Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7855E012
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiF1JKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 05:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbiF1JKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 05:10:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECAE1054D
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 02:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52EB0616E2
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 09:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DA3C3411D;
        Tue, 28 Jun 2022 09:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656407404;
        bh=Disv3QmJzs/lAD02TiTjIsNW6sBGSMMQ4qkbpVgiQv0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NCqj1HFxDYTU6tved2ICVWkXjPWdcLWWZhmcisaC8ecHcTOJzQxqqEWUvgkpEzvCz
         jB4ZgDVCcU9A2Zw43rvXGDMKyspfqQIgdYElnGVLZtfL+V4Bh9LJEUSOIYIIMf7SlV
         k1RoHdGCVIrtKINg1xw0dOeYX6mc861aODh9+YZ4=
Date:   Tue, 28 Jun 2022 11:10:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/1] bcache: memset on stack variables in
 bch_btree_check() and bch_sectors_dirty_init()
Message-ID: <YrrFaU+eWk37JtFd@kroah.com>
References: <20220628084933.8713-1-colyli@suse.de>
 <20220628084933.8713-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628084933.8713-2-colyli@suse.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 04:49:33PM +0800, Coly Li wrote:
> The local variables check_state (in bch_btree_check()) and state (in
> bch_sectors_dirty_init()) should be fully filled by 0, because before
> allocating them on stack, they were dynamically allocated by kzalloc().
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Link: https://lore.kernel.org/r/20220527152818.27545-2-colyli@suse.de
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/md/bcache/btree.c     | 1 +
>  drivers/md/bcache/writeback.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 2362bb8ef6d1..e136d6edc1ed 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
>  	if (c->root->level == 0)
>  		return 0;
>  
> +	memset(&check_state, 0, sizeof(struct btree_check_state));
>  	check_state.c = c;
>  	check_state.total_threads = bch_btree_chkthread_nr();
>  	check_state.key_idx = 0;
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 75b71199800d..d138a2d73240 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
>  		return;
>  	}
>  
> +	memset(&state, 0, sizeof(struct bch_dirty_init_state));
>  	state.c = c;
>  	state.d = d;
>  	state.total_threads = bch_btre_dirty_init_thread_nr();
> -- 
> 2.35.3
> 

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
