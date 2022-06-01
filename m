Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FDB53AB16
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355285AbiFAQeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 12:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356124AbiFAQeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 12:34:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9866ACA;
        Wed,  1 Jun 2022 09:34:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 73AC81F938;
        Wed,  1 Jun 2022 16:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654101256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cFhOhGTkWOdWt0QDJ4fs9W4sHYX2lYn7+ibFFbNYJyQ=;
        b=cm5KNBn7DCZzV+joGwMLKRjBP0czN0uMJmaAB3x4SrpgJB3sPwvCoaLbZ2+Wed7cwI67kb
        3iy4B/JME2TaCJhdNppEdnmJL0UHl03qd2yH5j1P5nWqrXqZNWP3AHEvE1brC5Hx5SrZ1m
        ByxKN3a4zo6UafM/cDN8Dkk5qCItw+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654101256;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=cFhOhGTkWOdWt0QDJ4fs9W4sHYX2lYn7+ibFFbNYJyQ=;
        b=A1r4sS/rCAep8NYncDlK4u6dVSaqVg2VQ0WhYu7dgfYnCY00VWfNSsoT0qXmEFUN7Yhbvi
        /uHsxi073Y17OaDA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 56B5D2C141;
        Wed,  1 Jun 2022 16:34:16 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 6F9D6A0633; Wed,  1 Jun 2022 18:34:10 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     <linux-block@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Wed,  1 Jun 2022 18:34:05 +0200
Message-Id: <20220601163405.29478-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1641; h=from:subject; bh=u9pcp5UoDXQxoj3ZLRxhk9+TbpWRpxKK60xlgA8lMSI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBil5TyMyUsMh/fbgu37NGo92nB19CiU4LXI6JYwS11 MFgzuRCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYpeU8gAKCRCcnaoHP2RA2dOoCA DnfrA2cy6qkYowi2KyLKJ63v496xyBIJpICXnEfFTUaJoymJgrj+M5sUTpFvk2+WdYc1HKJZo918Hd lGTd0De4fJh6eoYkswcYXfPfwuvQGQMBAg5Mn3VysD0amh4SU0t3aC1m4iqzYWjixX8GK+XBhkbj14 5r1AUd+/HX3wJhCjeUgcWWBsVQ0CVey+hKnHhKFq3Zk2qeYcsItadggzguInv0nQkH/WwMOHoXGHuq 8QTKCEdhH0bfTYSc6XIxlEI+UX6TQEJpJBNq04YS2+WkH4tn59Sak9kMOT1yOsTZyPVjxtv8t/hN3e 1X5R+DwHgpr3k/v0aPcBAyb3fmwMuZ
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

Commit d92c370a16cb ("block: really clone the block cgroup in
bio_clone_blkg_association") changed bio_clone_blkg_association() to
just clone bio->bi_blkg reference from source to destination bio. This
is however wrong if the source and destination bios are against
different block devices because struct blkcg_gq is different for each
bdev-blkcg pair. This will result in IOs being accounted (and throttled
as a result) multiple times against the same device (src bdev) while
throttling of the other device (dst bdev) is ignored. In case of BFQ the
inconsistency can even result in crashes in bfq_bic_update_cgroup().
Fix the problem by looking up correct blkcg_gq for the cloned bio.

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-cgroup.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 40161a3f68d0..ecb4eaff6817 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1975,10 +1975,9 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
 	if (src->bi_blkg) {
-		if (dst->bi_blkg)
-			blkg_put(dst->bi_blkg);
-		blkg_get(src->bi_blkg);
-		dst->bi_blkg = src->bi_blkg;
+		rcu_read_lock();
+		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
+		rcu_read_unlock();
 	}
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
-- 
2.35.3

