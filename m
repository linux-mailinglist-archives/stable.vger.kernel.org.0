Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E06A1F5738
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgFJPCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 11:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgFJPCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 11:02:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA7C03E96B;
        Wed, 10 Jun 2020 08:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e/I7IeBlmcoJH8pxLjvp2NE3V5TNcZtshVifaD2OjQs=; b=tyK3sm9NsopRaJm+EEC0wowYUV
        Tr8R2GEGuheASallfJRx0hvcmZ5g1lyREuAeVbfaIieHwryNVsG641pMAQWCYm16/ruW/WhOT7dCz
        BJhsmqsXlVHRiMzszwd4KY6njDoRid1x2z/bPZPKD/101UyjXaM6KtyrcNqWsc+YMWrpFcBbUZMfK
        WR0Akzk+k5wNAvgcqlTWRcLaDU0hjRwl8Jy9BNXZM0JuuaIfqlammJ8l6Vgi/UlwDSFC6/DWAavHU
        rJNNrnkSwCuukx6pYjxNB3peUp8jdluURTlMYnjaKSYM2N8OcquTCLP/7KFjL+uQI33YsCPX8MX58
        lMHDhVYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jj2Et-0003Ao-7J; Wed, 10 Jun 2020 15:02:03 +0000
Date:   Wed, 10 Jun 2020 08:02:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        Martijn Coenen <maco@android.com>, tj@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: Avoid skipping inode writeback
Message-ID: <20200610150203.GA21733@infradead.org>
References: <20200601091202.31302-1-jack@suse.cz>
 <20200601091904.4786-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601091904.4786-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This generall looks ok, but a few nitpicks below:

> -static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
> +static void __redirty_tail(struct inode *inode, struct bdi_writeback *wb)

I think redirty_tail_locked would be a more decriptive name, and also
fit other uses in this file (e.g. inode_io_list_move_locked and
inode_io_list_del_locked).

>  {
> +	assert_spin_locked(&inode->i_lock);
>  	if (!list_empty(&wb->b_dirty)) {

Nit: I find an empty line after asserts and before the real code starts
nice on the eye.

>  			break;
>  		list_move(&inode->i_io_list, &tmp);
>  		moved++;
> +		spin_lock(&inode->i_lock);
>  		if (flags & EXPIRE_DIRTY_ATIME)
> -			set_bit(__I_DIRTY_TIME_EXPIRED, &inode->i_state);
> +			inode->i_state |= I_DIRTY_TIME_EXPIRED;
> +		inode->i_state |= I_SYNC_QUEUED;
> +		spin_unlock(&inode->i_lock);

I wonder if the locking changes should go into a prep patch vs the
actual logic changes related to I_SYNC_QUEUED?  That would untangle
the patch quite a bit and make it easier to follow.

>  #define I_WB_SWITCH		(1 << 13)
>  #define I_OVL_INUSE		(1 << 14)
>  #define I_CREATING		(1 << 15)
> +#define I_SYNC_QUEUED		(1 << 16)

FYI, this conflicts with the I_DONTCAT addition in mainline now.
