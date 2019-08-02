Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5F97F877
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393295AbfHBNUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393281AbfHBNUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D19218A3;
        Fri,  2 Aug 2019 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752008;
        bh=ritnmQKeXCNUkl00pdK+bMvgCPeyD/nYb7rU9HK3wAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvXV1hSIK+Ae3Gj1VvZ8kwBVeWWfKa+aEfIUNKxDJN5vYfnkuIn+Q7Tegab0RUPxO
         LssHxI/JAZf7sDnhL7ldvHNBZBVVEpOgepEHn3BN1S8HNxPFP0fDhQlY9FEWiCY/2j
         rGgVlurPZTj0S2uDxEp6d6x3dxZVoHILsXLHjow4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 14/76] rq-qos: use a mb for got_token
Date:   Fri,  2 Aug 2019 09:18:48 -0400
Message-Id: <20190802131951.11600-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

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

