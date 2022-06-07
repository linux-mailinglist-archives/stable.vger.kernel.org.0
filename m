Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184095416A8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377416AbiFGUyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376933AbiFGUsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D90E1F62FC;
        Tue,  7 Jun 2022 11:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D94DFB81FE1;
        Tue,  7 Jun 2022 18:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A65C385A2;
        Tue,  7 Jun 2022 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627151;
        bh=QkiFAHOJFLYpTE4pDqY8HSQkwJMKiiJioaFUGFDAQSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a++uQWqQTw9BIazdjHYlqv56UguIkM4FS5kXrULLb6+orv+c398zHhqF1jjiRrmXg
         lxgl18AwAzwewQQB/s6vJ2Mj7TDmfW/j2I1yLWQ4lQMAhvdjC1uzc2snAMfg9UX7Zs
         QR9SuAjlvtJlVDzFDbYyCkso+KcjKA8r9pSW/8WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 635/772] bfq: Make sure bfqg for which we are queueing requests is online
Date:   Tue,  7 Jun 2022 19:03:47 +0200
Message-Id: <20220607165007.647021878@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jan Kara <jack@suse.cz>

commit 075a53b78b815301f8d3dd1ee2cd99554e34f0dd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -612,10 +612,19 @@ static void bfq_link_bfqg(struct bfq_dat
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


