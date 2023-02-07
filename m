Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DA168D796
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjBGNB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjBGNBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C40E39BB6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87BD561403
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79762C433D2;
        Tue,  7 Feb 2023 13:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774839;
        bh=1fAa6k1mwQRSnOZe31Kzo8oKONdjGcfLHZhM9nThEpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eX4O693kYgkLIHoGar1da3IeGyJKqeXhD/ihfLU/WVAMeDHWANfXQ0ia4qFjN6Fg+
         t+gwH2lMkEI7Bwt+8MdA3xquqA/SvuBZualt7KS8Rg1U7SFCmr47QqCaw3XtMnY6F4
         6zj02/vDZyNfhCDI9alYar4dDhIPraKKytugaR30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/208] block, bfq: replace 0/1 with false/true in bic apis
Date:   Tue,  7 Feb 2023 13:55:03 +0100
Message-Id: <20230207125636.502515863@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 337366e02b370d2800110fbc99940f6ddddcbdfa ]

Just to make the code a litter cleaner, there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221214033155.3455754-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b600de2d7d3a ("block, bfq: fix uaf for bfqq in bic_set_bfqq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  | 8 ++++----
 block/bfq-iosched.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 7d624a3a3f0f..dfb6d1d8bd46 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -718,15 +718,15 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				     struct bfq_io_cq *bic,
 				     struct bfq_group *bfqg)
 {
-	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, 0);
-	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, 1);
+	struct bfq_queue *async_bfqq = bic_to_bfqq(bic, false);
+	struct bfq_queue *sync_bfqq = bic_to_bfqq(bic, true);
 	struct bfq_entity *entity;
 
 	if (async_bfqq) {
 		entity = &async_bfqq->entity;
 
 		if (entity->sched_data != &bfqg->sched_data) {
-			bic_set_bfqq(bic, NULL, 0);
+			bic_set_bfqq(bic, NULL, false);
 			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
@@ -762,7 +762,7 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 */
 				bfq_put_cooperator(sync_bfqq);
 				bfq_release_process_ref(bfqd, sync_bfqq);
-				bic_set_bfqq(bic, NULL, 1);
+				bic_set_bfqq(bic, NULL, true);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7b894df32e32..917939b60ef8 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -3180,7 +3180,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 	/*
 	 * Merge queues (that is, let bic redirect its requests to new_bfqq)
 	 */
-	bic_set_bfqq(bic, new_bfqq, 1);
+	bic_set_bfqq(bic, new_bfqq, true);
 	bfq_mark_bfqq_coop(new_bfqq);
 	/*
 	 * new_bfqq now belongs to at least two bics (it is a shared queue):
@@ -6627,7 +6627,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq)
 		return bfqq;
 	}
 
-	bic_set_bfqq(bic, NULL, 1);
+	bic_set_bfqq(bic, NULL, true);
 
 	bfq_put_cooperator(bfqq);
 
-- 
2.39.0



