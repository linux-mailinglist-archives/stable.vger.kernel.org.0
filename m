Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF617FED90
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfKPPor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbfKPPor (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:47 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8EF82072D;
        Sat, 16 Nov 2019 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919086;
        bh=w0/xY84kePr1FeSz8bEq9jbc2HkpuXp4oF3+DxCx8oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDTTG/aZIq2/5jXH/1DudVwjMVsMUooueRqkQzOkN+sL5hXqZQcx+bjQTmxgj+E7j
         6xz22EChGC+83GY242U9NdHXRyPvWS/lvASRyko4ff4fTAH8wkoFj4A7GJJXxX5xkg
         T53KgIDPsNdncgF7UOTvznHWLSR3BoTXMy4pPFC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 148/237] block: call rq_qos_exit() after queue is frozen
Date:   Sat, 16 Nov 2019 10:39:43 -0500
Message-Id: <20191116154113.7417-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c57cdf7a9e51d97a43e29b8f4a04157875104000 ]

rq_qos_exit() removes the current q->rq_qos, this action has to be
done after queue is frozen, otherwise the IO queue path may never
be waken up, then IO hang is caused.

So fixes this issue by moving rq_qos_exit() after queue is frozen.

Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c  | 3 +++
 block/blk-sysfs.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 074ae9376189b..ea33d6abdcfc9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -784,6 +784,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * prevent that q->request_fn() gets invoked after draining finished.
 	 */
 	blk_freeze_queue(q);
+
+	rq_qos_exit(q);
+
 	spin_lock_irq(lock);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index bab47a17b96f4..8286640d4d663 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -997,8 +997,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
-	rq_qos_exit(q);
-
 	mutex_lock(&q->sysfs_lock);
 	if (q->request_fn || (q->mq_ops && q->elevator))
 		elv_unregister_queue(q);
-- 
2.20.1

