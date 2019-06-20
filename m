Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24374D756
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbfFTSRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbfFTSRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53ED4205F4;
        Thu, 20 Jun 2019 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054652;
        bh=FNNY4z0fWNTg2RzTbJOuQrUVa1cKqXAWH9utYhcXyvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSYHoC/q6nFEHtWW7Q31I2Mz0P8B7/w7mhFzOCUTLjgutbfbPlVzcu0lmP9DW3LCt
         vGVJSU6QAUa8Uf9y6L8zx8JNt75azVQnXgfpD/L7VPiXmuJ/HFETrY/16pHeYecWZ+
         WHEprz3RMoEM0k7958cC7dZ3PP7uqNmstKdZE3Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 83/98] blk-mq: Fix memory leak in error handling
Date:   Thu, 20 Jun 2019 19:57:50 +0200
Message-Id: <20190620174353.494201302@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 11efca3534ad..00b826399228 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2846,7 +2846,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		goto err_exit;
 
 	if (blk_mq_alloc_ctxs(q))
-		goto err_exit;
+		goto err_poll;
 
 	/* init q->mq_kobj and sw queues' kobjects */
 	blk_mq_sysfs_init(q);
@@ -2907,6 +2907,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
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



