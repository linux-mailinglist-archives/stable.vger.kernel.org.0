Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D994345073E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 15:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbhKOOmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 09:42:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231718AbhKOOlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 09:41:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B563661BFA;
        Mon, 15 Nov 2021 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636987132;
        bh=9ohmRE3zzns6lMH5yHwcSoMqq6bBuIb8kOcTNEAmpH8=;
        h=Subject:To:Cc:From:Date:From;
        b=DF4vhNBg4xgCnOyxb672PaSnWb+4crjiFCKQJgFYWW3h9yt1Ay+2AnUC18C1/o9Li
         WNpa7wrvWhhAeaCQWTlVORTxfe7GjszsFowVYTDo4RByCUG+OF43AtUkownZVCqpvd
         zbRt0FRGBgNyrk5rAQHTX2Pg8EKvnJLjpop7jXto=
Subject: FAILED: patch "[PATCH] bcache: fix use-after-free problem in bcache_device_free()" failed to apply to 5.14-stable tree
To:     colyli@suse.de, axboe@kernel.dk, hare@suse.de, hch@lst.de,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 15:38:49 +0100
Message-ID: <1636987129245209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8468f45091d2866affed6f6a7aecc20779139173 Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Wed, 3 Nov 2021 14:49:17 +0800
Subject: [PATCH] bcache: fix use-after-free problem in bcache_device_free()

In bcache_device_free(), pointer disk is referenced still in
ida_simple_remove() after blk_cleanup_disk() gets called on this
pointer. This may cause a potential panic by use-after-free on the
disk pointer.

This patch fixes the problem by calling blk_cleanup_disk() after
ida_simple_remove().

Fixes: bc70852fd104 ("bcache: convert to blk_alloc_disk/blk_cleanup_disk")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org # v5.14+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211103064917.67383-1-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 84a48eed8e24..a7bb3355b776 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -885,9 +885,9 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		blk_cleanup_disk(disk);
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
+		blk_cleanup_disk(disk);
 	}
 
 	bioset_exit(&d->bio_split);

