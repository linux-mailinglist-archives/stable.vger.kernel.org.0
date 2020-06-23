Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3537620599A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 19:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733144AbgFWRml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 13:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbgFWRf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 13:35:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F774207E8;
        Tue, 23 Jun 2020 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592933757;
        bh=VdLNrCbuwMYCY9QDHYOlAwoBGMDQ4WJP7+Rn3wVFuD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwzAXhEZhnQnjzAfxTiXhq0zAP7qwWwldtvRssbuepHeyz9/e/Ks3p+lTYRmfRiK1
         ntAFAdEeyQQwo1JRXW16cPa2ZxyM9rgXL5MxewFqliNZ5Yg5M30Dx1jUwdDLJfTd1o
         xgtgQ9OLJNU373jIs2sd6m6l221ftafMAocpb0/I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weiping Zhang <zhangweiping@didiglobal.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 27/28] block: update hctx map when use multiple maps
Date:   Tue, 23 Jun 2020 13:35:22 -0400
Message-Id: <20200623173523.1355411-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623173523.1355411-1-sashal@kernel.org>
References: <20200623173523.1355411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weiping Zhang <zhangweiping@didiglobal.com>

[ Upstream commit fe35ec58f0d339221643287bbb7cee15c93a5389 ]

There is an issue when tune the number for read and write queues,
if the total queue count was not changed. The hctx->type cannot
be updated, since __blk_mq_update_nr_hw_queues will return directly
if the total queue count has not been changed.

Reproduce:

dmesg | grep "default/read/poll"
[    2.607459] nvme nvme0: 48/0/0 default/read/poll queues
cat /sys/kernel/debug/block/nvme0n1/hctx*/type | sort | uniq -c
     48 default

tune the write queues to 24:
echo 24 > /sys/module/nvme/parameters/write_queues
echo 1 > /sys/block/nvme0n1/device/reset_controller

dmesg | grep "default/read/poll"
[  433.547235] nvme nvme0: 24/24/0 default/read/poll queues

cat /sys/kernel/debug/block/nvme0n1/hctx*/type | sort | uniq -c
     48 default

The driver's hardware queue mapping is not same as block layer.

Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 98a702761e2cc..8f580e66691b9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3328,7 +3328,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	if (set->nr_maps == 1 && nr_hw_queues > nr_cpu_ids)
 		nr_hw_queues = nr_cpu_ids;
-	if (nr_hw_queues < 1 || nr_hw_queues == set->nr_hw_queues)
+	if (nr_hw_queues < 1)
+		return;
+	if (set->nr_maps == 1 && nr_hw_queues == set->nr_hw_queues)
 		return;
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
-- 
2.25.1

