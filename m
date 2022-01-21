Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFD2495E04
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 11:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380040AbiAUK6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 05:58:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52642 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380045AbiAUK6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 05:58:18 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B366221980;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1642762696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pcw0Dz6qCaXjfiGIwaXI/xy2ZlOMa2tLvBlwHG3TYvw=;
        b=3F0H0T/N7puPNecLtv2tBEStiG0W9aH2UP2+muvJjLmpR5XolIVXE1AK/UdAOr+i4CDeaA
        5p1EWzz1Xram3pEcy74OCGQ2u/25iWXI7rKOkYmmKuifQs7q4E9+pyeY/iS5rQbmmF04xR
        QVXZALFMH0NcrBFu3SW09Z/vsDZWqbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1642762696;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pcw0Dz6qCaXjfiGIwaXI/xy2ZlOMa2tLvBlwHG3TYvw=;
        b=7UO0Gyyl3iuXwhjN26AxPqTBFOob+rFsjC1v3GyVPC1ETx3r0BLABZAPJvV8zGAIhOxOnK
        /JUnBVeykOz+baAw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A6379A3B98;
        Fri, 21 Jan 2022 10:58:16 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 3A9C3A05E9; Fri, 21 Jan 2022 11:58:16 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] bfq: Update cgroup information before merging bio
Date:   Fri, 21 Jan 2022 11:56:45 +0100
Message-Id: <20220121105816.27320-4-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121105503.14069-1-jack@suse.cz>
References: <20220121105503.14069-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1409; h=from:subject; bh=P/+2SbEdiz2xvmkxw/cr+I4TuGV2AeuKw8OJviTNrjg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh6pFsQy/HX7G773Vd6m9ykG4cMcysm53jNa0NyqZ3 2jEOnyWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYeqRbAAKCRCcnaoHP2RA2WdGB/ 9Ox9UdnqFIMP3pXbqy1aULT6iVv9YZfhFsQK/FpBuVFoF5Dau3sEvJaXcfYVvVNrpO+xO8rckmRR93 gEhlg54O3yaSXZIQDSOE75KmQFOzRAjjpil5QfT568YFkVAGH3o6VgKoJUvgfqulYOvK33Op9cuEpJ pToclamBq+DOtu9vJohs4YiU1b+zw0NxF/DM0plnQwW0lVUisFY/B1S+BQcMvIFswOZWt8n60WhsbG s4pxr8+lgohlGhQ6yX6KGCD1CrQKnMBYJnVKip1bU0cRXzTkMVSSkzjlSwTYpS/4EQwl+sY5G402tm QaZVRKVAbnrmljCY8Hy6R5ew6MQGb3
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the process is migrated to a different cgroup (or in case of
writeback just starts submitting bios associated with a different
cgroup) bfq_merge_bio() can operate with stale cgroup information in
bic. Thus the bio can be merged to a request from a different cgroup or
it can result in merging of bfqqs for different cgroups or bfqqs of
already dead cgroups and causing possible use-after-free issues. Fix the
problem by updating cgroup information in bfq_merge_bio().

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 361d321b012a..8a088d77a0b6 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2337,10 +2337,17 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 
 	spin_lock_irq(&bfqd->lock);
 
-	if (bic)
+	if (bic) {
+		/*
+		 * Make sure cgroup info is uptodate for current process before
+		 * considering the merge.
+		 */
+		bfq_bic_update_cgroup(bic, bio);
+
 		bfqd->bio_bfqq = bic_to_bfqq(bic, op_is_sync(bio->bi_opf));
-	else
+	} else {
 		bfqd->bio_bfqq = NULL;
+	}
 	bfqd->bio_bic = bic;
 
 	ret = blk_mq_sched_try_merge(q, bio, nr_segs, &free);
-- 
2.31.1

