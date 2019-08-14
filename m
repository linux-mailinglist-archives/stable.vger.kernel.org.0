Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8876E8DB74
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfHNRZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfHNRFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 075FE2084D;
        Wed, 14 Aug 2019 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802345;
        bh=b2zNZyKjcECupHNHtgikwqMvVgIIB0qbiiwmrBACDAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zx/x3+iQPhZuniANkZKN+dMjavidf3MmfERdoJ0WNeMgRQC0ZqK0JiMjiOkcAeqpw
         FWyxOgughTWwN6HXX2NrHCc1KwRucyD8FaURiEgnf2e7HPZE3WgIf6phaFpJx3BNb0
         BxK3GfFVSv920ATqrXcj84B26FHDrUo8/HJTrOd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 062/144] rq-qos: use a mb for got_token
Date:   Wed, 14 Aug 2019 19:00:18 +0200
Message-Id: <20190814165802.430179590@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ac38297f7038cd5b80d66f8809c7bbf5b70031f3 ]

Oleg noticed that our checking of data.got_token is unsafe in the
cleanup case, and should really use a memory barrier.  Use a wmb on the
write side, and a rmb() on the read side.  We don't need one in the main
loop since we're saved by set_current_state().

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index e3ab75e4df9ea..06d024204f504 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -202,6 +202,7 @@ static int rq_qos_wake_function(struct wait_queue_entry *curr,
 		return -1;
 
 	data->got_token = true;
+	smp_wmb();
 	list_del_init(&curr->entry);
 	wake_up_process(data->task);
 	return 1;
@@ -245,6 +246,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 	prepare_to_wait_exclusive(&rqw->wait, &data.wq, TASK_UNINTERRUPTIBLE);
 	do {
+		/* The memory barrier in set_task_state saves us here. */
 		if (data.got_token)
 			break;
 		if (!has_sleeper && acquire_inflight_cb(rqw, private_data)) {
@@ -255,6 +257,7 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 			 * which means we now have two. Put our local token
 			 * and wake anyone else potentially waiting for one.
 			 */
+			smp_rmb();
 			if (data.got_token)
 				cleanup_cb(rqw, private_data);
 			break;
-- 
2.20.1



