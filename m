Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A38FCB5
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfHPHtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:49:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfHPHtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:49:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AC823090FC2;
        Fri, 16 Aug 2019 07:49:03 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DE3AA4F89;
        Fri, 16 Aug 2019 07:48:59 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        stable@vger.kernel.org, Mark Ray <mark.ray@hpe.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] blk-mq: remove blk_mq_hw_sysfs_cpus
Date:   Fri, 16 Aug 2019 15:48:49 +0800
Message-Id: <20190816074849.7197-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 16 Aug 2019 07:49:03 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is reported that sysfs buffer overflow can be triggered in case
of too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs in
blk_mq_hw_sysfs_cpus_show().

This info isn't useful, given users may retrieve the CPU list
from sw queue entries under same kobject dir, so far not see
any active users.

So remove the entry as suggested by Greg.

Cc: stable@vger.kernel.org
Cc: Mark Ray <mark.ray@hpe.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sysfs.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index d6e1a9bd7131..e0b97c22726c 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -164,24 +164,6 @@ static ssize_t blk_mq_hw_sysfs_nr_reserved_tags_show(struct blk_mq_hw_ctx *hctx,
 	return sprintf(page, "%u\n", hctx->tags->nr_reserved_tags);
 }
 
-static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
-{
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
-	}
-
-	ret += sprintf(ret + page, "\n");
-	return ret;
-}
-
 static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {
 	.attr = {.name = "nr_tags", .mode = 0444 },
 	.show = blk_mq_hw_sysfs_nr_tags_show,
@@ -190,15 +172,10 @@ static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_reserved_tags = {
 	.attr = {.name = "nr_reserved_tags", .mode = 0444 },
 	.show = blk_mq_hw_sysfs_nr_reserved_tags_show,
 };
-static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_cpus = {
-	.attr = {.name = "cpu_list", .mode = 0444 },
-	.show = blk_mq_hw_sysfs_cpus_show,
-};
 
 static struct attribute *default_hw_ctx_attrs[] = {
 	&blk_mq_hw_sysfs_nr_tags.attr,
 	&blk_mq_hw_sysfs_nr_reserved_tags.attr,
-	&blk_mq_hw_sysfs_cpus.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(default_hw_ctx);
-- 
2.20.1

