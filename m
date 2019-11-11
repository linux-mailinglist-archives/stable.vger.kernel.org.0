Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17AF6E72
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfKKGM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:12:28 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50519 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbfKKGM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:12:28 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 525B0568;
        Mon, 11 Nov 2019 01:12:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:12:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qRhtAj
        faD9judxMXR9eAv6eQImdxJJyUU2SPpseE/co=; b=C0HLE5D/S0narO0P7rjBQx
        KRXHbDpTkkpXLjW3eU89IczqNqBKx7lGL4fgSLu+c/9xJlc0mF7Wzi+r3hr5tYaY
        CuTSGNPUO0k/r2MtYxjGJ1zSiCP6sl4Si7ub7jKIjk4ZsVZ4KkX8orWbDAldKWl5
        jkO08vkhcU0AKcj4SgbOOW+6atReivzUoaMDCLh3p50II+z+4U2HvMICygnhOzEc
        eZAiWy10uavkdUGRYNuGsPjNISZDulHJ8j3+1KUQfFX59di4f9I/Lydliswzl4d7
        7HYpxHWweQ4rA6IYv02BfUa3BmexqugkVEEXYPlVZ6sk11f+Dyg9aEMuUH0DGW9A
        ==
X-ME-Sender: <xms:yvvIXRqwhNLFVTU_jDPJ_K6iaRk63CYDK4bfm2zmleKYHbJJH75yaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:yvvIXcnUdKZwIuoVcIlEVMy4_FEDJ1a6kqIruvPVebvlzbeDzpj7zg>
    <xmx:yvvIXQIbz-tfp6w6c4K9ngNnH_-JxdyNnZkx9oYqf-L8im7Ti10kUA>
    <xmx:yvvIXZz-3vZD6HGuEodoslAmcZ4vYpG__SdYng1KCLZA16OGqubBow>
    <xmx:yvvIXb4RgB-CElqCSPeCL7hhA6mQ7_rLD_WL0mQ9KMgK-2MNcQSCBg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60AE5306005E;
        Mon, 11 Nov 2019 01:12:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] blkcg: make blkcg_print_stat() print stats only for online" failed to apply to 4.19-stable tree
To:     tj@kernel.org, axboe@kernel.dk, guro@fb.com, jbacik@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:12:24 +0100
Message-ID: <1573452744205173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b0814361a25cba73a224548843ed92d8ea78715a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 5 Nov 2019 08:09:51 -0800
Subject: [PATCH] blkcg: make blkcg_print_stat() print stats only for online
 blkgs

blkcg_print_stat() iterates blkgs under RCU and doesn't test whether
the blkg is online.  This can call into pd_stat_fn() on a pd which is
still being initialized leading to an oops.

The heaviest operation - recursively summing up rwstat counters - is
already done while holding the queue_lock.  Expand queue_lock to cover
the other operations and skip the blkg if it isn't online yet.  The
online state is protected by both blkcg and queue locks, so this
guarantees that only online blkgs are processed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Roman Gushchin <guro@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Fixes: 903d23f0a354 ("blk-cgroup: allow controllers to output their own stats")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5d21027b1faf..1eb8895be4c6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -934,9 +934,14 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		int i;
 		bool has_stats = false;
 
+		spin_lock_irq(&blkg->q->queue_lock);
+
+		if (!blkg->online)
+			goto skip;
+
 		dname = blkg_dev_name(blkg);
 		if (!dname)
-			continue;
+			goto skip;
 
 		/*
 		 * Hooray string manipulation, count is the size written NOT
@@ -946,8 +951,6 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		 */
 		off += scnprintf(buf+off, size-off, "%s ", dname);
 
-		spin_lock_irq(&blkg->q->queue_lock);
-
 		blkg_rwstat_recursive_sum(blkg, NULL,
 				offsetof(struct blkcg_gq, stat_bytes), &rwstat);
 		rbytes = rwstat.cnt[BLKG_RWSTAT_READ];
@@ -960,8 +963,6 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 		wios = rwstat.cnt[BLKG_RWSTAT_WRITE];
 		dios = rwstat.cnt[BLKG_RWSTAT_DISCARD];
 
-		spin_unlock_irq(&blkg->q->queue_lock);
-
 		if (rbytes || wbytes || rios || wios) {
 			has_stats = true;
 			off += scnprintf(buf+off, size-off,
@@ -999,6 +1000,8 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 				seq_commit(sf, -1);
 			}
 		}
+	skip:
+		spin_unlock_irq(&blkg->q->queue_lock);
 	}
 
 	rcu_read_unlock();

