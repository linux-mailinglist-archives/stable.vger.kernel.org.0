Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146D94EC4D1
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344972AbiC3MrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiC3Mqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:46:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0167255750;
        Wed, 30 Mar 2022 05:43:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 731AD212C6;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648644181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRZ85jQoU7TvkqgM00hNxz5/k9iJcTYk7V8sofKyQmw=;
        b=1drrYO5eyLfp5ux6hC/3GacnJGXYFn//wlwdHrM9gp9VjuRCWRGttn+mK48mD2k5EB4TN1
        U6uzbsFXQJtxmuauUMniJstpTCqcpM9iEMoBGOipGp1UCY/ddTbJSOqRYBObPExuwDbZk+
        uiKt0SOaw3RNPQ4D5ZY1WZn9+zKxHxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648644181;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRZ85jQoU7TvkqgM00hNxz5/k9iJcTYk7V8sofKyQmw=;
        b=qtXVwJeEhH0lSEWEd55HRZ1XWwPhK7EamdK2Y37aiASPy0QpR+LRE9Xa4KNhxfLodoiqPj
        EPKbHKJqQSQo1BDQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 66156A3BA0;
        Wed, 30 Mar 2022 12:43:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 963CFA061F; Wed, 30 Mar 2022 14:42:56 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-block@vger.kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 9/9] bfq: Make sure bfqg for which we are queueing requests is online
Date:   Wed, 30 Mar 2022 14:42:52 +0200
Message-Id: <20220330124255.24581-9-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330123438.32719-1-jack@suse.cz>
References: <20220330123438.32719-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; h=from:subject; bh=IG83mxZ/ZhVpcfY2IHN0K8dR/1UrFaCWqw7Cz0PSQXg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRFBLFh/PSPExza98vsZtwLk6Rd2oChOwIwvG7Dk0 TN0o3ImJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkRQSwAKCRCcnaoHP2RA2X7wB/ 0R1pDb6L3U/ExXLnsZiWZzWFa+fX4FBl0mHD6lOdrgiOForcDlHbYzI/PoKhXaYsJBbYxh8IlWsjWv 6acjRHUG3xm8ajWXu8pVoXVH0TXz3cAMYYWp24IxEggv8cX4E7G7IXBtYWAYmoGgm7D2LXBihKSUJT gj71z6W8jFUxl3zQbn4nm1CR7vttxv6/4+9321x1iDnJqbYyShC+iH+vs+BTZqdC88L0y/Ru2zIJTs JgklGBIHyUS8KxRfBy3RyNi+m6rni1pBZKowAuhZDDl50daPvx+mhC7UVGhGSh8TjALISxD3pFz8SO pDMLSzxOyNb9YZqkHK2Ta0hZKgsSW5
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

Bios queued into BFQ IO scheduler can be associated with a cgroup that
was already offlined. This may then cause insertion of this bfq_group
into a service tree. But this bfq_group will get freed as soon as last
bio associated with it is completed leading to use after free issues for
service tree users. Fix the problem by making sure we always operate on
online bfq_group. If the bfq_group associated with the bio is not
online, we pick the first online parent.

CC: stable@vger.kernel.org
Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

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
-- 
2.34.1

