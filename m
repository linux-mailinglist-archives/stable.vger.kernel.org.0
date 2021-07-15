Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46803CA7B7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbhGOS4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240256AbhGOSxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E59C613ED;
        Thu, 15 Jul 2021 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375055;
        bh=uVE04i3VRKABrlOZWq05fkd587OP1AIH8sa9nrjJCBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N6HPgzXULrEFGQahfmJjCe6XJFZLFM2H52VEIZn3XmykS1OceN/n4KMRFLoQQawW
         leRRkvyqk5brnvzypZy+JzSKFN7REwI7ioBkGMq96yhQHuVs+LF0EJuNI2LxdGjWy0
         16Laxw7SOTo1ZPUXcmObW6+VTwa9yZxazvJ3e4YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eric Desrochers <eric.desrochers@canonical.com>,
        Mauricio Faria de Oliveira <mfo@canonical.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 139/215] loop: fix I/O error on fsync() in detached loop devices
Date:   Thu, 15 Jul 2021 20:38:31 +0200
Message-Id: <20210715182624.121950937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauricio Faria de Oliveira <mfo@canonical.com>

commit 4ceddce55eb35d15b0f87f5dcf6f0058fd15d3a4 upstream.

There's an I/O error on fsync() in a detached loop device
if it has been previously attached.

The issue is write cache is enabled in the attach path in
loop_configure() but it isn't disabled in the detach path;
thus it remains enabled in the block device regardless of
whether it is attached or not.

Now fsync() can get an I/O request that will just be failed
later in loop_queue_rq() as device's state is not 'Lo_bound'.

So, disable write cache in the detach path.

Do so based on the queue flag, not the loop device flag for
read-only (used to enable) as the queue flag can be changed
via sysfs even on read-only loop devices (e.g., losetup -r.)

Test-case:

    # DEV=/dev/loop7

    # IMG=/tmp/image
    # truncate --size 1M $IMG

    # losetup $DEV $IMG
    # losetup -d $DEV

Before:

    # strace -e fsync parted -s $DEV print 2>&1 | grep fsync
    fsync(3)                                = -1 EIO (Input/output error)
    Warning: Error fsyncing/closing /dev/loop7: Input/output error
    [  982.529929] blk_update_request: I/O error, dev loop7, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0

After:

    # strace -e fsync parted -s $DEV print 2>&1 | grep fsync
    fsync(3)                                = 0

Co-developed-by: Eric Desrochers <eric.desrochers@canonical.com>
Signed-off-by: Eric Desrochers <eric.desrochers@canonical.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Tested-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1224,6 +1224,9 @@ static int __loop_clr_fd(struct loop_dev
 		goto out_unlock;
 	}
 
+	if (test_bit(QUEUE_FLAG_WC, &lo->lo_queue->queue_flags))
+		blk_queue_write_cache(lo->lo_queue, false, false);
+
 	/* freeze request queue during the transition */
 	blk_mq_freeze_queue(lo->lo_queue);
 


