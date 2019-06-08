Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D9A39EF3
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfFHLwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbfFHLmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1533C214AF;
        Sat,  8 Jun 2019 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994129;
        bh=6ZqSkqUfSiHWlEmWK7T0Wo1G2xB0Sqd74l/iyst+E5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pid24HwReedYkdDfoGWq5bIEpZlS/ecl7jY6IRbQGh6QAsGk3xyrs4i7UkftWqUSJ
         0oy6j+HofV0BdO09F0CyoJmuGSihzaBbdmYxr6YwV6v1ZocDA4toxiok7oMbxeScjY
         VN55bZfwy0oVEScN6xaS5f1N8aPtXeyNmxGhIOnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jes Sorensen <jsorensen@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 60/70] blk-mq: Fix memory leak in error handling
Date:   Sat,  8 Jun 2019 07:39:39 -0400
Message-Id: <20190608113950.8033-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

[ Upstream commit 41de54c64811bf087c8464fdeb43c6ad8be2686b ]

If blk_mq_init_allocated_queue() fails, make sure to free the poll
stat callback struct allocated.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8a41cc5974fe..95e8005982cd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2844,7 +2844,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		goto err_exit;
 
 	if (blk_mq_alloc_ctxs(q))
-		goto err_exit;
+		goto err_poll;
 
 	/* init q->mq_kobj and sw queues' kobjects */
 	blk_mq_sysfs_init(q);
@@ -2905,6 +2905,9 @@ err_hctxs:
 	kfree(q->queue_hw_ctx);
 err_sys_init:
 	blk_mq_sysfs_deinit(q);
+err_poll:
+	blk_stat_free_callback(q->poll_cb);
+	q->poll_cb = NULL;
 err_exit:
 	q->mq_ops = NULL;
 	return ERR_PTR(-ENOMEM);
-- 
2.20.1

