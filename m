Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9523B5618EE
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiF3LTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 07:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiF3LTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 07:19:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96834F1AC
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 04:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3175B622C5
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 11:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDECC34115;
        Thu, 30 Jun 2022 11:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656587938;
        bh=p65hUkQW/U+BGv9lER63/DhH7AepzuHNz5LnzVBXyg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sVKxJJbxyvmFrEyns1fW0DJdf8elYsEhE0QHFRuSfN6o1Flp7y2iLApWlsm3ei5mW
         Ym/LiIu3+4YcG8uRx0GcFGk6HRD/S6UHWORdggjJJ8gieVyh8RnQsfsEg0FZRdPgf7
         w41K9RobW1qlnmGy19IaeKr4CZILjL0BiopIefII=
Date:   Thu, 30 Jun 2022 13:18:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/1] bcache: memset on stack variables in
 bch_btree_check() and bch_sectors_dirty_init()
Message-ID: <Yr2GnxhFasAHbfy2@kroah.com>
References: <20220628084933.8713-1-colyli@suse.de>
 <20220628084933.8713-2-colyli@suse.de>
 <YrrFaU+eWk37JtFd@kroah.com>
 <FD321F11-8639-48E9-8208-A5A3EAB5CACE@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FD321F11-8639-48E9-8208-A5A3EAB5CACE@suse.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 05:29:44PM +0800, Coly Li wrote:
> 
> 
> > 2022年6月28日 17:10，Greg KH <gregkh@linuxfoundation.org> 写道：
> > 
> > On Tue, Jun 28, 2022 at 04:49:33PM +0800, Coly Li wrote:
> >> The local variables check_state (in bch_btree_check()) and state (in
> >> bch_sectors_dirty_init()) should be fully filled by 0, because before
> >> allocating them on stack, they were dynamically allocated by kzalloc().
> >> 
> >> Signed-off-by: Coly Li <colyli@suse.de>
> >> Link: https://lore.kernel.org/r/20220527152818.27545-2-colyli@suse.de
> >> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> ---
> >> drivers/md/bcache/btree.c     | 1 +
> >> drivers/md/bcache/writeback.c | 1 +
> >> 2 files changed, 2 insertions(+)
> >> 
> >> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> >> index 2362bb8ef6d1..e136d6edc1ed 100644
> >> --- a/drivers/md/bcache/btree.c
> >> +++ b/drivers/md/bcache/btree.c
> >> @@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
> >> 	if (c->root->level == 0)
> >> 		return 0;
> >> 
> >> +	memset(&check_state, 0, sizeof(struct btree_check_state));
> >> 	check_state.c = c;
> >> 	check_state.total_threads = bch_btree_chkthread_nr();
> >> 	check_state.key_idx = 0;
> >> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> >> index 75b71199800d..d138a2d73240 100644
> >> --- a/drivers/md/bcache/writeback.c
> >> +++ b/drivers/md/bcache/writeback.c
> >> @@ -950,6 +950,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
> >> 		return;
> >> 	}
> >> 
> >> +	memset(&state, 0, sizeof(struct bch_dirty_init_state));
> >> 	state.c = c;
> >> 	state.d = d;
> >> 	state.total_threads = bch_btre_dirty_init_thread_nr();
> >> -- 
> >> 2.35.3
> >> 
> > 
> > What is the git commit id of this patch in Linus's tree?
> 
> 
> Oops, the commit tag in email was filtered out. This patch in Linus tree is
> 
> commit 7d6b902ea0e0 (“bcache: memset on stack variables in bch_btree_check() and bch_sectors_dirty_init()”)

Thanks, now queued up.

greg k-h
