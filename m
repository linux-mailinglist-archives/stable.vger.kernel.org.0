Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AB553CE0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355200AbiFUVBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355410AbiFUU5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA213205A;
        Tue, 21 Jun 2022 13:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9040B81B46;
        Tue, 21 Jun 2022 20:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0995C341C7;
        Tue, 21 Jun 2022 20:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844635;
        bh=lGYMb0noynPJBGvmNQGp+A9u4UxmxItW8wjaBl01wE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZlxgGLDCpVHxwb5A4TRf5e3BjrIfrlDwiC+RLXSxmJsI265pxDYbYLQz7l3LH7Nh
         /7Cz4+jMS/gjDOFqTocOrh7Gtn/FZb2ijvkfq2Kmz1KNDC4zp9tSPqnsSOVTwsLkcS
         dGQ4oOGKkMFa+lrbWl+TG5Fipw7+QU6kszkboTh095Lge8o+rWP6IOaj1aREumonB4
         b0qCjIe94ef8ykKxRXu9yIt81ReYfxp/A7btQ39ylshMES0AOU/9iZYDenjBXiM0LJ
         /4RV6kY5MHxrtg7/+uB1cMSg6PiB2WstqBkmnRRyGGdH4jTS9E8Mo3wNh7UrsmMBU3
         L0c67VlysdMVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 16/20] blk-mq: protect q->elevator by ->sysfs_lock in blk_mq_elv_switch_none
Date:   Tue, 21 Jun 2022 16:50:06 -0400
Message-Id: <20220621205010.250185-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 5fd7a84a09e640016fe106dd3e992f5210e23dc7 ]

elevator can be tore down by sysfs switch interface or disk release, so
hold ->sysfs_lock before referring to q->elevator, then potential
use-after-free can be avoided.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220616014401.817001-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f18e1c9c3f4a..5021e8ed2053 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4433,12 +4433,14 @@ static bool blk_mq_elv_switch_none(struct list_head *head,
 	if (!qe)
 		return false;
 
+	/* q->elevator needs protection from ->sysfs_lock */
+	mutex_lock(&q->sysfs_lock);
+
 	INIT_LIST_HEAD(&qe->node);
 	qe->q = q;
 	qe->type = q->elevator->type;
 	list_add(&qe->node, head);
 
-	mutex_lock(&q->sysfs_lock);
 	/*
 	 * After elevator_switch_mq, the previous elevator_queue will be
 	 * released by elevator_release. The reference of the io scheduler
-- 
2.35.1

