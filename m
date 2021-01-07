Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515952EFDCD
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 05:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbhAIEpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 23:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbhAIEpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 23:45:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F89CC061573;
        Fri,  8 Jan 2021 20:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rlt23EkBPxKCTsUQC+ORG3e/Em19JiHhSLMj3woiVuo=; b=vLipm221NPJuEUlgaq3Ay399v4
        TNZP5WpHweX3MPFQvCCsidDC20GzcGPuQfqv0OSzrrwx6IZNsf0baeD20EQJhHMSzJeeLB75hzYJI
        tfM94Emz3mKv/mXPn5iWdqGB35Il0rUSLpZWlMciAozBUV4IUywvuIU4w2gUermQjkH8Iyf2pvLoi
        L2FeDcbj+XoJJKUmGroW6WMmoUB2eHVo5+VOL+BCLDEAhpuU3/JbgeDWUXnn6ikjUpADaddGjIeeu
        XRnWEdnKilwM7+O/9iw5XT2v9qwsOE+/MhOwbQfePjCsyL+2Ji7B0KIGxNeQtQvmQ1F6m5+kbx6kj
        7rOEkooQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kxWkH-0009Mi-0g; Thu, 07 Jan 2021 14:59:13 +0000
Date:   Thu, 7 Jan 2021 14:58:37 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <20210107145837.GA5270@casper.infradead.org>
References: <20210105005452.92521-1-ebiggers@kernel.org>
 <20210105005452.92521-2-ebiggers@kernel.org>
 <20210107144709.GG12990@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107144709.GG12990@quack2.suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:47:09PM +0100, Jan Kara wrote:
> I think attached patch (compile-tested only) should actually fix the
> problem as well without this special ->dirty_inode() call. It basically
> only moves the mark_inode_dirty_sync() before inode->i_state clearing.
> Because conceptually mark_inode_dirty_sync() is IMO the right function to
> call. It will take care of clearing I_DIRTY_TIME flag (because we are
> setting I_DIRTY_SYNC), it will also not touch inode->i_io_list if the inode
> is queued for sync (I_SYNC_QUEUED is set in that case). The only problem
> with calling it was that it was called *after* clearing dirty bits from
> i_state... What do you think?

I like this patch far more, fwiw.

