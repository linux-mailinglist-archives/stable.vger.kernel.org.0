Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963B747B74A
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 03:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhLUB6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:58:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33210 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbhLUB6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:58:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61576B8111A;
        Tue, 21 Dec 2021 01:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72459C36AEF;
        Tue, 21 Dec 2021 01:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051916;
        bh=sGmWq4pHc841nSLO8r6OmKQ9C/1AcqFfi6xhBItwG7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECj1x1jvaHHN0upfnua5LH+QCLKX5QXvGJ+UVUQcleakNr/hIwZQk1Hvaov7JGtjO
         bouHfeDlwBZLV3D++H50X09WI60LfdHFz6ecpYmWPst5Kd95AhbecETwKj7ZSo23nB
         YQxdD7g+iPyxdxq9in9MqEP0pq5MeIjD8i13p1YuNPLi0LMbmDGIYAJcqnjaa+MrhM
         kzrPSDwudzu8GM0pB625V73w9cRxckvNuDs1p789dZBQcoPbiRwYgDn6ZlP/e5J072
         LPmFgz2emSxzM6DrJRVuk0UAOu0tbXpl4fowPp9TMf5RjlTpQAunKVGUq9Sk2B2/Fg
         q5VX2Il6dOIpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/29] block: reduce kblockd_mod_delayed_work_on() CPU consumption
Date:   Mon, 20 Dec 2021 20:57:41 -0500
Message-Id: <20211221015751.116328-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cb2ac2912a9ca7d3d26291c511939a41361d2d83 ]

Dexuan reports that he's seeing spikes of very heavy CPU utilization when
running 24 disks and using the 'none' scheduler. This happens off the
sched restart path, because SCSI requires the queue to be restarted async,
and hence we're hammering on mod_delayed_work_on() to ensure that the work
item gets run appropriately.

Avoid hammering on the timer and just use queue_work_on() if no delay
has been specified.

Reported-and-tested-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index c2d912d0c976c..a728434fcff87 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1625,6 +1625,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
 				unsigned long delay)
 {
+	if (!delay)
+		return queue_work_on(cpu, kblockd_workqueue, &dwork->work);
 	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
-- 
2.34.1

