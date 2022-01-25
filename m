Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3967049B00E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380267AbiAYJZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455885AbiAYJHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:07:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBBCC0604ED;
        Tue, 25 Jan 2022 00:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0EF61367;
        Tue, 25 Jan 2022 08:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC95AC340E6;
        Tue, 25 Jan 2022 08:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643100795;
        bh=PXg7dW+YeL0p6xi+YdL/9GS4sqHwZFwbdh1xEkLal9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HzfkXg5gctspyew5Ozty/tVC9EVPcSuGuC2aTrhV0g5YJbJMqseyBIn7u11jhJrUY
         nxX6y+rjzaPvkf3LNrO3Mt3d9OqiuA+9zpXXqABixZxDNYfxHALqQjIGdDQVrktOCf
         /sp/ZhWSMHvq6CIDx4EfO6iR1V3A+tHBrJmpvTj8=
Date:   Tue, 25 Jan 2022 09:53:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        Laibin Qiu <qiulaibin@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, alex_y_xu@yahoo.ca
Subject: Re: [PATCH 5.16 1026/1039] blk-mq: fix tag_get wait task cant be
 awakened
Message-ID: <Ye+6eIDoJ2VFdAM+@kroah.com>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184159.785093232@linuxfoundation.org>
 <e8558aeb-7343-da56-88bb-14c1a27d099c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8558aeb-7343-da56-88bb-14c1a27d099c@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 08:38:01AM +0000, John Garry wrote:
> On 24/01/2022 18:46, Greg Kroah-Hartman wrote:
> > From: Laibin Qiu<qiulaibin@huawei.com>
> > 
> > commit 180dccb0dba4f5e84a4a70c1be1d34cbb6528b32 upstream.
> > 
> > In case of shared tags, there might be more than one hctx which
> > allocates from the same tags, and each hctx is limited to allocate at
> > most:
> >          hctx_max_depth = max((bt->sb.depth + users - 1) / users, 4U);
> > 
> > tag idle detection is lazy, and may be delayed for 30sec, so there
> > could be just one real active hctx(queue) but all others are actually
> > idle and still accounted as active because of the lazy idle detection.
> > Then if wake_batch is > hctx_max_depth, driver tag allocation may wait
> > forever on this real active hctx.
> > 
> > Fix this by recalculating wake_batch when inc or dec active_queues.
> > 
> > Fixes: 0d2602ca30e41 ("blk-mq: improve support for shared tags maps")
> > Suggested-by: Ming Lei<ming.lei@redhat.com>
> > Suggested-by: John Garry<john.garry@huawei.com>
> > Signed-off-by: Laibin Qiu<qiulaibin@huawei.com>
> > Reviewed-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> > Link:https://lore.kernel.org/r/20220113025536.1479653-1-qiulaibin@huawei.com
> > Signed-off-by: Jens Axboe<axboe@kernel.dk>
> > Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> 
> JFYI, Somebody reported a hang with this commit:
> https://lore.kernel.org/linux-block/78cafe94-a787-e006-8851-69906f0c2128@huawei.com/T/#t

Thanks for the report, I'll go drop this patch now.

greg k-h
