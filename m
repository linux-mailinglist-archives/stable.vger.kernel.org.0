Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9043C25F3A3
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 09:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIGHMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 03:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgIGHMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 03:12:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D99BC061573;
        Mon,  7 Sep 2020 00:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sRwaojnvVzc22iW0i8NlJG/12Ib/PukN7Tq7eXaU5vo=; b=XFaXrqq1Gxwveqc+eBXdlLhbhW
        JwP8LEDWN0RWlaXurzSXMt4aIRtPuBzZeWJK/Ufw6fv2Nq3AVFeoWC/PpBbjMZv+zKf9eZPbvya+P
        AcLA5+uNbOi2Gm+qoBSpfD9PoGZfQoLBw+4bh0lSa/EBKVg3pJmH4PVLxfa5F2/sGcm/vQWz0L39D
        FsM5piAQDKg5f8VXYLmu1RbKdcgl39w2BjHXh6hexptdR4Xj50gJghDc5/7E/ndn/aEkZZq4yLYQU
        gc/BolXai1zy4pocXfj5i7Y9BLvRSuqTBMp2CAR1opFdWEmxtVEkDMGTD9cp4lpVvU7i1ww3AQDfV
        dRJezAfA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFBKG-0007KA-Ku; Mon, 07 Sep 2020 07:12:28 +0000
Date:   Mon, 7 Sep 2020 08:12:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        yebin <yebin10@huawei.com>, Andreas Dilger <adilger@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: Don't invalidate page buffers in
 block_write_full_page()
Message-ID: <20200907071228.GA27898@infradead.org>
References: <20200904085852.5639-1-jack@suse.cz>
 <20200904085852.5639-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904085852.5639-2-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 10:58:51AM +0200, Jan Kara wrote:
> If block_write_full_page() is called for a page that is beyond current
> inode size, it will truncate page buffers for the page and return 0.
> This logic has been added in 2.5.62 in commit 81eb69062588 ("fix ext3
> BUG due to race with truncate") in history.git tree to fix a problem
> with ext3 in data=ordered mode. This particular problem doesn't exist
> anymore because ext3 is long gone and ext4 handles ordered data
> differently. Also normally buffers are invalidated by truncate code and
> there's no need to specially handle this in ->writepage() code.
> 
> This invalidation of page buffers in block_write_full_page() is causing
> issues to filesystems (e.g. ext4 or ocfs2) when block device is shrunk
> under filesystem's hands and metadata buffers get discarded while being
> tracked by the journalling layer. Although it is obviously "not
> supported" it can cause kernel crashes like:

Btw, while looking over the block device revalidation code I think
all the magic we do on shrinking block devices actually is a bad
idea - potentially very harmful, but without much real benefit.
And it only is run on file systems directly created on the whole device,
meaning it isn't even used at all with the typical setups that use
partitions.

Anyway, this patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
