Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9653B4D0
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiFBIM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiFBIMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:12:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830B239094;
        Thu,  2 Jun 2022 01:12:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8AE141F8C7;
        Thu,  2 Jun 2022 08:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654157573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kfIIAThWtEk1d6dpEsw8g4j1ltC0Xe7EwKNluxQa/ys=;
        b=jA0WkSVY7l3tfE7VzceBG2YYxeGHJouWRal6oOpW+oPmEriTAZJOA4e7BsAi9+2pXonE4j
        OZQQyQea5COy6/M1PgJiox+dPLrRWqYOUeRlbayt+JF0FfxT/wEsEnBhQJZEnGdm4xkOqG
        qDreZi8xH9qzAyaTmocp7q1G91IRR/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654157573;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kfIIAThWtEk1d6dpEsw8g4j1ltC0Xe7EwKNluxQa/ys=;
        b=7YJsHXi9Xj17dqbHPbSjNeJIr11sCgfg/vrainBCCN9yAtEhpgPLYXC0NbtfIPaCWY3FDJ
        oWKSFJeZljXLIfBA==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 739F22C141;
        Thu,  2 Jun 2022 08:12:53 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2637DA0633; Thu,  2 Jun 2022 10:12:53 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     <linux-block@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Thu,  2 Jun 2022 10:12:42 +0200
Message-Id: <20220602081242.7731-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1757; h=from:subject; bh=L9TDv6pt6PvZaowD3JImOB0iZkdUaZqUtEHfWoBiY4I=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBimHDp4cWcSxJ0pN4cOxYBEarR4iuKonoL6o88z+ZS ha8xnbmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYphw6QAKCRCcnaoHP2RA2UdDB/ 96H0v5glgVt2obSrlzh+SDeBpzQ1Iduw0gEmPdTPtA6VlTkqsO29l7Lod/m5pF5g956cNwQ+t2Gd0Y hVxA7BQtZaxitjiyg5oJhNCFFilJWgvWustBYPFk5h487/uGR72ZDWX7Yj8/O5uU9HKm1XE2aSJCdw Wpb5REUUyZpA3WQeA/+qaYUZtUrI352pZkUlNsj1Wj6yn4SBI/ki2hSpOztuU++uDqsPrXNE4XzStz WvcmdlxscsnUgt+lGfz3j+THZK/ydkHB3X/d5JPE7BdC2IvsM3NQPvglUUzy1oxoVu5vRKYAnOTOFR luJ3pQ05kihXrtrbQNeP6Pi+oifvPe
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
Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
CC: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-cgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Changes since v1:
* Added tags
* Removed unnecessary RCU protection

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 40161a3f68d0..764e740b0c0f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1974,12 +1974,8 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg) {
-		if (dst->bi_blkg)
-			blkg_put(dst->bi_blkg);
-		blkg_get(src->bi_blkg);
-		dst->bi_blkg = src->bi_blkg;
-	}
+	if (src->bi_blkg)
+		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 
-- 
2.35.3

