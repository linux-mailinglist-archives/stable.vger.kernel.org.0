Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0864EEB35
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiDAK3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241970AbiDAK3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDB626E566;
        Fri,  1 Apr 2022 03:27:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C61CA210FC;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kz4yzWuKqKHnpGX5HVClU1VX8JDHF41CaOQeK0bFmM=;
        b=vase2uVkwsTdL52H0RMuKpv3tNlREid2a/5wuH5ZsF4NY6DXwfXPvlw2kCcqAAuuAjNyPw
        Q6ATyXdyqbPVqewJZ3rgH/RuLLlQIqzs9mp6O/KjC23ilHT+W4VleJlP7ZhKvWWQt1bP+c
        34uDXm4jYXG5tagz4zKhr11tuWz+kLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kz4yzWuKqKHnpGX5HVClU1VX8JDHF41CaOQeK0bFmM=;
        b=uw9KWn9V+62jXZyHOqvdLFqKI6OfiQZSyeS1FUa3fbLOApKXvmRfDy/nKeaSJb44VWjmCK
        UFZlciojuI+gi4BA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A4107A3B88;
        Fri,  1 Apr 2022 10:27:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 875CCA061A; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 4/9] bfq: Update cgroup information before merging bio
Date:   Fri,  1 Apr 2022 12:27:45 +0200
Message-Id: <20220401102752.8599-4-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1455; h=from:subject; bh=ZXtMvPdme+98TvEer4Fc63SIc5w+HQccSDUrivn0Ttw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOhxr8HA9TU7R2le3a3GLod00df5u+vOKGbBIwA +UOFXbeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbToQAKCRCcnaoHP2RA2UA1B/ 4s/xVxYae2jfiby2vEr7yP16xSSAlPNPznE2wAYZdRP1HZsmwXMabpNPa+8rZMMQDNTHcnoULZ7EEh r3xB/PO/vsYCyGUzaB8sIBjaSxFFo3HwjZ+grmYicnY5q7oudywN7LTHlRvkYizRwg25jA2UB4Ascn U5kggrSnQVvPHrRsQQcrtPAGrij8xc0rl285Vf0PRJromv5ls2BtscqpNkF+DZc0KbchCLC/bvCfVb y6o/K1+P8b6fiyIEiLRrGYgyMa0vJWVsjDZSPWAENekVVd4/3XV9juuDmwr5E2ULFl9Q39hiwCbQhS mZL+KVGEXsLOG50KdQQHI2TfBoodDU
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
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
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

