Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784F58EB54
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 14:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfHOMPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 08:15:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfHOMPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 08:15:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA688C0092D1;
        Thu, 15 Aug 2019 12:15:29 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF84D5C22F;
        Thu, 15 Aug 2019 12:15:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>
Subject: [PATCH] blk-mq: avoid sysfs buffer overflow by too many CPU cores
Date:   Thu, 15 Aug 2019 20:15:18 +0800
Message-Id: <20190815121518.16675-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 15 Aug 2019 12:15:30 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is reported that sysfs buffer overflow can be triggered in case
of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
one hctx.

So use snprintf for avoiding the potential buffer overflow.

Cc: stable@vger.kernel.org
Cc: Mark Ray <mark.ray@hpe.com>
Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sysfs.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index d6e1a9bd7131..e75f41a98415 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -164,22 +164,28 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
 	return sprintf(page, "%u\n", hctx->tags->nr_reserved_tags);
 }
 
+/* avoid overflow by too many CPU cores */
 static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
 {
-	unsigned int i, first = 1;
-	ssize_t ret = 0;
-
-	for_each_cpu(i, hctx->cpumask) {
-		if (first)
-			ret += sprintf(ret + page, "%u", i);
-		else
-			ret += sprintf(ret + page, ", %u", i);
-
-		first = 0;
+	unsigned int cpu = cpumask_first(hctx->cpumask);
+	ssize_t len = snprintf(page, PAGE_SIZE - 1, "%u", cpu);
+	int last_len = len;
+
+	while ((cpu = cpumask_next(cpu, hctx->cpumask)) < nr_cpu_ids) {
+		int cur_len = snprintf(page + len, PAGE_SIZE - 1 - len,
+				       ", %u", cpu);
+		if (cur_len >= PAGE_SIZE - 1 - len) {
+			len -= last_len;
+			len += snprintf(page + len, PAGE_SIZE - 1 - len,
+					"...");
+			break;
+		}
+		len += cur_len;
+		last_len = cur_len;
 	}
 
-	ret += sprintf(ret + page, "\n");
-	return ret;
+	len += snprintf(page + len, PAGE_SIZE - 1 - len, "\n");
+	return len;
 }
 
 static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {
-- 
2.20.1

