Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A05253ED60
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiFFR5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiFFR5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1284031CC88;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6454F21B91;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SDuL1yHsM9tqahZ4MTx0RfeBwJpM0mHbD0EbAJ/Kms=;
        b=Nht0RnweMQ17Ddsdp05K38fzLgjJRxF+Fq/RVzG24opijEiasCqBHlr993FHnh7iyyw3tt
        0iw3nX5SHIRCEmEk04B88Svi+bCmmkSIPPfBUqWJzye9z+lTdskRDSPrOyetYJlyrpfIC0
        Iub6gpSLV02quYm3xxxskde4gKNC8zQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SDuL1yHsM9tqahZ4MTx0RfeBwJpM0mHbD0EbAJ/Kms=;
        b=Jlp7hjFIFuptWqYeviQaN61LA6aRCdjwxBDhuYbDchSCi5A2/NQRpiYVTs0E//9W3Ww6Qv
        Bz6L5vB5xmW3zMDQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 545582C141;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 28BE9A0639; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] bfq: Make sure bfqg for which we are queueing requests is online
Date:   Mon,  6 Jun 2022 19:56:40 +0200
Message-Id: <20220606175655.8993-5-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1787; h=from:subject; bh=CGjHdnXjgD/kEx+rwRDpVFYMVyeiH0NpKSH89ZbtK5Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/XYYVlTHQfy2/yW+znzcBe9OxDzVmM98FKwdFt aZWTb+KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/1wAKCRCcnaoHP2RA2axKCA DrZBTOP2vhcgiaz85nwXbcoBNDj6eEt3k2TIgHKj5HC0Fp3ij7xHBeVOT8EuQ5WQ9QtR0w1ayLcKt0 MbfHwo0C4ozdkpX+sbem19TmRtqYJGosrYpLlWEh8FBTS3r1VvpgCw6VWxfwQnenwaACY1nsX1HvrX ig0Nww1ObE+DGAohLPX9ytuksMS7MKKuRqsylUd+G7k62fc9OpSQ11PcvNIU/sjXsQKIwJbrdR+jda lNRhdN+VoOiFqFukun6LKSFCYrZGu/Dzwx7SxJqbjDopdLHc48yyIQIR5IBqQRa3XcFF9LWBEWsNAI pFHOlZzwHFVba3UKHEfvitup+ecaZO
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
---
 block/bfq-cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 622c9a13e496..be6733558b83 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -608,10 +608,19 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
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
2.35.3

