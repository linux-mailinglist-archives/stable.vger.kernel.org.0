Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D39E6DEF0E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjDLIrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjDLIrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553557EE4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35DF8630EC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4870BC433EF;
        Wed, 12 Apr 2023 08:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289197;
        bh=K+Y+tweG5YdWT2kXHVXfyuMkvSBN8SWxTBudNmv/B/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuJJb8lT+Kj4JeRdGJDiLYsIEDiscKqtNGuddlH84qsd3hQncDdb46PwwG7S8aMy/
         hzpqzF50wckSlfiho2qJMzNJIlpBZCb0EI6nnqXg5IHqEf8/QH0omomZpcym1H2laP
         CqpgD99Bydi1iQ7hkhurtawaWalXwqE9ERqbk6ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tejun Heo <tj@kernel.org>,
        Kemeng Shi <shikemeng@huawei.com>,
        Jens Axboe <axboe@kernel.dk>,
        Khazhy Kumykov <khazhy@google.com>
Subject: [PATCH 6.1 142/164] blk-throttle: Fix that bps of child could exceed bps limited in parent
Date:   Wed, 12 Apr 2023 10:34:24 +0200
Message-Id: <20230412082842.638417255@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huawei.com>

commit 84aca0a7e039c8735abc0f89f3f48e9006c0dfc7 upstream.

Consider situation as following (on the default hierarchy):
 HDD
  |
root (bps limit: 4k)
  |
child (bps limit :8k)
  |
fio bs=8k
Rate of fio is supposed to be 4k, but result is 8k. Reason is as
following:
Size of single IO from fio is larger than bytes allowed in one
throtl_slice in child, so IOs are always queued in child group first.
When queued IOs in child are dispatched to parent group, BIO_BPS_THROTTLED
is set and these IOs will not be limited by tg_within_bps_limit anymore.
Fix this by only set BIO_BPS_THROTTLED when the bio traversed the entire
tree.

There patch has no influence on situation which is not on the default
hierarchy as each group is a single root group without parent.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
Link: https://lore.kernel.org/r/20221205115709.251489-3-shikemeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Khazhy Kumykov <khazhy@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-throttle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1066,7 +1066,6 @@ static void tg_dispatch_one_bio(struct t
 	sq->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
-	bio_set_flag(bio, BIO_BPS_THROTTLED);
 
 	/*
 	 * If our parent is another tg, we just need to transfer @bio to
@@ -1079,6 +1078,7 @@ static void tg_dispatch_one_bio(struct t
 		throtl_add_bio_tg(bio, &tg->qnode_on_parent[rw], parent_tg);
 		start_parent_slice_with_credit(tg, parent_tg, rw);
 	} else {
+		bio_set_flag(bio, BIO_BPS_THROTTLED);
 		throtl_qnode_add_bio(bio, &tg->qnode_on_parent[rw],
 				     &parent_sq->queued[rw]);
 		BUG_ON(tg->td->nr_queued[rw] <= 0);


