Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FC53F938
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiFGJPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239086AbiFGJPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAABEA33A9;
        Tue,  7 Jun 2022 02:15:30 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8579E21B59;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654593329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMltRdJpRUnmKvDTuHmMk0aj1eUAB3irYm2h+BMnSmQ=;
        b=t12fRnubHY8xZFu7uFqOGIExOGyLYbS3ZOE6Kp7uC6YVHF65ZFm768rfU55+d2evV1caMh
        o0aDHdewuOaHhCcGHqx1DLHgxJFCiKoG7UYE2/aWiZSko2ZBzyoY75ULddzyaXC7XJdzsZ
        W8h5xlPGgbOaKBcHDDcxzotLIJBHS6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654593329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMltRdJpRUnmKvDTuHmMk0aj1eUAB3irYm2h+BMnSmQ=;
        b=0qPf6bNhT5dq9WK5bmQrxZ/G2WsvJDYkckS11Vqut+34j6O8wH/xcADMc8Rilr4j8O8SwV
        6DikguK4nu3l1FBA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 702692C149;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 9855BA0639; Tue,  7 Jun 2022 11:15:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "yukuai (C)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] bfq: Make sure bfqg for which we are queueing requests is online
Date:   Tue,  7 Jun 2022 11:15:13 +0200
Message-Id: <20220607091528.11906-5-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220607091209.24033-1-jack@suse.cz>
References: <20220607091209.24033-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1787; h=from:subject; bh=1ePM1sdlRu7Fu6FfeJIVVQi3q1icetZ/FTCwaRrlWPU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinxcgbbH+hfj+7zwvGEmYptpcbPAH7AwzI2Ei8HhS hdTxkAWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp8XIAAKCRCcnaoHP2RA2XFrB/ 9+GHgeDOQx2k3ZEOp2mkTD2H8h9v1Nk+DH+52RFyB7UDMPuGu9h/KdQqWMmD9CB8ogsT+KP0qOsrri 3jyn/XuQ+3DwtC4R10kiH7P5XNILonk9mzDj6nf0yoIQn1RilTn7FWmFcsEnBXhfW9tQ7UkKIUvnEj QJZQ3C6/72wqidwJ+abDW+STAb8NbcEbC82sLt6Qg7r0GmDdXSSXEDzBRWHutVGPK1OaXJC+zXL64t +iuK8cpQwyBnrUQPoZBJKkiYrh944Fe5B0dBnFsgMVLU64+CcsEeUIz6YmYh1pn98F0hZ1e+prSk7M LUBkqxrYl0hul5NUdBu17+fHXf5Zaf
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
index 3835cd920587..09d721b1f6ac 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -591,10 +591,19 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
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

