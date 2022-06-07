Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9391A540E9C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355011AbiFGS5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353541AbiFGSw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:52:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BE14AC81;
        Tue,  7 Jun 2022 11:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A4D1B82182;
        Tue,  7 Jun 2022 18:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA27C385A5;
        Tue,  7 Jun 2022 18:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625016;
        bh=L8rzIN4RHuUhR9tM7Gxa3OxLT7IY0eF6EikHksfZklw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2W2iXQNNEQ2s/O0qX69b5hO2Bt/hAIEaUYVTqQfET+u6hVM81MJr9h97gyp+NsE5C
         lrkaOa7T348jHt8YQEnjlwl2dipeT7I82O6zKlBbMALHvqWfCfO1QXvQ8cH03e/CbP
         qhflm6ABBP3ar4VSaV3mJfvulJUhzGho3ebrBMgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 537/667] bfq: Track whether bfq_group is still online
Date:   Tue,  7 Jun 2022 19:03:22 +0200
Message-Id: <20220607164950.807522693@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

commit 09f871868080c33992cd6a9b72a5ca49582578fa upstream.

Track whether bfq_group is still online. We cannot rely on
blkcg_gq->online because that gets cleared only after all policies are
offlined and we need something that gets updated already under
bfqd->lock when we are cleaning up our bfq_group to be able to guarantee
that when we see online bfq_group, it will stay online while we are
holding bfqd->lock lock.

CC: stable@vger.kernel.org
Tested-by: "yukuai (C)" <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220401102752.8599-7-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c  |    3 ++-
 block/bfq-iosched.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -555,6 +555,7 @@ static void bfq_pd_init(struct blkg_poli
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
@@ -601,7 +602,6 @@ struct bfq_group *bfq_find_set_group(str
 	struct bfq_entity *entity;
 
 	bfqg = bfq_lookup_bfqg(bfqd, blkcg);
-
 	if (unlikely(!bfqg))
 		return NULL;
 
@@ -969,6 +969,7 @@ static void bfq_pd_offline(struct blkg_p
 
 put_async_queues:
 	bfq_put_async_queues(bfqd, bfqg);
+	bfqg->online = false;
 
 	spin_unlock_irqrestore(&bfqd->lock, flags);
 	/*
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -926,6 +926,8 @@ struct bfq_group {
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
 	int ref;
+	/* Is bfq_group still online? */
+	bool online;
 
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;


