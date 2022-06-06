Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFFF53E8F4
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbiFFL4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235882AbiFFL4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4821E7CB21
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 04:56:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D15ED60F84
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 11:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E528BC34119;
        Mon,  6 Jun 2022 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654516574;
        bh=stgnt7RmBUTRWEWNk1AVMX46jzfctHc1o1dZpbtE3Xg=;
        h=Subject:To:Cc:From:Date:From;
        b=XKzrnE7TE0QOk33laPVhGWF02a86g0nBbaBDqEvIt8XkjRwBo5ueA76kL46EMhLUJ
         kMZ8fpAay5fYtghFaHiUF+rDx3qoQQ9JzzA4MkQf88LQ1dzJ4K4qh1VcqWrFLV3T6X
         3iZfV163c7EqfsDU3TQRrsAusCWrg2hLEgg1fmNI=
Subject: FAILED: patch "[PATCH] bfq: Make sure bfqg for which we are queueing requests is" failed to apply to 5.4-stable tree
To:     jack@suse.cz, axboe@kernel.dk, hch@lst.de, yukuai3@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 13:56:03 +0200
Message-ID: <165451656360169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 075a53b78b815301f8d3dd1ee2cd99554e34f0dd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 1 Apr 2022 12:27:50 +0200
Subject: [PATCH] bfq: Make sure bfqg for which we are queueing requests is
 online

Bios queued into BFQ IO scheduler can be associated with a cgroup that
was already offlined. This may then cause insertion of this bfq_group
into a service tree. But this bfq_group will get freed as soon as last
bio associated with it is completed leading to use after free issues for
service tree users. Fix the problem by making sure we always operate on
online bfq_group. If the bfq_group associated with the bio is not
online, we pick the first online parent.

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-9-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 32d2c2a47480..09574af83566 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -612,10 +612,19 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
 struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct bfq_group *bfqg;
 
-	if (!blkg)
-		return bfqd->root_group;
-	return blkg_to_bfqg(blkg);
+	while (blkg) {
+		bfqg = blkg_to_bfqg(blkg);
+		if (bfqg->online) {
+			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
+			return bfqg;
+		}
+		blkg = blkg->parent;
+	}
+	bio_associate_blkg_from_css(bio,
+				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
+	return bfqd->root_group;
 }
 
 /**

