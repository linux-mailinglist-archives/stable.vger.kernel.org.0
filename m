Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA255542F66
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238324AbiFHLpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiFHLpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:45:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DEBED3EB;
        Wed,  8 Jun 2022 04:45:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6FC9C1F8B9;
        Wed,  8 Jun 2022 11:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654688740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1CMpBQOn5+cUgJcRoMuI6TTAPLMaD/dLPWWB26C6/PM=;
        b=B1HIlHC4Mocvg3xaqd0ckpmHOhzcQu+JR5sKOMXZ8MVy9T09a/gnWBsG0SPUhIcNPegHy8
        +RwwCLqFg1kP+eGfof2TnG16nss5rb1i1LS6DUz5dvYvKA7CMWQwYkOfGIDLHdeHOdUGvn
        bpPVVaSYzCQWjtzQFzXDh/3Sv8zZslI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654688740;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1CMpBQOn5+cUgJcRoMuI6TTAPLMaD/dLPWWB26C6/PM=;
        b=OiYWnUUfkt3tMhq1joWRtiHucYJuZ731RQ+zIwo4pjJvLHGGOmLvIaED7itryhHmwYIQH3
        9oLTB3PXGPh2qRDA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 596A32C141;
        Wed,  8 Jun 2022 11:45:40 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id EBF6BA06E2; Wed,  8 Jun 2022 13:45:39 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Wed,  8 Jun 2022 13:45:28 +0200
Message-Id: <20220608114528.15611-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1937; h=from:subject; bh=B2CGxiFWrNxMSNFjp2FGVowXPDbamcFvKyJboulNsEo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBioIvF9+He+4B/yY/KFaMHdWI8THP5m4lrjpNVJ5tp USp+Ev+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqCLxQAKCRCcnaoHP2RA2cwKB/ 49dQ6pQuFwFR+Z1fzK2Gd7tP/JhR9yBXCJ7IH1xzfvu6+MFSomukIL6gtobuBFeIUfNny7uvRiXIml ykmwoJ7LVqGYwWukKi8QM08FZPIyCV7H1f6jlAkliuNfHUZAv7vL0uCvUKpxZOATTC9u3JD/wRUTba Tu5GZd5NW4hSLa8Dl9V9gpxy4VNiepRlOUGTlGkr9DlPHZDexCCOwqUdkMDwCPUnY8leVMVX6XLsba VDADrVRiXsthPGOlynQLEHS7OLD4T+2iuvSMZbZBybirrr+e/oLzH3M5/1guTt0D69MVdSkO3SuEPT x32oPJiWsztpXlsGu19fa/bcNpPC7M
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

commit 22b106e5355d6e7a9c3b5cb5ed4ef22ae585ea94 upstream.

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
Link: https://lore.kernel.org/r/20220602081242.7731-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

This patch should be a backport for 5.15, 5.17, and 5.18 stable branches.

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 07a2524e6efd..ce5858dadca5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1886,12 +1886,8 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
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
+		bio_associate_blkg_from_css(dst, &bio_blkcg(src)->css);
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 
-- 
2.35.3

