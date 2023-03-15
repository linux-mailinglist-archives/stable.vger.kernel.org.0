Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CB16BB10B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjCOMYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjCOMX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DB57389B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E47861ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A09C433D2;
        Wed, 15 Mar 2023 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882956;
        bh=VEJO0mu4Zr9obcBgVJ7JwhAuXNYrzStk8jsF/f6LWcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbTDtawXj/sDhiPNjbdt7IXiSvZGTj3xkJESMD+o+U5Hvc8E6Y/VeGTL1T7wx+IEM
         G3XAmL8GEajw3L3l+Y7WBLr+fanVp1wtO+ahR7RyV3/NXsaTQqpjYFlLcEb2iEWNK4
         Vu279bplJk7f/GPywVP3lrHnqzleAquPLXMc+dZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 5.10 065/104] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date:   Wed, 15 Mar 2023 13:12:36 +0100
Message-Id: <20230315115734.670453825@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b600de2d7d3a16f9007fad1bdae82a3951a26af2 ]

After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
bic->bfqq will be freed, and bic_set_bfqq() is called with the freed
bic->bfqq.

Fix the problem by always freeing bfqq after bic_set_bfqq().

Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230130014136.591038-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 2f440b79183d3..1f9ccc661d574 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -748,8 +748,8 @@ static void *__bfq_bic_change_cgroup(struct bfq_data *bfqd,
 				 * request from the old cgroup.
 				 */
 				bfq_put_cooperator(sync_bfqq);
-				bfq_release_process_ref(bfqd, sync_bfqq);
 				bic_set_bfqq(bic, NULL, true);
+				bfq_release_process_ref(bfqd, sync_bfqq);
 			}
 		}
 	}
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 016d7f32af9f1..6687b805bab3b 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5070,9 +5070,11 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		bfq_release_process_ref(bfqd, bfqq);
+		struct bfq_queue *old_bfqq = bfqq;
+
 		bfqq = bfq_get_queue(bfqd, bio, false, bic);
 		bic_set_bfqq(bic, bfqq, false);
+		bfq_release_process_ref(bfqd, old_bfqq);
 	}
 
 	bfqq = bic_to_bfqq(bic, true);
-- 
2.39.2



