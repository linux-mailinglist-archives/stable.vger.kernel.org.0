Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56B48C353
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 12:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240184AbiALLjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 06:39:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42136 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbiALLjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 06:39:33 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B503C1F3BB;
        Wed, 12 Jan 2022 11:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641987571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pcw0Dz6qCaXjfiGIwaXI/xy2ZlOMa2tLvBlwHG3TYvw=;
        b=onsstIQttVSLGgFpUSh3I8HnRDo/bROAbMlFewWB3U43RyYQ82nc4hoqFT161CX9+guIzd
        Jms7ILfI8Y+NMgyYLx5CBZ1R7c+WbgueYVfCUSF8y6x2PnhHAnf12bloWEKM45dWRHQhdX
        VXB4iTq5M+buNDopk2u4lDh9nWNytbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641987571;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pcw0Dz6qCaXjfiGIwaXI/xy2ZlOMa2tLvBlwHG3TYvw=;
        b=qKNFZ6VjH57hsbem0RH8vQwYgBX3CXct42Clu9pZEGrwTOTZykyQM/60E9IMvf2k26d3+1
        o8zALtEnkCuUtoCw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A1829A3B87;
        Wed, 12 Jan 2022 11:39:31 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C1000A05E1; Wed, 12 Jan 2022 12:39:28 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] bfq: Update cgroup information before merging bio
Date:   Wed, 12 Jan 2022 12:39:22 +0100
Message-Id: <20220112113928.32349-4-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112113529.6355-1-jack@suse.cz>
References: <20220112113529.6355-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1409; h=from:subject; bh=P/+2SbEdiz2xvmkxw/cr+I4TuGV2AeuKw8OJviTNrjg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh3r3pQy/HX7G773Vd6m9ykG4cMcysm53jNa0NyqZ3 2jEOnyWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYd696QAKCRCcnaoHP2RA2SMXB/ 9jRaHsj0cG/dgAOCCu6VA+421DnphVVT+iVOcNsSjpmRH7QvpRl58F+OkMmbSZDP1If4Xjl50txiIb 6RQqBlUkj95eBCT4ufcZlA1e/TGlVIvlB+MS9FGs/a9EYhe4vm4NUde+ihp2AfXGZCb1/v3UrcTHhu pS+DEv8gzxe+qpbvYfDf8Lt8fHyTDNibiYmgs1MqolBOYz9/65MVASylA+AuGLYMnhPpZhNnQ2ds6G efBH0ZiJG9zKeqmGHgirmbKoJqwEVeUWdh0JzKCPhITYMx/1e2esDgZp4aP9KO2VXAN//HibX3KxIY rZQlGH7YPWm42GtOMC7LtZNDbM67HD
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

