Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB969328609
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhCARCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235673AbhCAQz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D250664FCA;
        Mon,  1 Mar 2021 16:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616539;
        bh=3tTxIIAFSKhg+2F35lC5yapf8EqqBjI+Tr/G8f5+WdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rf+vjJf2DZuiCYVWTwe6BSe2sk0QVsWMEpcYelF4/2HQw3QhDiBx+pSjinkLrA7KX
         358gcSJz2Mn6YVhEc6jsqfU9AsMZZ4ST5E8hs/TtzMHPfOd+IxCmcdKpGxhkrWBvoG
         R3Apr/E4sKwjn1IvbvWbTt+4iSBRML5w1oOczxi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4.19 010/247] block: fix race between switching elevator and removing queues
Date:   Mon,  1 Mar 2021 17:10:30 +0100
Message-Id: <20210301161032.191692418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 0a67b5a926e63ff5492c3c675eab5900580d056d upstream.

cecf5d87ff20 ("block: split .sysfs_lock into two locks") starts to
release & actuire sysfs_lock again during switching elevator. So it
isn't enough to prevent switching elevator from happening by simply
clearing QUEUE_FLAG_REGISTERED with holding sysfs_lock, because
in-progress switch still can move on after re-acquiring the lock,
meantime the flag of QUEUE_FLAG_REGISTERED won't get checked.

Fixes this issue by checking 'q->elevator' directly & locklessly after
q->kobj is removed in blk_unregister_queue(), this way is safe because
q->elevator can't be changed at that time.

Fixes: cecf5d87ff20 ("block: split .sysfs_lock into two locks")
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-sysfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -977,7 +977,6 @@ EXPORT_SYMBOL_GPL(blk_register_queue);
 void blk_unregister_queue(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	bool has_elevator;
 
 	if (WARN_ON(!q))
 		return;
@@ -993,7 +992,6 @@ void blk_unregister_queue(struct gendisk
 	 */
 	mutex_lock(&q->sysfs_lock);
 	blk_queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
-	has_elevator = !!q->elevator;
 	mutex_unlock(&q->sysfs_lock);
 
 	mutex_lock(&q->sysfs_dir_lock);
@@ -1009,7 +1007,11 @@ void blk_unregister_queue(struct gendisk
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
 	mutex_lock(&q->sysfs_lock);
-	if (q->request_fn || has_elevator)
+	/*
+	 * q->kobj has been removed, so it is safe to check if elevator
+	 * exists without holding q->sysfs_lock.
+	 */
+	if (q->request_fn || q->elevator)
 		elv_unregister_queue(q);
 	mutex_unlock(&q->sysfs_lock);
 	mutex_unlock(&q->sysfs_dir_lock);


