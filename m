Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D1B4EEB42
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245574AbiDAK3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245635AbiDAK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:29:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7EF26E56E;
        Fri,  1 Apr 2022 03:27:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A15131FD03;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648808874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tA0rKXsxf77nc7Y9wimslw6o3kvPAaCI532S6Fi8Ku8=;
        b=JTpL/yQ35Uo0cdyHthSMpwo+YYr9z9gbqEVfbnlwtm21i1pPikC5BwnHiJFfwEH4wMQOa/
        d4smprMTtGFMDt99t6UwNOX+824oE5uZdUy/814GNlYDYcRh2AZYCbA9OIqJHKBsVMQxHe
        BNA6ivLPACoKsUlieD372btioLxvB0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648808874;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tA0rKXsxf77nc7Y9wimslw6o3kvPAaCI532S6Fi8Ku8=;
        b=JweEsUcElcwq2AE3MqnVDYuqWGUXa7Ic1doIZQzk+ycT4MEhnss9WChRssxOgY3o6sF41o
        e28Eb49SIPkFKtDg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 821DFA3B88;
        Fri,  1 Apr 2022 10:27:54 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id A709CA061F; Fri,  1 Apr 2022 12:27:52 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "yukuai (C)" <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 9/9] bfq: Make sure bfqg for which we are queueing requests is online
Date:   Fri,  1 Apr 2022 12:27:50 +0200
Message-Id: <20220401102752.8599-9-jack@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401102325.17617-1-jack@suse.cz>
References: <20220401102325.17617-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1568; h=from:subject; bh=sgAPcAQrJvyNTY55SSAru4QatmfaUnmjg+zxK4TmvNM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiRtOlKklLhNNV3RGbf7D1KUJYUgBsxgg8XSM1TWU0 HAuk0saJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYkbTpQAKCRCcnaoHP2RA2WUuB/ 45d/A4FWTboIVYdZ+QTKDERa161jYw4o75MeQV0qFUxjSiBn1+H1MSA5bPrLHZUGJhfAsD+RMefQIg oxOjs4FUnRMk2utm8NFp39DvIwTryxvAhI85kRUFLpXS5TOQrk6j6WQAeybv4ucYN/opBfH7ikQBEe iDW+Okuhm4+wzbxoEBOitpzukCfF6eK3aky2OeiHz78HU672Df1Gx22XTmXF3mstLzoFP35yonrra6 HZMnZIZCAvtjxOsozE5Dv0E5WnuPq4q0M9r95UaHad4mUF9kltwKmYuluyi9CvyS6QjKruRzVf3l1Z kYLXABUvmFhNAIiYt4qTATjJmfQsi6
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
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
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

