Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1B5E3A4
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGCMRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726217AbfGCMRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD23218A0;
        Wed,  3 Jul 2019 12:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156223;
        bh=/7CkEg+Cd/Vi0rAO0XEw6NFXR0YoEHPH3FR5WzyK3bA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xsl05hIiJM9UHWoLI8Ah2VJDsfrP0oeannVi7BOI5+Xid4YVsJxB4aZtOQiArV8js
         85jYFc38Fx09EJJqDp9QjAk/dWA+g+0sgbt48mFtMJ895w1rrgmCCsAdcaGEIOwMCb
         7ZGZ0QZmkokoyejXxcRt/Na7o3hUG3gb6g5xGwWs=
Date:   Wed, 3 Jul 2019 14:17:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        jay.vosburgh@canonical.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <songliubraving@fb.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Subject: Re: [4.19.y PATCH 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
Message-ID: <20190703121700.GE7784@kroah.com>
References: <20190628221759.18274-1-gpiccoli@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628221759.18274-1-gpiccoli@canonical.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 07:17:58PM -0300, Guilherme G. Piccoli wrote:
> -----------------------------------------------------------------
> This patch is not on mainline and is meant to 4.19 stable *only*.
> After the patch description there's a reasoning about that.
> -----------------------------------------------------------------
> 
> Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
> with device removal triggers a crash") introduced a NULL pointer
> dereference in generic_make_request(). The patch sets q to NULL and
> enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
> which is not taken, and then the 'else' will dereference q in
> blk_queue_dying(q).
> 
> This patch just moves the 'q = NULL' to a point in which it won't trigger
> the oops, although the semantics of this NULLification remains untouched.
> 
> A simple test case/reproducer is as follows:
> a) Build kernel v4.19.56-stable with CONFIG_BLK_CGROUP=n.
> 
> b) Create a raid0 md array with 2 NVMe devices as members, and mount
> it with an ext4 filesystem.
> 
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme1n1/device/device/remove
> (whereas nvme1n1 is the 2nd array member)
> 
> This will trigger the following oops:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:generic_make_request+0x32b/0x400
> Call Trace:
>  submit_bio+0x73/0x140
>  ext4_io_submit+0x4d/0x60
>  ext4_writepages+0x626/0xe90
>  do_writepages+0x4b/0xe0
> [...]
> 
> This patch has no functional changes and preserves the md/raid0 behavior
> when a member is removed before kernel v4.17.
> 
> ----------------------------
> Why this is not on mainline?
> ----------------------------
> 
> The patch was originally submitted upstream in linux-raid and
> linux-block mailing-lists - it was initially accepted by Song Liu,
> but Christoph Hellwig[0] observed that there was a clean-up series
> ready to be accepted from Ming Lei[1] that fixed the same issue.
> 
> The accepted patches from Ming's series in upstream are: commit
> 47cdee29ef9d ("block: move blk_exit_queue into __blk_release_queue") and
> commit fe2008640ae3 ("block: don't protect generic_make_request_checks
> with blk_queue_enter"). Those patches basically do a clean-up in the
> block layer involving:
> 
> 1) Putting back blk_exit_queue() logic into __blk_release_queue(); that
> path was changed in the past and the logic from blk_exit_queue() was
> added to blk_cleanup_queue().
> 
> 2) Removing the guard/protection in generic_make_request_checks() with
> blk_queue_enter().
> 
> The problem with Ming's series for -stable is that it relies in the
> legacy request IO path removal. So it's "backport-able" to v5.0+,
> but doing that for early versions (like 4.19) would incur in complex
> code changes. Hence, it was suggested by Christoph and Song Liu that
> this patch was submitted to stable only; otherwise merging it upstream
> would add code to fix a path removed in a subsequent commit.
> 
> [0] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
> [1] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Tested-by: Eric Ren <renzhengeek@gmail.com>
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Both patches now queued up, thanks.

greg k-h
