Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DD14EC4D0
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345620AbiC3MrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345236AbiC3Mqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:46:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D5B7DE16;
        Wed, 30 Mar 2022 05:43:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2E0C81F7AB;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648644181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQpb3DlBpC+xUzJx/SvzpuHxoRpxIiDopbRVeNdSa9A=;
        b=yR5UWcrbn14XpWeWjX5H6HlNocJ16DztxIg7aPmwVLIq4VH4hY5gO9mr+pDHF0/5LMEHRL
        cVpcZ+6oRrfvj1fDHaousDrG2RYQApIkSIuzKkXefILHzX3xAn/teQuVYj/+j7J5YBcPzj
        +0qsftB9lTnGKin+iMojNJI6W5sXIM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648644181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQpb3DlBpC+xUzJx/SvzpuHxoRpxIiDopbRVeNdSa9A=;
        b=u6cKgGrGYXHqcfeLJb6mXH76Bf9vSh3/Z8nXsWCZIL3zBbP7NxAp/j/jUOehB6ZQ/Fe0hL
        Ak22qhc53arabJBA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 19BA9A3B83;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 78D4CA061A; Wed, 30 Mar 2022 14:42:56 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/9] bfq: Update cgroup information before merging bio
Date:   Wed, 30 Mar 2022 14:42:47 +0200
Message-Id: <20220330124255.24581-4-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330123438.32719-1-jack@suse.cz>
References: <20220330123438.32719-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1409; h=from:subject; bh=vBnlnDsUwY71kZB9dCskeOZQL4WP3DTzp9qFZwDR62M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRFBH7s2MVgHfYyX7/j3Uz+L7Pwc2kwt7cjXogDoj nSmTnGWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkRQRwAKCRCcnaoHP2RA2RSSB/ 0WB0b7X01Qo+1rx9nKW/zefbr92awfYlpwrSL8lo6045feevYqyavolAM8ZOa9k3I7GtKLYVHzYigp fYZuQrmyUn3ur6/sz58I126oHSGGjaAv902P4tt2JiDr7PN205xZ2AwEIebyJi9Q4gGoxJ+cE74ZcY PvqEBu5aNbHwug8UQxlxV4ZZnmvxOpdt0/3yJohDd7Jldyy4ze5rsj3mi5AvHllz9mWIsxw+cSwr/q joayjRM0nZU0KdoKgE4RU5qdIx3ZO82m6yWi7eZZxumNosImKmgoNv0ZsnFob9JRrSMlGB0hrui5uK FbalNNj69MP8f48mePNHAPO0NsLydj
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 89fe3f85eb3c..1fc4d4628fba 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2457,10 +2457,17 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 
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
2.34.1

