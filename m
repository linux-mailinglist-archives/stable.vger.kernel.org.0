Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BA64866E9
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiAFPps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:45:48 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50276 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbiAFPpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 10:45:46 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 513652112A;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641483945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XI20t3x6VluxG/lEe3pVn9R5bOW+Q1xeNYKAadDibN0=;
        b=2aMcAwOjv3tN6KVz42xVTCTqcXhUCB3J2tn+LXeQeCMmTq8M2AeOl5ajzhLiA+zDsSkmHO
        2DQm88d+Vfxfudju2pWYyEvkpTWhAVCj5xS9d8x62dyAA85LpcnMiAYZ4XHvHHCEylRfvU
        XGfTKecPhpYBiEaOd453ZvdlXEToxnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641483945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XI20t3x6VluxG/lEe3pVn9R5bOW+Q1xeNYKAadDibN0=;
        b=8YFk5AtUz/abnPVcy9O2O4XZwWFnUsqSJo3h0aTB3Hb9jh5AvnDwKicEDk1ie5hd49XaKo
        fpbPwZrItw+tpcBg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4594EA3B89;
        Thu,  6 Jan 2022 15:45:45 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id D8BC4A084C; Wed,  5 Jan 2022 15:36:39 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 5/5] bfq: Update cgroup information before merging bio
Date:   Wed,  5 Jan 2022 15:36:36 +0100
Message-Id: <20220105143639.31266-5-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220105143037.20542-1-jack@suse.cz>
References: <20220105143037.20542-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; h=from:subject; bh=C0+SJ39G5KroczINGXi/DmV/R4t2VczWioMIeh5rfLk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh1az0bT4FhjQ/C3K9EvbFmFE27QKGZ0RF44hR8KVz AKfB/uOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdWs9AAKCRCcnaoHP2RA2d3gCA CxEIICfQmj0qLCyG49URS9AtsNC7S/UKlG6HzbDjzE16TxVcY0OTuJXEnk7SPqykvMpZ/BkwIjrECJ GaIGUeUruWbMRUfKhiqc3+dyh5sMC8OSqMd9X35stuFg4AiKjWLYDV89dPuwexJP0/whI4/3H8uLD5 o7Z869Qtp8j2KcD7hAH0Bdr1yosJtd2iGosPpMWelDujKFe99LIJWEMPtjKYV/cC68wOjWctAftFIb yuaio53FKWNLXY6BX4oMduVH2PtC9e95UjQczrtyTu6CB0JNuYkEqtV7Hd5Y+ShYJVtTzj3jcqaFH3 MVuRAAMqy7Q4cwDAcXvjbFfhS6alNG
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
index 654191c6face..f77f79d1d04c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2337,10 +2337,17 @@ static bool bfq_bio_merge(struct request_queue *q, struct bio *bio,
 
 	spin_lock_irq(&bfqd->lock);
 
-	if (bic)
+	if (bic) {
+		/*
+		 * Make sure cgroup info is uptodate for current process before
+ 		 * considering the merge.
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

