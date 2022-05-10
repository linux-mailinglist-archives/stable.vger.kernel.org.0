Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A943E5211B3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiEJKKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiEJKKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:10:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F75E16D118;
        Tue, 10 May 2022 03:06:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C296621889;
        Tue, 10 May 2022 10:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652177166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ytZlP7vVK+dBIlmkee79MIPsVpRUqqEBBWJPXxxXFVw=;
        b=TS7kb4CQdw0UWYaKL1F2HZbsoWfdeqZyokWrx2/pzmLN9JCLD3JWTv3x/0jtZxgRZMELPS
        oIFCC1Z4s0ixxjqnQ+cctz6PFleszxO4hln0/8rTP5V7fTCj9YJP7Ns1+/jeV39lNuCa5r
        GUEun9eWj5S6mKcgP7yqN4lcV7qwgvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652177166;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ytZlP7vVK+dBIlmkee79MIPsVpRUqqEBBWJPXxxXFVw=;
        b=wDevVj6IjhWv9uRasThN3fVEL8j47oLzjDzyCNS440VR+lnJV5Z6cO6VUeD6tXLEfuD3qP
        IFHcc4+Del9EThBQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6EFE92C141;
        Tue, 10 May 2022 10:06:06 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 20527A062A; Tue, 10 May 2022 12:06:06 +0200 (CEST)
Date:   Tue, 10 May 2022 12:06:06 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jing Xia <jing.xia@unisoc.com>
Cc:     viro@zeniv.linux.org.uk, jack@suse.cz, hch@lst.de,
        jing.xia.mail@gmail.com, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] writeback: Avoid skipping inode writeback
Message-ID: <20220510100606.qqiiti2i3axfusnh@quack3.lan>
References: <20220510023514.27399-1-jing.xia@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510023514.27399-1-jing.xia@unisoc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 10-05-22 10:35:14, Jing Xia wrote:
> We have run into an issue that a task gets stuck in
> balance_dirty_pages_ratelimited() when perform I/O stress testing.
> The reason we observed is that an I_DIRTY_PAGES inode with lots
> of dirty pages is in b_dirty_time list and standard background
> writeback cannot writeback the inode.
> After studing the relevant code, the following scenario may lead
> to the issue:
> 
> task1                                   task2
> -----                                   -----
> fuse_flush
>  write_inode_now //in b_dirty_time
>   writeback_single_inode
>    __writeback_single_inode
>                                  fuse_write_end
>                                   filemap_dirty_folio
>                                    __xa_set_mark:PAGECACHE_TAG_DIRTY
>     lock inode->i_lock
>     if mapping tagged PAGECACHE_TAG_DIRTY
>     inode->i_state |= I_DIRTY_PAGES
>     unlock inode->i_lock
>                                    __mark_inode_dirty:I_DIRTY_PAGES
>                                       lock inode->i_lock
>                                       -was dirty,inode stays in
>                                       -b_dirty_time
>                                       unlock inode->i_lock
> 
>    if(!(inode->i_state & I_DIRTY_All))
>       -not true,so nothing done
> 
> This patch moves the dirty inode to b_dirty list when the inode
> currently is not queued in b_io or b_more_io list at the end of
> writeback_single_inode.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> CC: stable@vger.kernel.org
> Fixes: 0ae45f63d4ef ("vfs: add support for a lazytime mount option")
> Signed-off-by: Jing Xia <jing.xia@unisoc.com>

Thanks. I've queued the patch to my tree and will push it to Linus tomorrow
or so.

								Honza

> ---
>  fs/fs-writeback.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 591fe9cf1659..1fae0196292a 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1712,6 +1712,10 @@ static int writeback_single_inode(struct inode *inode,
>  	 */
>  	if (!(inode->i_state & I_DIRTY_ALL))
>  		inode_cgwb_move_to_attached(inode, wb);
> +	else if (!(inode->i_state & I_SYNC_QUEUED) &&
> +		 (inode->i_state & I_DIRTY))
> +		redirty_tail_locked(inode, wb);
> +
>  	spin_unlock(&wb->list_lock);
>  	inode_sync_complete(inode);
>  out:
> -- 
> 2.17.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
