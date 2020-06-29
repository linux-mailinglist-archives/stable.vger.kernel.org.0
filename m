Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4120DA53
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbgF2T4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387658AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D49724907;
        Mon, 29 Jun 2020 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444457;
        bh=BXpjKMRjKVDNEazo5/y3JtFBbZ+zFAHaaJVS6tJxJAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA7fyluAZXGGHYGSOCQ7kX4DzeWNBLq4VJA8QBl+Xuqo/JuTnfQozc2aojqUPmSkk
         eguc1yQI6PvtUKBP0gNNZ6PdNaVSyNx/XaPLgstPl6hXehbjJishsXzmNlYH46P9ao
         JMU2FbPuy0jN67aiK0drc7iqg42sdZ20xWIQcI0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weiping Zhang <zhangweiping@didiglobal.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/178] block: update hctx map when use multiple maps
Date:   Mon, 29 Jun 2020 11:24:42 -0400
Message-Id: <20200629152523.2494198-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index 0550366e25d8b..f1b930a300a38 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3279,7 +3279,9 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
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

